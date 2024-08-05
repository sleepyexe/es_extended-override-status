local function removeHungerAndThirst(xPlayer)
    local playerState = Player(xPlayer.source).state
    local newHunger = xPlayer.removeStatus('hunger', Config.HungerRate)
    local newThirst = xPlayer.removeStatus('thirst', Config.ThirstRate)
    playerState:set('hunger', newHunger, true)
    playerState:set('thirst', newThirst, true)
    TriggerClientEvent('status:update', xPlayer.source, newHunger, newThirst)
end

RegisterNetEvent('status:update', function ()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    removeHungerAndThirst(xPlayer)
end)

RegisterNetEvent('status:add', function (key, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local playerState = Player(xPlayer.source).state
    local status = xPlayer.getStatus(key)
    if status and type(status) == 'number' then
        local newStatus = xPlayer.addStatus(key, value)
        playerState:set(key, newStatus, true)
    end
end)

RegisterNetEvent('status:remove', function (key, value)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local playerState = Player(xPlayer.source).state
    local status = xPlayer.getStatus(key)
    if status and type(status) == 'number' then
        local newStatus = xPlayer.removeStatus(key, value)
        playerState:set(key, newStatus, true)
    end
end)

RegisterNetEvent('status:reset', function ()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local playerState = Player(xPlayer.source).state
    local newHunger = xPlayer.setStatus('hunger', 50)
    local newThirst = xPlayer.setStatus('thirst', 50)
    playerState:set('hunger', newHunger, true)
    playerState:set('thirst', newThirst, true)
    TriggerClientEvent('status:update', xPlayer.source, newHunger, newThirst)
end)