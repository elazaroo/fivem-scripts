RegisterNetEvent('getPlayerServerId')
AddEventHandler('getPlayerServerId', function()
    local playerServerId = GetPlayerServerId(PlayerId()) -- Obtener la ID del jugador
    local playerName = GetPlayerName(PlayerId()) -- Obtener el nombre de usuario
    TriggerServerEvent('playerConnected', playerServerId, playerName)
end)

-- Llamar al evento para enviar la ID del jugador y el nombre de usuario al servidor
TriggerEvent('getPlayerServerId')
