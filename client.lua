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
    TaskLeaveVehicle(ped, vehicle, 1)
end


lib.onCache('vehicle', function(vehicle)
    if vehicle and GetPedInVehicleSeat(vehicle, -1) == cache.ped then
        if ESX.GetPlayerData().job then
            if not IsVehicleAllowedForJob(vehicle, ESX.GetPlayerData().job.name) then
                TaskLeaveVehicle(cache.ped, vehicle, 0)
                Wait(500)
                TeleportToSideOfVehicle(cache.ped, vehicle)
                ShowNotification(Config.Translations.error_title, Config.Translations.no_permission, 'error')
            end
        end
    end
end)


