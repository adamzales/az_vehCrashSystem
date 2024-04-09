local wasInCar = false
local oldBodyDamage = 0.0
local oldSpeed = 0.0
local currentDamage = 0.0
local currentSpeed = 0.0


IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end 

CreateThread(function()
	while true do
        Wait(10)
        
        vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)
        -- If the damage changed, see if it went over the threshold and blackout if necesary
        if DoesEntityExist(vehicle) and (wasInCar or IsCar(vehicle)) then
        wasInCar = true
        oldSpeed = currentSpeed
        oldBodyDamage = currentDamage
        currentDamage = GetVehicleBodyHealth(vehicle)
        currentSpeed = GetEntitySpeed(vehicle) * 2.23
            if currentDamage ~= oldBodyDamage then
            --print("crash")
                if not effect and currentDamage < oldBodyDamage then
                --print("effect")
                --print(oldBodyDamage - currentDamage)
                    if (oldBodyDamage - currentDamage) >= Config.Demage or (oldSpeed - currentSpeed)  >= Config.Speed
                    then
                        SetVehicleEngineHealth(vehicle, 0)
                        SetVehiclePetrolTankHealth(vehicle, 0)
                        SetVehicleEngineOn(vehicle, false, true, true)
                        SetVehicleUndriveable(vehicle, true)
                        --print(GetVehicleEngineHealth(vehicle))
                        Wait(10)
                        SetEntityHealth(PlayerPedId(-1), 0)
                        oldBodyDamage = currentDamage
                    end
                end
            end
        elseif wasInCar then
            wasInCar = false
            currentDamage = 0
            oldBodyDamage = 0
            currentSpeed = 0
            oldSpeed = 0
        end
	end
end)


function Dispatch()

    if Config.Dispatch == "cd_dispatch" then
        
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = Config.Jobs, 
        coords = data.coords,
        title = '10-50 Vehicle crash',
        message = 'A '..data.sex..' crashed a vehicle on '..data.street, 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
        sprite = 431, 
        scale = 1.2, 
        colour = 3,
        flashes = false, 
        text = '10-50 Vehicle crash',
        time = 5,
        radius = 0,
        }
        })
    else
        ---Your dispatch export




    end
end