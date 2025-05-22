exports('getCoreAPI', function()
    local self = {}

    self.RpcCall = function(name, callback, ...) 
        ClientRPC.Callback.TriggerAsync(name, callback, ...) 
    end

    self.instancePlayers = function(set)
        TriggerServerEvent("tpz_core:instanceplayers", set)
    end
        
    self.getLocale = function(string)
        
        local str = Locales[string]

        if Locales[string] == nil then 
            str = "Locale `" .. string .. "` does not seem to exist." 
        end

        return str
    end

    self.DisplayProgressBar = function(time, desciption, cb)
        DisplayProgressBar(time, desciption, cb)
    end

    -- Notifications
    self.NotifyLeft = function(firsttext, secondtext, dict, icon, duration, color)
        CoreNotifications.NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon), tonumber(duration), (tostring(color) or "COLOR_WHITE"))
    end

    self.NotifyTip = function(text, duration)
        CoreNotifications.NotifyTip(tostring(text), tonumber(duration))
    end

    self.NotifyTop = function(text, location, duration)
        CoreNotifications.NotifyTop(tostring(text), tostring(location), tonumber(duration))
    end

    self.NotifyRightTip = function(text, duration)
        CoreNotifications.NotifyRightTip(tostring(text), tonumber(duration))
    end

    self.NotifyObjective = function(text, duration)
        CoreNotifications.NotifyObjective(tostring(text), tonumber(duration))
    end

    self.NotifySimpleTop = function(title, subtitle, duration)
        CoreNotifications.NotifySimpleTop(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyAvanced = function(text, dict, icon, text_color, duration, quality)
        CoreNotifications.NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality)
    end

    self.NotifyBasicTop = function(text, duration)
        CoreNotifications.NotifyBasicTop(tostring(text), tonumber(duration))
    end

    self.NotifyCenter = function(text, duration)
        CoreNotifications.NotifyCenter(tostring(text), tonumber(duration))
    end

    self.NotifyBottomRight = function(text, duration)
        CoreNotifications.NotifyBottomRight(tostring(text), tonumber(duration))
    end

    self.NotifyFail = function(title, subtitle, duration)
        CoreNotifications.NotifyFail(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyDead = function(title, audioRef, audioName, duration)
        CoreNotifications.NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyUpdate = function(utitle, umsg, duration)
        CoreNotifications.NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
    end

    self.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        CoreNotifications.NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
        CoreNotifications.NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon), tonumber(duration), (tostring(color))) 
    end -- End of notifications

    self.loadModel = function(model)
        CoreFunctions.LoadModel(model)
    end

    self.loadTexture = function(hash)
        return CoreFunctions.LoadTexture(hash)
    end

    self.teleportToCoords = function(x, y, z, heading)
        CoreFunctions.TeleportToCoords(x, y, z, heading)
    end

    self.teleportPedToCoords = function(ped, x, y, z, heading)
        CoreFunctions.TeleportPedToCoords(ped, x, y, z, heading)
    end

    -- @param source
    -- @param loaded
    -- @param identifier
    -- @param charIdentifier
    -- @param money
    -- @param gold
    -- @param blackmoney
    -- @param firstname
    -- @param lastname
    -- @param gender
    -- @param dob
    -- @param job
    -- @param jobGrade
    -- @param identityId
    self.getPlayerClientData = function()

        local finished, foundData = false, nil

        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)
            finished  = true
            foundData = data
        end)

        while not finished do
            Wait(50)
        end

        return foundData
    
    end

    self.getClosestPedsNearbyTargetPed = function(targetPedId, targetDistance)

        if targetPedId == nil then
            targetPedId = PlayerPedId()
        end

        if targetDistance == nil then
            targetDistance = 10.0
        end
        
        local playerCoords      = GetEntityCoords(targetPedId)
        local closestEntityPeds = {}

        for _, entityPed in ipairs(GetGamePool('CPed')) do
    
            if entityPed ~= targetPedId and not IsPedAPlayer(entityPed) then
                
                local pedCoords = GetEntityCoords(entityPed)
                local distance  = GetDistanceBetweenCoords(playerCoords, pedCoords, true)
    
                if distance <= targetDistance then

                    table.insert(closestEntityPeds, { 
                        entity   = entityPed, 
                        pedType  = GetPedType(entityPed),
                        distance = distance, 
                        isDead   = IsEntityDead(entityPed)
                    })

                end
    
            end

        end
    
        return closestEntityPeds

    end

    self.StartsWith = function(inputString, findString)
        return string.sub(inputString, 1, string.len(findString)) == findString
    end

    self.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    self.GetTableLength = function(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    
    self.Split = function(inputstr, sep)
        if sep == nil then
            sep = "%s"
        end

        local t = {}

        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end

        return t

    end

    return self
end)
