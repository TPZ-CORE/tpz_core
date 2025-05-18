-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('playerJoining', function()
    local _source = source

    if Config.DevMode then
        return
    end

    TriggerClientEvent('tpz_core:playerJoining', _source)
end)

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

onSelectedCharacter = function(tSource, charId, newChar, firstname, lastname, dob)
    local _source = tSource

    if _source == nil then 
        _source = source
    end

    local sid = GetSteamID(_source)

    if not newChar then
        exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE charidentifier = @charidentifier", { ["@charidentifier"] = tonumber(charId),
            
        }, function(result)

            while not result[1] do
                Wait(10)
            end
    
            local res = result[1]

            local decodedCoords = json.decode(res.coords)

            Character(_source, sid, charId, res.group, res.firstname,res.lastname,res.gender,res.dob,res.skin,res.skinComp,res.job,res.jobGrade, res.accounts, res.identity_id, res.healthOuter,res.healthInner,res.staminaOuter,res.staminaInner,decodedCoords, tonumber(res.isdead), tostring(res.default_weapon)) 
            Wait(1000)

            local data         = PlayerData[_source]
            local lastLocation = data.coords
        
            if lastLocation and lastLocation.x then
        
                local status = { healthOuter = data.healthOuter, healthInner = data.healthInner, staminaOuter = data.staminaOuter, staminaInner = data.staminaInner }
                TriggerClientEvent("tpz_core:onPlayerFirstSpawn", _source, lastLocation, status, tonumber(data.isdead), 0)
                TriggerEvent('tpz_core:isPlayerReady', _source, 0)
            end

        end)

    else

        exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE identifier = @identifier AND firstname = @firstname AND lastname = @lastname AND dob = @dob", { 
            ["@identifier"] = sid, ["@firstname"] = firstname, ["@lastname"] = lastname, ['@dob'] = dob 
        }, function(result)
    
            PlayerData[_source].charIdentifier = tonumber(result[1].charidentifier)
      
            local data         = PlayerData[_source]
            local lastLocation = data.coords
        
            if lastLocation and lastLocation.x then
        
                local status = { healthOuter = data.healthOuter, healthInner = data.healthInner, staminaOuter = data.staminaOuter, staminaInner = data.staminaInner }
                TriggerClientEvent("tpz_core:onPlayerFirstSpawn", _source, lastLocation, status, tonumber(data.isdead), 1)
                TriggerEvent('tpz_core:isPlayerReady', _source, 1)
            end
    
        end)

    end

end

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_core:requestCharacters')
AddEventHandler('tpz_core:requestCharacters', function(refresh)

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

            if not refresh then -- If player joined, we load the character selection properly.
                
                TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, currentChars, charactersList)
       
            else -- If a new player has been created or deleted, we refresh the data on character selector.
                TriggerClientEvent("tpz_characters:refreshCharacterSelection", _source, currentChars, charactersList)
            end

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
            TriggerClientEvent("tpz_characters:loadCharacterSelection", _source, 0, {} )
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
    onSelectedCharacter(tSource, charId, newChar, firstname, lastname, dob)
end)
