PlayerData = {}

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

function CreateNewCharacter(source, firstname, lastname, gender, dob, skinData, job)
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

    Character(_source, sid, nil, "user", firstname,lastname,gender,dob, skinData['model'], SkinData, job, 0, accounts, generatedIdentityId, 500,100,500,100, newCoords, 0, "0", defaultInventoryCapacity)

    local Parameters = {
        ['identifier']          = tostring(sid),
        ['steamname']           = steamName,
        ['group']               = "user",
        ['firstname']           = firstname,
        ['lastname']            = lastname,
        ['gender']              = gender,
        ['dob']                 = dob,
        ['skin']                = skinData['model'],
        ['skinComp']            = json.encode(skinData),
        ['job']                 = job,
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

    Citizen.CreateThread(function()
    
        exports.ghmattimysql:execute("INSERT INTO characters (`identifier`, `steamname`, `group`, `firstname`, `lastname`, `gender`, `dob`, `skin`, `skinComp`, `job`, `jobGrade`,`accounts`, `identity_id`, `healthOuter`, `healthInner`, `staminaOuter`, `staminaInner`, `coords`, `isdead`, `inventory_capacity` ) VALUES (@identifier, @steamname, @group, @firstname, @lastname, @gender, @dob, @skin, @skinComp, @job, @jobGrade, @accounts, @identity_id, @healthOuter, @healthInner, @staminaOuter, @staminaInner, @coords, @isdead, @inventory_capacity)", Parameters)
        
        Wait(2000)

        onSelectedCharacter(_source, nil, true, firstname, lastname, dob)

        print("(!) The following player ( ".. steamName .. " ) created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }")

        local webhookData = Config.DiscordWebhooking.URL['CREATE_NEW_CHARACTER']

        if webhookData.Enabled then
            local title   = "📋` New Character Created` "
            local message = "**Steam name: **`" .. steamName .. "`**\nSteam Identifier**`" .. tostring(sid) .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `The following player created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }`"
            SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
        end

    end)

end

function Character(source, identifier, charIdentifier, group, firstname, lastname, gender, dob, skin, skinComp, job, jobGrade, accounts, identityId, healthOuter, healthInner, staminaOuter, staminaInner, coords, isdead, default_weapon, inventoryCapacity)

    PlayerData[source]            = {}

    local data                    = PlayerData[source]

    data.source                   = tonumber(source)

    data.identifier               = identifier
    data.charIdentifier           = tonumber(charIdentifier)
    data.group                    = group

    data.firstname                = firstname
    data.lastname                 = lastname

    data.gender                   = gender

    data.dob                      = dob

    data.skin                     = skin
    data.skinComp                 = skinComp

    data.job                      = job
    data.jobGrade                 = tonumber(jobGrade)

    local decodedAccounts         = json.decode(accounts) -- accounts returns the result.accounts from `characters` table.

    data.account                  = { 
        [0] = decodedAccounts.cash, 
        [1] = decodedAccounts.gold, 
        [2] = decodedAccounts.black_money 
    }

    data.identity_id              = identityId

    data.healthOuter              = tonumber(healthOuter)
    data.healthInner              = tonumber(healthInner)
    data.staminaOuter             = tonumber(staminaOuter)
    data.staminaInner             = tonumber(staminaInner)

    data.coords                   = coords
    data.isdead                   = tonumber(isdead)

    data.default_weapon           = default_weapon
    data.inventory_capacity       = inventoryCapacity
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
AddEventHandler('tpz_core:createNewCharacter', function(firstname, lastname, gender, dob, skin, job)
    local _source   = source
    local _skinData = skin

    CreateNewCharacter(_source, firstname, lastname, gender, dob, _skinData, job)
end)

RegisterServerEvent('tpz_core:savePlayerCurrentLocation')
AddEventHandler('tpz_core:savePlayerCurrentLocation', function(coords)
    local _source = source

    SavePlayerLocationInDatabase(_source, coords)
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

    local Parameters = { 
        ['identifier']     = data.identifier,
        ['charidentifier'] = data.charIdentifier,
        ['isdead']         = tonumber(cb),
    }

    Citizen.CreateThread(function()
        exports.ghmattimysql:execute("UPDATE `characters` SET `isdead` = @isdead WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
    end)

end)