local Functions = {}

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Functions = nil

end)

-------------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

function GetFunctions()
    return Functions
end

-----------------------------------------------------------
--[[ Utility Functions  ]]--
-----------------------------------------------------------

Functions.LoadModel = function(model)
    local model = GetHashKey(model)

    if IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(100)
        end
    else
        print(model .. " is not valid") -- Concatenations
    end
end

Functions.LoadTexture = function(hash)
    if not HasStreamedTextureDictLoaded(hash) then
        RequestStreamedTextureDict(hash, true)
        while not HasStreamedTextureDictLoaded(hash) do
            Wait(1)
        end
        return true
    end
    return false
end


Functions.BigInt  = function(text)
    local string1 = DataView.ArrayBuffer(16)
    string1:SetInt64(0, text)
    return string1:GetInt64(0)
end

Functions.DrawText  = function(text, font, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(fontscale, fontsize)
    SetTextColor(r, g, b, alpha)
    SetTextCentre(textcentred)
    if shadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextFontForCurrentCommand(font)
    DisplayText(str, x, y)
end

Functions.TeleportToCoords = function(x, y, z, heading)
    local playerPedId = PlayerPedId()
    SetEntityCoords(playerPedId, x, y, z, true, true, true, false)

    if heading then
        SetEntityHeading(playerPedId, heading)
    end

    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Wait(500)
    end

end

Functions.TeleportPedToCoords = function(ped, x, y, z, heading)
    local playerPedId = ped
    SetEntityCoords(playerPedId, x, y, z, true, true, true, false)

    if heading then
        SetEntityHeading(playerPedId, heading)
    end

    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Wait(500)
    end

end

Functions.TeleportToWaypoint = function()

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

Functions.GetWebhookUrl = function(webhook)
    local wait = true
    local data_result

    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getWebhookUrl", function(cb) data_result = cb wait = false end, { webhook = webhook } )

    while wait do
        Wait(10)
    end

    return data_result
end

Functions.GetPlayerData = function()

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

Functions.HealPlayer = function()
    local ped = PlayerPedId()

    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100) -- inner first
    SetEntityHealth(ped, 600, 1) -- outter after
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100) -- fills inner
    Citizen.InvokeNative(0x675680D089BFA21F, ped, 1065330373) -- fills outter.
end


Functions.RemoveEntityProperly = function(entity, objectHash)
	DeleteEntity(entity)
	DeletePed(entity)
	SetEntityAsNoLongerNeeded( entity )

	if objectHash then
		SetModelAsNoLongerNeeded(objectHash)
	end
end

Functions.GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end