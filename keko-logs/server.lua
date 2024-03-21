ESX = exports["es_extended"]:getSharedObject()

local webhook_join = "CHANGEME"
local webhook_drop = "CHANGEME"

RegisterServerEvent('playerConnected')
AddEventHandler('playerConnected', function(playerServerId, playerName)
    local source = source

    -- Obtener información del jugador
    local playerId = GetPlayerIdentifiers(source)[1] -- Obtener la primera licencia del jugador
    local playerLicenseDiscord = "N/A" -- Valor predeterminado para la licencia de Discord

    -- Obtener las licencias del jugador
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:sub(1, string.len("discord:")) == "discord:" then
            playerLicenseDiscord = v
        elseif v:sub(1, string.len("license:")) == "license:" then
            playerId = v
        end
    end

    -- Obtener la IP del jugador
    local playerIP = GetPlayerEndpoint(source)
    local hiddenIP = "||" .. playerIP .. "||" -- Agregar el formato spoiler

    -- Obtener la fecha y hora actual
    local date = os.date('%Y-%m-%d')
    local time = os.date('%H:%M:%S')

    -- Crear el mensaje embed con la información del jugador
    local embed = {
        {
            ['color'] = 65280, -- Color verde
            ['title'] = 'Nuevo jugador conectado',
            ['fields'] = {
                {['name'] = ':pencil: Nombre de usuario', ['value'] = playerName, ['inline'] = false},
                {['name'] = ':id: ID del jugador', ['value'] = playerServerId, ['inline'] = false},
                {['name'] = ':video_game: Licencia Rockstar', ['value'] = playerId, ['inline'] = false},
                {['name'] = ':boom: Licencia Discord', ['value'] = playerLicenseDiscord, ['inline'] = false},
                {['name'] = ':warning: IP', ['value'] = hiddenIP, ['inline'] = false},
                {['name'] = ':date: Fecha', ['value'] = date, ['inline'] = true},
                {['name'] = ':hourglass: Hora', ['value'] = time, ['inline'] = true}
            },
            ['footer'] = {
                ['text'] = 'Keko logs' -- Agregar una marca de agua al final del embed
            }
        }
    }

    -- Convertir el mensaje embed a formato JSON
    local jsonEmbed = json.encode({embeds = embed})

    -- Enviar el mensaje a la webhook de Discord
    PerformHttpRequest(webhook_join, function(err, text, headers) end, 'POST', jsonEmbed, {['Content-Type'] = 'application/json'})
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function(reason)
    local source = source

    -- Obtener información del jugador desconectado
    local playerServerId = source
    local playerName = GetPlayerName(source)
    local playerId = GetPlayerIdentifiers(source)[1] -- Obtener la primera licencia del jugador
    local playerLicenseDiscord = "N/A" -- Valor predeterminado para la licencia de Discord

    -- Obtener las licencias del jugador
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:sub(1, string.len("discord:")) == "discord:" then
            playerLicenseDiscord = v
        elseif v:sub(1, string.len("license:")) == "license:" then
            playerId = v
        end
    end

    -- Obtener la IP del jugador
    local playerIP = GetPlayerEndpoint(source)
    local hiddenIP = "||" .. playerIP .. "||" -- Agregar el formato spoiler

    -- Obtener la fecha y hora actual
    local date = os.date('%Y-%m-%d')
    local time = os.date('%H:%M:%S')

    -- Crear el mensaje embed con la información del jugador desconectado
    local embed = {
        {
            ['color'] = 16711680, -- Color rojo
            ['title'] = 'Jugador desconectado',
            ['fields'] = {
                {['name'] = ':pencil: Nombre de usuario', ['value'] = playerName, ['inline'] = false},
                {['name'] = ':id: ID del jugador', ['value'] = playerServerId, ['inline'] = false},
                {['name'] = ':video_game: Licencia Rockstar', ['value'] = playerId, ['inline'] = false},
                {['name'] = ':boom: Licencia Discord', ['value'] = playerLicenseDiscord, ['inline'] = false},
                {['name'] = ':warning: IP', ['value'] = hiddenIP, ['inline'] = false},
                {['name'] = ':date: Fecha', ['value'] = date, ['inline'] = true},
                {['name'] = ':hourglass: Hora', ['value'] = time, ['inline'] = true},
                {['name'] = ':x: Razón', ['value'] = reason, ['inline'] = false}
            },
            ['footer'] = {
                ['text'] = 'Keko logs' -- Agregar una marca de agua al final del embed
            }
        }
    }

    -- Convertir el mensaje embed a formato JSON
    local jsonEmbed = json.encode({embeds = embed})

    -- Enviar el mensaje a la webhook de Discord
    PerformHttpRequest(webhook_drop, function(err, text, headers) end, 'POST', jsonEmbed, {['Content-Type'] = 'application/json'})
end)
