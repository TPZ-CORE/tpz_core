

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

    TriggerClientEvent('tpz_core:sendBottomTipNotification', _source, "Your Player ID: ~o~" .. xPlayer.source, 3000)

end, false)

--[[ Player Job Command ]] --
RegisterCommand("job", function(source, args, rawCommand)
    local _source = source
    local xPlayer = PlayerData[_source]

    if xPlayer == nil then
        return
    end

    TriggerClientEvent('tpz_core:sendBottomTipNotification', _source, "Your Player Job: ~o~" .. xPlayer.job, 3000)

end, false)

--[[ Set Group Command ]] --
RegisterCommand("setgroup", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['setgroup'].Groups[xPlayer.group] then

        local target, newgroup = args[1], args[2]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if newgroup == nil or newgroup == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['setgroup'].Webhook

        if webhookData.Enable then
            local title   = "📋` /setgroup ".. target .. " " .. newgroup .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Group Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.group = newgroup

                Wait(1000)
                SaveCharacter(tonumber(target))

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

--[[ Set Job Command ]] --
RegisterCommand("setjob", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['setjob'].Groups[xPlayer.group] then

        local target, newjob, newGrade = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier
        local ip              = GetPlayerEndpoint(_source)

        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if newjob == nil or newjob == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['setjob'].Webhook

        if webhookData.Enable then
            local title   = "📋` /setjob ".. target .. " " .. newjob .. " " .. newGrade .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Set Job Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer    = PlayerData[tonumber(target)]

            if tPlayer then
                tPlayer.job = newjob

                tPlayer.jobGrade = 0

                if newGrade then
                    tPlayer.jobGrade = tonumber(newGrade)
                end

                Wait(1000)
                SaveCharacter(tonumber(target))

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

    local xPlayer = PlayerData[_source]

    if Config.Commands['addaccount'].Groups[xPlayer.group] then

        local target, moneytype, quantity = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or moneytype == nil or moneytype == '' or quantity == nil or quantity == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['addaccount'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /addaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Account Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then
                if (tPlayer.account[tonumber(moneytype)]) then

                    tPlayer.account[tonumber(moneytype)] = tPlayer.account[tonumber(moneytype)] + tonumber(quantity)
                
                    Wait(1000)
                    SaveCharacter(tonumber(target))
    
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

    local xPlayer = PlayerData[_source]

    if Config.Commands['removeaccount'].Groups[xPlayer.group] then

        local target, moneytype, quantity = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or moneytype == nil or moneytype == '' or quantity == nil or quantity == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['removeaccount'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /removeaccount ".. target .. " " .. moneytype .. " " .. quantity .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Remove Account Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
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

                    Wait(1000)
                    SaveCharacter(tonumber(target))

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

--[[ Add Item Command ]] --
RegisterCommand("additem", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['additem'].Groups[xPlayer.group] then

        local target, item, quantity = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or item == nil or item == '' or quantity == nil or quantity == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['additem'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /additem ".. target .. " " .. item .. " " .. quantity .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Item Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                exports.tpz_inventory:getInventoryAPI().addItem(tonumber(target), item, quantity)

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully gave : X%s %s on The following ID: %s.", quantity, item, target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("You just received X%s %s", quantity, item), 3000)

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


--[[ Add Weapon Command ]] --
RegisterCommand("addweapon", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['addweapon'].Groups[xPlayer.group] then

        local target, weaponName, serialId = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' or weaponName == nil or weaponName == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['addweapon'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /addweapon ".. target .. " " .. weaponName .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Add Weapon Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local TPZInv = exports.tpz_inventory:getInventoryAPI()

                TPZInv.addWeapon(tonumber(target), string.upper(weaponName), serialId)

                local weaponLabel = TPZInv.getWeaponLabel(string.upper(weaponName))

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully gave : X%s %s on The following ID: %s.", 1, weaponLabel, target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), string.format("You just received X%s %s", 1, weaponLabel), 3000)

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


--[[ Clear All Inventory Contents Command ]] --
RegisterCommand("clearinventory", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['clearinventory'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['clearinventory'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /clearinventory ".. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                exports.tpz_inventory:getInventoryAPI().clearInventoryContents(tonumber(target))

                TriggerClientEvent('tpz_core:sendRightTipNotification', _source, string.format("You successfully removed all the inventory contents on the following ID: %s.", target), 3000)
                TriggerClientEvent('tpz_core:sendRightTipNotification', tonumber(target), "All your inventory contents have been removed.", 3000)

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

    local xPlayer = PlayerData[_source]

    if Config.Commands['revive'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['revive'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /revive ".. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
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

                if Config.OnPlayerDeath.TPDirtSystem then
                    TriggerClientEvent("tp_dirtsystem:stopParticleFxProperlyFromTarget", tonumber(target), tonumber(target), true)
                end

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

    local xPlayer = PlayerData[_source]

    if Config.Commands['kill'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['kill'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /kill " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                TriggerClientEvent('tpz_core:applyLethalDamageToPlayerPed', tonumber(target), true)

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

    local xPlayer         = PlayerData[_source]

    local identifier      = xPlayer.identifier
    local steamName       = GetPlayerName(_source)

    local ip              = GetPlayerEndpoint(_source)

    local discordIdentity = GetIdentity(_source, "discord")
    local discordId       = string.sub(discordIdentity, 9)

    if Config.Commands['tpm'].Groups[xPlayer.group] then
        TriggerClientEvent('tpz_core:teleportToWayPoint', _source)

        local webhookData = Config.Commands['tpm'].Webhook

        if webhookData.Enable then  
            local title   = "📋` /tpm " .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used TPM Command`"
            TriggerEvent('tpz_core:sendToDiscord', webhookData.Url, title, message, webhookData.Color)
        end
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Teleport Coords Command ]] --
RegisterCommand("tpcoords", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['tpcoords'].Groups[xPlayer.group] then

        local coordsX, coordsY, coordsZ = args[1], args[2], args[3]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)

        if coordsX == nil or coordsX == '' or tonumber(coordsX) == nil or coordsY == nil or coordsY == '' or tonumber(coordsY) == nil or coordsZ == nil or coordsZ == '' or tonumber(coordsZ) == nil then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(coordsX), tonumber(coordsY), tonumber(coordsZ))

        local webhookData = Config.Commands['tpcoords'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /tpcoords { x = " .. coordsX .. ", y = " .. coordsY .. ", z = " .. coordsZ .. " }" .. "`"

            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', _source, Locales['NO_PERMISSIONS'], 3000)
    end

end, false)

--[[ Teleport To Player Command ]] --
RegisterCommand("tpto", function(source, args, rawCommand)
    local _source = source

    local xPlayer = PlayerData[_source]

    if Config.Commands['tpto'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['tpto'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /tpto " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local ped          = GetPlayerPed(tonumber(target))
                local playerCoords = GetEntityCoords(ped)
            
                TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(playerCoords.x), tonumber(playerCoords.y), tonumber(playerCoords.z))

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

    local xPlayer = PlayerData[_source]

    if Config.Commands['tphere'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['tphere'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /tphere " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
        end

        if targetSteamName then
            local tPlayer = PlayerData[tonumber(target)]

            if tPlayer then

                local ped          = GetPlayerPed(_source)
                local playerCoords = GetEntityCoords(ped)
            
                TriggerClientEvent('tpz_core:teleportToCoords', tonumber(target), tonumber(playerCoords.x), tonumber(playerCoords.y), tonumber(playerCoords.z))

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

    local xPlayer = PlayerData[_source]

    if Config.Commands['heal'].Groups[xPlayer.group] then

        local target = args[1]

        local identifier      = xPlayer.identifier

        local ip              = GetPlayerEndpoint(_source)
    
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId       = string.sub(discordIdentity, 9)

        local steamName       = GetPlayerName(_source)
        local targetSteamName = GetPlayerName(tonumber(target))

        if target == nil or target == '' then
            TriggerClientEvent('tpz_core:sendRightTipNotification', _source, "~e~ERROR: Use Correct Sintaxis", 3000)
            return
        end

        local webhookData = Config.Commands['heal'].Webhook
    
        if webhookData.Enable then
            local title   = "📋` /heal " .. target .. "`"
            local message = "**Steam name: **`" .. steamName .. " (" .. xPlayer.group .. ")`**\nIdentifier**`" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `Used Clear Inventory Command`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
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

                if Config.OnPlayerDeath.TPRealisticFlieSwamping then
                    TriggerClientEvent("tp_realistic_flieswamping:stopFliesSwampingPtfx", tonumber(target), true, true)
                end
                
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

    local xPlayer    = PlayerData[_source]

    -- Clear Tasks
    TriggerEvent("chat:addSuggestion", "/cleartasks", "Use this command to clear all the player tasks (Including Animations).")

    -- Set Group 
    TriggerClientEvent("chat:addSuggestion", _source, "/setgroup", Config.Commands['setgroup'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Group", help = 'Group' },
    })

    -- Set Job 
    TriggerClientEvent("chat:addSuggestion", _source, "/setjob", Config.Commands['setjob'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Job", help = 'Job' },
        { name = "Grade", help = 'Grade' },

    })

    -- Add Account Money 
    TriggerClientEvent("chat:addSuggestion", _source, "/addaccount", Config.Commands['addaccount'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Type", help = 'Types : ( [0]: Cash | [1]: Cents | [2]: Gold | [3]: Black Money )' },
        { name = "Quantity", help = 'Quantity' },

    })

    -- Remove Account Money 
    TriggerClientEvent("chat:addSuggestion", _source, "/removeaccount", Config.Commands['removeaccount'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Type", help = 'Types : ( [0]: Cash | [1]: Cents | [2]: Gold | [3]: Black Money )' },
        { name = "Quantity", help = 'Quantity' },

    })

    -- Add Items
    TriggerClientEvent("chat:addSuggestion", _source, "/additem", Config.Commands['additem'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Item", help = 'Item' },
        { name = "Quantity", help = 'Quantity' },

    })

    -- Add Weapons
    TriggerClientEvent("chat:addSuggestion", _source, "/addweapon", Config.Commands['addweapon'].Suggestion, {
        { name = "Id", help = 'Player ID' },
        { name = "Weapon", help = 'Weapon Name' },
        { name = "Serial Number", help = 'Serial Number ID (do not add spaces)' },
    })

    -- Clear Player Inventory
    TriggerClientEvent("chat:addSuggestion", _source, "/clearinventory", Config.Commands['clearinventory'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })

    -- Revive Player
    TriggerClientEvent("chat:addSuggestion", _source, "/revive", Config.Commands['revive'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })

    
    -- Kill Player
    TriggerClientEvent("chat:addSuggestion", _source, "/kill", Config.Commands['kill'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })


    -- TPM
    if Config.Commands['tpm'].Groups[xPlayer.group] then
        TriggerClientEvent("chat:addSuggestion", _source, "/tpm", Config.Commands['tpm'].Suggestion, {})
    end

    -- TP COORDS
    TriggerClientEvent("chat:addSuggestion", _source, "/tpcoords", Config.Commands['tpcoords'].Suggestion, {
        { name = "X", help = 'X' },
        { name = "Y", help = 'Y' },
        { name = "Z", help = 'Z' },
    })

    -- TP TO PLAYER
    TriggerClientEvent("chat:addSuggestion", _source, "/tpto", Config.Commands['tpto'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })

    -- TP PLAYER HERE
    TriggerClientEvent("chat:addSuggestion", _source, "/tphere", Config.Commands['tphere'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })

    -- HEAL PLAYER
    TriggerClientEvent("chat:addSuggestion", _source, "/heal", Config.Commands['heal'].Suggestion, {
        { name = "Id", help = 'Player ID' },
    })
end)