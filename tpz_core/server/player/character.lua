PlayerData = {}
local CharacterCreationLocks = {}
local LocationSaveTimers = {}

local function isValidCharacterText(value, maxLength)
    return type(value) == 'string' and #value > 0 and #value <= maxLength and not value:find('[%c<>]')
end

local function isValidCoords(coords)
    if type(coords) ~= 'table' then return false end
    local x, y, z, heading = tonumber(coords.x), tonumber(coords.y), tonumber(coords.z), tonumber(coords.heading)
    if not x or not y or not z or not heading or x ~= x or y ~= y or z ~= z or heading ~= heading then return false end
    return math.abs(x) <= 10000 and math.abs(y) <= 10000 and math.abs(z) <= 2000 and math.abs(heading) <= 360
end

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

function CreateNewCharacter(source, firstname, lastname, gender, dob, skinData, encodedSkin)
    local _source         = source
    local sid             = GetSteamID(_source)
    
    local ip              = GetPlayerEndpoint(_source)
        
    local discordIdentity = GetIdentity(_source, "discord")
    local discordId       = string.sub(discordIdentity, 9)

    local steamName       = GetPlayerName(_source)

    local randomCoords = Config.NewCharacter.FirstSpawnCoords[math.random(#Config.NewCharacter.FirstSpawnCoords)]
    local newCoords = {x = randomCoords.x, y = randomCoords.y, z = randomCoords.z, heading = randomCoords.heading}

    local generatedIdentityId = ""

    for i = 1, Config.IdentityIdGeneratedData.numbers do 
        local randomIdentityNumber = math.random(0, 9)
        generatedIdentityId = tostring(generatedIdentityId) .. tostring(randomIdentityNumber)
    end

    generatedIdentityId = Config.IdentityIdGeneratedData.first_letters .. os.date('%M') .. os.date('%S') .. generatedIdentityId

    local accounts = json.encode( { 
        cash        = Config.NewCharacter.Accounts[0], 
        gold        = Config.NewCharacter.Accounts[1], 
        black_money = Config.NewCharacter.Accounts[2] 
    })

    local defaultInventoryCapacity = exports["tpz_inventory"].getInventoryAPI().getConfig().InventoryDefaultWeight

    Character(_source, sid, nil, "user", firstname,lastname,gender,dob, skinData, 'unemployed', 0, accounts, generatedIdentityId, 500,100,500,100, newCoords, 0, "0", defaultInventoryCapacity)

    local Parameters = {
        ['identifier']          = tostring(sid),
        ['steamname']           = steamName,
        ['group']               = "user",
        ['firstname']           = firstname,
        ['lastname']            = lastname,
        ['gender']              = gender,
        ['dob']                 = dob,
        ['skinComp']            = encodedSkin or json.encode(skinData),
        ['job']                 = 'unemployed',
        ['jobGrade']            = 0,

        ['accounts']            = accounts,

        ['identity_id']         = generatedIdentityId,
        ['healthOuter']         = 500,
        ['healthInner']         = 100,
        ['staminaOuter']        = 500,
        ['staminaInner']        = 100,
        ['coords']              = json.encode(newCoords),
        ['isdead']              = 0,
        ['inventory_capacity']  = defaultInventoryCapacity,
    }
    
    PlayerData[_source].skinComp = encodedSkin or json.encode(skinData)
    
    Citizen.CreateThread(function()

        exports.ghmattimysql:execute("INSERT INTO characters (`identifier`, `steamname`, `group`, `firstname`, `lastname`, `gender`, `dob`, `skinComp`, `job`, `jobGrade`,`accounts`, `identity_id`, `healthOuter`, `healthInner`, `staminaOuter`, `staminaInner`, `coords`, `isdead`, `inventory_capacity` ) VALUES (@identifier, @steamname, @group, @firstname, @lastname, @gender, @dob, @skinComp, @job, @jobGrade, @accounts, @identity_id, @healthOuter, @healthInner, @staminaOuter, @staminaInner, @coords, @isdead, @inventory_capacity)", Parameters)
        
        Wait(2000)

        onSelectedCharacter(_source, nil, true, firstname, lastname, dob)

        print("(!) The following player ( ".. steamName .. " ) created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }")

        local webhookData = Config.DiscordWebhooking.URL['CREATE_NEW_CHARACTER']

        if webhookData.Enabled then
            local title   = "📋` New Character Created` "
            local message = "**Steam name: **`" .. steamName .. "`**\nSteam Identifier**`" .. tostring(sid) .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `The following player created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }`"
            SendToDiscordWebhook(GetWebhookUrlByName("tpz_core", "CREATE_NEW_CHARACTER"), title, message, webhookData.Color)
        end

    end)

end

function Character(source, identifier, charIdentifier, group, firstname, lastname, gender, dob, skinComp, job, jobGrade, accounts, identityId, healthOuter, healthInner, staminaOuter, staminaInner, coords, isdead, default_weapon, inventoryCapacity)
  
    local decodedAccounts = json.decode(accounts) -- accounts returns the result.accounts from `characters` table.

    PlayerData[source] = {
        source             = tonumber(source),
        identifier         = identifier,
        charIdentifier     = tonumber(charIdentifier),
        group              = group,
        firstname          = firstname,
        lastname           = lastname,
        gender             = gender,
        dob                = dob,
        skinComp           = skinComp,
        job                = job,
        jobGrade           = tonumber(jobGrade),

        account = { 
            [0] = decodedAccounts.cash, 
            [1] = decodedAccounts.gold, 
            [2] = decodedAccounts.black_money 
        },

        identity_id        = identityId,
        healthOuter        = tonumber(healthOuter),
        healthInner        = tonumber(healthInner),
        staminaOuter       = tonumber(staminaOuter),
        staminaInner       = tonumber(staminaInner),
        coords             = coords,
        isdead             = tonumber(isdead),
        default_weapon     = default_weapon,
        inventory_capacity = inventoryCapacity,
        connection_lost    = 0,
    }

end

function SaveCharacter(_source, cb)

    local data = PlayerData[_source]

    if data then

        local Parameters = { 
            ['identifier']         = data.identifier,
            ['charidentifier']     = tonumber(data.charIdentifier),

            ['firstname']          = data.firstname, 
            ['lastname']           = data.lastname, 

            ['dob']                = data.dob, 

            ['group']              = data.group, 
            ['job']                = data.job, 
            ['jobGrade']           = tonumber(data.jobGrade), 
            ['accounts']           = json.encode( { cash = data.account[0], gold = data.account[1], black_money = data.account[2] }),
            ['coords']             = json.encode(data.coords),

            ['identity_id']        = data.identity_id,
            ['default_weapon']     = data.default_weapon,
            ['inventory_capacity'] = data.inventory_capacity,
        }
    
        Citizen.CreateThread(function()
            exports.ghmattimysql:execute("UPDATE `characters` SET `firstname` = @firstname, `lastname` = @lastname, `dob` = @dob, `group` = @group, `job` = @job, `jobGrade` = @jobGrade, `accounts` = @accounts, `coords` = @coords, `identity_id` = @identity_id, `default_weapon` = @default_weapon, `inventory_capacity` = @inventory_capacity WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
        end)

        if cb then
            PlayerData[_source] = nil
        end

    end

end

function SavePlayerLocationInDatabase(source, coords)

    local data = PlayerData[source]

    if data then

        data.coords = coords

        local Parameters = { 
            ['identifier'] = data.identifier,
            ['charidentifier'] = data.charIdentifier,
            ['coords'] = json.encode(coords),
        }
    
        Citizen.CreateThread(function()
            exports.ghmattimysql:execute("UPDATE `characters` SET `coords` = @coords WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
        end)

    end    
end


-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_core:createNewCharacter')
AddEventHandler('tpz_core:createNewCharacter', function(firstname, lastname, gender, dob, skin)
    local _source = source
    if CharacterCreationLocks[_source] or PlayerData[_source] then return end
    local validSkin, encodedSkin = pcall(json.encode, skin)
    if not isValidCharacterText(firstname, 32) or not isValidCharacterText(lastname, 32)
        or not isValidCharacterText(gender, 16) or not isValidCharacterText(dob, 16)
        or not validSkin or #encodedSkin > 65535 then
        if Config.Debug then
            print(("[tpz_core] Blocked invalid character creation payload from %s"):format(_source))
        end
        return
    end

    CharacterCreationLocks[_source] = true
    local identifier = GetSteamID(_source)
    exports["ghmattimysql"]:execute([[SELECT u.max_chars, COUNT(c.charidentifier) AS character_count
        FROM users u LEFT JOIN characters c ON c.identifier = u.identifier
        WHERE u.identifier = @identifier GROUP BY u.max_chars]], { ['@identifier'] = identifier }, function(result)
        CharacterCreationLocks[_source] = nil
        local row = result and result[1]
        local maxCharacters = row and tonumber(row.max_chars)
        local characterCount = row and tonumber(row.character_count)
        if not maxCharacters or not characterCount or characterCount >= maxCharacters then
            if Config.Debug then
                print(("[tpz_core] Blocked character-limit bypass attempt from %s"):format(_source))
            end
            return
        end
        CreateNewCharacter(_source, firstname, lastname, gender, dob, skin, encodedSkin)
    end)
end)

RegisterServerEvent('tpz_core:savePlayerCurrentLocation')
AddEventHandler('tpz_core:savePlayerCurrentLocation', function(coords)
    local _source = source
    if not PlayerData[_source] or not isValidCoords(coords) then return end

    local now = GetGameTimer()
    if LocationSaveTimers[_source] and now - LocationSaveTimers[_source] < 5000 then return end
    LocationSaveTimers[_source] = now

    local serverCoords = GetEntityCoords(GetPlayerPed(_source))
    local requestedCoords = vector3(coords.x, coords.y, coords.z)
    if #(serverCoords - requestedCoords) > 250.0 then
        if Config.Debug then
            print(("[tpz_core] Blocked invalid location save from %s"):format(_source))
        end
        return
    end
    SavePlayerLocationInDatabase(_source, { x = coords.x, y = coords.y, z = coords.z, heading = coords.heading })
end)

AddEventHandler('playerDropped', function()
    CharacterCreationLocks[source] = nil
    LocationSaveTimers[source] = nil
end)

RegisterServerEvent('tpz_core:saveCharacter')
AddEventHandler('tpz_core:saveCharacter', function()
    local _source = source
    SaveCharacter(_source, false)
end)

RegisterServerEvent('tpz_core:savePlayerDeathStatus')
AddEventHandler('tpz_core:savePlayerDeathStatus', function(cb)
    local _source = source
    local data    = PlayerData[_source]
    if not data or (cb ~= 0 and cb ~= 1) then return end
    data.isdead = cb

    local Parameters = { 
        ['identifier']     = data.identifier,
        ['charidentifier'] = data.charIdentifier,
        ['isdead']         = tonumber(cb),
    }

    Citizen.CreateThread(function()
        exports.ghmattimysql:execute("UPDATE `characters` SET `isdead` = @isdead WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
    end)


end)



