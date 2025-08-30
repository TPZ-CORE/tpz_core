
-- The following event is triggered when the player selected a character and successfully spawned (teleported) to the last saved location.
RegisterNetEvent('tpz_core:isPlayerReady')
AddEventHandler("tpz_core:isPlayerReady", function(newChar)

    if Config.PlayAnimPostFX then
        AnimpostfxPlay("Title_Gen_FewHoursLater")
    end

    CreateThread(function()
        while true do
            Wait(60000 * Config.SavePlayerData)

            if PlayerPedId() == nil or PlayerPedId() and not DoesEntityExist(PlayerPedId()) then
                break
            end

            TriggerServerEvent("tpz_core:tpz_core:saveCharacter")
        end

    end)

end)


-- The following event is triggered when the player has been respawned (not revived).
RegisterNetEvent('tpz_core:isPlayerRespawned')
AddEventHandler("tpz_core:isPlayerRespawned", function()
    -- to-do nothing
end)

-- @param job      - returns the current job
-- @param jobGrade - returns the current job grade
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    -- to-do nothing
end)

-- @param group - returns the current group
RegisterNetEvent("tpz_core:getPlayerGroup")
AddEventHandler("tpz_core:getPlayerGroup", function(group)
    -- to-do nothing
end)


RegisterNetEvent("tpz_core:teleportToCoords")
AddEventHandler("tpz_core:teleportToCoords", function(x, y, z, heading)
    GetFunctions().TeleportToCoords(x, y, z, heading)
    Citizen.InvokeNative(0x2FF10C9C3F92277E,GetHashKey('MAP'))
end)

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_core:teleportToWayPoint')
AddEventHandler('tpz_core:teleportToWayPoint', function()
    GetFunctions().TeleportToWaypoint()
    Citizen.InvokeNative(0x2FF10C9C3F92277E,GetHashKey('MAP'))
end)

RegisterNetEvent('tpz_core:healPlayer')
AddEventHandler('tpz_core:healPlayer', function()
    GetFunctions().HealPlayer()
end)

RegisterNetEvent('tpz_core:sendAnnouncement')
AddEventHandler('tpz_core:sendAnnouncement', function(title, description, duration, title_rgba, description_rgba)
    SendAnnouncement(title, description, duration, title_rgba, description_rgba)
end)

-----------------------------------------------------------
--[[ Notifications  ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_core:sendLeftNotification')
AddEventHandler('tpz_core:sendLeftNotification', function(firsttext, secondtext, dict, icon, duration, color)
    GetNotifications().NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon), tonumber(duration), (tostring(color) or "COLOR_WHITE"))
end)

RegisterNetEvent('tpz_core:sendTipNotification')
AddEventHandler('tpz_core:sendTipNotification', function(text, duration)
    GetNotifications().NotifyTip(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendTopNotification')
AddEventHandler('tpz_core:sendTopNotification', function(text, location, duration)
    GetNotifications().NotifyTop(tostring(text), tostring(location), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendRightTipNotification')
AddEventHandler('tpz_core:sendRightTipNotification', function(text, duration)
    GetNotifications().NotifyRightTip(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendBottomTipNotification')
AddEventHandler('tpz_core:sendBottomTipNotification', function(text, duration)
    GetNotifications().NotifyObjective(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendSimpleTopNotification')
AddEventHandler('tpz_core:sendSimpleTopNotification', function(title, subtitle, duration)
    GetNotifications().NotifySimpleTop(tostring(title), tostring(subtitle), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendAdvancedRightNotification')
AddEventHandler('tpz_core:sendAdvancedRightNotification', function(text, dict, icon, text_color, duration, quality)
    GetNotifications().NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality)
end)

RegisterNetEvent('tpz_core:sendBasicTopNotification')
AddEventHandler('tpz_core:sendBasicTopNotification', function(text, duration)
    GetNotifications().NotifyBasicTop(tostring(text), tonumber(duration))
end)       

RegisterNetEvent('tpz_core:sendSimpleCenterNotification')
AddEventHandler('tpz_core:sendSimpleCenterNotification', function(text, duration)
    GetNotifications().NotifyCenter(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendBottomRightNotification')
AddEventHandler('tpz_core:sendBottomRightNotification', function(text, duration)
    GetNotifications().NotifyBottomRight(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendFailMissionNotification')
AddEventHandler('tpz_core:sendFailMissionNotification', function(title, subtitle, duration)
    GetNotifications().NotifyFail(tostring(title), tostring(subtitle), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendDeadPlayerNotification')
AddEventHandler('tpz_core:sendDeadPlayerNotification', function(title, audioRef, audioName, duration)
    GetNotifications().NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendMissionUpdateNotification')
AddEventHandler('tpz_core:sendMissionUpdateNotification', function(utitle, umsg, duration)
    GetNotifications().NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendWarningNotification')
AddEventHandler('tpz_core:sendWarningNotification', function(title, msg, audioRef, audioName, duration)
    GetNotifications().NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendLeftRankNotification')
AddEventHandler('tpz_core:sendLeftRankNotification', function(title, subtitle, dict, icon, duration, color)
    GetNotifications().NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon) , tonumber(duration), (tostring(color))) 
end)


