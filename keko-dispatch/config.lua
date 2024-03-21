Config = {}
Config.Sound = true -- Enable/Disable dispatch sounds
Config.Framework = 'ESX' -- 'ESX' or 'QBCore'
Config.Locale = 'es' -- Language 'en' or 'es'
Config.ShootingAlerts = true -- Enable/Disable Shooting alerts
Config.Measurement = true -- True = Metric False = Imperial
Config.ShootingCooldown = 30 -- Seconds
Config.BlipDeletion = 30 -- Seconds

Config.CommandShow = {
    command = 'alertas',
    description = 'Abrir alertas'
}

Config.VehicleRob = {
    command = 'forzar',
    description = 'Se enviara una alerta a la policia'
}

Config.CommandPanic = {
    command = 'panic',
    description = 'Boton del panico'
}

Config.CommandClear = {
    command = 'borraralertas',
    description = 'Borrar alertas'
}

Config.DispatcherJob = 'police'
Config.Jobs = {'police', 'ambulance'}
Config.DefaultDispatchNumber = '0A-00'

Config.AllowedJobs = {
    ["police"] = {
        name = 'police',
        label = 'LSPD',
        command = 'entorno',
        descriptcommand = 'Envia un entorno a la policia',
        panic = true
    },
    ["ambulance"] = {
        name = 'ambulance',
        label = 'EMS',
        command = 'auxilio',
        descriptcommand = 'Envia alerta a la ambulancia',
        panic = true
    }
}
