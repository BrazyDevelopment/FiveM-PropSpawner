local isPropSpawnerActive = false
local spawnedProp = nil
local propSpawner = nil
local hasPermission = false

RegisterNetEvent("propSpawner:toggleMenu")
AddEventHandler("propSpawner:toggleMenu", function()
    ToggleMenu()
end)

RegisterNetEvent("propSpawner:allowedToUse")
AddEventHandler("propSpawner:allowedToUse", function(allowed)
    hasPermission = allowed
    if allowed then
        ToggleMenu()
    else
        ShowNotification(Config.Translations[2])
    end
end)

function ToggleMenu()
    local newMenuState = not isPropSpawnerActive
    if newMenuState ~= isPropSpawnerActive then
        isPropSpawnerActive = newMenuState
        SetNuiFocus(isPropSpawnerActive, isPropSpawnerActive)
        SendNUIMessage({
            type = "toggleMenu",
            state = isPropSpawnerActive,
            menuActive = isPropSpawnerActive
        })
        if not isPropSpawnerActive then
            SetNuiFocus(false, false)
        end
    end
end

RegisterNUICallback("fromNui", function(data)
    local type = data.type

    if type == "showPropList" then
        ShowPropList()
    elseif type == "spawnProp" then
        local propName = data.propName
        SpawnProp(propName)
        EnablePropMovement()
    elseif type == "closeMenu" then
        ToggleMenu()
    elseif type == "moveProp" then
        EnablePropMovement()   
    elseif type == "deleteProp" then
        DeleteProp()          
    end
end)

function ShowPropList()
    local propList = ""
    for i, prop in ipairs(Config.Props) do
        propList = propList .. "<div class='propListItem' data-prop='" .. prop.model .. "' data-label='" .. prop.label .. "'>" .. prop.label .. "</div>"

    end

    SendNUIMessage({
        type = "showPropList",
        propList = propList
    })
end

function DeleteProp(propToDelete)
    if propToDelete == nil then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local propIterator = ObjectEnumerator()
        local closestDistance = math.huge

        repeat
            local prop = propIterator:GetNext()

            if DoesEntityExist(prop) then
                local distance = #(coords - GetEntityCoords(prop))

                if distance < closestDistance then
                    propToDelete = prop
                    closestDistance = distance
                end
            end
        until not prop
    end

    if propToDelete ~= nil then
        if propSpawner == PlayerId() then
            DeleteEntity(propToDelete)
            ShowNotification(Config.Translations[3])

            if spawnedProp == propToDelete then
                spawnedProp = nil
            end
        else
            ShowNotification(Config.Translations[3])
        end
    end
end

function ObjectEnumerator()
    local iteratorTable = {}
    iteratorTable.__index = iteratorTable

    function iteratorTable:GetNext()
        if self.entityTable == nil then
            self.entityTable = {}
            for _, entity in ipairs(GetGamePool('CObject')) do
                table.insert(self.entityTable, entity)
            end
        end

        self.currentIndex = self.currentIndex + 1

        if self.currentIndex > #self.entityTable then
            return nil
        else
            return self.entityTable[self.currentIndex]
        end
    end

    local function ObjectEnumerator()
        local instance = {}
        instance.entityTable = nil
        instance.currentIndex = 0
        setmetatable(instance, iteratorTable)
        return instance
    end

    return ObjectEnumerator()
end

function EnablePropMovement()
    local playerPed = PlayerPedId()

    -- Disable player movement
    SetPedCanPlayGestureAnims(playerPed, false)
    FreezeEntityPosition(playerPed, true)

    -- Find closest prop to player
    local coords = GetEntityCoords(playerPed)
    local propIterator = ObjectEnumerator()
    local closestDistance = math.huge
    local closestProp = nil

    repeat
        local prop = propIterator:GetNext()

        if DoesEntityExist(prop) then
            local distance = #(coords - GetEntityCoords(prop))

            if distance < closestDistance then
                closestProp = prop
                closestDistance = distance
            end
        end
    until not prop

    if closestProp ~= nil then
        -- Check if the player who spawned the prop is trying to move it
        if propSpawner == PlayerId() then
            -- Enable prop movement
            SetEntityCollision(closestProp, false, false)
            SetEntityHeading(closestProp, GetEntityHeading(playerPed))
            SetEntityAlpha(closestProp, 150)
            AttachEntityToEntity(closestProp, playerPed, GetPedBoneIndex(playerPed, 57005), 0.2, 0.0, -0.1, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

            Citizen.CreateThread(function()
                while true do
                    Citizen.Wait(0)
                    if IsControlJustReleased(0, Config.PlaceButton) then
                        DetachEntity(closestProp, true, true)
                        SetEntityCollision(closestProp, true, true)
                        SetEntityAlpha(closestProp, 255)
                        SetPedCanPlayGestureAnims(playerPed, true)
                        FreezeEntityPosition(playerPed, false)
                        PlaceObjectOnGroundProperly(closestProp)
                        break
                    end
                end
            end)
        else
            ShowNotification(Config.Translations[5])
        end
    end
end

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
end)

function SpawnProp(propModel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forward = GetEntityForwardVector(playerPed)
    local propCoords = vector3(coords.x + forward.x * 2, coords.y + forward.y * 2, coords.z)

    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Citizen.Wait(0)
    end

    spawnedProp = CreateObject(GetHashKey(propModel), propCoords, true, true, true)
    SetEntityCollision(spawnedProp, true, true)
    PlaceObjectOnGroundProperly(spawnedProp)
    SetModelAsNoLongerNeeded(propModel)

    -- Set the player who spawned the prop
    propSpawner = PlayerId()

    ShowNotification(Config.Translations[6])
end

RegisterCommand(Config.Command, function()
    TriggerServerEvent("propSpawner:checkPermission")
end, false)

if Config.OpenWithKeyPress then 
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased(0, Config.KeyCode) then
                TriggerServerEvent("propSpawner:checkPermission")
            end
        end
    end)
end
