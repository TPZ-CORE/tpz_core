local CURRENT_START_TIME = os.time()
local allowedToJoin = true

-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format(Locales['STEAM_CHECKING_JOIN'], name))

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    -- mandatory wait!
    Wait(0)

    if not steamIdentifier then
        deferrals.done(Locales['NOT_CONNECTED_STEAM'])
        return
    end

    if ( name:find("/") or name:find("https") or name:find("script") or name:find("<") or name:find(">") ) then
        deferrals.done(Locales['NOT_ALLOWED_TO_JOIN_STEAM_NAME_REASON'])
        return
    end

    if Config.PreventPlayersJoiningDelay.Enabled then
        local currentJoinTime = os.time()

        if (currentJoinTime - CURRENT_START_TIME) < (Config.PreventPlayersJoiningDelay.Delay) then

            local secondsLeft = (Config.PreventPlayersJoiningDelay.Delay) - (currentJoinTime - CURRENT_START_TIME )
            deferrals.done(string.format(Config.PreventPlayersJoiningDelay.DeferNotify, secondsLeft))
            return
        end

    end

    deferrals.done()
end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    local webhookData = Config.DiscordWebhooking.URL['SERVER_STARTUP']

    if webhookData.Enabled then
        local title   = webhookData.title
        local message = webhookData.message
        SendToDiscordWebhook(webhookData.Url, title, message, webhookData.Color)
    end

end)

AddEventHandler("playerConnecting", OnPlayerConnecting)

-- Saving player data when dropped.
AddEventHandler('playerDropped', function (reason)
    local _source = source
    SaveCharacter(_source, true)
end)

-----------------------------------------------------------
--[[ Server Restart  ]]--
-----------------------------------------------------------

if Config.RestartManagement.Enabled then

    Citizen.CreateThread(function()
        while true do
            Wait(60000)

            local finished    = false

            local time        = os.date("*t") 
            local currentTime = table.concat({time.hour, time.min}, ":")
    
            for index, blockedTime in pairs (Config.RestartManagement.BlockedJoiningTime) do

                if currentTime == blockedTime then
                    allowedToJoin = false
                end

                if next(Config.RestartManagement.BlockedJoiningTime, index) == nil then
                    finished = true
                end
            end

            while not finished do
                Wait(500)
            end
    
            if not allowedToJoin then

                for _index, kickTime in pairs (Config.RestartManagement.KickPlayersTime) do

                    if currentTime == kickTime then
    
                        local xPlayers = GetPlayers()
        
                        for i=1, #xPlayers, 1 do
            
                            Wait(100)
                            DropPlayer(xPlayers[i], Config.RestartManagement.KickWarning)
            
                        end

                    end
        
                end

            end

        end
    
    end)

    AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
        deferrals.defer()
        
        local s, joined = source, false
        
        Wait(100)
        
        if allowedToJoin then
            deferrals.done()
            joined = true 
        end
                
        Wait(1)
    
        if joined then return end
        deferrals.done(Config.RestartManagement.ConnectWarning)
    end)

end

Citizen.CreateThread(function()

    while true do
        Wait(60000 * Config.SavePlayerData)

        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] then
                SaveCharacter(_source, false)
            end

        end

    end

end)

-----------------------------------------------------------
--[[ Player Data Callback  ]]--
-----------------------------------------------------------

addNewCallBack("tpz_core:getPlayerData", function(source, cb, data)
    local _source = source

    if data and data.source ~= nil then
        _source = tonumber(data.source)
    end

    if PlayerData[_source] == nil then 
        return cb(nil)
    end

    local xPlayer = PlayerData[_source]

    return cb(
        { 
            source          = tonumber(_source),
            identifier      = xPlayer.identifier,
            charIdentifier  = tonumber(xPlayer.charIdentifier),
            money           = tonumber(xPlayer.account[0]), 
            gold            = tonumber(xPlayer.account[1]), 
            blackmoney      = tonumber(xPlayer.account[2]),
            firstname       = xPlayer.firstname,
            lastname        = xPlayer.lastname,
            gender          = xPlayer.gender,
            dob             = xPlayer.dob,
            job             = xPlayer.job,
            jobGrade        = xPlayer.jobGrade,
            identityId      = xPlayer.identity_id,
            defaultWeapon   = xPlayer.default_weapon,
            inventoryMaxWeight = xPlayer.inventory_capacity,
        } 
    ) 
end)    

