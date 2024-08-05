local status = {}
local function handleOnTick()
    for k, v in pairs(ESX.PlayerData.status) do
        if v then
            status[#status+1] = {
                name = k,
                val = v,
                percent = v
            }
        end
    end
    TriggerEvent('esx_status:onTick', status)
    status = {}
end

CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            handleOnTick()
        end
        Wait(Config.StatusInterval)
    end
end)

local sleep = (1000 * 60) * Config.UpdateInterval
CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            TriggerServerEvent('status:update')
        end
        Wait(sleep)
    end
end)

---@deprecated use status:add instead
RegisterNetEvent('esx_status:add', function (key, value)
    if value > 100 or value < -100 then
        value = value * 0.0001
    end
    TriggerServerEvent('status:add', key, value)
end)

---@deprecated use status:remove instead
RegisterNetEvent('esx_status:remove', function (key, value)
    if value > 100 or value < -100 then
        value = value * 0.0001
    end
    TriggerServerEvent('status:remove', key, value)
end)

---@deprecated use status:get instead
RegisterNetEvent('esx_status:getStatus', function (name, cb)
    local stat = ESX.PlayerData.status[name]
    if not stat then cb(nil) return end
    local retval = {}
    retval = {
        name = name,
        val = stat * 10000,
        percent = stat
    }
    cb(retval)
end)

-- esx_basicneeds compatibility
RegisterNetEvent('esx_basicneeds:resetStatus', function ()
    TriggerServerEvent('status:reset')
end)

-- esx_basicneeds compatibility
RegisterNetEvent('esx_basicneeds:healPlayer', function ()
    TriggerServerEvent('status:reset')
    local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)


local defaultStatus = {
    'hunger',
    'thirst',
    'stress',
}

for i = 1, #defaultStatus do
    local stats = defaultStatus[i]
    AddStateBagChangeHandler(stats, ("player:%s"):format(GetPlayerServerId(PlayerId())), function(_, key, value)
        if not ESX.PlayerLoaded then return end
        ESX.PlayerData.status[key] = value
        Wait(100)
        ESX.SetPlayerData('status', ESX.PlayerData.status)
    end)
end

AddEventHandler('esx_status:onTick', function(data)
	local playerPed  = PlayerPedId()
	local prevHealth = GetEntityHealth(playerPed)
	local health     = prevHealth
	
	for k, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end
	
	if health ~= prevHealth then SetEntityHealth(playerPed, health) end
end)
