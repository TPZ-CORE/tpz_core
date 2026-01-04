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

    self.modules = function()
        return core
    end

    self.IsPlayerBusy = function() 
        return GetTaskManager():IsPlayerBusy()
    end

    self.SetBusy = function(scriptName, state) 
        GetTaskManager():SetBusy(scriptName, state) 
    end

    --- @deprecated : Use TPZ.module().keys instead.
    self.GetKeys = function()
        return core.keys
    end
        
    self.GetLocales = function(string)
        
        local str = Locales[string]

        if Locales[string] == nil then 
            str = "Locale `" .. string .. "` does not seem to exist." 
        end

        return str
    end

    --- @deprecated : Use TPZ.modules().functions.DisplayProgressBar(time, desciption, cb) instead.
    self.DisplayProgressBar = function(time, desciption, cb)
        core.functions.DisplayProgressBar(time, desciption, cb)
    end

    --- @deprecated : Use TPZ.modules().functions.PlayAnimation(ped, anim) instead.
    self.PlayAnimation = function(ped, anim)
        return core.functions.PlayAnimation(ped, anim)
    end

    --- @deprecated : Use TPZ.modules().functions.LoadModel(inputModel) instead.
    self.LoadModel = function(inputModel)
        return core.functions.LoadModel(inputModel)
    end

    --- @deprecated : Use TPZ.modules().functions.RemoveEntityProperly(entity, objectHash) instead.
    self.RemoveEntityProperly = function(entity, objectHash)
        core.functions.RemoveEntityProperly(entity, objectHash)
    end

    --- @deprecated : Use TPZ.modules().functions.TeleportToCoords(x, y, z, heading) instead.
    self.TeleportToCoords = function(x, y, z, heading)
        core.functions.TeleportToCoords(x, y, z, heading)
    end

    --- @deprecated : Use TPZ.modules().functions.TeleportPedToCoords(ped, x, y, z, heading) instead.
    self.TeleportPedToCoords = function(ped, x, y, z, heading)
        core.functions.TeleportPedToCoords(ped, x, y, z, heading)
    end

    -- Notifications
    self.NotifyLeft = function(firsttext, secondtext, dict, icon, duration, color)
        core.notifications.NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon), tonumber(duration), (tostring(color) or "COLOR_WHITE"))
    end

    self.NotifyTip = function(text, duration)
        core.notifications.NotifyTip(tostring(text), tonumber(duration))
    end

    self.NotifyTop = function(text, location, duration)
        core.notifications.NotifyTop(tostring(text), tostring(location), tonumber(duration))
    end

    self.NotifyRightTip = function(text, duration)
        core.notifications.NotifyRightTip(tostring(text), tonumber(duration))
    end

    self.NotifyObjective = function(text, duration)
        core.notifications.NotifyObjective(tostring(text), tonumber(duration))
    end

    self.NotifySimpleTop = function(title, subtitle, duration)
        core.notifications.NotifySimpleTop(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyAvanced = function(text, dict, icon, text_color, duration, quality)
        core.notifications.NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality)
    end

    self.NotifyBasicTop = function(text, duration)
        core.notifications.NotifyBasicTop(tostring(text), tonumber(duration))
    end

    self.NotifyCenter = function(text, duration)
        core.notifications.NotifyCenter(tostring(text), tonumber(duration))
    end

    self.NotifyBottomRight = function(text, duration)
        core.notifications.NotifyBottomRight(tostring(text), tonumber(duration))
    end

    self.NotifyFail = function(title, subtitle, duration)
        core.notifications.NotifyFail(tostring(title), tostring(subtitle), tonumber(duration))
    end

    self.NotifyDead = function(title, audioRef, audioName, duration)
        core.notifications.NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyUpdate = function(utitle, umsg, duration)
        core.notifications.NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
    end

    self.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        core.notifications.NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    self.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
        core.notifications.NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon), tonumber(duration), (tostring(color))) 
    end -- End of notifications

    self.SendAnnouncement = function(title, description, duration, title_rgba, description_rgba)
        SendAnnouncement(title, description, duration, title_rgba, description_rgba)
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
        return core.functions.GetPlayerData()
    end

    self.GetNearestPlayers = function(distance)
        return core.functions.GetNearestPlayers(distance)
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
        return core.functions.StartsWith(inputString, findString)
    end

    self.Round = function(num, numDecimalPlaces)
        return core.functions.Round(num, numDecimalPlaces)
    end

    self.GetTableLength = function(T)
        return core.functions.GetTableLength(T)
    end
    
    self.Split = function(inputstr, sep)
        return core.functions.Split(inputstr, sep)
    end

    self.Capitalize = function(str)
        return (str:gsub("^%l", string.upper))
    end

    return self
end)





