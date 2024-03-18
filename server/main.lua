function createSQLColumn(name)
    local p = promise.new()

    local exists = MySQL.scalar.await("SHOW COLUMNS FROM `users` LIKE '" .. name .. "'")
    if exists then
        return p:resolve(false)
    end

    MySQL.query([[
            ALTER TABLE `users`
            ADD COLUMN `]] .. name .. [[` INT(11) NULL DEFAULT '0';
        ]], function()
        p:resolve(true)
    end)

    return p
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "00h:00m:00s";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      return hours.."h:"..mins.."m:"..secs.."s"
    end
  end

function loadPlayerPlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local playedTime = MySQL.scalar.await("SELECT playedTime FROM users WHERE identifier = ?", { xPlayer.identifier })
	Player(player).state.playedTime = playedTime
end

CreateThread(function()
    if Config.UseAdminCounter then
        count = 0
        local admins = exports["villamos_adutyv2"]:GetDutys()
        for _ in pairs(admins) do
            count = count + 1
        end
        Wait(10000)
    end
end)

ESX.RegisterServerCallback('dashboard:Name', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerName = xPlayer.getName()
    local Bank = xPlayer.getAccount('bank').money
    local Cash = xPlayer.getMoney()
    local date = xPlayer.get('dateofbirth')
    local job = xPlayer.getJob().label
    local jobgrade = xPlayer.getJob().grade_label
    local height = xPlayer.get('height')
    local sex = xPlayer.get('sex')
    local group = xPlayer.getGroup()
    local pp = MySQL.scalar.await("SELECT premiumPoints FROM users WHERE identifier = ?", { xPlayer.identifier })
    local vehicleCount = MySQL.Sync.fetchScalar(
        "SELECT COUNT(*) FROM owned_vehicles WHERE owner = ?",
        { xPlayer.identifier }
    )
    cb(PlayerName, Bank, Cash, date, job, jobgrade, height, sex, vehicleCount, group, pp, xPlayer)
end)


CreateThread(function()
	Citizen.Await(createSQLColumn("playedTime"))
    Citizen.Await(createSQLColumn("premiumPoints"))
    Citizen.Await(createSQLColumn("dailyCoin"))

	for _, player in pairs(GetPlayers()) do
		local sb = Player(player).state

		if not sb.joinTime then
			Player(player).state.joinTime = os.time()
		end

		if not sb.playedTime then
			loadPlayerPlayedTime(player)
		end

	end
end)

function savePlayedTime(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return
	end

	local sb = Player(player).state
	local oldTime = sb.playedTime or 0
	local joinTime = sb.joinTime or os.time()
	local newTime = oldTime + (os.time() - joinTime)

	exports.oxmysql:update("UPDATE users SET playedTime = ? WHERE identifier = ?", { newTime, xPlayer.identifier })
end