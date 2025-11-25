
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent('tpz_core:isPlayerReady')
AddEventHandler("tpz_core:isPlayerReady", function(newChar)

    Citizen.CreateThread(function()
        while true do
            TriggerServerEvent("tpz_core:server:heartbeat")
            Wait(500)
        end
    end)
    
end)
