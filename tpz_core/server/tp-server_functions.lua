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


SendToDiscordWebhook = function(webhook, name, description, color)
    local data = Config.DiscordWebhooking

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = color or 15105570,
                ["author"] = {
                    ["name"] = data.Label,
                    ["icon_url"] = data.ImageUrl,
                },
                ["title"] = name,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = data.Footer .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = data.ImageUrl,

                },
            },

        },
        avatar_url = data.ImageUrl
    }), {
        ['Content-Type'] = 'application/json'
    })
end

SendImageUrlToDiscordWebhook = function(webhook, name, description, url, color)
    local data = Config.DiscordWebhooking

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = color or 15105570,
                ["author"] = {
                    ["name"] = data.Label,
                    ["icon_url"] = data.ImageUrl,
                },
                     
                ["title"] = name,
                ["description"] = description,
                     
                ["footer"] = {
                    ["text"] = data.Footer .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = data.ImageUrl,

                },

                ['image'] = { ['url'] = url },

            },

        },
        avatar_url = data.ImageUrl
    }), {
        ['Content-Type'] = 'application/json'
    })
end

HasPermissionsByAce = function(ace, source)

    local all = 'tpzcore.all'
    local aceAllowed = IsPlayerAceAllowed(source, all)

    if aceAllowed then
        return true
    end

    if not ace then
        print(string.format("Input ace permission is invalid: {%s}", ace))
        return false
    end

    aceAllowed = IsPlayerAceAllowed(source, ace)

    if aceAllowed then
        return true
    end

    return false
end

HasAdministratorPermissions = function(source, groups, discordRoles)

    if GetTableLength(groups) > 0 and PlayerData[source] then

        for _, group in pairs (groups) do
        
            if group == PlayerData[source].group then
                return true
            end
      
        end

    end

    
    local userRoles  = GetUserDiscordRoles(source, Config.DiscordServerID)

    if not userRoles or userRoles == nil then
        userRoles = {}
    end

    if GetTableLength(userRoles) > 0 and GetTableLength(discordRoles) > 0 then

        for _, role in pairs (discordRoles) do

            for _, userRole in pairs (userRoles) do
              
              if tonumber(userRole) == tonumber(role) then
                return true
              end
        
            end

        end

    end

    return false

end

-- @GetTableLength returns the length of a table.
GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end