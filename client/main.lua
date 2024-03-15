local nuiFocus = false
local showedUI = false

CreateThread(function()
    while true do
        if IsControlJustReleased(0, Config.MenuKey) then
                ESX.TriggerServerCallback('dashboard:Name',
                function(PlayerName, Bank, Cash, date, job, jobgrade, height, sex, admins, vehicleCount, onlineTime, playtime, group, pp, xPlayer)
                    showedUI = not showedUI
                    if showedUI then
                        TriggerScreenblurFadeIn(0.5)
                        showUI()

                        SendNUIMessage({
                            playerCount = #GetActivePlayers(),
                            playerName  = PlayerName,
                            name = GetPlayerName(PlayerId()),
                            bankMoney   = Bank,
                            cash        = Cash,
                            dob         = date,
                            job         = job,
                            jobgrade    = jobgrade,
                            height      = height,
                            sex         = sex,
                            admins      = admins,
                            pp = pp,
                            group = group,
                            vehicleCount = vehicleCount,
                            currentSessionTime = onlineTime,
                            playtime = playtime,
                            steam =       GetPlayerName(PlayerId()),
                            id    =       GetPlayerServerId(PlayerId()),
                            ServerName  = Config.ServerName,
                            Link        = Config.Link,
                            unit        = Config.Unit,
                            Male        = Config.Male,
                            Female      = Config.Female,
                        })
                    else
                        hideUI()
                    end
                end)
        end
        Wait(0)
    end
end)

RegisterNUICallback('close', function()
    hideUI()
end)

function showUI()
    SendNUIMessage({
        action = "showUI"
    })
    SetNuiFocus(true, true)
end

function hideUI()
    TriggerScreenblurFadeOut(0)
    SendNUIMessage({
        action = "hideUI"
    })
    SetNuiFocus(false, false)
end


RegisterCommand('dashboard', function ()
    showUI()
end, false)