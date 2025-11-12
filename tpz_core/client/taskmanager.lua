local TaskManager = { list = {}, count = 0 }

-- Register script as busy / not. 
function TaskManager:SetBusy(scriptName, state)

    if state and self.list[scriptName] == nil then
        self.count += 1
        self.list[scriptName] = true
    end

    if not state and self.list[scriptName] then
        self.count = math.max(0, self.count - 1)
        self.list[scriptName] = nil
    end

end

-- Check if any script action is busy.
function TaskManager:IsPlayerBusy()
    return self.count > 0
end

exports('IsPlayerBusy', function() return TaskManager:IsPlayerBusy() end)
exports('SetBusy', function(scriptName, state) TaskManager:SetBusy(scriptName, state) end)