core           = {}

CreateThreadNow = Citizen.CreateThreadNow
Await           = Citizen.Await
InvokeNative    = Citizen.InvokeNative

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function core.RequestModuleAwait(module)

    Citizen.CreateThread(function()
        while module == nil or module and not module.loaded() do
            Citizen.Wait(50)
        end
    end)

end

function core.IsModuleLoaded(module, callback)
    Citizen.CreateThread(function()

        while module == nil or module and not module.loaded() do
            Citizen.Wait(50)
        end

        callback(module)
    end)
end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

-- Event: only runs once when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    core.onResourceStop()
end)