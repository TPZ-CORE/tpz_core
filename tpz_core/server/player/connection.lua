local UserHeartbeats = {}


-----------------------------------------------------------
--[[ Public Events ]]--
-----------------------------------------------------------

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

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    
    while true do
        Wait(1000)

        local now = GetGameTimer()

        for source, user in pairs(UserHeartbeats) do

            source = tonumber(source)

            local diff = now - user.timer

            if diff > 2000 then
                
                user.triggered = 1

                if PlayerData[source] then
                    PlayerData[source].connection_lost = 1
                end

                if Config.KickPlayerOnEthernetDisconnect.Enabled then

                    if PlayerData[source] and GetPlayerName(source) ~= nil then
                        DropPlayer(source, Config.KickPlayerOnEthernetDisconnect.DisplayKickMessage)
                    end

                    UserHeartbeats[source] = nil
                end

            else 

                if PlayerData[source] then
                    PlayerData[source].connection_lost = 0
                end

                user.triggered = 0
            end

            if GetPlayerName(tonumber(source)) == nil then 
                UserHeartbeats[source] = nil
            end

        end

    end

end)

