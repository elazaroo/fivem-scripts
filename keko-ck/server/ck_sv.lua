ESX = exports["es_extended"]:getSharedObject()

-- Config Variables
local logs = "CHANGEME"

-- Global Variables [Do not change]
local ckIdentifier = nil

-- Minified Code
RegisterCommand("cancelck", function(source, args, rawCommand)
    local identifier = args[1]
    local player = tonumber(identifier)
    local playerData = ESX.GetPlayerFromId(player)

    if playerData == nil then
        TriggerClientEvent('esx:showNotification', source, 'Id incorrecta.')
    else
        ckIdentifier = playerData.identifier
        discordCancel(source)
        Citizen.Wait(10000)
        ckIdentifier = nil
    end
end, true)

RegisterCommand("ck", function(source, args, rawCommand)
    local identifier = args[1]
    local player = tonumber(identifier)
    local playerData = ESX.GetPlayerFromId(player)

    if playerData == nil then
        TriggerClientEvent('esx:showNotification', source, 'Id incorrecta.')
    else
        TriggerClientEvent('esx:showNotification', player, 'Te están haciendo un CK, si fue un error avísale rápidamente a un moderador!')
        TriggerClientEvent('esx:showNotification', source, 'Estás haciendo un CK, recuerda que puedes cancelarlo con /cancelck!')
        Citizen.Wait(10000)

        if ckIdentifier == playerData.identifier then
            TriggerClientEvent('esx:showNotification', source, 'Ck cancelado correctamente!')
            ckIdentifier = nil
        else
            discordMsg(player, source)
            DropPlayer(player, 'Te han hecho un ck, olvidarás toda tu vida pasada!')
            DeleteTables(playerData.identifier)
            ckIdentifier = nil
        end
    end
end, true)

function discordMsg(target, source)
    local targetName = GetPlayerName(target)
    local sourceName = GetPlayerName(source)
    local targetIP = GetPlayerEndpoint(target)
    local sourceIP = GetPlayerEndpoint(source)
    local targetLicenseRockstar = GetPlayerLicense(target, "license:rockstar")
    local sourceLicenseRockstar = GetPlayerLicense(source, "license:rockstar")

    local embeds = {{
        color = 16742656,
        title = 'Se ha producido un CK!',
        description = string.format('Ck hacia: **%s** :dart:\n\nLicencia de Rockstar (receptor): ||%s||\nIP del receptor: ||%s||\n\n\nCk por: **%s** :bow_and_arrow:\n\nLicencia de Rockstar (emisor): ||%s||\nIP del emisor: ||%s||',
            targetName, targetLicenseRockstar or "N/A", targetIP, sourceName, sourceLicenseRockstar or "N/A", sourceIP),
        footer = { text = 'CK System by keko' }
    }}

    PerformHttpRequest(logs, function() end, 'POST', json.encode({ username = 'Keko CK', embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

function discordCancel(source)
    local playerName = GetPlayerName(source)
    local playerLicenseRockstar = GetPlayerLicense(source, "license:rockstar")
    local playerIP = GetPlayerEndpoint(source)

    local embeds = {{
        color = 16742656,
        title = 'Se ha rechazado un CK',
        description = string.format('Ck rechazado por: **%s** :closed_book:\n\nLicencia de Rockstar: ||%s||\nIP del emisor: ||%s||', playerName, playerLicenseRockstar or "N/A", playerIP),
        footer = { text = 'CK System Keko' }
    }}

    PerformHttpRequest(logs, function() end, 'POST', json.encode({ username = 'Keko CK', embeds = embeds }), { ['Content-Type'] = 'application/json' })
end

function GetPlayerLicense(playerId, licenseType)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        return xPlayer.getIdentifier(licenseType)
    end
    return "N/A"
end

function GetPlayerEndpoint(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, "ip") then
            return string.sub(identifier, 4)
        end
    end
    return "N/A"
end

function DeleteTables(identifier)
    local sqlQuery1 = "DELETE FROM users WHERE identifier = @identifier"
    local sqlQuery2 = "DELETE FROM owned_vehicles WHERE owner = @identifier"

    MySQL.Async.execute(sqlQuery1, { identifier = identifier }, function(affectedRows)
    end)

    MySQL.Async.execute(sqlQuery2, { identifier = identifier }, function(affectedRows)
    end)
end
