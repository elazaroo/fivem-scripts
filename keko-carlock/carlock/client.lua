local lockDistance = 50 -- Distancia de bloqueo de vehículo

saved = false


ESX = nil
ESX = exports["es_extended"]:getSharedObject()


-- Acción animacion llave
Citizen.CreateThread(function()
    local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
end
	
-- Evento luces
RegisterNetEvent('lockLights')
AddEventHandler('lockLights',function()
local vehicle = saveVehicle
	SetVehicleLights(vehicle, 2)
	Wait (200)
	SetVehicleLights(vehicle, 0)
	Wait (200)
	SetVehicleLights(vehicle, 2)
	Wait (400)
	SetVehicleLights(vehicle, 0)
end)

-- Bloquear vehículo
-- Comandos y teclas
RegisterKeyMapping('lock', 'Lock and unlock your saved car', 'keyboard', 'l') 
RegisterCommand("lock", function()
    local vehicle = saveVehicle
	local vehcoords = GetEntityCoords(vehicle)
	local coords = GetEntityCoords(PlayerPedId())
	local isLocked = GetVehicleDoorLockStatus(vehicle)
		if DoesEntityExist(vehicle) then
			if #(vehcoords - coords) < lockDistance then
				if (isLocked == 1) then
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle, 2)
				ESX.ShowNotification("Vehículo bloqueado")
				TriggerEvent('lockLights')
				else
				PlaySoundFrontend(-1, "BUTTON", "MP_PROPERTIES_ELEVATOR_DOORS", 1)
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
				SetVehicleDoorsLocked(vehicle,1)
				ESX.ShowNotification("Vehículo abierto")
				TriggerEvent('lockLights')
				end
			else
				ShowNotification("Debe estar mas cerca del vehículo")
			end
		else
			ESX.ShowNotification("Llaves no guardadas")
		end
	end)
end) 

-- Guardar llaves del vehiculo para cerrarlo
-- Comandos y teclas 
RegisterKeyMapping('coger', 'Save and unsave the car you are in', 'keyboard', 'delete') 
RegisterCommand("coger",function()
	local player = PlayerPedId()
	print("save")
	  if (IsPedSittingInAnyVehicle(player)) then
			if saved == true then
			saveVehicle = nil
			RemoveBlip(targetBlip)
			ESX.ShowNotification("Llaves borradas")
			saved = false
		else
			RemoveBlip(targetBlip)
			saveVehicle = GetVehiclePedIsIn(player,true)
			local vehicle = saveVehicle
			targetBlip = AddBlipForEntity(vehicle)
			SetBlipSprite(targetBlip,225)
			ESX.ShowNotification("Llaves guardadas")
			saved = true
		end
	end
end)



