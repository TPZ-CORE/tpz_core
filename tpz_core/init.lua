core          = {}
InvokeNative  = Citizen.InvokeNative

local LoadedModules = {}

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function core.RequestModuleAwait(module)

    while LoadedModules[module] == nil do
        Citizen.Wait(100)
    end
end

function core.IsModuleLoaded(module, callback)
    Citizen.CreateThread(function()

        while LoadedModules[module] == nil  do
            Citizen.Wait(100)
        end

        callback(module)
    end)
end

function core.SetModuleLoaded(module)
    LoadedModules[module] = true
end

function core.stop()
    LoadedModules = nil
end

function GetHashFromString(value)
    if type(value) == "string" then
      local number = tonumber(value)
      if number then return number end
      return joaat(value)
    end
    return value
end
  
function UnJson(value)
    if not value then return {} end
    if value == "null" then return {} end
    if type(value) == "string" then
      return json.decode(value)
    end
    return value
end
  
---Set a default value if the value is nil
---@param value any your value
---@param default any the default value
---@return any
function GetValue(value, default)
    if default == nil then
      return value
    end
    if default == false then
      return value or false
    end
    return value == nil and default or value
end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

-- Event: only runs once when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    core.stop()
end)
