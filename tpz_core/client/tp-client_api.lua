exports('getCoreAPI', function()
    local self = {}

    self.RpcCall = function(name, callback, ...) 
        ClientRPC.Callback.TriggerAsync(name, callback, ...) 
    end

    self.InstancePlayers = function(set)
        TriggerServerEvent("tpz_core:instanceplayers", set)
    end

    self.GetConfig = function()
        return Config
    end

    self.GetKeys = function()
        return GetKeys()
    end
        
    self.GetLocales = function(string)
        
        local str = Locales[string]

        if Locales[string] == nil then 
            str = "Locale `" .. string .. "` does not seem to exist." 
        end

        return str
    end

    self.DisplayProgressBar = function(time, desciption, cb)
        DisplayProgressBar(time, desciption, cb)
    end

    self.LoadModel = function(inputModel)
        local model = GetHashKey(inputModel)
 
        RequestModel(model)
 
        while not HasModelLoaded(model) do RequestModel(model)
            Citizen.Wait(10)
        end
    end

    self.RemoveEntityProperly = function(entity, objectHash)
        DeleteEntity(entity)
        DeletePed(entity)
        SetEntityAsNoLongerNeeded(entity)

        if objectHash then
            SetModelAsNoLongerNeeded(objectHash)
        end
    end

    -- Notifications
    self.NotifyLeft = function(firsttext, secondtext, dict, icon, duration, color)
        GetNotifications().NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon), tonumber(duration), (tostring(color) or "COLOR_WHITE"))
    end

    self.NotifyTip = function(text, duration)
        GetNotifications().NotifyTip(tostring(text), tonumber(duration))
    end

    self.NotifyTop = function(text, location, duration)
        GetNotifications().NotifyTop(tostring(text), tostring(location), tonumber(duration))
    end

    self.NotifyRightTip = function(text, duration)
        GetNotifications().NotifyRightTip(tostring(text), tonumber(duration))
    end

    self.NotifyObjective = function(text, duration)
        GetNotifications().NotifyObjective(tostring(text), tonumber(duration))
    end

    self.NotifySimpleTop = function(title, subtitle, duration)
        GetNotifications().NotifySimpleTop(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyAvanced = function(text, dict, icon, text_color, duration, quality)
        GetNotifications().NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality)
    end

    self.NotifyBasicTop = function(text, duration)
        GetNotifications().NotifyBasicTop(tostring(text), tonumber(duration))
    end

    self.NotifyCenter = function(text, duration)
        GetNotifications().NotifyCenter(tostring(text), tonumber(duration))
    end

    self.NotifyBottomRight = function(text, duration)
        GetNotifications().NotifyBottomRight(tostring(text), tonumber(duration))
    end

    self.NotifyFail = function(title, subtitle, duration)
        GetNotifications().NotifyFail(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyDead = function(title, audioRef, audioName, duration)
        GetNotifications().NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyUpdate = function(utitle, umsg, duration)
        GetNotifications().NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
    end

    self.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        GetNotifications().NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
        GetNotifications().NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon), tonumber(duration), (tostring(color))) 
    end -- End of notifications

    self.SendAnnouncement = function(title, description, duration, title_rgba, description_rgba)
        SendAnnouncement(title, description, duration, title_rgba, description_rgba)
    end

    self.TeleportToCoords = function(x, y, z, heading)
        GetFunctions().TeleportToCoords(x, y, z, heading)
    end

    self.TeleportPedToCoords = function(ped, x, y, z, heading)
        GetFunctions().TeleportPedToCoords(ped, x, y, z, heading)
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
    self.GetPlayerClientData = function()
        return GetFunctions().GetPlayerData()
    end

    self.GetNearestPlayers = function(distance)
        local closestDistance = distance
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed, true, true)
        local closestPlayers = {}
    
        for _, player in pairs(GetActivePlayers()) do
            local target = GetPlayerPed(player)
    
            if target ~= playerPed then
                local targetCoords = GetEntityCoords(target, true, true)
                local distance = #(targetCoords - coords)
    
                if distance < closestDistance then
                    table.insert(closestPlayers, player)
                end
            end
        end
        return closestPlayers
    end

    self.GetClosestPedsNearbyTargetPed = function(targetPedId, targetDistance)

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


