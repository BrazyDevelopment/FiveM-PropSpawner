Config = {}

Config.Command = 'propmenu' -- Command name to open the prop menu

Config.OpenWithKeyPress = true -- Use 'true' to open with keypress also or 'false' to use only the command.
Config.KeyCode = 344 -- Currently: F11. To change, find the corresponding number here https://docs.fivem.net/docs/game-references/controls/ (Advised to keep the same as Config.KeyMap if using Key Mapping)

Config.PlaceButton = 25 -- Button to place the prop. Currently Right-Click on mouse. 

Config.Props = { -- Configure custom props and their names here.
    { model = "prop_alien_egg_01", label = "Alien Egg" },
    { model = "prop2", label = "Custom Prop 2" },
    -- ...
}

Config.MinDistanceBetweenProps = 1.0
Config.PropInteractionRange = 3.0