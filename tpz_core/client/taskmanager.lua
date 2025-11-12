local TaskManager = { list = {} }

-- Register script as busy / not. 
function TaskManager:SetBusy(scriptName, state)

    -- We remove from the list if busy state is false
    -- this allows us to not loop through many data. 
    if state then self.list[scriptName] = state else self.list[scriptName] = nil end
end

-- Check if any script action is busy.
function TaskManager:IsPlayerBusy()
    for _, busy in pairs(self.list) do
        if busy then return true end
    end
    return false
end

exports('IsPlayerBusy', function() return TaskManager:IsPlayerBusy() end)
exports('SetBusy', function(scriptName, state) TaskManager:SetBusy(scriptName, state) end)