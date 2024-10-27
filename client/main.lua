local showedUI = false

RegisterNUICallback('close', function()
    hideUI()
end)

function toggleDashboardUI()
    showedUI = not showedUI
    if showedUI then
        ESX.TriggerServerCallback('dashboard:Name', function(data)
            SendNUIMessage({
                action       = "showUI",
                playerName   = data.PlayerName,
                name         = GetPlayerName(PlayerId()),
                bankMoney    = data.Bank,
                cash         = data.Cash,
                dob          = data.date,
                job          = data.job,
                jobgrade     = data.jobgrade,
                height       = data.height,
                sex          = data.sex,
                group        = data.group,
                vehicleCount = data.vehicleCount,
                steam        = GetPlayerName(PlayerId()),
                ServerName   = Config.ServerName,
                Link         = Config.Link,
                unit         = Config.Unit,
                Admins       = data.adminCount
            })
            SetNuiFocus(true, true)
        end)
    else
        hideUI()
    end
end

function hideUI()
    TriggerScreenblurFadeOut(0)
    SendNUIMessage({ action = "hideUI" })
    SetNuiFocus(false, false)
    showedUI = false
end

RegisterCommand('dashboard', toggleDashboardUI, false)
RegisterKeyMapping('dashboard', 'Dashboard', 'keyboard', Config.MenuKey)
