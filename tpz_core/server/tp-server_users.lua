-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local function convertSecondsToText(seconds)
    local secondsInMinute = 60
    local secondsInHour   = 60 * secondsInMinute
    local secondsInDay    = 24 * secondsInHour
    local secondsInMonth  = 30 * secondsInDay  -- Assuming 30-day months

    local months          = math.floor(seconds / secondsInMonth)
    local days            = math.floor((seconds % secondsInMonth) / secondsInDay)
    local hours           = math.floor((seconds % secondsInDay) / secondsInHour)
    local mins            = math.floor((seconds % secondsInHour) / secondsInMinute)

    local parts = {}

    if months > 0 then
        table.insert(parts, months .. " " .. (months ~= 1 and Locales['MONTHS'] or Locales['MONTH']))
    end

    if days > 0 then
        table.insert(parts, days .. " " .. (days ~= 1 and Locales['DAYS'] or Locales['DAY']))
    end

    if hours > 0 then
        table.insert(parts, hours .. " " .. (hours ~= 1 and Locales['HOURS'] or Locales['HOUR']))
    end

    if mins > 0 then
        table.insert(parts, mins .. " " .. (mins ~= 1 and Locales['MINUTES'] or Locales['MINUTE']))
    end

    return table.concat(parts, " " .. Locales['AND'] .. " ")
end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

GetUserData = function(source)
	local _source = source
    local identifier = GetSteamID(_source)

    local data, wait  = nil, true
    
	exports["ghmattimysql"]:execute("SELECT * FROM `users` WHERE `identifier` = @identifier", { ["@identifier"] = identifier }, function(result)
        data = result
        wait = false
    end)

    while wait do
        Wait(50)
    end

    return data

end

BanPlayerBySource = function(target, returnedValue, duration)
    target           = tonumber(target)
    local identifier = GetSteamID(target)

	if duration == nil or tonumber(duration) == nil then
		duration = -1
    else
        duration = os.time() + (duration)
    end

	local Parameters = {
		['identifier']      = identifier,
		['banned_until']    = duration,
		['banned_reason']   = returnedValue,
	}

	exports.ghmattimysql:execute("UPDATE `users` SET `banned_until` = @banned_until, `banned_reason` = @banned_reason WHERE `identifier` = @identifier", Parameters )

	local reason = string.format(Locales['BAN_REASON'], returnedValue) -- permanent
	DropPlayer(target, reason)
end

BanPlayerBySteamIdentifier = function(steamIdentifier, returnedValue, duration)

    exports["ghmattimysql"]:execute("SELECT * FROM `users` WHERE `identifier` = @identifier", { ["@identifier"] = steamIdentifier }, function(result)

        if result and result[1] then 

            if duration == nil or tonumber(duration) == nil then
                duration = -1
            else
                duration = os.time() + (duration)
            end
        
            local Parameters = {
                ['identifier']      = steamIdentifier,
                ['banned_until']    = duration,
                ['banned_reason']   = returnedValue,
            }
        
            exports.ghmattimysql:execute("UPDATE `users` SET `banned_until` = @banned_until, `banned_reason` = @banned_reason WHERE `identifier` = @identifier", Parameters )
    
        else
            print(string.format('Attempt to ban an unknown steam hex identifier: %s', steamIdentifier))
        end

    end)

end

ResetBanBySteamIdentifier = function(steamIdentifier)

    exports["ghmattimysql"]:execute("SELECT * FROM `users` WHERE `identifier` = @identifier", { ["@identifier"] = steamIdentifier }, function(result)

        if result and result[1] then 
            
            local Parameters = {
                ['identifier']      = steamIdentifier,
                ['banned_until']    = 0,
                ['banned_reason']   = 'N/A',
                ['warnings']        = 0,
            }
        
            exports.ghmattimysql:execute("UPDATE `users` SET `banned_until` = @banned_until, `banned_reason` = @banned_reason, `warnings` = @warnings WHERE `identifier` = @identifier", Parameters )
            
        else
            print(string.format('Attempt to un-ban an unknown steam hex identifier: %s', steamIdentifier))
        end

    end)

end


AddPlayerWarning = function(target)

    target                = tonumber(target)
    local identifier      = GetSteamID(target)
	local targetSteamName = GetPlayerName(target)

	exports.ghmattimysql:execute("UPDATE `users` SET `warnings` = warnings + 1 WHERE `identifier` = @identifier", { ['identifier'] = identifier } )

    Wait(1000) -- mandatory wait!

    local TargetUserData = GetUserData(target)
    local isBanned = false

	if TargetUserData.warnings >= Config.MaxPlayerWarnings then
	  
	  print("The following player: " .. targetSteamName .. " with the identifier: " .. identifier .. " has been permanently banned by reaching the maximum warnings.")
	  BanPlayerBySource(target, Locales['BAN_REASON_REACHED_MAXIMUM_WARNINGS_DESCRIPTION'])

	  isBanned = true
	end

	return isBanned

end

ClearPlayerWarnings = function(target)
    target = tonumber(target)
    local identifier = GetSteamID(target)

	exports.ghmattimysql:execute("UPDATE `users` SET `warnings` = 0 WHERE `identifier` = @identifier", { ['identifier'] = identifier } )
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler("playerConnecting", function (name, kick, deferrals)
    local _source = source
    local steamName
    local steamIdentifier

    deferrals.defer()

    -- mandatory wait!
    Wait(0)
    steamIdentifier = GetSteamID(_source)
    steamName       = GetPlayerName(_source)
    -- mandatory wait!
    Wait(0)

    if steamIdentifier then

        exports.ghmattimysql:execute('SELECT `banned_until`, `banned_reason` FROM `users` WHERE `identifier` = @identifier', { ['@identifier'] = steamIdentifier
        }, function(result)

            if (not result) or (result and not result[1]) then
				local Parameters = { ['identifier'] = steamIdentifier, ['steamname']  = GetPlayerName(_source) }
				exports.ghmattimysql:execute("INSERT INTO `users` (`identifier`, `steamname`) VALUES (@identifier, @steamname)", Parameters)

                -- Not banned
				deferrals.done()
            else

                if result[1].banned_until ~= -1 and result[1].banned_until <= os.time() then
                    exports.ghmattimysql:execute("UPDATE `users` SET `banned_until` = 0 WHERE `banned_until` = @identifier", { ['identifier'] = steamIdentifier } )
                end

                if result[1] and result[1].banned_until ~= 0 then
                    -- Still banned
                    local remaining = result[1].banned_until - os.time()

                    local reason = string.format(Locales['BAN_REASON_DESCRIPTION'], result[1].banned_reason) -- permanent

    				if result[1].banned_until ~= -1 then
                    
                        local durationDisplay = convertSecondsToText(remaining)
    					reason = string.format(Locales['BAN_REASON_DURATION_DESCRIPTION'], result[1].banned_reason, durationDisplay) -- permanent
    				end

                    print(string.format("^1Joining the server has been declined for the player ( %s ). Reason: Banned for %s^0", steamName, result[1].banned_reason .. "."))
    				deferrals.done(reason)
                    return
                else
                    -- Not banned
    				deferrals.done()
                end
            end

        end)

    end

end)
