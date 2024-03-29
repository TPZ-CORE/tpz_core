PlayerData = {}


function Character(source, identifier, charIdentifier, group, firstname, lastname, gender, dob, skin, skinComp, job, jobGrade, clan, money, cents, gold, blackmoney, healthOuter, healthInner, staminaOuter, staminaInner, coords, warnings, banned, bannedReason, isdead)

    PlayerData[source]            = {}
    local data                    = PlayerData[source]

    data.source                   = source

    data.identifier               = identifier
    data.charIdentifier           = charIdentifier
    data.group                    = group

    data.firstname                = firstname
    data.lastname                 = lastname

    data.gender                   = gender

    data.dob                      = dob

    data.skin                     = skin
    data.skinComp                 = skinComp

    data.job                      = job
    data.jobGrade                 = jobGrade

    data.clan                     = clan

    data.account                  = { [0] = money, [1] = cents, [2] = gold, [3] = blackmoney}
    data.healthOuter              = healthOuter
    data.healthInner              = healthInner
    data.staminaOuter             = staminaOuter
    data.staminaInner             = staminaInner

    data.coords                   = coords
    data.warnings                 = warnings
    data.banned                   = banned
    data.bannedReason             = bannedReason

    data.isdead                   = isdead
end

function CreateNewCharacter(source, firstname, lastname, gender, dob, skinData, job)
    local _source         = source
    local sid             = GetSteamID(_source)
    
    local ip              = GetPlayerEndpoint(_source)
        
    local discordIdentity = GetIdentity(_source, "discord")
    local discordId       = string.sub(discordIdentity, 9)

    local steamName       = GetPlayerName(_source)

    local randomCoords = Config.SpawnCoords[math.random(#Config.SpawnCoords)]
    local newCoords = {x = randomCoords.x, y = randomCoords.y, z = randomCoords.z, heading = randomCoords.heading}


    Character(_source, sid, nil, "user", firstname,lastname,gender,dob, skinData['model'], SkinData,job,0,0,Config.NewCharacter.Accounts[0], Config.NewCharacter.Accounts[1], Config.NewCharacter.Accounts[2], Config.NewCharacter.Accounts[3],500,100,500,100, newCoords, 0,0,'N/A',0) 


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
        ['clan']                = 0,
        ['money']               = Config.NewCharacter.Accounts[0],
        ['cents']               = Config.NewCharacter.Accounts[1],
        ['gold']                = Config.NewCharacter.Accounts[2],
        ['blackmoney']          = Config.NewCharacter.Accounts[3],
        ['healthOuter']         = 500,
        ['healthInner']         = 100,
        ['staminaOuter']        = 500,
        ['staminaInner']        = 100,
        ['coords']              = json.encode(newCoords),
        ['warnings']            = 0,
        ['banned']              = 0,
        ['bannedReason']        = 'N/A',
        ['isdead']              = 0,
    }

    Citizen.CreateThread(function()
    
        exports.ghmattimysql:execute("INSERT INTO characters (`identifier`, `steamname`, `group`, `firstname`, `lastname`, `gender`, `dob`, `skin`, `skinComp`, `job`, `jobGrade`, `clan`,`money`, `cents`, `gold`, `blackmoney`, `healthOuter`, `healthInner`, `staminaOuter`, `staminaInner`, `coords`, `warnings`, `banned`, `bannedReason`, `isdead`) VALUES (@identifier, @steamname, @group, @firstname, @lastname, @gender, @dob, @skin, @skinComp, @job, @jobGrade, @clan, @money, @cents, @gold, @blackmoney, @healthOuter, @healthInner, @staminaOuter, @staminaInner, @coords, @warnings, @banned, @bannedReason, @isdead)", Parameters)
        TriggerEvent('tpz_core:onSelectedCharacter', _source, nil, true, firstname, lastname, dob)

        print("(!) The following player ( ".. steamName .. " ) created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }")

        local webhookData = Config.DiscordWebhooking.URL['CREATE_NEW_CHARACTER']

        if webhookData.enabled then
            local title   = "📋` New Character Created` "
            local message = "**Steam name: **`" .. steamName .. "`**\nSteam Identifier**`" .. tostring(sid) .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `The following player created a character with the following information: { firstname: " .. firstname .. ", lastname: " .. lastname .. ", dob: " .. dob .. " }`"
            TriggerEvent("tpz_core:sendToDiscord", webhookData.url, title, message, webhookData.color)
        end

    end)

end

function SaveCharacter(_source, cb)

    local data = PlayerData[_source]

    if data then

        local Parameters = { 
            ['identifier']         = data.identifier,
            ['charidentifier']     = tonumber(data.charIdentifier),
            ['group']              = data.group, 
            ['job']                = data.job, 
            ['jobGrade']           = tonumber(data.jobGrade), 
             
            ['clan']               = tonumber(data.clan), 
            ['money']              = tonumber(data.account[0]),
            ['cents']              = tonumber(data.account[1]),
            ['gold']               = tonumber(data.account[2]),
            ['blackmoney']         = tonumber(data.account[3]),
            ['coords']             = json.encode(data.coords),
        }
    
        Citizen.CreateThread(function()
            exports.ghmattimysql:execute("UPDATE `characters` SET `group` = @group, `job` = @job, `jobGrade` = @jobGrade, `clan` = @clan, `money` = @money, `cents` = @cents, `gold` = @gold, `blackmoney` = @blackmoney, `coords` = @coords WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
        end)

        if cb then
            PlayerData[_source] = nil
        end

    end

end

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