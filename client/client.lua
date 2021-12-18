ESX = nil
local timer2 = false
local mycie = false

Citizen.CreateThread(function()
	while esx == nil do
		TriggerEvent('esx:getSharedObject', function(obj) esx = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function ()
	for i = 1, #config.vehicleWashStation do
		garageCoords = config.vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords.x, garageCoords.y, garageCoords.z)
		SetBlipSprite(stationBlip, 100)
		SetBlipAsShortRange(stationBlip, true)
		SetBlipScale(stationBlip, 1.0)
		SetBlipColour(stationBlip, 11)
	end
end)

Citizen.CreateThread(function ()
	local delay = 1
	while true do
		local wait = true
		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			for i = 1, #config.vehicleWashStation do
				garageCoords2 = config.vehicleWashStation[i]
				local dis = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords2.x, garageCoords2.y, garageCoords2.z, false)
				if dis < 15 then
					wait = false
					if dis < 3.5 then
						if mycie == false then
							esx.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~ aby skorzystać z myjni za ~g~$' .. config.price .. '')
							if IsControlJustPressed(1, 38) then
								TriggerServerEvent('szxna_myjnia:checkmoney')
							end
						end
					end
				end
			end
		end
		if wait then
			delay = 500
		else
			delay = 1
		end
		Citizen.Wait(delay)
	end
end)

RegisterNetEvent('szxna_myjnia:success')
AddEventHandler('szxna_myjnia:success', function (price)
	local car = GetVehiclePedIsUsing(PlayerPedId())
	local coords = GetEntityCoords(PlayerPedId())
	mycie = true
	FreezeEntityPosition(car, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	UseParticleFxAssetNextCall("core")
	particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("core")
	particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x + 2, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	timer = 15
	timer2 = true
	TriggerEvent('esx:showNotification', 'Trwa mycie samochodu')
	Citizen.Wait(15000)
	mycie = false
	WashDecalsFromVehicle(car, 1.0)
	SetVehicleDirtLevel(car)
	FreezeEntityPosition(car, false)
	TriggerEvent('esx:showNotification', 'Zapłacono ~g~$' .. config.price .. '~w~ za skorzystanie z myjni')
	StopParticleFxLooped(particles, 0)
	StopParticleFxLooped(particles2, 0)
	timer2 = false

end)

RegisterNetEvent('szxna_myjnia:notenoughmoney')
AddEventHandler('szxna_myjnia:notenoughmoney', function ()
	TriggerEvent('esx:showNotification', 'Nie posiadasz wystarczającej ilości pieniędzy')
end)