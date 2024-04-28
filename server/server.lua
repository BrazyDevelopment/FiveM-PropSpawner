RegisterNetEvent("propSpawner:checkPermission")
AddEventHandler("propSpawner:checkPermission", function()
    local src = source
    local allowed = false

    for _, group in ipairs(Config.PermissionGroups) do
        if IsPlayerAceAllowed(src, "prop_spawner." .. group) then
            allowed = true
            break
        end
    end

    TriggerClientEvent("propSpawner:allowedToUse", src, allowed)
end)
