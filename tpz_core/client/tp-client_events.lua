
core.RequestModuleAwait("core.functions")

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
    core.functions.CloseMapUI()
    core.functions.TeleportToCoords(x, y, z, heading)
end)

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_core:teleportToWayPoint')
AddEventHandler('tpz_core:teleportToWayPoint', function()
    core.functions.CloseMapUI()
    core.functions.TeleportToWaypoint()
end)

RegisterNetEvent('tpz_core:healPlayer')
AddEventHandler('tpz_core:healPlayer', function()
    core.functions.HealPlayer()
end)

RegisterNetEvent('tpz_core:sendAnnouncement')
AddEventHandler('tpz_core:sendAnnouncement', function(title, description, duration, title_rgba, description_rgba)
    SendAnnouncement(title, description, duration, title_rgba, description_rgba)
end)