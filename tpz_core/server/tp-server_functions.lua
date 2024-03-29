AddEventHandler('getTPZCore', function(cb)

    local coreData = {}

    coreData.GetPlayer = function(source)
        return GetPlayer(source)
    end

    coreData.GetJobPlayers = function(job)
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] and PlayerData[player].job == job then

                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    cb(coreData)

end)


-- @GetPlayer return the current selected player character.
GetPlayer = function(source)

    local functions = {}

    functions.loaded = function()
        return PlayerData[source] ~= nil
    end

    functions.getIdentifier = function()
        return PlayerData[source].identifier
    end

    functions.getCharacterIdentifier = function()
        return PlayerData[source].charIdentifier
    end

    functions.getGender = function()
        return PlayerData[source].gender
    end

    functions.getDob = function()
        return PlayerData[source].dob
    end

    functions.getGroup = function()
        return PlayerData[source].group
    end

    functions.setGroup = function(group)
        PlayerData[source].group = group
    end

    functions.getClan = function()
        return PlayerData[source].clan
    end

    functions.setClan = function(clan)
        PlayerData[source].clan = clan
    end

    functions.getFirstName = function()
        return PlayerData[source].firstname
    end

    functions.getLastName = function()
        return PlayerData[source].lastname
    end

    functions.getJob = function()
        return PlayerData[source].job
    end

    functions.setJob = function(job)
        PlayerData[source].job = job
    end

    functions.getJobGrade = function()
        return PlayerData[source].jobGrade
    end

    functions.setJobGrade = function(grade)
        PlayerData[source].jobGrade = grade
    end

    functions.getAccount = function(currency_type)

        if (PlayerData[source].account[currency_type]) then
            return tonumber(PlayerData[source].account[currency_type])
        else 
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
            return 0
        end

    end

    functions.addAccount = function(currency_type, quantity) 

        if (PlayerData[source].account[currency_type]) then
            PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] + quantity
        else
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
        end
    end

    functions.removeAccount = function(currency_type, quantity) 

        if (PlayerData[source].account[currency_type]) then

            local success = true

            if Config.NegativeValueOnAccounts then
                PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

            else
                
                if currency_type ~= 1 then -- if the account is not cents, we go through the normal transaction system.
                    PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

                    if PlayerData[source].account[currency_type] <= 0 then
                        PlayerData[source].account[currency_type] = 0
                    end


                else
                    
                    -- If quantity is less than 100 (100 = 1 dollar) and we do have the required cents.
                    if quantity < 100 and quantity <= PlayerData[source].account[1] then 

                        PlayerData[source].account[1] = PlayerData[source].account[1] - quantity -- we remove cents

                    -- if cents total cost is equals to a dollars price, we remove dollars than cents.
                    elseif PlayerData[source].account[0] == 1 * (quantity / 100) then

                        local fixedQuantity = 1 * (quantity / 100)

                        PlayerData[source].account[0] = PlayerData[source].account[0] - math.floor(fixedQuantity)

                    -- if cents total cost is more than a dollar and has dollars and cents, we remove both.
                    elseif PlayerData[source].account[0] >= 1 * (quantity / 100) and PlayerData[source].account[1] >= quantity - math.floor(1 * (quantity / 100)) * 100 then
                        local fixedQuantity  = 1 * (quantity / 100)
                        local fixedQuantity2 = quantity - math.floor(fixedQuantity) * 100
            
                        PlayerData[source].account[0] = PlayerData[source].account[0] - math.floor(fixedQuantity)
                        PlayerData[source].account[1] = PlayerData[source].account[1] - math.floor(fixedQuantity2)

                    -- if cents total cost is more than a dollar and has more dollars and no cents, we remove only dollars and we give cents that left.
                    elseif PlayerData[source].account[0] >= 1 * (quantity / 100) and PlayerData[source].account[1] < quantity - math.floor(1 * (quantity / 100)) * 100 then
                        local fixedQuantity  = 1 * (quantity / 100)
                        local fixedQuantity2 = quantity - math.floor(fixedQuantity) * 100
                        
                        PlayerData[source].account[0] = PlayerData[source].account[0] - (math.floor(fixedQuantity) + 1)
                        PlayerData[source].account[1] = PlayerData[source].account[1] + ( 100 - math.floor(fixedQuantity2) )

                    else
                        success = false
                    end

                    if PlayerData[source].account[0] <= 0 then PlayerData[source].account[0] = 0 end
                    if PlayerData[source].account[1] <= 0 then PlayerData[source].account[1] = 0 end

                end

            end

            return success

        else 
            print("Error: This currency type (" .. currency_type .. ") does not exist.")
            return false
        end
    end

    functions.getLastSavedLocation = function()
        return json.decode(PlayerData[source].coords)
    end

    functions.saveLocation = function(coords, heading)
        local _source = source

        local newCoords = nil

        if coords then

            newCoords                 = { x = coords.x, y = coords.y, z = coords.z, heading = heading }
            PlayerData[source].coords = { x = coords.x, y = coords.y, z = coords.z, heading = heading }

        else
            local playerPed           = GetPlayerPed(source)
            local _coords, _heading   = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

            newCoords             = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
            PlayerData[source].coords = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
        end

        while newCoords == nil do
            Wait(100)
        end

        SavePlayerLocationInDatabase(_source, newCoords)
    end

    functions.saveCharacter = function()
        SaveCharacter(source)
    end

    return functions
end

GetSteamID = function(source)
    local sid = GetPlayerIdentifiers(source)[1] or false

    if (sid == false or sid:sub(1, 5) ~= "steam") then

        return false
    end

    return sid
end

GetIdentity = function(source, identity)
    local num = 0
    if not source then return end
    
    local num2 = GetNumPlayerIdentifiers(source)

    if GetNumPlayerIdentifiers(source) > 0 then
        local ident = nil
        while num < num2 and not ident do
            local a = GetPlayerIdentifier(source, num)
            if string.find(a, identity) then ident = a end
            num = num + 1
        end
        --return ident;
        if ident == nil then
            return ""
        end
        return string.sub(ident, 9)
    end
end
