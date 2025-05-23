-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local function convertMinutesToText(minutes)
    local minutesInDay = 24 * 60
    local minutesInMonth = 30 * minutesInDay

    local months = math.floor(minutes / minutesInMonth)
    local days = math.floor((minutes % minutesInMonth) / minutesInDay)
    local hours = math.floor((minutes % minutesInDay) / 60)
    local mins = minutes % 60

    local parts = {}

    if months > 0 then
        table.insert(parts, months .. " " .. Locales['MONTHS'])
    end

    if days > 0 then
        table.insert(parts, days .. " " .. Locales['DAYS'])
    end

    if hours > 0 then
        table.insert(parts, hours .. " " .. Locales['HOURS'])
    end

    if mins > 0 or #parts == 0 then
        table.insert(parts, mins .. " " .. Locales['MINUTES'])
    end

    return table.concat(parts, " " .. Locales['AND'] .. " ")
end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

GetUserData = function(source)
	local _source     = source
	local xPlayer     = PlayerData[_source]

	local identifier  = xPlayer.identifier
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
	end

	local Parameters = {
		['identifier']      = identifier,
		['banned_duration'] = duration,
		['banned_reason']   = returnedValue,
	}

	exports.ghmattimysql:execute("UPDATE `users` SET `banned_duration` = @banned_duration, `banned_reason` = @banned_reason WHERE `identifier` = @identifier", Parameters )

	local reason = string.format(Locales['BAN_REASON_DESCRIPTION'], returnedValue) -- permanent

	if duration ~= -1 then
		reason = string.format(Locales['BAN_REASON_DURATION_DESCRIPTION'], returnedValue, duration) -- duration banned.
	end

	DropPlayer(target, returnedValue)
end

BanPlayerBySteamIdentifier = function(steamIdentifier, returnedValue, duration)

    exports["ghmattimysql"]:execute("SELECT * FROM `users` WHERE `identifier` = @identifier", { ["@identifier"] = steamIdentifier }, function(result)

        if result and result[1] then 

            if duration == nil or tonumber(duration) == nil then
                duration = -1
            end
        
            local Parameters = {
                ['identifier']      = steamIdentifier,
                ['banned_duration'] = duration,
                ['banned_reason']   = returnedValue,
            }
        
            exports.ghmattimysql:execute("UPDATE `users` SET `banned_duration` = @banned_duration, `banned_reason` = @banned_reason WHERE `identifier` = @identifier", Parameters )
    
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
                ['banned_duration'] = 0,
                ['banned_reason']   = 'N/A',
                ['warnings']        = 0,
            }
        
            exports.ghmattimysql:execute("UPDATE `users` SET `banned_duration` = @banned_duration, `banned_reason` = @banned_reason, `warnings` = @warnings WHERE `identifier` = @identifier", Parameters )
            
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
    local steamIdentifier

    deferrals.defer()

    -- mandatory wait!
    Wait(0)
    steamIdentifier = GetSteamID(_source)
    -- mandatory wait!
    Wait(0)

    if steamIdentifier then

		exports["ghmattimysql"]:execute("SELECT * FROM `users` WHERE `identifier` = @identifier", { ["@identifier"] = steamIdentifier }, function(result)
	
			if (not result) or (result and not result[1]) then
				local Parameters = { ['identifier'] = steamIdentifier, ['steamname']  = GetPlayerName(_source) }
				exports.ghmattimysql:execute("INSERT INTO `users` (`identifier`, `steamname`) VALUES (@identifier, @steamname)", Parameters)
			end

			if result[1] and result[1].banned_duration ~= 0 then

				local reason = string.format(Locales['BAN_REASON_DESCRIPTION'], result[1].banned_reason) -- permanent

				if result[1].banned_duration ~= -1 then
                    
                    local durationDisplay = convertMinutesToText(result[1].banned_duration)
					reason = string.format(Locales['BAN_REASON_DURATION_DESCRIPTION'], result[1].banned_reason, durationDisplay) -- permanent
				end

				deferrals.done(reason)
				return
			else
				deferrals.done()
			end

		end)

    end

end)

