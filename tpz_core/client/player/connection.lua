
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

local HeartbeatStarted = false

RegisterNetEvent('tpz_core:isPlayerReady')
AddEventHandler("tpz_core:isPlayerReady", function(newChar)

    if HeartbeatStarted then return end
    HeartbeatStarted = true

    Citizen.CreateThread(function()
        while true do
            TriggerServerEvent("tpz_core:server:heartbeat")
            Wait(500)
        end
    end)
    
end)
