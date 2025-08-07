local NUIFocus = false

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local ToggleUI = function(display)

    NUIFocus = display 

	SetNuiFocus(false,false)
    SendNUIMessage({ type = "enable", enable = display })
end

local FormatTime = function (seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-----------------------------------------------------------
--[[ Public Functions ]]--
-----------------------------------------------------------

function SendAnnouncement(title, description, duration, title_rgba, description_rgba)

    SendNUIMessage({ 
        action                 = 'sendAnnouncement',
        title                  = title,
        title_rgba             = title_rgba,
        title_description      = description,
        title_description_rgba = description_rgba,
    })

    ToggleUI(true)

    Wait(duration)
    CloseNUI()
end

function DisplayDeathCountdown(countdown)

    countdown = FormatTime(countdown)

    if tonumber(countdown) and tonumber(countdown) <= 0 then
        countdown = Locales['DEATH_NUI_RESPAWN_NOW']
    end

    if not NUIFocus then
        SendNUIMessage({ 
            action            = 'displayDeathCountdown',
            title             = Locales['DEATH_NUI_TITLE'],
            title_description = Locales['DEATH_NUI_DESCRIPTION'],
            countdown         = countdown,
        })
    
        ToggleUI(true)

    else
        SendNUIMessage({ action = 'updateDeathCountdown', countdown = countdown })
    end

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
