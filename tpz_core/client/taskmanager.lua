local TaskManager = { list = {}, count = 0 }

core.stop = function() self.list = nil end

-------------------------------------------------------------
--[[ Functions ]]--
-------------------------------------------------------------

-- Register script as busy. 
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

-- Check if count > 0 to return the player as busy if there is any active. 
function TaskManager:IsPlayerBusy()
    return self.count > 0
end

function GetTaskManager() return TaskManager end

-------------------------------------------------------------
--[[ Events ]]--
-------------------------------------------------------------

AddEventHandler("onResourceStop", function(resourceName)
    if self.list[resourceName] then self:SetBusy(resourceName, false) end
end)

-------------------------------------------------------------
--[[ Commands ]]--
-------------------------------------------------------------

RegisterCommand("taskmanager_debug", function()
    local busyList = {}
    for scriptName, _ in pairs(TaskManager.list) do
        table.insert(busyList, scriptName)
    end

    local count = TaskManager.count
    local listString = #busyList > 0 and table.concat(busyList, ", ") or "None"

    print(string.format("Busy scripts count: %d | Active scripts: %s", count, listString))
end, false)
