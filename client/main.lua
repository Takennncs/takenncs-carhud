local currentVehicle = 0
local cruiseActive, beltActive = false, false
local playerPed = nil
local inAir = 0

local vehicleInfo = {
    hasBelt = false,
    hasCruise = false,
    currentRpm = 0.0,
    currentSpeed = 0.0,
    cruiseSpeed = 0.0,
    prevVelocity = {x = 0.0, y = 0.0, z = 0.0},
}

local BELT_KEY = 0x5A

Citizen.CreateThread(function()
    while true do
        if currentVehicle ~= 0 then
            local fuelLevel = 0
            
            if exports then
                if exports['cdn-fuel'] then
                    local success, result = pcall(function()
                        return exports['cdn-fuel']:GetFuel(currentVehicle)
                    end)
                    
                    if success and result then
                        fuelLevel = result
                    else
                        local success2, result2 = pcall(function()
                            return exports['cdn-fuel']:getFuel(currentVehicle)
                        end)
                        
                        if success2 and result2 then
                            fuelLevel = result2
                        else
                            fuelLevel = GetVehicleFuelLevel(currentVehicle)
                        end
                    end
                else
                    fuelLevel = GetVehicleFuelLevel(currentVehicle)
                end
            else
                fuelLevel = GetVehicleFuelLevel(currentVehicle)
            end

            SendNUIMessage({
                message = 'vehicleUpdate',
                vehicleSpeed = math.floor(vehicleInfo['currentSpeed'] * 3.6),
                vehicleRpm = vehicleInfo['currentRpm'],
                vehicleFuel = math.floor(fuelLevel)
            })
        end

        Citizen.Wait(currentVehicle == 0 and 500 or 60)
    end
end)

Citizen.CreateThread(function()
    while true do
        if currentVehicle ~= 0 then
            if IsControlJustReleased(0, BELT_KEY) and vehicleInfo['hasBelt'] then
                beltActive = not beltActive

                SendNUIMessage({
                    message = 'beltToggle',
                    HasBelt = vehicleInfo['hasBelt'],
                    BeltActive = beltActive
                })
            end

            local prevSpeed = vehicleInfo['currentSpeed']
            vehicleInfo['currentSpeed'] = GetEntitySpeed(currentVehicle)
            vehicleInfo['currentRpm'] = GetVehicleCurrentRpm(currentVehicle)

            local isDriver = (GetPedInVehicleSeat(currentVehicle, -1) == playerPed)

            if isDriver then
                if isDriver ~= vehicleInfo['hasCruise'] then
                    vehicleInfo['hasCruise'] = isDriver
                    SendNUIMessage({
                        message = 'cruiseToggle',
                        HasCruise = vehicleInfo['hasCruise'],
                        CruiseActive = cruiseActive
                    })
                end

                if IsControlJustReleased(0, Config['cruiseControlKey']) then
                    cruiseActive = not cruiseActive
                    SendNUIMessage({
                        message = 'cruiseToggle',
                        HasCruise = isDriver,
                        CruiseActive = cruiseActive
                    })
                    vehicleInfo['cruiseSpeed'] = vehicleInfo['currentSpeed']
                    cruiseSpeed = vehicleInfo['cruiseSpeed']
                end

                local maxSpeed = cruiseActive and vehicleInfo['cruiseSpeed'] or GetVehicleHandlingFloat(currentVehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                SetEntityMaxSpeed(currentVehicle, maxSpeed)

                local roll = GetEntityRoll(currentVehicle)

                if cruiseActive and not IsEntityInAir(currentVehicle) and inAir >= 100 and not (roll > 75.0 or roll < -75.0) then
                    if cruiseSpeed < maxSpeed then
                        cruiseSpeed = cruiseSpeed + 0.15
                    end
                    SetVehicleForwardSpeed(currentVehicle, cruiseSpeed)
                elseif cruiseActive and not IsEntityInAir(currentVehicle) then
                    inAir = inAir + 1
                    cruiseSpeed = vehicleInfo['currentSpeed']
                elseif cruiseActive then
                    inAir = 0
                end
            else
                cruiseActive = false
            end
        end

        Citizen.Wait(currentVehicle == 0 and 500 or 5)
    end
end)

function vehicleHasBelt(class)
    if not class then return false end
    local hasBelt = Config.beltClasses[class]
    if not hasBelt or hasBelt == nil then return false end
    return hasBelt
end

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)

        local position = GetEntityCoords(playerPed)
        local heading = Config['Directions'][math.floor((GetEntityHeading(playerPed) + 45.0) / 90.0)]
        local zoneNameFull = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))

        SendNUIMessage({
            message = 'streetInfo',
            streetName = zoneNameFull,
            streetDirection = heading
        })

        if veh ~= currentVehicle then
            currentVehicle = veh

            SendNUIMessage({
                message = 'vehicleHud',
                hudActive = veh ~= 0
            })

            if veh == 0 then
                beltActive = false
                cruiseActive = false
                vehicleInfo['hasCruise'] = false
                vehicleInfo['currentSpeed'] = 0.0

                SendNUIMessage({
                    message = 'cruiseToggle',
                    HasCruise = false,
                    CruiseActive = false
                })

                SendNUIMessage({
                    message = 'beltToggle',
                    HasBelt = false,
                    BeltActive = false
                })
            else
                local vehicleClass = GetVehicleClass(veh)
                vehicleInfo['hasBelt'] = vehicleHasBelt(vehicleClass)

                SendNUIMessage({
                    message = 'beltToggle',
                    HasBelt = vehicleInfo['hasBelt'],
                    BeltActive = beltActive
                })
            end
        end

        Citizen.Wait(800)
    end
end)

local screenPosX = 0.195
local screenPosY = 0.95

local textColor = {255, 255, 255, 255}

local directions = {
    [0] = 'N', [1] = 'NW', [2] = 'W', [3] = 'SW',
    [4] = 'S', [5] = 'SE', [6] = 'E', [7] = 'NE', [8] = 'N'
}

local zones = {
    ['KOREAT'] = "Little Seoul",
    ['ROCKF'] = "Rockford Hills",
    ['AIRP'] = "Los Santos International Airport",
    ['ZP_ORT'] = "Port of South Los Santos",
    ['ZQ_UAR'] = "Davis Quartz",
}

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local position = GetEntityCoords(playerPed)

            local heading = GetEntityHeading(playerPed)
            local dirIndex = math.floor((heading + 22.5) / 45.0) % 8
            local headingText = directions[dirIndex] or "?"

            local streetHash, crossingHash = GetStreetNameAtCoord(position.x, position.y, position.z)
            local streetName = GetStreetNameFromHashKey(streetHash) or ""
            local crossingName = GetStreetNameFromHashKey(crossingHash) or ""

            local zoneHash = GetNameOfZone(position.x, position.y, position.z)
            local zoneName = zones[zoneHash] or zoneHash or ""

            local fullText = headingText
            if streetName ~= "" then
                fullText = fullText .. " | " .. streetName
            end
            if crossingName ~= "" and crossingName ~= streetName then
                fullText = fullText .. " / " .. crossingName
            end
            if zoneName ~= "" then
                fullText = fullText .. " | " .. zoneName
            end

            drawTxt(fullText, 4, textColor, 0.40, screenPosX, screenPosY)
        end

        Citizen.Wait(IsPedInAnyVehicle(playerPed, false) and 0 or 500)
    end
end)

function drawTxt(text, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], colour[4] or 255)
    SetTextEntry("STRING")
    SetTextCentre(false)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            local torqueMult   = 0.45
            local powerMult    = 0.70
            local maxSpeedKmh  = nil

            SetVehicleEngineTorqueMultiplier(vehicle, torqueMult)
            SetVehicleEnginePowerMultiplier(vehicle, powerMult)

            if maxSpeedKmh then
                local maxSpeedMs = maxSpeedKmh / 3.6
                SetVehicleMaxSpeed(vehicle, maxSpeedMs)
            end
        end
    end
end)