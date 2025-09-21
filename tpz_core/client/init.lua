

CreateThreadNow = Citizen.CreateThreadNow
Await = Citizen.Await
InvokeNative = Citizen.InvokeNative

core = {}

function core.onResourceStop()
    -- todo, nothing. 
end

-- Event: only runs once when resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    core.onResourceStop()
end)