
-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

ToggleUI = function(display)
	SetNuiFocus(false,false)
    SendNUIMessage({ type = "enable", enable = display })
end

-----------------------------------------------------------
--[[ Public Functions ]]--
-----------------------------------------------------------

function SendAnnouncement(title, description, title_rgba, description_rgba)

    SendNUIMessage({ 
        action                 = 'sendAnnouncement',
        title                  = title,
        title_rgba             = title_rgba,
        title_description      = description,
        title_description_rgba = description_rgba,
    })

    ToggleUI(true)

end

function CloseNUI()
    SendNUIMessage({action = 'close'})
end

-----------------------------------------------------------
--[[ NUI Callbacks  ]]--
-----------------------------------------------------------

RegisterNUICallback('close', function()
	ToggleUI(false)
end)
