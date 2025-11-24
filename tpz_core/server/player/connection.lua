local UserHeartbeats = {}

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

if Config.KickPlayerOnEthernetDisconnect.Enabled then
    
    RegisterNetEvent("tpz_core:server:heartbeat")
    AddEventHandler("tpz_core:server:heartbeat", function() 
        local _source = source
    
        if UserHeartbeats[_source] == nil then
    
            UserHeartbeats[_source] = { 
                timer = 0, 
                triggered = 0, 
            }
    
        end
        
        UserHeartbeats[_source].timer = GetGameTimer() 
    end)
    
    Citizen.CreateThread(function()
    
        while true do
            Wait(1000)
    
            local now = GetGameTimer()
    
            for source, user in pairs(UserHeartbeats) do
    
                source = tonumber(source)
    
                local diff = now - user.timer
    
                if diff > 2000 then
                    
                    if user.triggered == 1 and GetPlayerName(tonumber(source)) then 
                        
                        TriggerClientEvent("tpz_core:client:desync", tonumber(source), true)
    
                        DropPlayer(tonumber(source), Config.KickPlayerOnEthernetDisconnect.DisplayKickMessage)
                        UserHeartbeats[source] = nil
                    end
    
                else 
                    user.triggered = 0
                end
    
                if GetPlayerName(tonumber(source)) == nil then 
                    UserHeartbeats[source] = nil
                end
    
            end
    
        end
    
    end)

end
