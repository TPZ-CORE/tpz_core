local SpawnPlayerData = {
    FirstSpawn    = true,
    CanBeDamaged  = false,
    Active        = false,
    MountMapType  = Config.MapTypeOnMount,
    FootMapType   = Config.MapTypeOnFoot,
    EnableMapType = Config.EnableTypeRadar,
    HealthData    = {},
    Pvp           = Config.PVP,
    PlayerHash    = GetHashKey("PLAYER"),
    MultiplierHealth = nil,
    MultiplierStamina = nil,
}

function setPVP()
    NetworkSetFriendlyFireOption(SpawnPlayerData.Pvp)

    if not SpawnPlayerData.Active then
        if SpawnPlayerData.Pvp then
            SetRelationshipBetweenGroups(5, SpawnPlayerData.PlayerHash, SpawnPlayerData.PlayerHash)
        else
            SetRelationshipBetweenGroups(1, SpawnPlayerData.PlayerHash, SpawnPlayerData.PlayerHash)
        end
    else
        SetRelationshipBetweenGroups(1, SpawnPlayerData.PlayerHash, SpawnPlayerData.PlayerHash)
    end
end

if Config.DevMode then
    Citizen.CreateThread(function()

        TriggerServerEvent('tpz_core:onPlayerJoined')
    end)
end


RegisterNetEvent('tpz_core:onPlayerFirstSpawn')
AddEventHandler("tpz_core:onPlayerFirstSpawn", function(coords, status, isdead, newChar)
    SpawnPlayerData.FirstSpawn   = false

    SpawnPlayerData.CanBeDamaged = true
    setPVP()

    Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), Config.EnableEagleEye)
    Citizen.InvokeNative(0x95EE1DEE1DCD9070, PlayerId(), Config.EnableDeadEye)

    DisplayRadar(true)
    SetMinimapHideFow(true)

    TaskStandStill(PlayerPedId(), 1)

    Wait(3000)

    CoreFunctions.TeleportToCoords(coords.x, coords.y, coords.z, coords.heading)

    Wait(2000)

    -- We are checking if the player left in guarma in order to request the map when spawning the player.
    local pedCoords = GetEntityCoords(PlayerPedId())
    local area = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 10)

    if area == -512529193 then

        Citizen.InvokeNative(0xA657EC9DBC6CC900, 1935063277)
        Citizen.InvokeNative(0xE8770EE02AEE45C2, 1)
        Citizen.InvokeNative(0x74E2261D2A66849A, true)
    end

    if isdead == 1 then
        Wait(4000)

        while not IsEntityDead(PlayerPedId()) do
            Wait(1500)
            SetEntityHealth(PlayerPedId(), 0, 0)
        end

    else

        if not Config.HealthRecharge.Enable then
            Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), 0.0)                                 -- SetPlayerHealthRechargeMultiplier
        else
            Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), Config.HealthRecharge.Multiplier)    -- SetPlayerHealthRechargeMultiplier
            SpawnPlayerData.MultiplierHealth = Citizen.InvokeNative(0x22CD23BB0C45E0CD, PlayerId())   -- GetPlayerHealthRechargeMultiplier
        end

        if not Config.StaminaRecharge.Enable then
            Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), 0.0)                                 -- SetPlayerStaminaRechargeMultiplier
        else
            Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), Config.StaminaRecharge.Multiplier['1'])   -- SetPlayerStaminaRechargeMultiplier
            SpawnPlayerData.MultiplierStamina = Citizen.InvokeNative(0x617D3494AD58200F, PlayerId())  -- GetPlayerStaminaRechargeMultiplier
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, status.healthInner)
        SetEntityHealth(PlayerPedId(), status.healthOuter + status.healthInner, 0)
        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, status.staminaInner)
        Citizen.InvokeNative(0x675680D089BFA21F, PlayerPedId(), status.staminaOuter / 1065353215 * 100)

        if Config.DisableHealthRechargeMultipler then
            Citizen.InvokeNative(0xDE1B1907A83A1550, PlayerPedId(), 0) --SetHealthRechargeMultiplier
        end

    end
    
    DoScreenFadeIn(6000)
    
    local newCharCb = newChar == true and 1 or 0
    TriggerEvent('tpz_core:isPlayerReady', newCharCb)

    Wait(20000)
    TriggerServerEvent("tpz_core:registerChatSuggestions")
end)

--[[ ------------------------------------------------
   (Thread) Health & Stamina Multipliers
]]---------------------------------------------------

CreateThread(function()
    while true do
        Wait(1000)
        if not SpawnPlayerData.FirstSpawn then
            local multiplierH = Citizen.InvokeNative(0x22CD23BB0C45E0CD, PlayerId()) -- GetPlayerHealthRechargeMultiplier

            if multiplierHealth and multiplierHealth ~= multiplierH then
                Wait(500)
                Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), Config.HealthRecharge.Multiplier) -- SetPlayerHealthRechargeMultiplier
            elseif not multiplierHealth and multiplierH then
                Wait(500)
                Citizen.InvokeNative(0x8899C244EBCF70DE, PlayerId(), 0.0) -- SetPlayerHealthRechargeMultiplier
            end

            local stamina = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 1) --ACTUAL STAMINA CORE GETTER

            if stamina then
                if tonumber(stamina) == 100 then

                    Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), Config.StaminaRecharge.Multiplier['1']) -- SetPlayerStaminaRechargeMultiplier
    
                elseif tonumber(stamina) < 100 and tonumber(stamina) > 50 then
    
                    Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), Config.StaminaRecharge.Multiplier['2']) -- SetPlayerStaminaRechargeMultiplier
    
                elseif tonumber(stamina) <= 50 and tonumber(stamina) > 20 then
        
                    Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), Config.StaminaRecharge.Multiplier['3']) -- SetPlayerStaminaRechargeMultiplier

                elseif tonumber(stamina) <= 20 and tonumber(stamina) > 5 then
                    Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), Config.StaminaRecharge.Multiplier['4']) -- SetPlayerStaminaRechargeMultiplier
                end
            end

            if (not stamina) or (stamina and tonumber(stamina) <= 5) then
                Citizen.InvokeNative(0xFECA17CF3343694B, PlayerId(), 0.0) -- SetPlayerStaminaRechargeMultiplier
                Citizen.InvokeNative(0xC3D4B754C0E86B9E, PlayerPedId(), -1000.0)
            end
        end
    end
end)

--[[ ------------------------------------------------
   (Thread) Saving Player Status (Health & Stamina)
]]---------------------------------------------------

CreateThread(function()
    while true do
        Wait(Config.SavePlayerHealthAndStaminaTime)
        
        local ich  = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0, Citizen.ResultAsInteger())
        local ocs  = Citizen.InvokeNative(0x22F2A386D43048A9, PlayerPedId())
        local ics  = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 1, Citizen.ResultAsInteger())

        local health, innerHealth, innerStamina = GetEntityHealth(PlayerPedId()), tonumber(ich), tonumber(ics)

        if innerHealth and innerStamina and health and ocs then

            local healthData  = { outer = health, inner = innerHealth }
            local staminaData = { outer = ocs, inner = innerStamina }

            TriggerServerEvent("tpz_core:savePlayerStatus", healthData, staminaData)
        end
    end
end)

--[[ ------------------------------------------------
   (Thread) Allow Player Damage (After Character Selection)
]]---------------------------------------------------


CreateThread(function()
    while true do

        if Citizen.InvokeNative(0x75DF9E73F2F005FD, PlayerPedId()) then
            SetEntityCanBeDamaged(PlayerPedId(), false)
        end

        if SpawnPlayerData.CanBeDamaged then
            Wait(12000)
            SetEntityCanBeDamaged(PlayerPedId(), true)
            break
        end
        Wait(0)
    end
end)


--[[ ------------------------------------------------
   (Thread) Sets Minimap Type
]]---------------------------------------------------

CreateThread(function()
    while true do
        Wait(3000)

        if not SpawnPlayerData.FirstSpawn then
            local player          = PlayerPedId()

            -- If true, we set every x seconds the map type based on player actions when being on a vehicle / not.
            local isPedOnMount    = IsPedOnMount(player)
            local isPedOnVehicle  = IsPedInAnyVehicle(player)

            if SpawnPlayerData.EnableMapType then

                if not isPedOnMount and not isPedOnVehicle then
                    SetMinimapType(SpawnPlayerData.FootMapType)
        
                elseif isPedOnMount or isPedOnVehicle then
                    SetMinimapType(SpawnPlayerData.MountMapType)
                end
        
            end

        end
    end

end)

if Config.ShowInteriorMappingsRadar then

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)  
    
            local playerPed = PlayerPedId()
            local interiorId = GetInteriorFromEntity(playerPed)
    
            if interiorId ~= 0 then
                -- ped entered an interior
                SetRadarConfigType(0xDF5DB58C, 0) -- zoom in the map by 10x
            else
                -- ped left an interior
                SetRadarConfigType(0x25B517BF, 0) -- zoom in the map by 0x (return the minimap back to normal)
            end
        end
    end)

end

--[[ ------------------------------------------------
   (Thread) Disables HUD
]]---------------------------------------------------


CreateThread(function()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        
        DisableControlAction(0, 0x580C4473, true) DisableControlAction(0, 0xCF8A4ECA, true) DisableControlAction(0, 0x9CC7A1A4, true) DisableControlAction(0, 0x1F6D95E5, true)

        if not SpawnPlayerData.FirstSpawn then
            if IsControlPressed(0, 0xCEFD9220) then
                SpawnPlayerData.Active = true
                setPVP()
                Citizen.Wait(4000)
            end

            if not IsPedOnMount(playerPed) and not IsPedInAnyVehicle(playerPed, false) and SpawnPlayerData.Active then
                SpawnPlayerData.Active = false
                setPVP()
            elseif SpawnPlayerData.Active and IsPedOnMount(playerPed) or IsPedInAnyVehicle(playerPed, false) then
                if IsPedInAnyVehicle(playerPed, false) then

                elseif GetPedInVehicleSeat(GetMount(playerPed), -1) == playerPed then
                    SpawnPlayerData.Active = false
                    setPVP()
                end
            else
                setPVP()
            end
        end

    end
end)

--[[ ------------------------------------------------
   (Thread) Save Current Player Coords
]]---------------------------------------------------

CreateThread(function()
    while true do
        Wait(Config.SavePlayerLocationTime)

        if not SpawnPlayerData.FirstSpawn then 
   
            local player        = PlayerPedId()
            local coords        = GetEntityCoords(player, true, true)
            local data          = { x = coords.x, y = coords.y, z = coords.z, heading = GetEntityHeading(player) }

            TriggerServerEvent("tpz_core:savePlayerCurrentLocation", data)
        end
    end
end)

