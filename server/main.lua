function GetAdminCount()
    local count = 0
    for _, playerId in ipairs(ESX.GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if Config.Admins[xPlayer.getGroup()] then
            count = count + 1
        end
    end
    return count
end

ESX.RegisterServerCallback('dashboard:Name', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehicleCount = MySQL.scalar.await("SELECT COUNT(*) FROM owned_vehicles WHERE owner = ?", { xPlayer.identifier })

    local playerData = {
        PlayerName   = xPlayer.getName(),
        Bank         = xPlayer.getAccount('bank').money,
        Cash         = xPlayer.getMoney(),
        date         = xPlayer.get('dateofbirth'),
        job          = xPlayer.getJob().label,
        jobgrade     = xPlayer.getJob().grade_label,
        height       = xPlayer.get('height'),
        sex          = xPlayer.get('sex'),
        group        = xPlayer.getGroup(),
        adminCount   = GetAdminCount(),
        vehicleCount = vehicleCount
    }

    cb(playerData)
end)
