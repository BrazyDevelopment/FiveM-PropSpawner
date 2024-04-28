--[[
    In order for the permissions to work, you need to add the following to your server.cfg:

    add_ace group.superadmin prop_spawner.superadmin allow
    add_ace group.admin prop_spawner.admin allow
    add_ace group.mod prop_spawner.mod allow

    Only use the lines you need.
]]

Config.PermissionGroups = {
    --"superadmin",
    "admin",
    --"mod"
}