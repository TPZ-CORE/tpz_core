
-----------------------------------------------------------
--[[ Local Functions  ]]--
-----------------------------------------------------------

local function RemovePlayerAccount(source, currency_type, quantity) 

    if (PlayerData[source].account[currency_type]) then

        if Config.NegativeValueOnAccounts then
            PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

        else
            PlayerData[source].account[currency_type] = PlayerData[source].account[currency_type] - quantity

            if PlayerData[source].account[currency_type] <= 0 then
                PlayerData[source].account[currency_type] = 0
            end

        end

    else
        print("Error: This currency type (" .. currency_type .. ") does not exist.")
    end
end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_core:onPlayerDeathContents")
AddEventHandler("tpz_core:onPlayerDeathContents", function()
    local _source = source

    if PlayerData[_source] then

        local xPlayer     = PlayerData[_source]
        local configData  = Config.OnPlayerDeathRespawn

        for index, account in pairs (_source.Accounts) do
        
            if account then
    
                local totalAccount = xPlayer.account[index]
                RemovePlayerAccount(_source, index, totalAccount)
    
            end
        end
    
        if configData.RemoveInventoryContents then
            TriggerClientEvent("tpz_inventory:clearEquippedWeapon", _source)
            exports.tpz_inventory:getInventoryAPI().clearInventoryContents(_source)
        end
    
        Wait(2000)
    
        xPlayer.saveCharacter() -- we save to prevent any kind of unexpected bugs.
    end


end) 