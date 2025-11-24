local DESYNC_STATUS = false

local MenuData = {}

TriggerEvent("tpz_menu_base:getData", function(call)
    MenuData = call
end)

--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterNetEvent("tpz_core:client:desync")
AddEventHandler("tpz_core:client:desync", function(isDesync)

    if isDesync == true and DESYNC_STATUS ~= isDesync then 

        SetNuiFocus(false, false)
        MenuData.CloseAll()

    end

    DESYNC_STATUS = isDesync

end)

if Config.KickPlayerOnEthernetDisconnect.Enabled then

    RegisterNetEvent('tpz_core:isPlayerReady')
    AddEventHandler("tpz_core:isPlayerReady", function(newChar)
    
        Citizen.CreateThread(function()
            while true do
                TriggerServerEvent("tpz_core:server:heartbeat")
                Wait(500)
            end
        end)
    end)
    
end