Config = {}

-- (!) Do not use this on live servers with players, this is only for testing purposes.
Config.DevMode = false

Config.Debug   = false

-- OneSync is suggested for servers, it should NOT be set to false if you don't
-- know what you doing.
Config.OneSync = true

---------------------------------------------------------------
--[[ Discord API Configurations ]]--
---------------------------------------------------------------

-- The specified feature is for advanced permissions which are based on the discord roles of your discord server.

-- Your discord server ID.
Config.DiscordServerID = 'xxxxxxxxxxxxxxxxxxxxxxxx'

-- Your discord bot token, if does not exist, create a bot in the url below:
-- https://discord.com/developers/applications

Config.DiscordBotToken = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

-- The specified discord roles will be considered as administrators and will be used in some CORE Functions such as API.DisconnectAll()
Config.DiscordAdministratorRoles = { 1111111111111111, 222222222222222222 }

-- The specified groups will be considered as administrators and will be used in some CORE Functions such as API.DisconnectAll()
Config.AdministratorGroups = { 'admin' }

---------------------------------------------------------------
--[[ General Settings ]]--
---------------------------------------------------------------

Config.MaxCharacters = 2 -- By Default! Change manually through users database table. 

Config.SavePlayerLocationTime = 120000 -- in milliseconds, 120.000 = every 2 minutes.
Config.SavePlayerHealthAndStaminaTime = 300000 -- in milliseconds, 300.000 = 5 minutes.
Config.DisableAutoAim = true
Config.HideOnlyDeadEye = true

-- If true, a map object will be attached to the players hand when opening the map.
Config.MapObject = true
    
-- Playing after selecting a character, AnimpostfxPlay Title_Gen_FewHoursLater.
Config.PlayAnimPostFX = true 

Config.HidePlayersCore = false
Config.HideHorsesCore = false

Config.MaxHealth = 5 -- 10 is max value, 0 is empty core for the players.
Config.MaxStamina = 5 -- 10 is max value, 0 is empty core for the players.

Config.MapTypeOnFoot = 1 -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass)
Config.MapTypeOnMount = 1 -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass)

-- If true, the above selections will run, if you keep it as false, players can choose their radar type from game settings.
Config.EnableTypeRadar = true

-- If true, the radar will be 10x zoomed in when being inside an interior (NOT CUSTOM MLO)
Config.ShowInteriorMappingsRadar = true

Config.EnableEagleEye = true
Config.EnableDeadEye = false

-- Can players attack/hurt one another?
Config.PVP = true

-- This enables the mercy kill on the animals like in RDR2, you will get a prompt kill to end their suffering when their are down and can't move,
-- this also allows to preserve the pelts quality.
Config.PlayerCanMercyKill = {Enabled = true, UpdateDelay = 30 } -- time in seconds, the PlayerId sometimes can change during the game and we have to update time to time.

-- If anyone wants to integrate the "Show Info" prompts for animals when pressing the Q key button, set it to true.
-- otherwise, this prompt will always be active but there will be no info displayed.
Config.AnimalShowInfo = false

Config.DisableHealthRechargeMultipler = false

-- enable or disable auto recharge of health outer core (real ped health), multiplier 1.0 is default
Config.HealthRecharge = { Enable = true, Multiplier = 0.37 }

-- enable or disable auto recharge of stamina outer core stages, multiplier 1.0 is default. (1 = 100 stamina, 2 = 50 stamina, 3 = 20 stamina, 4 = 5 stamina)
Config.StaminaRecharge = { Enable = true, Multiplier = { ['1'] = 0.6, ['2'] = 0.4, ['3'] = 0.3, ['4'] = 0.1 } }

-- If true, all the accounts can get negative when removing more than the available amount.
-- (!) I don't personally suggest it, it can also cause bugs if a script is not supporting it well.
Config.NegativeValueOnAccounts = false

-- @param first: What would you want the Identity generated letters to be when a new character is created?

-- @param numbers: How many numbers would you like the generated letters to have?
-- If numbers input are 3, the total will be (7) because the first (4) numbers will always be the month (0-12) and seconds (0-60) based on the character creation (real-time)
-- in order to have a better random generator, otherwise somehow, one day, someone might end up having the same identity with someone else.

-- Example: GRC-XXXXXXX
Config.IdentityIdGeneratedData = { first_letters = 'GRC-', numbers = 3 }

---------------------------------------------------------------
--[[ New Character Settings ]]--
---------------------------------------------------------------

Config.NewCharacter = {
        
    -- One of the specified coords will be randomly selected when a new character is created.
    -- When selected, this is the location where the player will be spawned on first join.
    FirstSpawnCoords = { 
        { x = -1369.91, y = -2289.31,  z = 43.535, heading = 103.0905227661 },
    },

    -- The given accounts (money) when player spawned for first time.
    Accounts = { 
        [0] = 10, -- cash
        [1] = 0,  -- gold
        [2] = 0,  -- blackmoney
    },

    -- The given items when player spawned for first time.
    StartItems = {
        Enabled = false, -- Set to false if you don't want to give any items.
 
        -- @Parameters : Item Name, Item Quantity
        Items = {
            ['consumable_water_bottle'] = 5,
        },

    },

    -- The given weapons when player spawned for first time.
    StartWeapons = {
        Enabled = false, -- Set to false if you don't want to give any weapons.
            
        -- @Parameters : Weapon Name
        Weapons = {
            'WEAPON_MELEE_KNIFE',
        },

    },

}


---------------------------------------------------------------
--[[ Player Death Settings ]]--
---------------------------------------------------------------

Config.OnPlayerDeath = {

    DeathCamera             = true, 
    UseControlsCamera       = true,

    -- All anim post fx can be found here: https://github.com/femga/rdr3_discoveries/blob/master/graphics/animpostfx/animpostfx.lua
    -- set to false if you don't want to use any camera effects. ( Ex: DeathCameraEffects = false )
    DeathCameraEffects      = { 	
        "ODR3_Injured01Loop",
        "MP_DeathInk_Color00",
        "MP_DeathInk_Color01",
        "MP_DeathInk_Color02",
        "MP_DeathInk_Color03",
        "MP_DeathInk_Color04",
        "MP_DeathInk_Color05",
        "MP_DeathInk_Color06",
        "MP_DeathInk_Color07",
        "MP_DeathInk_Color08",
        "MP_DeathInk_Color09",
        "MP_DeathInk_Color10" 
    },

    HealthOnRespawn         = 500, --Player's health when respawned. (MAX = 500)
    HealthOnResurrection    = 250, --Player's health when resurrected. (MAX = 500)
    RagdollOnResurrection   = true, -- Enable or disable Ragdoll and revive effects when revived including AnimpostfxPlay Title_Gen_FewHoursLater and PlayerWakeUpInterrogation.
    RagdollKeepDown         = 10,   -- Time in seconds (How many seconds would you like the player to be on ragdoll after respawn).
    
    PlayAnimPostFXPlay      = true, -- Playing when respawning AnimpostfxPlay Title_Gen_FewHoursLater and PlayerWakeUpInterrogation.

    -- RedM Keys List: https://github.com/mja00/redm-shit/blob/master/nuiweaponspawner/config.lua
    PromptKeys = {
        ['RESPAWN']  = {enabled = true,  label = "Respawn",  key = 0xC7B5340A,  holdMode = 5000,  cooldown = 600 }, -- Cooldown: To display (Enable) the Respawn Button (in seconds).
    },

    BottomPromptLabelDisplays = {
        ['WHILE_RESPAWN_HAS_COOLDOWN'] = "You have to wait %s seconds before respawning.",
        ['WHILE_NO_RESPAWN_COOLDOWN']  = "The time has passed and you can now respawn.",
    },

    RespawnLocations = {
        { Town = "Guarma",      Coords = { x = 1289.095,  y = -6856.16,   z = 42.934,  heading = 252.59 } },

        { Town = "Valentine",   Coords = { x = -283.83,   y = 806.4,      z = 119.38,  heading = 321.76 } },
        { Town = "Saint Denis", Coords = { x = 2721.4562, y = -1446.0975, z = 46.2303, heading = 321.76 } },
        { Town = "Armadillo",   Coords = { x = -3742.5,   y = -2600.9,    z = -13.23,  heading = 321.76 } },
        { Town = "Black water", Coords = { x = -723.9527, y = -1242.8358, z = 44.7341, heading = 321.76 } },
        { Town = "Rhodes",      Coords = { x = 1229.0,    y = -1306.1,    z = 76.9,    heading = 321.76 } },
    },

}

---------------------------------------------------------------
--[[ Player Respawn Settings ]]--
---------------------------------------------------------------

-- The following options below, allows you to remove from the selected player, the contents and account when respawning.
Config.OnPlayerDeathRespawn = {

    RemoveInventoryContents = true, -- Includes Items & Weapons.

    Accounts = {
        [0] = true,  -- Money Currency
        [1] = false, -- Gold Currency
        [2] = true,  -- Black Money
    },

}

---------------------------------------------------------------
--[[ Server Restart System ]]--
---------------------------------------------------------------

-- The specified features DOES NOT restart your server but it creates a system to prevent the players to join in the server while
-- its getting restarted, it is also kicking them few minutes before in order to save all data properly.
Config.RestartManagement = {
    Enabled = false,

    BlockedJoiningTime = { "7:55" , "13:55", "19:55", "1:55" }, -- The time to prevent players joining the game (5 minutes before restart as default).
    KickPlayersTime    = { "7:58" , "13:58", "19:58", "1:58" }, -- The time to kick all the connected players (2 minutes before restart as default, to save each player properly).

    KickWarning        = "[Server Name]: The server is now restarting, please try to connect within a few minutes.",
    ConnectWarning     = "[Server Name]: The server is restarting, please try to connect within a few minutes.",
}

-- If your scripts are taking time to ensure or you want to give to the server some time
-- before allowing the players to join, set it to true.
Config.PreventPlayersJoiningDelay = { Enabled = false, Delay = 60, DeferNotify = 'The server is still starting, please wait %s seconds before joining again.' } -- time in seconds.

---------------------------------------------------------------
--[[ Discord Webhooking ]]--
---------------------------------------------------------------

Config.DiscordWebhooking = {
    Label = "TPZ-CORE",
    ImageUrl = "https://i.imgur.com/XK16oK4.png",
    Footer = "© Titans Productions",

    URL = {
        ['SERVER_STARTUP']       = { Enabled = false, Url = "", Title = "[Server Name]", Description = "📣 The server has been succesffully started. Join us now!", color = 10038562},
        ['CREATE_NEW_CHARACTER'] = { Enabled = false, Url = "", Color = 10038562},
    },

}

---------------------------------------------------------------
--[[ Commands ]]--
---------------------------------------------------------------

Config.Commands = {

    ['cleartasks'] = { 
        Suggestion = "Perform this command to clear the ped tasks.",
        CommandHelpTips = false,
    },

    ['setmaxchars'] = { 

        Suggestion = "Perform this command to set the max characters of the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Chars", help = 'Max Chars (>= 1)' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['setinventoryweight'] = { 

        Suggestion = "Perform this command to set the maximum inventory weight capacity of the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Weight", help = 'Weight' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['addinventoryweight'] = { 

        Suggestion = "Perform this command to add am extra inventory weight capacity on the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Weight", help = 'Weight' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['setgroup'] = { 

        Suggestion = "Perform this command to set the group of the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Group", help = 'Group' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['setjob'] = { 

        Suggestion = "Perform this command to set the job of the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Job", help = 'Job Name' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['addaccount'] = { 

        Suggestion = "Perform this command to add account money on the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Account Type", help = "Types : ( [0]: Cash | [1]: Gold | [2]: Black Money )" }, { name = "Amount", help = 'Amount' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['removeaccount'] = { 

        Suggestion = "Perform this command to remove account money from the selected user.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Account Type", help = "Types : ( [0]: Cash | [1]: Gold | [2]: Black Money )" }, { name = "Amount", help = 'Amount' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['revive'] = { 

        Suggestion = "Perform this command to revive a player.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['kill'] = { 

        Suggestion = "Perform this command to kill a player.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['tpm'] = { 

        Suggestion = "Perform this command to teleport on the marked coords.",
        CommandHelpTips = false,

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod'},
        DiscordRoles  = { 670899926783361024 },
    },

    ['tpcoords'] = { 

        Suggestion = "Perform this command to teleport on the selected coords.",
        CommandHelpTips = { { name = "X", help = '(X) Coords' }, { name = "Y", help = '(Y) Coords' }, { name = "Z", help = '(Z) Coords' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['tpto'] = { 

        Suggestion = "Perform this command to teleport on the selected player coords.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    
    ['tphere'] = { 

        Suggestion = "Perform this command to teleport a player on your coords.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

    ['heal'] = { 

        Suggestion = "Perform this command to heal the selected player id.",
        CommandHelpTips = { { name = "Id", help = 'Player ID' } },

        Webhook = { 
            Enabled = false, 
            Url = "", 
            Color = 10038562,
        },
        
        Groups  = { 'admin', 'mod' },
        DiscordRoles  = { 670899926783361024 },
    },

}
