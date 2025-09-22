core          = {}
InvokeNative  = Citizen.InvokeNative

local LoadedModules = {}

-----------------------------------------------------------
--[[ Core Table Functions ]]--
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
