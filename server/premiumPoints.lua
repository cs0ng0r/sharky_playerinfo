local playerPP = {}

function chatbox(message, color, target)
	local msg = {
		color = color or { 255, 255, 255 },
		multiline = true,
		args = { "Rendszer", message },
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.838); border-radius: 5px;"><i class="fas fa-server"style="font-size:px;"></i> <b>{0}: {1} </font></b></i><span>'
	}

	if IsDuplicityVersion() then
		TriggerClientEvent("chat:addMessage", target or -1, msg)
		return
	end

	TriggerEvent("chat:addMessage", msg)
end
function loadPlayerPP(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return 0
	end

	local value = MySQL.scalar.await("SELECT premiumPoints FROM users WHERE identifier = ?", { xPlayer.identifier })

	playerPP[player] = value

	return value
end


function loadPlayerPP(player)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return 0
	end

	local value = MySQL.scalar.await("SELECT premiumPoints FROM users WHERE identifier = ?", { xPlayer.identifier })

	playerPP[player] = value

	return value

end

function getPlayerPP(player)
	if not playerPP[player] then
		return loadPlayerPP(player)
	end

	return playerPP[player] or 0
end
exports("getPlayerPP", getPlayerPP)

function setPlayerPP(player, value)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return false
	end

	playerPP[player] = value

	MySQL.query("UPDATE users SET premiumPoints = ? WHERE identifier = ?", { value, xPlayer.identifier })

	return true
end
exports("setPlayerPP", setPlayerPP)

function takePlayerPP(player, value)
	local currentPP = getPlayerPP(player)
	if currentPP < value then
		return false
	end

	currentPP = currentPP - value
	setPlayerPP(player, currentPP)

	return true
end
exports("takePlayerPP", takePlayerPP)

RegisterCommand("setpp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not Config.Admins[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 246, 124, 8 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/setpp [ID] [PP]", { 246, 124, 8 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 246, 124, 8 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 246, 124, 8 }, player)
	end
	setPlayerPP(xTarget.source, value)

	chatbox(
		GetPlayerName(player) .. " beállította a prémium pontjaid. Érték: " .. value,
		{ 246, 124, 8 },
		xTarget.source
	)
end, false)

RegisterCommand("givepp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not Config.Admins[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 246, 124, 8 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/givepp [ID] [PP]", { 246, 124, 8 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 246, 124, 8 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 246, 124, 8 }, player)
	end
	setPlayerPP(xTarget.source, getPlayerPP(xTarget.source) + value)

	chatbox(GetPlayerName(player) .. " adott prémium pontot. Mennyiség: " .. value, { 246, 124, 8 }, xTarget.source)
end, false)

RegisterCommand("takepp", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)

	if not Config.Admins[xPlayer.getGroup()] then
		return chatbox("Nincs jogod ehhez!", { 246, 124, 8 }, player)
	end

	if #args < 2 or not tonumber(args[2]) then
		return chatbox("/takepp [ID] [PP]", { 246, 124, 8 }, player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1] == "me" and player or args[1])
	if not xTarget then
		return chatbox("Játékos nem található!", { 246, 124, 8 }, player)
	end

	local value = math.floor(tonumber(args[2]))
	if value <= 0 then
		return chatbox("Ne má", { 246, 124, 8 }, player)
	end
	if not takePlayerPP(xTarget.source, value) then
		return chatbox("Játékosnak nem lehet negatívba a prémiumja", { 246, 124, 8 }, player)
	end
	chatbox(GetPlayerName(player) .. " levont prémium pontot. Mennyiség: " .. value, { 246, 124, 8 }, xTarget.source)
end, false)