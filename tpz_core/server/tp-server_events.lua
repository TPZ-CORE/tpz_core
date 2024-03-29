
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------


RegisterServerEvent("tpz_core:sendToDiscord")
AddEventHandler("tpz_core:sendToDiscord", function(webhook, name, description, color)
    local data = Config.DiscordWebhooking

    print(webhook, name, description, color)
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
end)
