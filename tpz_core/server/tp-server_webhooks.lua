----------------------------------------------
-- Webhooks (ADD ALL YOUR WEBHOOKS HERE)
----------------------------------------------

local WEBHOOKS = {
    ["TPZ_MINING"] = "xxxxxxxxxxxxxxxxxxxxxxxxxxx", -- this is an example.
}

----------------------------------------------
-- Functions (DONT TOUCH WITHOUT EXPERIENCE)
----------------------------------------------

GetWebhookUrlByName = function(webhook)
    if webhook == nil then
        print("The webhook input seems to be null (invalid).")
        return "n/a"
    end
    
    if WEBHOOKS[webhook] == nil then
        print(string.format("The webhook input %s is not registered on WEBHOOKS table."), webhook )
        return "n/a"
    end
    
    return WEBHOOKS[webhook]
end
