local PreviousLocation = nil -- for /back command. 

--[[ ------------------------------------------------
   Local Functions
]]---------------------------------------------------

-- @function FindSourceTarget is used for commands to be able to get an input source id to replace executed source id
-- $[id]. This is for in case a command is used server side and want to replace the 0 source to the executed source.
local function FindSourceTarget(source, args)
    local resolvedSource = source

    if args[1] then
        local embeddedSource = args[1]:match("%$%[(%d+)%]")

        if embeddedSource then
            resolvedSource = tonumber(embeddedSource)
            args[1] = args[1]:gsub("%$%[%d+%]", "")
        end

        args[1] = args[1]:match("^%s*(.-)%s*$")
        args[1] = tonumber(args[1])
    end

    return resolvedSource, args[1]
end


--[[ ------------------------------------------------
   Commands Registration
]]---------------------------------------------------

--[[ Player ID Command ]] --
RegisterCommand("id", function(source, args, rawCommand)
    local _source = source

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end

    local xPlayer = PlayerData[_source]
    
    if xPlayer == nil then
        return
    end

    SendCommandNotification(_source, string.format(Locales['PLAYER_ID_COMMAND'], xPlayer.source), 'info', 3000)

end, false)

--[[ Player Job Command ]] --
RegisterCommand("job", function(source, args, rawCommand)
    local _source = source

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end

    local xPlayer = PlayerData[_source]

    if xPlayer == nil then
        return
    end

    SendCommandNotification(_source, string.format(Locales['PLAYER_JOB_COMMAND'], xPlayer.job, xPlayer.jobGrade), 'info', 3000)
   
end, false)

--[[ Add Inventory Weight Command ]] --
RegisterCommand("addinventoryweight", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    local hasPermissions, await = false, true
   
    if _source ~= 0 then
        hasPermissions = HasPermissionsByAce("tpzcore.addinventoryweight", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['addinventoryweight'].Groups, Config.Commands['addinventoryweight'].DiscordRoles)
        end
    
        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target, weight = args[1], args[2]

        if target == nil or target == '' or tonumber(target) == nil or weight == nil or weight == '' or tonumber(weight) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['addinventoryweight'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /addinventoryweight ".. target .. " " .. weight .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)

                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Inventory Weight Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.inventory_capacity = tPlayer.inventory_capacity + weight
                SaveCharacter(tonumber(target))

                SendCommandNotification(_source, string.format("The following ID: %s, has now extra inventory weight.", target), 'success', 3000)
                SendCommandNotification(tonumber(target), "An extra weight added on your inventory", 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ Set Inventory Weight Command ]] --
RegisterCommand("setinventoryweight", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
   
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.setinventoryweight", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['setinventoryweight'].Groups, Config.Commands['setinventoryweight'].DiscordRoles)
        end

        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target, weight = args[1], args[2]

        if target == nil or target == '' or tonumber(target) == nil or weight == nil or weight == '' or tonumber(weight) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['setinventoryweight'].Webhook

        if webhookData.Enabled then
            
            local title   = "📋` /setinventoryweight ".. target .. " " .. weight .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)

                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Inventory Weight Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.inventory_capacity = weight
                SaveCharacter(tonumber(target))

                SendCommandNotification(_source, string.format("The following ID: %s, inventory weight set to: %s", target, weight), 'success', 3000)
                SendCommandNotification(tonumber(target), string.format("Your inventory weight has been set to: %s", weight), 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)


--[[ Delete Character ]] --
RegisterCommand("deletecharacter", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
    
    if _source ~= 0 then
    
        hasPermissions  = HasPermissionsByAce("tpzcore.deletecharacter", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['deletecharacter'].Groups, Config.Commands['deletecharacter'].DiscordRoles)
        end

        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end
    
    if hasPermissions then

        local target = args[1]
        
        if target == nil or target == '' or tonumber(target) == nil or reason == nil or reason == '' then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['deletecharacter'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /deletecharacter ".. target .. " " .. reason .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
    
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
            
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Deleted User Character`"
           
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local reasonConcat = table.concat(args, " ", 2)
                
                local Parameters = { 
                    ['identifier']     = PlayerData[tonumber(target)].identifier, 
                    ['charidentifier'] = PlayerData[tonumber(target)].charIdentifier, 
                }
        
                exports.ghmattimysql:execute("DELETE FROM `characters` WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
                
                PlayerData[tonumber(target)] = nil
                DropPlayer(tonumber(target), reasonConcat)

                SendCommandNotification(_source, string.format("A player character has been permanently deleted, reason: %s", reasonConcat), 'success', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
    
end, false)

--[[ Set Max Chars Command ]] --
RegisterCommand("setmaxchars", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
    
    if _source ~= 0 then
    
        hasPermissions  = HasPermissionsByAce("tpzcore.setmaxchars", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['setmaxchars'].Groups, Config.Commands['setmaxchars'].DiscordRoles)
        end

        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end
    
    if hasPermissions then

        local target, chars = args[1], args[2]

        if target == nil or target == '' or tonumber(target) == nil or chars == nil or chars == '' or tonumber(chars) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['setmaxchars'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setmaxchars ".. target .. " " .. chars .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
    
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
            
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Max Characters Command`"
           
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then
                
                SetUserMaxCharacters(tonumber(target), chars)

                SendCommandNotification(_source, string.format("The following ID: %s, max characters set to: %s", target, chars), 'success', 3000)
                SendCommandNotification(tonumber(target), string.format("Your max characters has been set to: %s", chars), 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
    
end, false)

--[[ Set Group Command ]] --
RegisterCommand("setgroup", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
    
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.setgroup", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['setgroup'].Groups, Config.Commands['setgroup'].DiscordRoles)
        end

        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end
    
    if hasPermissions then

        local target, newgroup = args[1], args[2]

        if target == nil or target == '' or tonumber(target) == nil or newgroup == nil or newgroup == '' then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['setgroup'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setgroup ".. target .. " " .. newgroup .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
    
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)

                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Group Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.group = newgroup

                --SaveCharacter(tonumber(target))

                TriggerClientEvent("tpz_core:getPlayerGroup", tonumber(target), tPlayer.group )

                SendCommandNotification(_source, string.format("The following ID: %s, group set to: %s", target, newgroup), 'success', 3000)
                SendCommandNotification(tonumber(target), string.format("Your group has been set to: %s", newgroup), 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ Set Job Command ]] --
RegisterCommand("setjob", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    local hasPermissions, await = false, true
     
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.setjob", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['setjob'].Groups, Config.Commands['setjob'].DiscordRoles)
        end

        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target, newjob, newGrade = args[1], args[2], args[3]

        if target == nil or target == '' or tonumber(target) == nil or newjob == nil or newjob == '' or newGrade == nil or newGrade == '' or tonumber(newGrade) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['setjob'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setjob ".. target .. " " .. newjob .. " " .. newGrade .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
    
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
            
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Job Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.job = newjob
                
                tPlayer.jobGrade = 0

                if newGrade then
                    tPlayer.jobGrade = tonumber(newGrade)
                end

                --SaveCharacter(tonumber(target))
                TriggerClientEvent("tpz_core:getPlayerJob", tonumber(target), { job = tPlayer.job, jobGrade = tPlayer.jobGrade })

                SendCommandNotification(_source, string.format("The following ID: %s, job set to: %s (grade: %s)", target, newjob, newGrade), 'success', 3000)
                SendCommandNotification(tonumber(target), string.format("Your job has been set to: %s (grade: %s)", newjob, newGrade), 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
    
end, false)

--[[ Add Account Money Command ]] --
RegisterCommand("addaccount", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    local hasPermissions, await = false, true

    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.addaccount", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['addaccount'].Groups, Config.Commands['addaccount'].DiscordRoles)
        end
    
        await = false

    else
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end
    
    while await do
        Wait(100)
    end

    if hasPermissions then

        local target, moneytype, quantity = args[1], args[2], args[3]

        if target == nil or target == '' or tonumber(target) == nil or moneytype == nil or moneytype == '' or tonumber(moneytype) == nil or quantity == nil or quantity == '' or tonumber(quantity) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['addaccount'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /addaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)

                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Account Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then
                if (tPlayer.account[tonumber(moneytype)]) then

                    tPlayer.account[tonumber(moneytype)] = tPlayer.account[tonumber(moneytype)] + tonumber(quantity)
                
                    --SaveCharacter(tonumber(target))

                    SendCommandNotification(_source, string.format("The following ID: %s, successfully received: %s (account-type: %s)", target, quantity, moneytype), 'success', 3000)
                    SendCommandNotification(tonumber(target), string.format("You just received %s (account-type: %s)", quantity, moneytype), 'info', 3000)

                else
                    SendCommandNotification(_source, string.format(Locales['ACCOUNT_TYPE_DOES_NOT_EXIST'], moneytype), 'error', 3000)
                end

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
        
end, false)

--[[ Remove Account Money Command ]] --
RegisterCommand("removeaccount", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
 
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.removeaccount", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['removeaccount'].Groups, Config.Commands['removeaccount'].DiscordRoles)
        end

        await = false

    else 
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target, moneytype, quantity = args[1], args[2], args[3]

        if target == nil or target == '' or tonumber(target) == nil or moneytype == nil or moneytype == '' or tonumber(moneytype) == nil or quantity == nil or quantity == '' or tonumber(quantity) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end
        
        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['removeaccount'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /removeaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Remove Account Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]
        
            if tPlayer then
                if (tPlayer.account[tonumber(moneytype)]) then

                    if Config.NegativeValueOnAccounts then
                        tPlayer.account[tonumber(moneytype)] = tPlayer.account[tonumber(moneytype)] - tonumber(quantity)
        
                    else
                        tPlayer.account[tonumber(moneytype)] = tPlayer.account[tonumber(moneytype)] - tonumber(quantity)
        
                        if tPlayer.account[tonumber(moneytype)] <= 0 then
                            tPlayer.account[tonumber(moneytype)] = 0
                        end
        
                    end

                    --SaveCharacter(tonumber(target))

                    SendCommandNotification(_source, string.format("Successfully removed from the following ID: %s, %s (account-type: %s)", target, quantity, moneytype), 'success', 3000)
                    SendCommandNotification(tonumber(target), string.format("%s (account-type: %s) removed from your account.", quantity, moneytype), 'info', 3000)

                else
                    SendCommandNotification(_source, string.format(Locales['ACCOUNT_TYPE_DOES_NOT_EXIST'], moneytype), 'error', 3000)
                end

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
    
end, false)

--[[ Heal Player Command ]] --
RegisterCommand("heal", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    local hasPermissions, await = false, true
 
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.heal", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['heal'].Groups, Config.Commands['heal'].DiscordRoles)
        end
 
        await = false

    else 
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then
 
        local target = args[1]

        if target == nil or target == '' or tonumber(target) == nil then
           SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
           return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['heal'].Webhook
     
        if webhookData.Enabled then
            local title   = "📋` /heal " .. target .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then
                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Heal Command`"
            
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                TriggerClientEvent('tpz_core:healPlayer', tonumber(target))

                -- tpz_metabolism.
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "HUNGER", "add", 100)
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "THIRST", "add", 100)

                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "STRESS", "remove", 100)
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "ALCOHOL", "remove", 100)
                
                TriggerEvent("tpz_medics:server:set_poisoned_state", tonumber(target), false)
                SendCommandNotification(_source, string.format("You successfully healed a player with the following ID: %s.", target), 'success', 3000)
                SendCommandNotification(tonumber(target), "You have been healed.", 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end
 
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end
 
 end, false)

--[[ Revive Player Command ]] --
RegisterCommand("revive", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end
   
    local hasPermissions, await = false, true
 
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.revive", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['revive'].Groups, Config.Commands['revive'].DiscordRoles)
        end

        await = false

    else 
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target = args[1]

        if target == nil or target == '' or tonumber(target) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['revive'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /revive ".. target .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)
                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Revive Command`"

            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                TriggerClientEvent('tpz_core:resurrectPlayer', tonumber(target), true)

                -- tpz_metabolism.
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "HUNGER", "add", 100)
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "THIRST", "add", 100)

                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "STRESS", "remove", 100)
                TriggerClientEvent("tpz_metabolism:setMetabolismValue", tonumber(target), "ALCOHOL", "remove", 100)

                TriggerEvent("tpz_medics:server:set_poisoned_state", tonumber(target), false)
                
                SendCommandNotification(_source, string.format("You successfully revived a player with the following ID: %s.", target), 'success', 3000)
                SendCommandNotification(tonumber(target), "You have been revived.", 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ Kill Player Command ]] --
RegisterCommand("kill", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    local hasPermissions, await = false, true
  
    if _source ~= 0 then

        hasPermissions = HasPermissionsByAce("tpzcore.kill", _source)

        if not hasPermissions then
            hasPermissions = HasAdministratorPermissions(_source, Config.Commands['kill'].Groups, Config.Commands['kill'].DiscordRoles)
         end

        await = false

    else 
        hasPermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if hasPermissions then

        local target = args[1]
 
        if target == nil or target == '' or tonumber(target) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['kill'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /kill " .. target .. "`"

            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer         = PlayerData[_source]

                local identifier      = xPlayer.identifier
                local ip              = GetPlayerEndpoint(_source)
        
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId       = string.sub(discordIdentity, 9)
        
                local steamName       = GetPlayerName(_source)

                message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Kill Command`"
            end

            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                TriggerClientEvent('tpz_core:applyLethalDamage', tonumber(target), true)

                SendCommandNotification(_source, string.format("You successfully killed a player with the following ID: %s.", target), 'success', 3000)
                SendCommandNotification(tonumber(target), "You have been killed by an administrator.", 'info', 3000)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ BACK Command ]] --
RegisterCommand("back", function(source)
    local _source = source

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end

    local hasPermissions = HasPermissionsByAce("tpzcore.back", _source)

    if not hasPermissions then
        hasPermissions = HasAdministratorPermissions(_source, Config.Commands['back'].Groups, Config.Commands['back'].DiscordRoles)
    end
 
    if hasPermissions then

        local xPlayer = PlayerData[_source]

         if previousLocation == nil then
            SendCommandNotification(_source, Locales['NO_BACK_LOCATION'], 'error', 3000)
            return
         end

        local identifier      = xPlayer.identifier
        local steamName       = GetPlayerName(_source)
    
        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        TriggerClientEvent('tpz_core:teleportToCoords', _source, previousLocation.x, previousLocation.y, previousLocation.z)

        local webhookData = Config.Commands['back'].Webhook

        if webhookData.Enabled then  
            local title   = "📋` /back " .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used TPM Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ TPM Command ]] --
RegisterCommand("tpm", function(source)
    local _source = source

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end

    local hasPermissions = HasPermissionsByAce("tpzcore.tpm", _source)

    if not hasPermissions then
        hasPermissions = HasAdministratorPermissions(_source, Config.Commands['tpm'].Groups, Config.Commands['tpm'].DiscordRoles)
    end
 
    if hasPermissions then

        local xPlayer         = PlayerData[_source]

        local identifier      = xPlayer.identifier
        local steamName       = GetPlayerName(_source)
    
        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

         previousLocation = GetEntityCoords(GetPlayerPed(_source))

        TriggerClientEvent('tpz_core:teleportToWayPoint', _source)

        local webhookData = Config.Commands['tpm'].Webhook

        if webhookData.Enabled then  
            local title   = "📋` /tpm " .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used TPM Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end
    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ Teleport Coords Command ]] --
RegisterCommand("tpcoords", function(source, args, rawCommand)
    local _source = source
    
    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end
    
    local hasPermissions = HasPermissionsByAce("tpzcore.tpcoords", _source)

    if not hasPermissions then
        hasPermissions = HasAdministratorPermissions(_source, Config.Commands['tpcoords'].Groups, Config.Commands['tpcoords'].DiscordRoles)
    end
 
    if hasPermissions then

        local xPlayer = PlayerData[_source]

        local coordsX, coordsY, coordsZ = args[1], args[2], args[3]

        local fullargs = table.concat(args, " ")

        if hasXYZLetters(fullargs) then 
            coordsX, coordsY, coordsZ = parseXYZ(fullargs)
        end

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)

        if coordsX == nil or coordsX == '' or tonumber(coordsX) == nil or coordsY == nil or coordsY == '' or tonumber(coordsY) == nil or coordsZ == nil or coordsZ == '' or tonumber(coordsZ) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

         previousLocation = GetEntityCoords(GetPlayerPed(_source))

        TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(coordsX), tonumber(coordsY), tonumber(coordsZ))

        local webhookData = Config.Commands['tpcoords'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /tpcoords { x = " .. coordsX .. ", y = " .. coordsY .. ", z = " .. coordsZ .. " }" .. "`"

            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Teleport To Coords Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)

--[[ Teleport To Player Command ]] --
RegisterCommand("tpto", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end
   
    local hasPermissions = HasPermissionsByAce("tpzcore.tpto", _source)

    if not hasPermissions then
        hasPermissions = HasAdministratorPermissions(_source, Config.Commands['tpto'].Groups, Config.Commands['tpto'].DiscordRoles)
    end

    if hasPermissions then

        local target = args[1]

        if target == nil or target == '' or tonumber(target) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['tpto'].Webhook
    
        if webhookData.Enabled then
            local xPlayer         = PlayerData[_source]

            local identifier      = xPlayer.identifier

            local ip              = GetPlayerEndpoint(_source)
        
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId       = string.sub(discordIdentity, 9)
    
            local steamName       = GetPlayerName(_source)

            local title   = "📋` /tpto " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Teleport To Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

               previousLocation = GetEntityCoords(GetPlayerPed(_source))

                local targetCoords = GetEntityCoords(GetPlayerPed( tonumber(target) ))
               TriggerClientEvent('tpz_core:teleportToCoords', _source, targetCoords.x, targetCoords.y, targetCoords.z)
               -- SetEntityCoords(GetPlayerPed(_source), toCoords)
            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    end

end, false)


--[[ Teleport Player Here Command ]] --
RegisterCommand("tphere", function(source, args, rawCommand)
    local _source, replacedArg = FindSourceTarget(source, args)

    if replacedArg then 
        args[1] = replacedArg
    end

    if _source == 0 then
        print(Locales['COMMAND_NOT_PERMITTED_ON_CONSOLE'])
        return
    end

    local hasPermissions = HasPermissionsByAce("tpzcore.tphere", _source)

    if not hasPermissions then
        hasPermissions = HasAdministratorPermissions(_source, Config.Commands['tphere'].Groups, Config.Commands['tphere'].DiscordRoles)
    end

    if hasPermissions then

        local target = args[1]

        if target == nil or target == '' or tonumber(target) == nil then
            SendCommandNotification(_source, Locales['INVALID_SYNTAX'], 'error', 3000)
            return
        end

        local targetSteamName = GetPlayerName(tonumber(target))

        local webhookData = Config.Commands['tphere'].Webhook
    
        if webhookData.Enabled then

            local xPlayer = PlayerData[_source]

            local identifier      = xPlayer.identifier

            local ip              = GetPlayerEndpoint(_source)
        
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId       = string.sub(discordIdentity, 9)
    
            local steamName       = GetPlayerName(_source)

            local title   = "📋` /tphere " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Bring Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local ped          = GetPlayerPed(_source)
                local playerCoords = GetEntityCoords(ped)
            
                local toCoords = GetEntityCoords(GetPlayerPed( _source ))
                SetEntityCoords(GetPlayerPed( tonumber(target) ), toCoords)

            else
                SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
            end

        else
            SendCommandNotification(_source, Locales['PLAYER_NOT_ONLINE'], 'error', 3000)
        end

    else
        SendCommandNotification(_source, Locales['NO_PERMISSIONS'], 'error', 3000)
    
    end

end, false)

--[[ ------------------------------------------------
   Chat Suggestions Registration
]]---------------------------------------------------

RegisterServerEvent("tpz_core:registerChatSuggestions")
AddEventHandler("tpz_core:registerChatSuggestions", function()
   local _source = source

   for name, command in pairs (Config.Commands) do
      local displayTip = command.CommandHelpTips 

      if not displayTip then
         displayTip = {}
      end

      TriggerClientEvent("chat:addSuggestion", _source, "/" .. name, command.Suggestion, command.CommandHelpTips )

  end

end)
