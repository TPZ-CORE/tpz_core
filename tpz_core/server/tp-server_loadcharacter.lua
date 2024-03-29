
RegisterServerEvent('tpz_core:requestCharacters')
AddEventHandler('tpz_core:requestCharacters', function()

    local _source = source
    local sid     = GetSteamID(_source)

    local isPlayedBefore     = false
    local isFinishedChecking = false

    exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE identifier = @identifier", { ["@identifier"] = sid }, function(result)

        isPlayedBefore     = result[1]
        isFinishedChecking = true

        while not isFinishedChecking do
            Wait(250)
        end
    
        if sid and not isPlayedBefore then
        
            print("(!) The following player ( " .. GetPlayerName(_source) .. " ) does not have any characters, we open the character creator.")
            TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, 1, {} )
        end
    
        if sid and isPlayedBefore then

            local currentChars = 0
            local charactersList = {}

            for index, results in pairs (result) do
                currentChars = currentChars + 1

                charactersList[index] = {}
                charactersList[index] = results
            end

            Wait(1000)

            TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, currentChars, charactersList)
        end

    end)

end)

RegisterServerEvent('tpz_core:onPlayerJoined')
AddEventHandler('tpz_core:onPlayerJoined', function()
    local _source = source
    local sid     = GetSteamID(_source)

    local isPlayedBefore     = false
    local isFinishedChecking = false

    print("The following player ( " .. GetPlayerName(_source) .. " ) is joining the game.")

    exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE identifier = @identifier", { ["@identifier"] = sid }, function(result)

        isPlayedBefore     = result[1]
        isFinishedChecking = true

        while not isFinishedChecking do
            Wait(250)
        end
    
        if sid and not isPlayedBefore then
        
            print("(!) The following player ( " .. GetPlayerName(_source) .. " ) does not have any characters, we open the character creator.")
            TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, 1, {} )
        end
    
        if sid and isPlayedBefore then

            local currentChars = 0
            local charactersList = {}

            for index, results in pairs (result) do
                currentChars = currentChars + 1

                charactersList[index] = {}
                charactersList[index] = results
            end

            Wait(1000)

            TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, currentChars, charactersList)
        end

    end)

end)

RegisterServerEvent('tpz_core:onSelectedCharacter')
AddEventHandler('tpz_core:onSelectedCharacter', function(tSource, charId, newChar, firstname, lastname, dob)
    local _source = tSource

    if _source == nil then
        _source = source
    end

    local sid     = GetSteamID(_source)

    local loadedCharacter = false

    if not newChar then
        exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE charidentifier = @charidentifier", { ["@charidentifier"] = tonumber(charId),
            
        }, function(result)

            while not result[1] do
                Wait(100)
            end
    
            local res = result[1]

            local decodedCoords = json.decode(res.coords)

            Character(_source, sid, charId, res.group, res.firstname,res.lastname,res.gender,res.dob,res.skin,res.skinComp,res.job,res.jobGrade,res.clan,res.money, res.cents, res.gold,res.blackmoney, res.healthOuter,res.healthInner,res.staminaOuter,res.staminaInner,decodedCoords,res.warnings,res.banned,res.bannedReason, tonumber(res.isdead)) 
    
            Wait(1000)
            loadedCharacter = true
        end)
    else

        local foundCharId = false

        exports["ghmattimysql"]:execute("SELECT charidentifier FROM characters WHERE identifier = @identifier AND firstname = @firstname AND lastname = @lastname AND dob = @dob", { ["@identifier"] = sid, ["@firstname"] = firstname, ["@lastname"] = lastname, ['@dob'] = dob }, function(result)

            while result == nil or result[1] == nil or result[1].charidentifier == nil or result[1].charidentifier == 0 do
                Wait(100)
            end

            PlayerData[_source].charIdentifier = tonumber(result[1].charidentifier)
            foundCharId = true
        end)


        while not foundCharId do
            Wait(100)
        end
        
        loadedCharacter = true
    end

    while not loadedCharacter do
        Wait(100)
    end


    local data         = PlayerData[_source]

    local lastLocation = data.coords

    if lastLocation and lastLocation.x then

        local status = { healthOuter = data.healthOuter, healthInner = data.healthInner, staminaOuter = data.staminaOuter, staminaInner = data.staminaInner }
        TriggerClientEvent("tpz_core:onPlayerFirstSpawn", _source, lastLocation, status, tonumber(data.isdead))

        if newChar then

        end
    end

end)


AddEventHandler('playerJoining', function()
    local _source = source

    if not Config.DevMode then
        TriggerClientEvent('tpz_core:playerJoining', _source)
    end
end)