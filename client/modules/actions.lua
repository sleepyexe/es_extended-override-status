local isJumping, inPauseMenu = false, false

lib.onCache('ped', function (newPed)
    ESX.SetPlayerData("ped", newPed)
    SetEntityMaxHealth(newPed, 200) -- Keep tracking max health to 200
    TriggerEvent("esx:playerPedChanged", newPed)
    TriggerServerEvent("esx:playerPedChanged", PedToNet(newPed))
end)

CreateThread(function()
    while not ESX.PlayerLoaded do Wait(200) end
    while true do
        ESX.SetPlayerData("coords", GetEntityCoords(cache.ped))
        if Config.DisableHealthRegeneration then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        end

        if IsPedJumping(cache.ped) and not isJumping then
            isJumping = true
        elseif not IsPedJumping(cache.ped) and isJumping then
            isJumping = false
        end

        if IsPauseMenuActive() and not inPauseMenu then
            inPauseMenu = true
            TriggerEvent("esx:pauseMenuActive", inPauseMenu)
        elseif not IsPauseMenuActive() and inPauseMenu then
            inPauseMenu = false
            TriggerEvent("esx:pauseMenuActive", inPauseMenu)
        end
        Wait(200)
    end
end)