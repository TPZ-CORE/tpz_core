local allowedToJoin = true

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    local webhookData = Config.DiscordWebhooking.URL['SERVER_STARTUP']

    if webhookData.enabled then
        local title   = webhookData.title
        local message = webhookData.message

        TriggerEvent("tpz_core:sendToDiscord", webhookData.url, title, message, webhookData.color)
    end

end)

AddEventHandler("playerConnecting", function (name, kick, defer)
    defer.defer()
    if ( name:find("/") or name:find("https") or name:find("script") or name:find("<") or name:find(">") ) then
        defer.done(Locales['NOT_ALLOWED_TO_JOIN_STEAM_NAME_REASON'])
        return
    end
    defer.done()
end)


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

-----------------------------------------------------------
--[[ Player Data Callback  ]]--
-----------------------------------------------------------

addNewCallBack("tpz_core:getPlayerData", function(source, cb)
    local _source = source

    if PlayerData[source] == nil then 
        return cb(nil)
    end

    local xPlayer = PlayerData[source]

    return cb(
        { 
            source          = tonumber(_source),
            identifier      = xPlayer.identifier,
            charIdentifier  = tonumber(xPlayer.charIdentifier),
            money           = tonumber(xPlayer.account[0]), 
            cents           = tonumber(xPlayer.account[1]), 
            gold            = tonumber(xPlayer.account[2]), 
            blackmoney      = tonumber(xPlayer.account[3]),
            firstname       = xPlayer.firstname,
            lastname        = xPlayer.lastname,
            gender          = xPlayer.gender,
            dob             = xPlayer.dob,
            job             = xPlayer.job,
            jobGrade        = xPlayer.jobGrade,
        } 
    ) 
end)    

