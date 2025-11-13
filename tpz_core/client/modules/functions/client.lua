core.functions = {}

core.stop = function()
    core.functions = nil
end

-----------------------------------------------------------
--[[ General Utility Functions  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()

    core.functions.LoadTexture = function(hash)
        if not HasStreamedTextureDictLoaded(hash) then
            RequestStreamedTextureDict(hash, true)
            while not HasStreamedTextureDictLoaded(hash) do
                Wait(1)
            end
            return true
        end
        return false
    end
    
    
    core.functions.BigInt  = function(text)
        local string1 = DataView.ArrayBuffer(16)
        string1:SetInt64(0, text)
        return string1:GetInt64(0)
    end
    
    core.functions.DrawText  = function(text, font, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
        local str = CreateVarString(10, "LITERAL_STRING", text)
        SetTextScale(fontscale, fontsize)
        SetTextColor(r, g, b, alpha)
        SetTextCentre(textcentred)
        if shadow then SetTextDropshadow(1, 0, 0, 0, 255) end
        SetTextFontForCurrentCommand(font)
        DisplayText(str, x, y)
    end
    
    core.functions.GetWebhookUrl = function(webhook)
        local wait = true
        local data_result
    
        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getWebhookUrl", function(cb) data_result = cb wait = false end, { webhook = webhook } )
    
        while wait do
            Wait(1)
        end
    
        return data_result
    end
    
    core.functions.CloseMapUI = function()
        InvokeNative(0x2FF10C9C3F92277E,GetHashKey('MAP'))
    end
    
    core.functions.GetTableLength = function(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    
    core.functions.StartsWith = function(inputString, findString)
        return string.sub(inputString, 1, string.len(findString)) == findString
    end

    core.functions.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    --- Performs linear interpolation between two values.
    ---@param a number (The starting value)
    ---@param b number (The ending value)
    ---@param t number (The interpolation factor, usually between 0 and 1)
    ---@return number (The interpolated value between a and b)
    core.functions.Lerp = function(a, b, t)
      return a + (b - a) * t
    end
    
    core.functions.Split = function(inputstr, sep)
        if sep == nil then
            sep = "%s"
        end

        local t = {}

        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end

        return t

    end

    -----------------------------------------------------------
    --[[ Player & Ped Utility Functions  ]]--
    -----------------------------------------------------------

    core.functions.GetNearestPlayers = function(distance)
        local closestDistance = distance
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed, true, true)
        local closestPlayers = {}
    
        for _, player in pairs(GetActivePlayers()) do
            local target = GetPlayerPed(player)
    
            if target ~= playerPed then
                local targetCoords = GetEntityCoords(target, true, true)
                local distance = #(targetCoords - coords)
    
                if distance < closestDistance then
                    table.insert(closestPlayers, player)
                end
            end
        end
        return closestPlayers
    end

    core.functions.PlayAnimation = function(ped, anim)
    
        if not DoesAnimDictExist(anim.dict) then
            return false
        end
        
        local await = 10000
        local loaded = true
    
        RequestAnimDict(anim.dict)
        
        while not HasAnimDictLoaded(anim.dict) do
    
            await = await - 10
    
            if await <= 0 then
                loaded = false
                break
            end
    
            Citizen.Wait(10)
        end
    
        if loaded then
            TaskPlayAnim(ped, anim.dict, anim.name, anim.blendInSpeed, anim.blendOutSpeed, anim.duration, anim.flag, anim.playbackRate, false, false, false, '', false)
            RemoveAnimDict(anim.dict)
        end
    
        return loaded
    end
    
    core.functions.LoadModel = function(model)
        local model = GetHashKey(inputModel)
 
        RequestModel(model)

        local await = 10000
        local loaded = true

        while not HasModelLoaded(model) do 
            RequestModel(model)

            await = await - 10

            if await <= 0 then
                loaded = false
                print('attempted to load a model but took too long.', 'model: ' .. model)
                break
            end

            Citizen.Wait(10)
        end

        return loaded
    end
    
    core.functions.RemoveEntityProperly = function(entity, objectHash)
    	DeleteEntity(entity)
    	DeletePed(entity)
    	SetEntityAsNoLongerNeeded( entity )
    
    	if objectHash then
    		SetModelAsNoLongerNeeded(objectHash)
    	end
    end
    
    core.functions.HealPlayer = function()
        local ped = PlayerPedId()
    
        InvokeNative(0xC6258F41D86676E0, ped, 0, 100) -- inner first
        SetEntityHealth(ped, 600, 1) -- outter after
        InvokeNative(0xC6258F41D86676E0, ped, 1, 100) -- fills inner
        InvokeNative(0x675680D089BFA21F, ped, 1065330373) -- fills outter.
    end
    
    core.functions.TeleportToCoords = function(x, y, z, heading)
        local playerPedId = PlayerPedId()
        SetEntityCoords(playerPedId, x, y, z, true, true, true, false)
    
        if heading then
            SetEntityHeading(playerPedId, heading)
        end
    
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(500)
        end
    
    end
    
    core.functions.TeleportPedToCoords = function(ped, x, y, z, heading)
        local playerPedId = ped or PlayerPedId()
        SetEntityCoords(playerPedId, x, y, z, true, true, true, false)
    
        if heading then
            SetEntityHeading(playerPedId, heading)
        end
    
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(500)
        end
    
    end
    
    core.functions.TeleportToWaypoint = function()
    
        local ped = PlayerPedId()
        local GetGroundZAndNormalFor_3dCoord = GetGroundZAndNormalFor_3dCoord
        local waypoint = IsWaypointActive()
        local coords = GetWaypointCoords()
        local x, y, groundZ, startingpoint = coords.x, coords.y, 650.0, 750.0
        local found = false
    
        if not waypoint then
            return
        end
        DoScreenFadeOut(500)
        Wait(1000)
        FreezeEntityPosition(ped, true)
        for i = startingpoint, 0, -25.0 do
            local z = i
            if (i % 2) ~= 0 then
                z = startingpoint + i
            end
            SetEntityCoords(ped, x, y, z - 1000)
            Wait(1000)
            found, groundZ = GetGroundZAndNormalFor_3dCoord(x, y, z)
            if found then
                SetEntityCoords(ped, x, y, groundZ)
                FreezeEntityPosition(ped, false)
                Wait(1000)
                DoScreenFadeIn(650)
                break
            end
        end
    end
    
    core.functions.GetPlayerData = function()
    
        local wait = true
        local data_result
    
        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(cb)
            data_result = cb
            wait = false
        end)
    
        while wait do
            Wait(25)
        end
    
        return data_result
    
    end

    core.SetModuleLoaded("functions")
end)
