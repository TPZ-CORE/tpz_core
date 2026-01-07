----------------------------------------------
-- Webhooks (ADD ALL YOUR WEBHOOKS HERE)
----------------------------------------------

/*
   Insert all the webhooks on the scripts you are having below.

   All of our webhooks are located here and not through the script config, the configuration file is shared,
   and since it is shared, a RedM Executer can find all of your script webhooks easily and spam or share them to others.
*/


local WEBHOOKS = {

    ["tpz_lumberjack"] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ["tpz_mining"] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ["tpz_users_inactivity"] = {
        ['ALL'] = "",
    },

    ["tpz_passports"] = {
        ['CREATED_PASSPORT'] = "",
        ['RETRIEVED_PASSPORT'] = "",
        ['RENEWED_PASSPORT'] = "",
    },

    ["tpz_police"] = {
        ['COMMANDS'] = "",
    },

    ["tpz_fishing"] = {
        ['FISH_RECEIVED'] = "",
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ["tpz_stables"] = {
        ['COMMANDS'] = "",
        ['BOUGHT'] = "",
        ['SOLD'] = "",
        ['SOLD_TAMED_HORSE'] = "",
        ['TRANSFERRED'] = "",
        ['RECEIVED_TAMED_HORSE'] = "",
    },

    ["tpz_society"] = {
        
        ['DEVTOOLS_INJECTION_CHEAT'] = "",

        -- Insert below the society job name for the webhook url from Config.Societies.
        ['police'] = "",
        ['medic'] = "",
    },
   
    ['tpz_medics'] = {
        ['ACTIONS'] = "",
        ['ALERTS'] = "", 
    },
   
    ['tpz_crafting'] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ['tpz_goldpanning'] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ['tpz_search'] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ['tpz_weapons'] = {
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },
   
    ['tpz_admin'] = {
        ['COMMANDS'] = "",
        ['DEVTOOLS_INJECTION_CHEAT'] = "",
    },

    ['tpz_death_logs'] = {
        ['ALL'] = "",
    },

    ['tpz_3dme'] = {
        ['ALL'] = "",
    },
}

----------------------------------------------
-- Functions (DONT TOUCH WITHOUT EXPERIENCE)
----------------------------------------------

GetWebhookUrlByName = function(script, webhooktype)

    if WEBHOOKS[script][webhooktype] == nil then 
        print(string.format('Attempted to retrieve GetWebhookUrlByName from an non valid webhook type of the mentioned script: { script: %s, type: %s }', script, webhooktype))
        return "N/A"
    end
   
    return WEBHOOKS[script][webhooktype]
end
