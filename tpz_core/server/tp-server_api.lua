exports('rServerAPI', function()
    local self = {}

    self.addNewCallBack = function(name, cb) TriggerEvent("tpz_core:addNewCallBack", name, cb) end

    -- Notifications
    self.NotifyLeft = function(source, firsttext, secondtext, dict, icon, duration, color)
        TriggerClientEvent('tpz_core:sendLeftNotification', source, firsttext, secondtext, dict, icon, duration, color)
    end

    self.NotifyTip = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendTipNotification', source, text, duration)
    end

    self.NotifyTop = function(source, text, location, duration)
        TriggerClientEvent('tpz_core:sendTopNotification', source, text, location, duration)
    end

    self.NotifyRightTip = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, text, duration)
    end

    self.NotifyObjective = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, text, duration)
    end

    self.NotifySimpleTop = function(source, title, subtitle, duration)
        TriggerClientEvent('tpz_core:sendSimpleTopNotification', source, title, subtitle, duration)
    end

    self.NotifyAvanced = function(source, text, dict, icon, text_color, duration, quality)
        TriggerClientEvent('tpz_core:sendAdvancedRightNotification', source, text, dict, icon, text_color, duration, quality)
    end

    self.NotifyBasicTop = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBasicTopNotification', source, text, duration)
    end

    self.NotifyCenter = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendSimpleCenterNotification', source, text, duration)
    end

    self.NotifyBottomRight = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBottomRightNotification', source, text, duration)
    end

    self.NotifyFail = function(source, title, subtitle, duration)
        TriggerClientEvent('tpz_core:sendFailMissionNotification', source, title, subtitle, duration)
    end

    self.NotifyDead = function(source, title, audioRef, audioName, duration)
        TriggerClientEvent('tpz_core:sendDeadPlayerNotification', source, title, audioRef, audioName, duration)
    end

    self.NotifyUpdate = function(source, utitle, umsg, duration)
        TriggerClientEvent('tpz_core:sendMissionUpdateNotification', source, utitle, umsg, duration)
    end

    self.NotifyWarning = function(source, title, msg, audioRef, audioName, duration)
        TriggerClientEvent('tpz_core:sendWarningNotification', source, title, msg, audioRef, audioName, duration)
    end

    self.NotifyLeftRank = function(source, title, subtitle, dict, icon, duration, color)
        TriggerClientEvent('tpz_core:sendLeftRankNotification', source, title, subtitle, dict, icon, duration, color)
    end -- End of notifications

    self.loaded = function(source)
        return PlayerData[source] ~= nil
    end

    self.getIdentifier = function(source)
        return PlayerData[source].identifier
    end

    self.getCharacterIdentifier = function(source)
        return PlayerData[source].charIdentifier
    end

    self.getGender = function(source)
        return PlayerData[source].gender
    end

    self.getDob = function(source)
        return PlayerData[source].dob
    end

    self.getGroup = function(source)
        return PlayerData[source].group
    end

    self.setGroup = function(source, group)
        PlayerData[source].group = group
    end

    self.getClan = function(source)
        return PlayerData[source].clan
    end

    self.setClan = function(source, clan)
        PlayerData[source].clan = clan
    end

    self.getFirstName = function(source)
        return PlayerData[source].firstname
    end

    self.getLastName = function(source)
        return PlayerData[source].lastname
    end

    self.getJob = function(source)
        return PlayerData[source].job
    end

    self.setJob = function(source, job)
        PlayerData[source].job = job
    end

    self.getJobGrade = function(source)
        return PlayerData[source].jobGrade
    end

    self.setJobGrade = function(source, grade)
        PlayerData[source].jobGrade = grade
    end

    self.getAccount = function(source, currency_type)

        if (PlayerData[source].account[currency_type]) then
            return tonumber(PlayerData[source].account[currency_type])
        else 
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
            return 0
        end

    end

    self.addAccount = function(source, currency_type, quantity) 

        if (PlayerData[source].account[currency_type]) then
            PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] + quantity
        else
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
        end
    end

    self.removeAccount = function(source, currency_type, quantity) 

        if (PlayerData[source].account[currency_type]) then

            if Config.NegativeValueOnAccounts then
                PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

            else
                PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

                if PlayerData[source].account[currency_type] <= 0 then
                    PlayerData[source].account[currency_type] = 0
                end

            end

        else
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
        end
    end

    self.getLastSavedLocation = function(source)
        return json.decode(PlayerData[source].coords)
    end

    self.saveLocation = function(source, coords, heading)
        local _source = source

        local newCoords = nil

        if coords then

            newCoords                 = { x = coords.x, y = coords.y, z = coords.z, heading = heading }
            PlayerData[source].coords = { x = coords.x, y = coords.y, z = coords.z, heading = heading }

        else
            local playerPed           = GetPlayerPed(source)
            local _coords, _heading   = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

            newCoords             = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
            PlayerData[source].coords = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
        end

        while newCoords == nil do
            Wait(100)
        end

        SavePlayerLocationInDatabase(_source, newCoords)
    end

    self.saveCharacter = function(source)
        SaveCharacter(source)
    end

    self.GetJobPlayers = function(job)
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            if PlayerData[player] then
                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    return self
end)
