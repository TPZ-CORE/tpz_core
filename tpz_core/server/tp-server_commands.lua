

--[[ ------------------------------------------------
   Commands Registration
]]---------------------------------------------------

--[[ Player ID Command ]] --
RegisterCommand("id", function(source, args, rawCommand)
    local _source = source
    local xPlayer = PlayerData[_source]
    
    if xPlayer == nil then
        return
    end

    TriggerClientEvent('tpz_core:sendBottomTipNotification', _source, string.format(Locales['PLAYER_ID_COMMAND'], xPlayer.source), 3000)

end, false)

--[[ Player Job Command ]] --
RegisterCommand("job", function(source, args, rawCommand)
    local _source = source
    local xPlayer = PlayerData[_source]

    if xPlayer == nil then
        return
    end

    TriggerClientEvent('tpz_core:sendBottomTipNotification', _source, string.format(Locales['PLAYER_JOB_COMMAND'], xPlayer.job, xPlayer.jobGrade), 3000)

end, false)

--[[ Add Inventory Weight Command ]] --
RegisterCommand("addinventoryweight", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.addinventoryweight", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['addinventoryweight'].Groups, Config.Commands['addinventoryweight'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, weight = args[1], args[2]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if weight == nil or weight == '' or tonumber(weight) == nil then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['addinventoryweight'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /addinventoryweight ".. target .. " " .. weight .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Inventory Weight Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.inventory_capacity = tPlayer.inventory_capacity + weight
                SaveCharacter(tonumber(target))

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, has now extra inventory weight.", target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), "An extra weight added on your inventory", 3000)
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Set Inventory Weight Command ]] --
RegisterCommand("setinventoryweight", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.setinventoryweight", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['setinventoryweight'].Groups, Config.Commands['setinventoryweight'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, weight = args[1], args[2]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if weight == nil or weight == '' or tonumber(weight) == nil then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['setinventoryweight'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setinventoryweight ".. target .. " " .. weight .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Inventory Weight Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.inventory_capacity = weight
                SaveCharacter(tonumber(target))

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, inventory weight set to: %s", target, weight), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("Your inventory weight has been set to: %s", weight), 3000)
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Set Group Command ]] --
RegisterCommand("setgroup", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.setgroup", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['setgroup'].Groups, Config.Commands['setgroup'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, newgroup = args[1], args[2]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if newgroup == nil or newgroup == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['setgroup'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setgroup ".. target .. " " .. newgroup .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Group Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.group = newgroup

                --SaveCharacter(tonumber(target))

                TriggerClientEvent("tpz_core:getPlayerGroup", tonumber(target), tPlayer.group )

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, group set to: %s", target, newgroup), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("Your group has been set to: %s", newgroup), 3000)
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Set Max Chars Command ]] --
RegisterCommand("setmaxchars", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.setmaxchars", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['setmaxchars'].Groups, Config.Commands['setmaxchars'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, chars = args[1], args[2]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if chars == nil or chars == '' or tonumber(chars) == nil then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['setmaxchars'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setmaxchars ".. target .. " " .. chars .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Max Characters Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                
                SetUserMaxCharacters(tonumber(target), chars)

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, max characters set to: %s", target, chars), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("Your max characters has been set to: %s", chars), 3000)

            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end
    
end, false)

--[[ Set Job Command ]] --
RegisterCommand("setjob", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.setjob", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['setjob'].Groups, Config.Commands['setjob'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, newjob, newGrade = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if newjob == nil or newjob == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['setjob'].Webhook

        if webhookData.Enabled then
            local title   = "📋` /setjob ".. target .. " " .. newjob .. " " .. newGrade .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Job Command`"
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

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, job set to: %s (grade: %s)", target, newjob, newGrade), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("Your job has been set to: %s (grade: %s)", newjob, newGrade), 3000)

                TriggerClientEvent("tpz_core:getPlayerJob", tonumber(target), { job = tPlayer.job, jobGrade = tPlayer.jobGrade })
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end
    
end, false)

--[[ Add Account Money Command ]] --
RegisterCommand("addaccount", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.addaccount", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['addaccount'].Groups, Config.Commands['addaccount'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, moneytype, quantity = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or moneytype == nil or moneytype == '' or quantity == nil or quantity == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['addaccount'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /addaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Account Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then
                if (tPlayer.account[tonumber(moneytype)]) then

                    tPlayer.account[tonumber(moneytype)] = tPlayer.account[tonumber(moneytype)] + tonumber(quantity)
                
                    --SaveCharacter(tonumber(target))
    
                    TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("The following ID: %s, successfully received: %s (account-type: %s)", target, quantity, moneytype), 3000)
                    TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("You just received %s (account-type: %s)", quantity, moneytype), 3000)

                else

                    TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~Error: This currency type (" .. moneytype .. ") does not exist.", 3000)

                end

            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end
        
end, false)

--[[ Remove Account Money Command ]] --
RegisterCommand("removeaccount", function(source, args, rawCommand)
   local _source = source
   
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.removeaccount", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['removeaccount'].Groups, Config.Commands['removeaccount'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target, moneytype, quantity = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or moneytype == nil or moneytype == '' or quantity == nil or quantity == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['removeaccount'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /removeaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Remove Account Command`"
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

                    TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("Successfully removed from the following ID: %s, %s (account-type: %s)", target, quantity, moneytype), 3000)
                    TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("%s (account-type: %s) removed from your account.", quantity, moneytype), 3000)
        
                else
                    TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~Error: This currency type (" .. moneytype .. ") does not exist.", 3000)
                end
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end
    
end, false)


--[[ Revive Player Command ]] --
RegisterCommand("revive", function(source, args, rawCommand)
   local _source = source

   local hasAcePermissions           = HasPermissionsByAce("tpzcore.revive", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['revive'].Groups, Config.Commands['revive'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['revive'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /revive ".. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
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

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully revived a player with the following ID: %s.", target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), "You have been revived.", 3000)

            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Kill Player Command ]] --
RegisterCommand("kill", function(source, args, rawCommand)
   local _source = source

   local hasAcePermissions           = HasPermissionsByAce("tpzcore.kill", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['kill'].Groups, Config.Commands['kill'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['kill'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /kill " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                TriggerClientEvent('tpz_core:applyLethalDamage', tonumber(target), true)

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully killed a player with the following ID: %s.", target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), "You have been killed.", 3000)

            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ TPM Command ]] --
RegisterCommand("tpm", function(source)
   local _source = source

   local hasAcePermissions           = HasPermissionsByAce("tpzcore.tpm", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['tpm'].Groups, Config.Commands['tpm'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then


        local xPlayer         = PlayerData[_source]

        local identifier      = xPlayer.identifier
        local steamName       = GetPlayerName(_source)
    
        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)
    
        TriggerClientEvent('tpz_core:teleportToWayPoint', _source)

        local webhookData = Config.Commands['tpm'].Webhook

        if webhookData.Enabled then  
            local title   = "📋` /tpm " .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used TPM Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Teleport Coords Command ]] --
RegisterCommand("tpcoords", function(source, args, rawCommand)
   local _source = source
    
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.tpcoords", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['tpcoords'].Groups, Config.Commands['tpcoords'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local coordsX, coordsY, coordsZ = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)

        if coordsX == nil or coordsX == '' or tonumber(coordsX) == nil or coordsY == nil or coordsY == '' or tonumber(coordsY) == nil or coordsZ == nil or coordsZ == '' or tonumber(coordsZ) == nil then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(coordsX), tonumber(coordsY), tonumber(coordsZ))

        local webhookData = Config.Commands['tpcoords'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /tpcoords { x = " .. coordsX .. ", y = " .. coordsY .. ", z = " .. coordsZ .. " }" .. "`"

            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Teleport To Player Command ]] --
RegisterCommand("tpto", function(source, args, rawCommand)
   local _source = source

   local hasAcePermissions           = HasPermissionsByAce("tpzcore.tpto", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['tpto'].Groups, Config.Commands['tpto'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then


        local xPlayer = PlayerData[_source]

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['tpto'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /tpto " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local toCoords = GetEntityCoords(GetPlayerPed( tonumber(target) ))
               -- SetEntityCoords(GetPlayerPed(_source), toCoords)
            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Teleport Player Here Command ]] --
RegisterCommand("tphere", function(source, args, rawCommand)
   local _source = source

   local hasAcePermissions           = HasPermissionsByAce("tpzcore.tphere", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['tphere'].Groups, Config.Commands['tphere'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['tphere'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /tphere " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
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
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)


--[[ Heal Player Command ]] --
RegisterCommand("heal", function(source, args, rawCommand)
   local _source = source
    
   local hasAcePermissions           = HasPermissionsByAce("tpzcore.heal", _source)
   local hasAdministratorPermissions = hasAcePermissions

   if not hasAcePermissions then
      hasAdministratorPermissions = HasAdministratorPermissions(_source, Config.Commands['heal'].Groups, Config.Commands['heal'].DiscordRoles)
   end

   if hasAcePermissions or hasAdministratorPermissions then

        local xPlayer = PlayerData[_source]

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['INVALID_SYNTAX'], 3000)
            return
        end

        local webhookData = Config.Commands['heal'].Webhook
    
        if webhookData.Enabled then
            local title   = "📋` /heal " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
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
                
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully healed a player with the following ID: %s.", target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), "You have been healed.", 3000)

            else
                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
            end

        else
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['PLAYER_NOT_ONLINE'], 3000)
        end


    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
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