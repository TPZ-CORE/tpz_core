--[[ ------------------------------------------------
   TPZ CORE CONFIGURATION
]]---------------------------------------------------

Config = {

    DevMode          = true, -- (!) Do not use this on live servers with players, this is only for testing purposes.

    OneSync          = true,

    SavePlayerLocationTime = 120000, -- in milliseconds, 120.000 = every 2 minutes.
    SavePlayerHealthAndStaminaTime = 300000, -- in milliseconds, 300.000 = 5 minutes.
    DisableAutoAim   = true,
    HideOnlyDeadEye  = true,

    MapObject        = true, -- If true, a map object will be attached to the players hand when opening the map.
    
    PlayAnimPostFX   = true, -- Playing after selecting a character, AnimpostfxPlay Title_Gen_FewHoursLater.
    HidePlayersCore  = false,
    HideHorsesCore   = false,

    MaxHealth        = 5, -- 10 is max value, 0 is empty core for the players.
    MaxStamina       = 5, -- 10 is max value, 0 is empty core for the players.

    MapTypeOnFoot    = 1, -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass)
    MapTypeOnMount   = 1, -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass)
    EnableTypeRadar  = true, -- If true, the above selections will run, if you keep it as false, players can choose their radar type from game settings.

    EnableEagleEye   = true,
    EnableDeadEye    = false,

    PVP              = true,         -- Can players attack/hurt one another

    DisableHealthRechargeMultipler = false,

    HealthRecharge           = { Enable = true, Multiplier = 0.37 }, -- enable or disable auto recharge of health outer core (real ped health), multiplier 1.0 is default
    StaminaRecharge          = { Enable = true, Multiplier = { ['1'] = 0.6, ['2'] = 0.4, ['3'] = 0.3, ['4'] = 0.1 } },  -- enable or disable auto recharge of stamina outer core stages, multiplier 1.0 is default. (1 = 100 stamina, 2 = 50 stamina, 3 = 20 stamina, 4 = 5 stamina)

    -- If true, all the accounts can get negative when removing more than the available amount.
    NegativeValueOnAccounts = false,

    NewCharacter = {

        Accounts = { 
            [0] = 10, -- cash
            [1] = 0,  -- cents
            [2] = 0,  -- gold
            [3] = 0,  -- blackmoney
        },
    
    },

    SpawnCoords = { 
        [1] = { 
            x = 1269.325, y = -6851.982, z = 42.168, heading = 235.10, 
        },

        [2] = { 
            x = 1269.55, y = -6854.188, z = 42.168, heading = 235.10, 
        },

        [3] = { 
            x = 1270.245, y = -6854.557, z = 42.168, heading = 235.10, 
        },

        [4] = { 
            x = 1265.973, y = -6854.015, z = 42.168, heading = 235.10, 
        },

        [5] = { 
            x = 1270.34, y = -6857.038, z = 42.168, heading = 235.10, 
        },
    },

    OnPlayerDeath = {

        TPDirtSystem            = false, -- Titans Productions Paid Script Supported for removing Ptfx particles.

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

        PlayAnimPostFXPlay      = true, -- Playing when respawning AnimpostfxPlay Title_Gen_FewHoursLater and PlayerWakeUpInterrogation.

        IncreaseRespawnIfAlertedBy = 300, -- If the player has alerted, we increase the respawn time by 300 seconds (5 minutes in total). If you don't want, set it to false.

        -- RedM Keys List: https://github.com/mja00/redm-shit/blob/master/nuiweaponspawner/config.lua
        -- The following prompt (ALERT) requires `tpz_pigeon_alerts`. Set `enabled` to false if you don't use it.
        PromptKeys = {
            ['RESPAWN']  = {enabled = true,  label = "Respawn",       key = 0xC7B5340A,  holdMode = 5000,  cooldown = 600 }, -- Cooldown: To display (Enable) the Respawn Button (in seconds).
            ['ALERT']    = {enabled = true,  label = "Alert Pigeon",  key = 0xD9D0E1C0,  holdMode = 3000,  cooldown = 300 }, -- Cooldown: After alert, the cooldown to alert again.
        },

        BottomPromptLabelDisplays = {
            ['WHILE_RESPAWN_HAS_COOLDOWN'] = "You have to wait %s seconds before respawning or you can alert a trained pigeon.",
            ['WHILE_NO_RESPAWN_COOLDOWN']  = "The time has passed and you can now respawn or you can still wait if you have already alerted.",
        },

        RespawnLocations = {
            { Town = "Guarma",      Coords = { x = 1289.095,  y = -6856.16,   z = 42.934,  heading = 252.59 } },

            { Town = "Valentine",   Coords = { x = -283.83,   y = 806.4,      z = 119.38,  heading = 321.76 } },
            { Town = "Saint Denis", Coords = { x = 2721.4562, y = -1446.0975, z = 46.2303, heading = 321.76 } },
            { Town = "Armadillo",   Coords = { x = -3742.5,   y = -2600.9,    z = -13.23,  heading = 321.76 } },
            { Town = "Black water", Coords = { x = -723.9527, y = -1242.8358, z = 44.7341, heading = 321.76 } },
            { Town = "Rhodes",      Coords = { x = 1229.0,    y = -1306.1,    z = 76.9,    heading = 321.76 } },
        },

    },

    -- The following options below, allows you to remove from the selected player, the contents and account when respawning.
    OnPlayerDeathRespawn = {

        RemoveInventoryContents = true, -- Includes Items & Weapons.
        RemoveLoadout           = true, -- Ammunition

        Accounts = {
            [0]         = true,  -- Money Currency
            [1]         = true,  -- Cents Currency
            [2]         = false, -- Gold Currency
            [3]         = true,  -- Black Money
        },

    },
    
    RestartManagement = {
        Enabled = true,

        BlockedJoiningTime = { "7:55" , "13:55", "19:55", "1:55" }, -- The time to prevent players joining the game (5 minutes before restart as default).
        KickPlayersTime    = { "7:58" , "13:58", "19:58", "1:58" }, -- The time to kick all the connected players (2 minutes before restart as default, to save each player properly).

        KickWarning        = "[Server Name]: The server is now restarting, please try to connect within a few minutes.",
        ConnectWarning     = "[Server Name]: The server is restarting, please try to connect within a few minutes.",
    },


    DiscordWebhooking = {
        Label = "TPZ-CORE",
        ImageUrl = "https://i.imgur.com/XK16oK4.png",
        Footer = "© Titans Productions",

        URL = {
            ['SERVER_STARTUP']       = { enabled = false, url = "", title = "[Server Name]", message = "📣 The server has been succesffully started. Join us now!", color = 10038562},

            ['CREATE_NEW_CHARACTER'] = { enabled = true,  url = "", color = 10038562},
        },

    },

    Commands = {

        ['cleartasks'] = { 
            Suggestion = "Perform this command to teleport on the marked coords.",
        },

        ['setgroup'] = { 

            Suggestion = "Perform this command to set the group of the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['setjob'] = { 

            Suggestion = "Perform this command to set the job of the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['addaccount'] = { 

            Suggestion = "Perform this command to add account money on the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['removeaccount'] = { 

            Suggestion = "Perform this command to remove account money from the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        
        ['additem'] = { 

            Suggestion = "Perform this command to add items on the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

                
        ['addweapon'] = { 

            Suggestion = "Perform this command to add weapons on the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['clearinventory'] = { 

            Suggestion = "Perform this command to clear all the inventory contents on the selected user.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['revive'] = { 

            Suggestion = "Perform this command to revive a player.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['kill'] = { 

            Suggestion = "Perform this command to kill a player.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['tpm'] = { 

            Suggestion = "Perform this command to teleport on the marked coords.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['tpcoords'] = { 

            Suggestion = "Perform this command to teleport on the selected coords.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['tpto'] = { 

            Suggestion = "Perform this command to teleport on the selected player coords.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        
        ['tphere'] = { 

            Suggestion = "Perform this command to teleport a player on your coords.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },

        ['heal'] = { 

            Suggestion = "Perform this command to heal the selected player id.",

            Webhook = { 
                Enable = true, 
                Url = "https://discord.com/api/webhooks/1176843075952328734/2hSyCGdtgtpY0iu5h9Bn09aNPlf-7GQyw_epjqkNMSgc9wdrEjm4NWLAQDVdAWRLd3wP", 
                Color = 10038562,
            },
            
            Groups  = { ['admin'] = true, ['mod'] = true },
        },
    }

}