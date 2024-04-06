ESX = nil

ESX = exports["es_extended"]:getSharedObject()
----------------------------------------------------------------------------------
RegisterNetEvent("keko-report:killPlayer")
AddEventHandler("keko-report:killPlayer", function()
  SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent("keko-report:freezePlayer")
AddEventHandler("keko-report:freezePlayer", function(input)
    local player = PlayerId()
	local ped = PlayerPedId()
    if input == 'freeze' then
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
    elseif input == 'unfreeze' then
        SetEntityCollision(ped, true)
	    FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    end
end)



-------- noclip --------------

local noclip = false
local noclip_speed = 1.5
function getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
end
function getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)

	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x,y,z
end
function isNoclip()
	return noclip
end

RegisterNetEvent("keko-report:noclip")
AddEventHandler("keko-report:noclip", function(input)
    local player = PlayerId()
	local ped = PlayerPedId
	local msg = "desactivado"
	if(noclip == false)then
	end
	noclip = not noclip
	if(noclip)then
		msg = "activado"
	end
	TriggerEvent("chatMessage", "Noclip ^2^*" .. msg)
		SetEntityVisible(GetPlayerPed(-1), true, 0)

	end)
	local heading = 0
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if noclip then
			local ped = GetPlayerPed(-1)
			local x,y,z = getPosition()
			local dx,dy,dz = getCamDirection()
			local speed = noclip_speed

			SetEntityVisible(GetPlayerPed(-1), false, 0)
			SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
		if IsControlPressed(0,32) then -- MOVE adelante
			x = x+speed*dx
			y = y+speed*dy
			z = z+speed*dz
		end
		if IsControlPressed(0,269) then -- MOVE atras
			x = x-speed*dx
			y = y-speed*dy
			z = z-speed*dz
		end
		if IsControlPressed(0,34) then -- MOVE IZQ
			x = x-1
		end
		if IsControlPressed(0,9) then -- MOVE DERCH
			x = x+1
		end
		if IsControlPressed(0,203) then -- MOVE arriba
			z = z+1
		end
		if IsControlPressed(0,210) then -- MOVE arriba
			z = z-1
		end
		if IsControlPressed(0,21) then
			noclip_speed = 3.0
		else
			noclip_speed = 1.5
		end
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
		end
	end
end)

--Thanks to qalle for this code | https://github.com/qalle-fivem/esx_marker
RegisterNetEvent("keko-report:tpm")
AddEventHandler("keko-report:tpm", function()
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
        end
        TriggerEvent('chatMessage', _U('teleported'))
    else
        TriggerEvent('chatMessage', _U('set_waypoint'))
    end
end)
