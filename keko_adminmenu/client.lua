local display = false
local InSpectatorMode, ShowInfos = false, false
local TargetSpectate, LastPosition, cam
local polarAngleDeg = 0
local azimuthAngleDeg = 90
local radius = -3.5
local PlayerDate = {}

ESX = exports["es_extended"]:getSharedObject()

RegisterKeyMapping('amenu', 'Open Adminmenu', 'keyboard', 'INSERT')

RegisterCommand("amenu", function(source, args)
	playerlist = getPlayers()
    ESX.TriggerServerCallback('keko_adminmenu:getGroup', function(grp)
        if grp ~= 'user' then
            TriggerEvent('keko_adminmenu:getAdmins')
            SendNUIMessage({type = 'open', players = playerlist})
            SetDisplay(true)
        end
    end)
end)

RegisterNUICallback("refreshplayers", function(data)
	playerlist = getPlayers()
    ESX.TriggerServerCallback('keko_adminmenu:getGroup', function(grp)
        if grp ~= 'user' then
            TriggerEvent('keko_adminmenu:getAdmins')
            SendNUIMessage({type = 'open', players = playerlist})
        end
    end)
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)


RegisterNUICallback("refreshplayercounts", function(data)
    TriggerEvent('keko_adminmenu:getAdmins')
end)

RegisterNetEvent('tpgoto')
AddEventHandler('tpgoto',function(coords)
	SetEntityCoords(GetPlayerPed(-1), coords)
end)
RegisterNetEvent('tpbring')
AddEventHandler('tpbring',function(coords)
	SetEntityCoords(GetPlayerPed(-1), coords)
end)
RegisterNUICallback("action", function(data)
	print(data.da)
    if data.da == 'kick' then
        TriggerServerEvent('keko_adminmenu:kickbru', data.target, data.grund)
    elseif data.da == 'spec' then
		local target = data.target
        TriggerServerEvent("requestSpectate", target)
	elseif data.da == 'goto' then
		local target = data.target
        TriggerServerEvent("goto", target)
	elseif data.da == 'bring' then
		local target = data.target
        TriggerServerEvent("bring", target)
	elseif data.da == 'freeze' then
		local target = data.target
        TriggerServerEvent("freeze", target)
	elseif data.da == 'screenshot' then
		local target = data.target
        TriggerServerEvent("screenshot", target)
	elseif data.da == 'ban' then
		local target = data.target
		local grund = data.grund
		local time = data.time
		print(time)
        TriggerServerEvent("ban", target, grund, time)
    end
end)

local freezed = false


RegisterNUICallback("banlist", function(data)
	ESX.TriggerServerCallback('keko_adminmenu:getbanlist', function(banList)
		local BanList
		local BanList = banList

		for i = 1, #BanList, 1 do
			print(json.encode(BanList[i]))
			if BanList[i].permanent == "1" then
				local perm = yes
			else
				local perm = no
			end
			SendNUIMessage({
				type = "banlistap",
				name = tostring(BanList[i].targetname),
				reason = tostring(BanList[i].reason),
				license = tostring(BanList[i].license),
				source = tostring(BanList[i].sourcename),
				finish = "NEVER",
				perma = perm,
			})
		end
	end)
end)

RegisterNUICallback("unban", function(data)
   TriggerServerEvent("unban", data.license)
end)


RegisterNetEvent("frezzecl")
AddEventHandler("frezzecl", function()
	if frozen then 
		frozen = false
	else
		frozen = true
	end
end)


RegisterNUICallback("main", function(data)
    ESX.TriggerServerCallback('keko_adminmenu:getInfo', function(infos, loadout, inventory)
        SendNUIMessage({
            type = "invhr"
        })
        for i,k in pairs(infos) do
            if i == 'lastname' then
                lastname = k
            elseif i == 'dob' then
                dob = k
            elseif i == 'height' then
                height = k
            elseif i == 'blackmoney' then
                blackmoney = k
            elseif i == 'firstname' then
                firstname = k
            elseif i == 'sex' then
                sex = k
            elseif i == 'bankmoney' then
                bankmoney = k
            elseif i == 'cash' then
                cash = k
            end
        end

        SendNUIMessage({
            type = "refreshinfos",
            lastname = lastname,
            dob = dob,
            height = height,
            blackmoney = blackmoney,
            firstname = firstname,
            sex = sex,
            bankmoney = bankmoney,
            cash = cash,
        })
        
        for i,k in pairs(inventory) do
            if k.count > 0 then
                SendNUIMessage({
                    type = "playeritems",
                    amount = k.count,
                    label = k.label
                })
            end
        end

        SendNUIMessage({
            type = "playerhr"
        })

        for i,k in pairs(loadout) do
            print(i,json.encode(k))
            SendNUIMessage({
                type = "playeritems",
                amount = k.ammo,
                label = k.name
            })
        end

    end, data.selected)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNetEvent('keko_adminmenu:getAdmins')
AddEventHandler('keko_adminmenu:getAdmins', function()
    ESX.TriggerServerCallback('keko_adminmenu:getAdmins', function(tbl)
        SendNUIMessage({
            type = "setplayers",
            admins = tbl.admins,
            players = tbl.players
        })
    end)
end)

function getPlayers()
	local players = {}
	ESX.TriggerServerCallback('keko_adminmenu:getPlayers', function(www)
		www = json.decode(www)
		for _, player in ipairs(www) do
        	table.insert(players, {id = player.id, name = player.name})
			--print(player.name, player.id)
    	end
		table.sort(players, function(a,b) return a.id < b.id end)
    end)
	return players
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if frozen then
			local localPlayerPedId = PlayerPedId()
			FreezeEntityPosition(localPlayerPedId, frozen)
			if IsPedInAnyVehicle(localPlayerPedId, true) then
				FreezeEntityPosition(GetVehiclePedIsIn(localPlayerPedId, false), frozen)
			end 
		else
			local localPlayerPedId = PlayerPedId()
			FreezeEntityPosition(localPlayerPedId, frozen)
			if IsPedInAnyVehicle(localPlayerPedId, true) then
				FreezeEntityPosition(GetVehiclePedIsIn(localPlayerPedId, false), frozen)
			end 
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(500)
		if drawInfo and not stopSpectateUpdate then
			local localPlayerPed = PlayerPedId()
			local targetPed = GetPlayerPed(drawTarget)
			local targetGod = GetPlayerInvincible(drawTarget)
			
			local tgtCoords = GetEntityCoords(targetPed)
			if tgtCoords and tgtCoords.x ~= 0 then
				SetEntityCoords(localPlayerPed, tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent("requestSpectate")
AddEventHandler('requestSpectate', function(playerServerId, tgtCoords)
	local localPlayerPed = PlayerPedId()
--print(tgtCoords, playerServerId)
	if ((not tgtCoords) or (tgtCoords.z == 0.0)) then tgtCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerServerId))) end
	if playerServerId == GetPlayerServerId(PlayerId()) then 
		if oldCoords then
			RequestCollisionAtCoord(oldCoords.x, oldCoords.y, oldCoords.z)
			Wait(500)
			SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
			oldCoords=nil
		end
		spectatePlayer(GetPlayerPed(PlayerId()),GetPlayerFromServerId(PlayerId()),GetPlayerName(PlayerId()))
		frozen = false
		return 
	else
		if not oldCoords then
			oldCoords = GetEntityCoords(PlayerPedId())
		end
	end
	SetEntityCoords(localPlayerPed, tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)
	frozen = true
	stopSpectateUpdate = true
	local adminPed = localPlayerPed
	local playerId = GetPlayerFromServerId(playerServerId)
	repeat
		Wait(200)
		playerId = GetPlayerFromServerId(playerServerId)
	until ((GetPlayerPed(playerId) > 0) and (playerId ~= -1))
	spectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
	stopSpectateUpdate = false 
end)




local active = false
function spectatePlayer(targetPed,target,name)
	local playerPed = PlayerPedId() -- yourself
	enable = true
	if (target == PlayerId() or target == -1) then 
		enable = false
		print("Target Player is ourselves, disabling spectate.")
	end
	if(enable)then
		if(active)then
			if oldCoords then
				RequestCollisionAtCoord(oldCoords.x, oldCoords.y, oldCoords.z)
				Wait(500)
				SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
				oldCoords=nil
			end
			NetworkSetInSpectatorMode(false, targetPed)
			frozen = false
			active = false
			Citizen.Wait(200) -- to prevent staying invisible
			SetEntityVisible(playerPed, true, 0)
			SetEntityCollision(playerPed, true, true)
			SetEntityInvincible(playerPed, false)
			NetworkSetEntityInvisibleToNetwork(playerPed, false)
		else
		SetEntityVisible(playerPed, false, 0)
		SetEntityCollision(playerPed, false, false)
		SetEntityInvincible(playerPed, true)
		NetworkSetEntityInvisibleToNetwork(playerPed, true)
		Citizen.Wait(200) -- to prevent target player seeing you
		if targetPed == playerPed then
			Wait(500)
			targetPed = GetPlayerPed(target)
		end
		active = true
		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(true, targetPed)
		end
	else
		if oldCoords then
			RequestCollisionAtCoord(oldCoords.x, oldCoords.y, oldCoords.z)
			Wait(500)
			SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
			oldCoords=nil
		end
		NetworkSetInSpectatorMode(false, targetPed)
		frozen = false
		active = false
		Citizen.Wait(200) -- to prevent staying invisible
		SetEntityVisible(playerPed, true, 0)
		SetEntityCollision(playerPed, true, true)
		SetEntityInvincible(playerPed, false)
		NetworkSetEntityInvisibleToNetwork(playerPed, false)
	end
	--print(enable)
end



RegisterNUICallback("leavespecpls", function(data)
	local playerPed = PlayerPedId() -- yourself
	enable = true
	if (target == PlayerId() or target == -1) then 
		enable = false
		print("Target Player is ourselves, disabling spectate.")
	end
	if(enable)then
		if(active)then
			if oldCoords then
				RequestCollisionAtCoord(oldCoords.x, oldCoords.y, oldCoords.z)
				Wait(500)
				SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
				oldCoords=nil
			end
			NetworkSetInSpectatorMode(false, targetPed)
			frozen = false
			active = false
			Citizen.Wait(200) -- to prevent staying invisible
			SetEntityVisible(playerPed, true, 0)
			SetEntityCollision(playerPed, true, true)
			SetEntityInvincible(playerPed, false)
			NetworkSetEntityInvisibleToNetwork(playerPed, false)
		else
		SetEntityVisible(playerPed, false, 0)
		SetEntityCollision(playerPed, false, false)
		SetEntityInvincible(playerPed, true)
		NetworkSetEntityInvisibleToNetwork(playerPed, true)
		Citizen.Wait(200) -- to prevent target player seeing you
		if targetPed == playerPed then
			Wait(500)
			targetPed = GetPlayerPed(target)
		end
		active = true
		local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		RequestCollisionAtCoord(targetx,targety,targetz)
		NetworkSetInSpectatorMode(true, targetPed)
		end
	else
		if oldCoords then
			RequestCollisionAtCoord(oldCoords.x, oldCoords.y, oldCoords.z)
			Wait(500)
			SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z, 0, 0, 0, false)
			oldCoords=nil
		end
		NetworkSetInSpectatorMode(false, targetPed)
		frozen = false
		active = false
		Citizen.Wait(200) -- to prevent staying invisible
		SetEntityVisible(playerPed, true, 0)
		SetEntityCollision(playerPed, true, true)
		SetEntityInvincible(playerPed, false)
		NetworkSetEntityInvisibleToNetwork(playerPed, false)
	end
end)



-- /REPARAR
function fix()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	  if IsPedInAnyVehicle(ped, false) then
		  SetVehicleEngineHealth(vehicle, 1000)
		  SetVehicleEngineOn( vehicle, true, true )
		  SetVehicleFixed(vehicle)
	end
  end
  
  RegisterNetEvent('keko_adminmenu:clientFix')
  AddEventHandler('keko_adminmenu:clientFix', function()
	fix()
end)

RegisterCommand("reparar", function(source, args)
	playerlist = getPlayers()
    ESX.TriggerServerCallback('keko_adminmenu:getGroup', function(grp)
        if grp ~= 'user' then
            fix()
        end
    end)
end)

--/NOCLIP
local KEKO_noclip = false
local KEKO_noclipveh = false

local normalSpeed = 1.80 -- Velocidad normal
local boostedSpeed = 3.00 -- Velocidad aumentada cuando se mantiene pulsada la tecla "Left Shift"
local currentSpeed = normalSpeed -- Velocidad actual, inicializada como la velocidad normal

function getPos()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    return x, y, z
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(math.rad(heading))
    local y = math.cos(math.rad(heading))
    local z = math.sin(math.rad(pitch))

    return x, y, z
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15)
        if KEKO_noclip then
            local ped = PlayerPedId()
            local x, y, z = getPos()
            local px, py, pz = getCamDirection()

            if IsControlPressed(0, 32) then
                if IsControlPressed(0, 21) then -- Si también se mantiene pulsada la tecla "Left Shift"
                    currentSpeed = boostedSpeed -- Usar la velocidad aumentada
                else
                    currentSpeed = normalSpeed -- Usar la velocidad normal
                end
                x = x + currentSpeed * px
                y = y + currentSpeed * py
                z = z + currentSpeed * pz
            elseif IsControlPressed(0, 33) then
                if IsControlPressed(0, 21) then -- Si también se mantiene pulsada la tecla "Left Shift"
                    currentSpeed = boostedSpeed -- Usar la velocidad aumentada
                else
                    currentSpeed = normalSpeed -- Usar la velocidad normal
                end
                x = x - currentSpeed * px
                y = y - currentSpeed * py
                z = z - currentSpeed * pz
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
            SetEntityVisible(ped, false, false) -- Hace al jugador invisible para sí mismo y para los demás
        end

        if KEKO_noclipveh then
            local ped = GetVehiclePedIsIn(PlayerPedId(), false)
            local x, y, z = getPos()
            local px, py, pz = getCamDirection()

            if IsControlPressed(0, 32) then
                if IsControlPressed(0, 21) then -- Si también se mantiene pulsada la tecla "Left Shift"
                    currentSpeed = boostedSpeed -- Usar la velocidad aumentada
                else
                    currentSpeed = normalSpeed -- Usar la velocidad normal
                end
                x = x + currentSpeed * px
                y = y + currentSpeed * py
                z = z + currentSpeed * pz
            elseif IsControlPressed(0, 33) then
                if IsControlPressed(0, 21) then -- Si también se mantiene pulsada la tecla "Left Shift"
                    currentSpeed = boostedSpeed -- Usar la velocidad aumentada
                else
                    currentSpeed = normalSpeed -- Usar la velocidad normal
                end
                x = x - currentSpeed * px
                y = y - currentSpeed * py
                z = z - currentSpeed * pz
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
            SetEntityVisible(ped, false, false) -- Hace al jugador invisible para sí mismo y para los demás
        end
    end
end)

-- Comando para activar/desactivar el noclip
RegisterCommand("noclip", function(source, args)
	playerlist = getPlayers()
	ESX.TriggerServerCallback('keko_adminmenu:getGroup', function(grp)
		if grp ~= 'user' then
			if KEKO_noclip then
				KEKO_noclip = false
				KEKO_noclipveh = false
				local ped = PlayerPedId()
				SetEntityVisible(ped, true, true) -- Hace al jugador visible nuevamente para sí mismo y para los demás
				ESX.ShowNotification("Noclip desactivado")
			else
				KEKO_noclip = true
				KEKO_noclipveh = false
				local ped = PlayerPedId()
				SetEntityVisible(ped, false, false) -- Hace al jugador invisible para sí mismo y para los demás
				ESX.ShowNotification("Noclip activado")
			end
		end
	end)
end)


	playerlist = getPlayers()
    ESX.TriggerServerCallback('keko_adminmenu:getGroup', function(grp)
        if grp ~= 'user' then
            fix()
        end
    end)