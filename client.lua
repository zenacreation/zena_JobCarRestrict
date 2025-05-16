ESX = exports['es_extended']:getSharedObject()

local function ShowNotification(title, message, type)
    if Config.NotificationSystem == 'okokNotify' then
        TriggerEvent('okokNotify:Alert', title, message, 5000, type)
    elseif Config.NotificationSystem == 'ESX' then
        ESX.ShowNotification(message)
    elseif Config.NotificationSystem == 'ox_lib' then
        lib.notify({
            title = title,
            description = message,
            type = type
        })
    end
end

local function IsVehicleAllowedForJob(vehicle, job)
    local model = GetEntityModel(vehicle)
    local allowedVehicles = Config.JobVehicles[job]
    if allowedVehicles then
        for _, vehicleName in ipairs(allowedVehicles) do
            if model == GetHashKey(vehicleName) then
                return true
            end
        end
    end
    return false
end

local function TeleportToSideOfVehicle(ped, vehicle)
    local offset = GetOffsetFromEntityInWorldCoords(vehicle,
        Config.TeleportOffset.x,
        Config.TeleportOffset.y,
        Config.TeleportOffset.z)
    SetEntityCoords(ped, offset.x, offset.y, offset.z)
end

CreateThread(function()
    while true do
        Wait(Config.CheckInterval)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle and DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
            local playerData = ESX.GetPlayerData()
            if playerData and playerData.job then
                local job = playerData.job.name
                if not IsVehicleAllowedForJob(vehicle, job) then
                    TaskLeaveVehicle(ped, vehicle, 0)
                    Wait(500)
                    TeleportToSideOfVehicle(ped, vehicle)
                    ShowNotification(
                        Config.Translations.error_title,
                        Config.Translations.no_permission,
                        'error'
                    )
                end
            end
        end
    end
end)
