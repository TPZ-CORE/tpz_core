local NamedInstanceList = {}
math.randomseed(os.time())

RegisterServerEvent("tpz_core:instanceplayers")
AddEventHandler("tpz_core:instanceplayers", function(setRoom)
    local _source = source
    local instanceSource = nil

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
            instanceSource = math.random(1, 63)

            while NamedInstanceList[instanceSource] and #NamedInstanceList[instanceSource] >= 1 do
                instanceSource = math.random(1, 63)
                Wait(1)
            end
        end
    end

    if instanceSource ~= 0 then
        if not NamedInstanceList[instanceSource] then
            NamedInstanceList[instanceSource] = {
                name = setRoom,
                people = {}
            }
        end

        table.insert(NamedInstanceList[instanceSource].people, _source)
    end

    SetPlayerRoutingBucket(_source, instanceSource)

end)

-- credits to MrDankKetchup
