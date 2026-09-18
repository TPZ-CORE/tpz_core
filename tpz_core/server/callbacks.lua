---@class ServerRPC @Callback class
---@field name string callback name
---@field _callback fun(source: number, cb: fun(data: any), ...) callback function
---@field uniqueId string callback unique id
ServerRPC = {}
ServerRPC.Callback = {}
ServerRPC.__index = ServerRPC
ServerRPC.__call = function()
    return 'ServerRPC'
end


function ServerRPC:New(name, callback)
    local self = setmetatable({}, ServerRPC)
    self.name = name
    self._callback = callback
    self.uniqueId = ""
    return self
end

function ServerRPC:Trigger(_source, uniqueId, isSync, ...)
    if not self._callback then
        return error("Callback " .. self.name .. " does not exist. Make sure it's registered in the server side.", 1)
    end

    self._callback(_source, function(...)
        TriggerClientEvent("tpz_core:ServerCallback", _source, uniqueId, isSync, ...)
    end, ...)
end

local RegisteredCalls = {}

-- Kept as a local server event for resource compatibility.  It is deliberately
-- not registered as a network event.
AddEventHandler("tpz_core:addNewCallBack", ServerRPC.Callback.Register)

RegisterNetEvent("tpz_core:TriggerServerCallback", function(name, uniqueId, isSync, ...)
    local _source = source

    if not RegisteredCalls[name] then
        return
    end

    RegisteredCalls[name]:Trigger(_source, uniqueId, isSync, ...)
end)



--- Register a new Rpc callback
---@param name string callback name
---@param callback fun(source: number, cb: fun(data: any), ...) callback function
function ServerRPC.Callback.Register(name, callback)
    -- error handling

    if type(name) ~= "string" or type(callback) ~= "function" then
        return error("Callback name must be a string and callback must be a function!", 1)
    end

    RegisteredCalls[name] = ServerRPC:New(name, callback)
end

-- Events backwars compatibility
-- Callback registration is server-only.  Registering this as a network event let
-- any client overwrite a callback with a nil/non-function value and deny service.
addNewCallBack = function(name, cb)
    return ServerRPC.Callback.Register(name, cb)
end

-- * TRIGGER CLIENT CALLBACKS
local callBackId = 0
local TriggeredCalls = {}


function ServerRPC:TriggerRpcAsync(source, ...)
    if not self.name and type(self.name) ~= "string" then
        return error("Callback name must be a string!", 1)
    end

    if not source and type(source) ~= "number" then
        return error("Callback source must exist and be a number!", 1)
    end

    callBackId = callBackId + 1
    if callBackId >= 65565 then
        callBackId = 0
        TriggeredCalls = {}
    end

    self.uniqueId = self.name .. tostring(callBackId)

    TriggerClientEvent("tpz_core:TriggerServerCallback", source, self.name, self.uniqueId, false, ...)

    TriggeredCalls[self.uniqueId] = { source = source, callback = self._callback }
end

function ServerRPC:TriggerRpcAwait(source, ...)
    if not self.name and type(self.name) ~= "string" then
        return error("Callback name must be a string!", 1)
    end
    callBackId = callBackId + 1
    if callBackId >= 65565 then
        callBackId = 0
        TriggeredCalls = {}
    end

    self.uniqueId = self.name .. tostring(callBackId)
    TriggerClientEvent("tpz_core:TriggerServerCallback", source, self.name, self.uniqueId, true, ...)

    local promise = promise.new()
    TriggeredCalls[self.uniqueId] = { source = source, promise = promise }

    local result = Citizen.Await(promise)
    return result
end

function ServerRPC.ExecuteRpc(uniqueId, isSync, ...)
    local _source = source
    local call = TriggeredCalls[uniqueId]
    if not call then
        return
    end

    -- A response is valid only from the player to whom this RPC was sent.
    if call.source ~= _source then
        return
    end

    if not isSync then
        if type(call.callback) == "function" then
            call.callback(...)
        end
    else
        call.promise:resolve(...)
    end

    TriggeredCalls[uniqueId] = nil
end

RegisterNetEvent('tpz_core:ServerCallback', ServerRPC.ExecuteRpc)


--- * Trigger a callback Asynchronously
---@param source number player source
---@param name string callback name
---@param callback fun(any) callback function
---@param ... any callback parameters tables strings numbers etc
function ServerRPC.Callback.TriggerAsync(name, source, callback, ...)
    local trigger = ServerRPC:New(name, callback)
    trigger:TriggerRpcAsync(source, ...)
end

--- * Trigger a callback Synchronously
---@param source number player source
---@param name string callback name
---@param ... any callback parameters tables strings numbers etc
---@return any callback return
function ServerRPC.Callback.TriggerAwait(name, source, ...)
    local trigger = ServerRPC:New(name, nil)
    return trigger:TriggerRpcAwait(source, ...)
end

-- Export
exports("ServerRpcCall", function()
    return ServerRPC
end)

return ServerRPC
