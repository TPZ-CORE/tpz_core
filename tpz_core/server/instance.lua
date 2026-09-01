local NamedInstanceList = {}
local InstanceRequestTimers = {}
math.randomseed(os.time())

RegisterServerEvent("tpz_core:instanceplayers")
AddEventHandler("tpz_core:instanceplayers", function(setRoom)
    local _source = source
    local instanceSource = nil

    if not PlayerData[_source] then return end
    if setRoom ~= 0 and (type(setRoom) ~= 'string' or #setRoom == 0 or #setRoom > 64) then return end
    local now = GetGameTimer()
    if InstanceRequestTimers[_source] and now - InstanceRequestTimers[_source] < 1000 then return end
    InstanceRequestTimers[_source] = now

    -- if setRoom is 0, then we are leaving the instance
    if setRoom == 0 then
        for k, v in pairs(NamedInstanceList) do
            for k2, v2 in pairs(v.people) do
                if v2 == _source then
                    table.remove(v.people, k2)
                end
            end
            if #v.people == 0 then
                NamedInstanceList[k] = nil
            end
        end
        instanceSource = setRoom
    else
        for k, v in pairs(NamedInstanceList) do
            if v.name == setRoom then
                instanceSource = k
            end
        end

        if instanceSource == nil then
            for _ = 1, 63 do
                local candidate = math.random(1, 63)
                if not NamedInstanceList[candidate] or #NamedInstanceList[candidate] == 0 then
                    instanceSource = candidate
                    break
                end
                Wait(1)
            end
            if instanceSource == nil then return end
        end
    end

    if instanceSource ~= 0 then
        if not NamedInstanceList[instanceSource] then
            NamedInstanceList[instanceSource] = {
                name = setRoom,
                people = {}
            }
        end

        local alreadyPresent = false
        for _, player in ipairs(NamedInstanceList[instanceSource].people) do
            if player == _source then alreadyPresent = true break end
        end
        if not alreadyPresent then
            table.insert(NamedInstanceList[instanceSource].people, _source)
        end
    end

    SetPlayerRoutingBucket(_source, instanceSource)

end)

-- credits to MrDankKetchup
