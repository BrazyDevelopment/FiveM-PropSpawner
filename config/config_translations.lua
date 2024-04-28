Config.Translations = {
    [1] = "Prop Menu",
    [2] = "You do not have permission to access this menu.",
    [3] = "Prop successfully deleted.",
    [4] = "You can only delete a prop you spawned.",
    [5] = "You can only move a prop you spawned.",
    [6] = "Prop successfully spawned."
}

function ShowNotification(text)
    -- SetNotificationTextEntry("STRING")
    -- AddTextComponentString(text)
    -- DrawNotification(false, false)

    exports['okokNotify']:Alert('Prop Spawner', text, 5000, 'info', true)
end