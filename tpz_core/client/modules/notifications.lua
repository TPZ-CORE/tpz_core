core.notifications = {}

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Notifications = nil

end)

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
  
    Citizen.InvokeNative(0x26E87218390E6729, structConfig:Buffer(), structData:Buffer(), 1, 1)
    Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict)
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
  
    Citizen.InvokeNative(0x049D5C615BD38BAD, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyTop = function(message, location, duration)

    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 5)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", location)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
  
    Citizen.InvokeNative(0xD05590C1AB38F068, structConfig:Buffer(), structData:Buffer(), 0, 1)
end
  
core.notifications.NotifyRightTip = function(tipMessage, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 3)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", tipMessage)))
  
    Citizen.InvokeNative(0xB2920B9760F0F36B, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyObjective = function(message, duration)

    local Functions = GetFunctions()
    Citizen.InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)
  
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 3)
    local strMessage = CreateVarString(10, "LITERAL_STRING", message)
    structData:SetInt64(8 * 1, Functions.BigInt(strMessage))
  
    Citizen.InvokeNative(0xCEDBF17EFCC0E4A4, structConfig:Buffer(), structData:Buffer(), 1)
end
  

core.notifications.NotifySimpleTop = function(title, subtitle, duration)

    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 7)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
  
    Citizen.InvokeNative(0xA6F4216AB10EB08E, structConfig:Buffer(), structData:Buffer(), 1, 1)
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
  
    Citizen.InvokeNative(0xB249EBCB30DD88E0, structConfig:Buffer(), structData:Buffer(), 1)
    Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict)
end

core.notifications.NotifyBasicTop = function(text, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 7)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
  
    Citizen.InvokeNative(0x7AE0589093A2E088, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyCenter = function(text, duration, text_color)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 4)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
    structData:SetInt64(8 * 2, Functions.BigInt(GetHashKey(text_color or "COLOR_PURE_WHITE")))
  
    Citizen.InvokeNative(0x893128CDB4B81FBB, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyBottomRight = function(text, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 7)
    structConfig:SetInt32(8 * 0, tonumber(duration or 3000))
  
    local structData = DataView.ArrayBuffer(8 * 5)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", text)))
  
    Citizen.InvokeNative(0x2024F4F333095FB1, structConfig:Buffer(), structData:Buffer(), 1)
end
  
core.notifications.NotifyFail = function(title, subtitle, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", subtitle)))
  
    local result = Citizen.InvokeNative(0x9F2CC2439A04E7BA, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end
  
core.notifications.NotifyDead = function(title, audioRef, audioName, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
    structData:SetInt64(8 * 3, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioName)))
  
    local result = Citizen.InvokeNative(0x815C4065AE6E6071, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end
  
core.notifications.NotifyUpdate = function(title, message, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
  
    local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
end
  

core.notifications.NotifyWarning = function(title, message, audioRef, audioName, duration)
    local Functions = GetFunctions()
    local structConfig = DataView.ArrayBuffer(8 * 5)
  
    local structData = DataView.ArrayBuffer(8 * 9)
    structData:SetInt64(8 * 1, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", title)))
    structData:SetInt64(8 * 2, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", message)))
    structData:SetInt64(8 * 3, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioRef)))
    structData:SetInt64(8 * 4, Functions.BigInt(CreateVarString(10, "LITERAL_STRING", audioName)))
  
    local result = Citizen.InvokeNative(0x339E16B41780FC35, structConfig:Buffer(), structData:Buffer(), 1)
    Wait(duration or 3000)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, result)
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
    Citizen.InvokeNative(0x3F9FDDBA79117C69, struct1:Buffer(), struct2:Buffer(), 1, 1)
    Citizen.InvokeNative(0x4ACA10A91F66F1E2, dict1)
end