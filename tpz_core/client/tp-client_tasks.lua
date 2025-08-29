--[[ ------------------------------------------------
   Looping Tasks
]]---------------------------------------------------

CreateThread(function() 
        
    while true do
        Wait(0)

        Citizen.InvokeNative(0x4CC5F2FC1332577F , -66088566)  -- Removing money accounts

        if Config.DisableAutoAim then
            Citizen.InvokeNative(0xD66A941F401E7302, 3)
            Citizen.InvokeNative(0x19B4F71703902238, 3)
        end

    end
end)

--[[ ------------------------------------------------
   Non Looping Tasks
]]---------------------------------------------------

CreateThread(function()

    if Config.HidePlayersCore then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 0, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 1, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 2, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 3, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 4, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 5, 2)
    end

    if Config.HideHorsesCore then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 6, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 7, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 8, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 9, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 10, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 11, 2)
    end

    if Config.HideOnlyDeadEye then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 2, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 3, 2)
    end

end)


--[[ ---------------------------------------------------------
   Map Folding Animations (This was made from other developer)
]]------------------------------------------------------------


if Config.MapObject then

    local isMapMenuOpen = false
    local prop          = nil

    local function StartMapObjectAnimation(v1,v2)
        local animationDict = v1
        local antar = v2
        if not DoesAnimDictExist(animationDict) then
            print("Invalid animation dictionary: " .. animationDict)
            return
        end
        RequestAnimDict(animationDict)
        while not HasAnimDictLoaded(animationDict) do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), animationDict, antar, -1.0, -0.5, -1   ,14, 0, true, 0, false, 0, false)
    end

    local function SortirMap()
        StartMapObjectAnimation("mech_inspection@two_fold_map@satchel", "enter")
    end
    
    local function RangerMap(animationDict)
        ClearPedTasks(PlayerPedId())

        RemoveAnimDict(animationDict)
        StartMapObjectAnimation("mech_inspection@two_fold_map@satchel", "exit_satchel")
    end

    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            local playerPed = PlayerPedId()

            if IsAppActive(`MAP`) ~= 0 and not isMapMenuOpen then

                SetCurrentPedWeapon(playerPed, joaat('WEAPON_UNARMED'), true) -- unarm player
                isMapMenuOpen = true

                SortirMap()
                Wait(2000)

                local coords = GetEntityCoords(playerPed) 
                local entity  = CreateObject(joaat("s_twofoldmap01x_us"), coords.x, coords.y, coords.z, 1, 0, 1)
                prop          = entity

                SetEntityAsMissionEntity(prop,true,true)

                RequestAnimDict("mech_carry_box")

                while not HasAnimDictLoaded("mech_carry_box") do
                    Citizen.Wait(100)
                end
                
                Citizen.InvokeNative(0xEA47FE3719165B94, playerPed,"mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0)
                Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop, playerPed, GetEntityBoneIndexByName(playerPed,"SKEL_L_Finger12"), 0.20, 0.00, -0.15, 180.0, 190.0, 0.0, true, true, false, true, 1, true)
            end

            if IsAppActive(`MAP`) ~= 1 and isMapMenuOpen then
                isMapMenuOpen = false

                RangerMap("mech_carry_box")

                ClearPedSecondaryTask(playerPed)

                GetFunctions().RemoveEntityProperly(prop, joaat("s_twofoldmap01x_us"))

                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                TaskStandStill(playerPed, 1)

                RemoveAnimDict("mech_inspection@two_fold_map@satchel")
            end
        end
    end)

end

Citizen.CreateThread(function()
    while true do
        Wait(Config.PlayerCanMercyKill.UpdateDelay * 1000)
        SetPlayerCanMercyKill(PlayerId(), Config.PlayerCanMercyKill.Enabled)
    end

end)

CreateThread(function()
    local maxplayers = GetConvarInt('sv_maxClients', Config.sv_maxClients)
    local players    = 0

    local DiscordData = Config.DiscordRichPresence

    SetDiscordAppId(DiscordData.ApplicationId)
    SetDiscordRichPresenceAsset(DiscordData.BigLogo)
    SetDiscordRichPresenceAssetText(DiscordData.BigLogoDescription)
    SetDiscordRichPresenceAssetSmall(DiscordData.SmallLogo)
    SetDiscordRichPresenceAssetSmallText(DiscordData.SmallLogoDescription)

    if Config.Buttons and Config.Buttons ~= false and type(Config.Buttons) == "table" then
        for k, v in pairs(Config.Buttons) do
            SetDiscordRichPresenceAction(k - 1, v.Text, v.Url)
        end
    end

    local Info = DiscordData.DisplayPlayerInfo

    if Info.OnlinePlayers or Info.SteamName or Info.Id then

        while true do

            local parts = {}
    
            if Info.OnlinePlayers then
                players = ClientRPC.Callback.TriggerAwait("tpz_core:callback:getOnlinePlayers", {})
                table.insert(parts, players .. "/" .. maxplayers)
            end
            
            if Info.Id then
                local sourceId = GetPlayerServerId(PlayerId())

                if #parts > 0 then
                    table.insert(parts, " - ID: " .. sourceId)
                else
                    table.insert(parts, "ID: " .. sourceId)
                end

            end

            if Info.SteamName then
                local steamName = GetPlayerName(PlayerId())

                if #parts > 0 then
                    table.insert(parts, " | " .. steamName)
                else
                    table.insert(parts, steamName)
                end

            end
            
            local finalString = table.concat(parts, " ")
            SetRichPresence(finalString)
    
            Wait(60000) -- 1 min update
        end
    
    end

end)

