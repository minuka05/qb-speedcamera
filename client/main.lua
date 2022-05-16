QBCore = exports['qb-core']:GetCoreObject()

Config = {}

Config.Speedcamera60Zone = {}

Config.Speedcamera80Zone = {}

Config.Speedcamera120Zone = {}

Config.Blips = {}

-- BELOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE! --
local useBilling = true -- OPTIONS: (true/false)
local useCameraSound = true -- OPTIONS: (true/false)
local useFlashingScreen = true -- OPTIONS: (true/false)
local useBlips = true -- OPTIONS: (true/false)
local alertPolice = true -- OPTIONS: (true/false)
local alertSpeed = 150 -- OPTIONS: (1-5000 KMH)

local defaultPrice60 = 100 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 60 ZONES
local defaultPrice80 = 300 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 80 ZONES
local defaultPrice120 = 500 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 120 ZONES

local extraZonePrice10 = 100 -- THIS IS THE EXTRA COST IF 10 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice20 = 500 -- THIS IS THE EXTRA COST IF 20 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice30 = 1000 -- THIS IS THE EXTRA COST IF 30 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
-- ABOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE!  --

local hasBeenCaught = false
local finalBillingPrice = 0;

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
	for _, info in pairs(Config.Blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

-- ZONES
CreateThread(function()
    while true do
        Wait(10)

		-- 60 zone
        for k in pairs(Config.Speedcamera60Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera60Zone[k].x, Config.Speedcamera60Zone[k].y, Config.Speedcamera60Zone[k].z)

            if dist <= 20.0 then
				local playerPed = PlayerPedId()
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 60.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == Config.PoliceVehicle then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), false))
											TriggerServerEvent('qb-phone:server:sendNewMail', {
												sender = "911/Police",
												subject = "Over Speeding",
												message = 'Someone passed the speed camera, above ' .. alertSpeed.. ' KMH',
											})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Wait(600)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
									QBCore.Functions.Notify("You've been fined by the speedcamera in a 60 zone! Your speed: " .. math.floor(SpeedKM) .. " KM/H", 'primary', 7500)
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice60 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice60 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice60 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice60
										end
										
										TriggerServerEvent('qb-speedcamera:PayBill60Zone')
									else
										TriggerServerEvent('qb-speedcamera:PayBill60Zone')
									end
										
									hasBeenCaught = true
									Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 80 zone
		for k in pairs(Config.Speedcamera80Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera80Zone[k].x, Config.Speedcamera80Zone[k].y, Config.Speedcamera80Zone[k].z)

            if dist <= 20.0 then
				local playerPed = PlayerPedId()
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 80.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == Config.PoliceVehicle then -- BLACKLISTED VEHICLE
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), false))
											TriggerServerEvent('qb-phone:server:sendNewMail', {
												sender = "911/Police",
												subject = "Over Speeding",
												message = 'Someone passed the speed camera, above ' .. alertSpeed.. ' KMH',
											})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Wait(600)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
									QBCore.Functions.Notify("You've been fined by the speedcamera in a 80 zone! Your speed: " .. math.floor(SpeedKM) .. " KM/H", 'error', 7500)
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice80 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice80 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice80 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice80
										end
									
										TriggerServerEvent('qb-speedcamera:PayBill80Zone')
									else
										TriggerServerEvent('qb-speedcamera:PayBill80Zone')
									end
										
									hasBeenCaught = true
									Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 120 zone
		for k in pairs(Config.Speedcamera120Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera120Zone[k].x, Config.Speedcamera120Zone[k].y, Config.Speedcamera120Zone[k].z)

            if dist <= 20.0 then
				local playerPed = PlayerPedId()
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 120.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == Config.PoliceVehicle then -- BLACKLISTED VEHICLE
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), false))
											TriggerServerEvent('qb-phone:server:sendNewMail', {
												sender = "911/Police",
												subject = "Over Speeding",
												message = 'Someone passed the speed camera, above ' .. alertSpeed.. ' KMH',
											})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('qb-speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Wait(600)
										TriggerServerEvent('qb-speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)
									QBCore.Functions.Notify("You've been fined by the speedcamera in a 120 zone! Your speed: " .. math.floor(SpeedKM) .. " KM/H", 'error', 7500)
									
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice120 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice120 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice120 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice120
										end
									
										TriggerServerEvent('qb-speedcamera:PayBill120Zone')
									else
										TriggerServerEvent('qb-speedcamera:PayBill120Zone')
									end
										
									hasBeenCaught = true
									Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

RegisterNetEvent('qb-speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('qb-speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)
