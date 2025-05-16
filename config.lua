Config = {}

-- Notification system: 'ESX', 'okokNotify', or 'ox_lib'
Config.NotificationSystem = 'ESX'

-- Time in ms between checks (e.g., 2000ms = 2 seconds)
Config.CheckInterval = 2000

-- Offset to teleport player to side of vehicle if kicked out
Config.TeleportOffset = vector3(-2.0, 0.0, 0.0)

-- Job to allowed vehicle models
Config.JobVehicles = {
    police = { "police", "police2" },
    ambulance = { "ambulance" },
    mechanic = { "flatbed", "towtruck" },
}

-- Notifications
Config.Translations = {
    error_title = "Access Denied",
    no_permission = "You don't have permission to drive this vehicle.",
}
