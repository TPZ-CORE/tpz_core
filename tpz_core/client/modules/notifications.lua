core.notifications = {}

core.onResourceStop() = function() 
  core.notifications = nil 
end

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

core.notifications.NotifyLeft = function(title, subtitle, dict, icon, duration, color)

    local Functions = GetFunctions()
    Functions.LoadTexture(dict)
  
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 8)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
    structData:SetInt32(8 * 3, 0)
    structData:SetInt64(8 * 4, Functions.BigInt(GetHashKey(dict)))
    structData:SetInt64(8 * 5, Functions.BigInt(GetHashKey(icon)))
    structData:SetInt64(8 * 6, Functions.BigInt(GetHashKey(color or "COLOR_WHITE")))
  
    InvokeNative(0x26E87218390E6729, structConfig:Buffer(), structData:Buffer(), 1, 1)
    InvokeNative(0x4ACA10A91F66F1E2, dict)
end
  
core.notifications.NotifyTip = function(tipMessage, duration)

    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
    structConfig:SetInt32(8 * 1, 0)
    structConfig:SetInt32(8 * 2, 0)
    structConfig:SetInt32(8 * 3, 0)
  
    local structData = DataView.ArrayBuffer(8 * 3)
    structData:SetUint64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", tipMessage)))
  
    InvokeNative(0x049D5C615BD38BAD, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyTop = function(message, location, duration)

    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 5)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", location)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
  
    InvokeNative(0xD05590C1AB38F068, structConfig:Buffer(), structData:Buffer(), 0, 1)
end
  
core.notifications.NotifyRightTip = function(tipMessage, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 3)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", tipMessage)))
  
    InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyObjective = function(message, duration)

    local Functions = GetFunctions()
    InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)
  
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 3)
    local strMessage = CreateVarString(10, "LITERAL_STRING", message)
    structData:SetInt64(8 * 1, Functions.BigInt(strMessage))
  
    InvokeNative(0xCEDBF17EFCC0E4A4, structConfig:Buffer(), structData:Buffer(), 1)
end
  

core.notifications.NotifySimpleTop = function(title, subtitle, duration)

    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 7)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
  
    InvokeNative(0xA6F4216AB10EB08E, structConfig:Buffer(), structData:Buffer(), 1, 1)
end
  
core.notifications.NotifyAvanced = function(text, dict, icon, text_color, duration, quality, showquality)

    local Functions = GetFunctions()
    Functions.LoadTexture(dict)
  
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
    structConfig:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", "Transaction_Feed_Sounds")))
    structConfig:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", "Transaction_Positive")))
  
    local structData = DataView.ArrayBuffer(8 * 10)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", dict)))
    structData:SetInt64(8 * 3, Functions.BigInt(GetHashKey(icon)))
    structData:SetInt64(8 * 5, Functions.BigInt(GetHashKey(text_color or "COLOR_WHITE")))

    if showquality then
      structData:SetInt32(8 * 6, quality or 1)
    end
  
    InvokeNative(0xB249EBCB30DD88E0, structConfig:Buffer(), structData:Buffer(), 1)
    InvokeNative(0x4ACA10A91F66F1E2, dict)
end

core.notifications.NotifyBasicTop = function(text, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 7)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
  
    InvokeNative(0x7AE0589093A2E088, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyCenter = function(text, duration, text_color)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 4)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
    structData:SetInt64(8 * 2, Functions.BigInt(GetHashKey(text_color or "COLOR_PURE_WHITE")))
  
    InvokeNative(0x893128CDB4B81FBB, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyBottomRight = function(text, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 5)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
  
    InvokeNative(0x2024F4F333095FB1, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyFail = function(title, subtitle, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
  
    local result = InvokeNative(0x9F2CC2439A04E7BA, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    InvokeNative(0x00A15B94CBA4F76F, result)
end
  
core.notifications.NotifyDead = function(title, audioRef, audioName, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
    structData:SetInt64(8 * 3, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioName)))
  
    local result = InvokeNative(0x815C4065AE6E6071, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    InvokeNative(0x00A15B94CBA4F76F, result)
end
  
core.notifications.NotifyUpdate = function(title, message, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
  
    local result = InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    InvokeNative(0x00A15B94CBA4F76F, result)
end
  

core.notifications.NotifyWarning = function(title, message, audioRef, audioName, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
    structData:SetInt64(8 * 3, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
    structData:SetInt64(8 * 4, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioName)))
  
    local result = InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    InvokeNative(0x00A15B94CBA4F76F, result)
end
  
core.notifications.NotifyLeftRank = function(title, subtitle, dict1, texture, duration, color)

    local Functions = GetFunctions()
    Functions.LoadTexture(dict1)
    duration = duration or 5000
    local dict = GetHashKey(dict1 or "TOASTS_MP_GENERIC")
    local texture = GetHashKey(texture or "toast_mp_standalone_sp")
    local string1 = CreateVarString(10, "LITERAL_STRING", title)
    local string2 = CreateVarString(10, "LITERAL_STRING", subtitle)
  
    local struct1 = DataView.ArrayBuffer(8 * 8)
    local struct2 = DataView.ArrayBuffer(8 * 10)
  
    struct1:SetInt32(8 * 0, duration)
  
    struct2:SetInt64(8 * 1, Functions.BigInt(string1))
    struct2:SetInt64(8 * 2, Functions.BigInt(string2))
    struct2:SetInt64(8 * 4, Functions.BigInt(dict))
    struct2:SetInt64(8 * 5, Functions.BigInt(texture))
    struct2:SetInt64(8 * 6, Functions.BigInt(GetHashKey(color or "COLOR_WHITE")))
    struct2:SetInt32(8 * 7, 1)
    InvokeNative(0x3F9FDDBA79117C69, struct1:Buffer(), struct2:Buffer(), 1, 1)
    InvokeNative(0x4ACA10A91F66F1E2, dict1)
end

-----------------------------------------------------------
--[[ Event Registrations ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_core:sendLeftNotification')
AddEventHandler('tpz_core:sendLeftNotification', function(firsttext, secondtext, dict, icon, duration, color)
    core.notifications.NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon), tonumber(duration), (tostring(color) or "COLOR_WHITE"))
end)

RegisterNetEvent('tpz_core:sendTipNotification')
AddEventHandler('tpz_core:sendTipNotification', function(text, duration)
    core.notifications.NotifyTip(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendTopNotification')
AddEventHandler('tpz_core:sendTopNotification', function(text, location, duration)
    core.notifications.NotifyTop(tostring(text), tostring(location), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendRightTipNotification')
AddEventHandler('tpz_core:sendRightTipNotification', function(text, duration)
    core.notifications.NotifyRightTip(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendBottomTipNotification')
AddEventHandler('tpz_core:sendBottomTipNotification', function(text, duration)
    core.notifications.NotifyObjective(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendSimpleTopNotification')
AddEventHandler('tpz_core:sendSimpleTopNotification', function(title, subtitle, duration)
    core.notifications.NotifySimpleTop(tostring(title), tostring(subtitle), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendAdvancedRightNotification')
AddEventHandler('tpz_core:sendAdvancedRightNotification', function(text, dict, icon, text_color, duration, quality)
    core.notifications.NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality)
end)

RegisterNetEvent('tpz_core:sendBasicTopNotification')
AddEventHandler('tpz_core:sendBasicTopNotification', function(text, duration)
    core.notifications.NotifyBasicTop(tostring(text), tonumber(duration))
end)       

RegisterNetEvent('tpz_core:sendSimpleCenterNotification')
AddEventHandler('tpz_core:sendSimpleCenterNotification', function(text, duration)
    core.notifications.NotifyCenter(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendBottomRightNotification')
AddEventHandler('tpz_core:sendBottomRightNotification', function(text, duration)
    core.notifications.NotifyBottomRight(tostring(text), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendFailMissionNotification')
AddEventHandler('tpz_core:sendFailMissionNotification', function(title, subtitle, duration)
    core.notifications.NotifyFail(tostring(title), tostring(subtitle), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendDeadPlayerNotification')
AddEventHandler('tpz_core:sendDeadPlayerNotification', function(title, audioRef, audioName, duration)
    core.notifications.NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendMissionUpdateNotification')
AddEventHandler('tpz_core:sendMissionUpdateNotification', function(utitle, umsg, duration)
    core.notifications.NotifyUpdate(tostring(utitle), tostring(umsg), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendWarningNotification')
AddEventHandler('tpz_core:sendWarningNotification', function(title, msg, audioRef, audioName, duration)
    core.notifications.NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
end)

RegisterNetEvent('tpz_core:sendLeftRankNotification')
AddEventHandler('tpz_core:sendLeftRankNotification', function(title, subtitle, dict, icon, duration, color)
    core.notifications.NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon) , tonumber(duration), (tostring(color))) 
end)