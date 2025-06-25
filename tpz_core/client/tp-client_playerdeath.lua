
local DeathData = { cooldown = 0, isDead = false, cameraHandler = nil, cameraAngleY = 0.0, cameraAngleZ = 0.0}

local Prompts       = GetRandomIntInRange(0, 0xffffff)
local PromptsList   = {}

-----------------------------------------------------------
--[[ Prompts  ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end

  if Config.OnPlayerDeath.DeathCamera then
    ClearDeathCam()
  end
  
  if Config.OnPlayerDeath.DeathCameraEffects then

    for index, effect in pairs (Config.OnPlayerDeath.DeathCameraEffects) do
      AnimpostfxStop(effect)
    end
  
  end
  
end)

RegisterDeathPromptActions = function()

  for index, tprompt in pairs (Config.OnPlayerDeath.PromptKeys) do

    if tprompt.enabled then

      -- We are getting the label of the prompt and the key.
      local str      = tprompt.label
      local keyPress = tprompt.key
    
      -- We registering the prompt.
      local dPrompt = PromptRegisterBegin()
      PromptSetControlAction(dPrompt, keyPress)
      str = CreateVarString(10, 'LITERAL_STRING', str)
      PromptSetText(dPrompt, str)

      -- When registering, we set the respawn key as not enabled since we use a cooldown system.
      if index == 'RESPAWN' then
        PromptSetEnabled(dPrompt, 0)
      else
        PromptSetEnabled(dPrompt, 1)
      end

      PromptSetVisible(dPrompt, 1)
      PromptSetStandardMode(dPrompt, 1)
      PromptSetHoldMode(dPrompt, tprompt.holdMode) -- we set the hold mode
      PromptSetGroup(dPrompt, Prompts)
      Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
      PromptRegisterEnd(dPrompt)
    
      table.insert(PromptsList, {prompt = dPrompt, action = index})
    end

  end

end

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterNetEvent('tpz_core:resurrectPlayer')
AddEventHandler('tpz_core:resurrectPlayer', function(cb)

  ResurrectPlayer(nil, cb)

  DeathData.cooldown      = 0
  DeathData.isDead        = false
end)

RegisterNetEvent('tpz_core:applyLethalDamage')
AddEventHandler('tpz_core:applyLethalDamage', function()
  SetEntityHealth(PlayerPedId(), 0, 0)
end)

RegisterNetEvent('tpz_core:onPlayerRespawn')
AddEventHandler('tpz_core:onPlayerRespawn', function()
  DeathData.cooldown = 0
end)


-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

-- Registering the death prompt actions.
Citizen.CreateThread(function()

  RegisterDeathPromptActions() 

  while true do

    Wait(0)

    local sleep = true
    local player = PlayerPedId() -- call it only once

    if IsEntityDead(player) then
      sleep = false

      -- Performing actions only once.
      if not DeathData.isDead then

        DeathData.isDead = true

        exports.spawnmanager.setAutoSpawn(false)
        TriggerServerEvent('tpz_core:savePlayerDeathStatus', 1)

        NetworkSetInSpectatorMode(false, player)
        DisplayRadar(false)

        DeathData.cooldown = Config.OnPlayerDeath.PromptKeys['RESPAWN'].cooldown

        if Config.OnPlayerDeath.DeathCamera then
          StartDeathCam()
        end

        if Config.OnPlayerDeath.DeathCameraEffects then

          for index, effect in pairs (Config.OnPlayerDeath.DeathCameraEffects) do
            AnimpostfxPlay(effect)
          end
        end

      end

      -- The following prompts such as respawn will be visible only if the player is not being carried.
      if DeathData.isDead and not IsEntityAttachedToAnyPed(player) then

        ProcessCamControls()

        local notifyText = string.format(Config.OnPlayerDeath.BottomPromptLabelDisplays['WHILE_RESPAWN_HAS_COOLDOWN'], DeathData.cooldown) 

        if DeathData.cooldown <= 0 then
          notifyText = Config.OnPlayerDeath.BottomPromptLabelDisplays['WHILE_NO_RESPAWN_COOLDOWN']
        end

        local label = CreateVarString(10, 'LITERAL_STRING', notifyText)
        PromptSetActiveGroupThisFrame(Prompts, label)

        for index, prompt in pairs(PromptsList) do

          if prompt.action == "RESPAWN" then

            if DeathData.cooldown <= 0 then
              PromptSetEnabled(prompt.prompt, 1)
            else

              PromptSetEnabled(prompt.prompt, 0)
            end

          end

          if PromptHasHoldModeCompleted(prompt.prompt) then

            if prompt.action == "RESPAWN" then

              DoScreenFadeOut(3000)

              Wait(3000)
              OnPlayerRespawn()

            end

            Wait(2000)

          end

        end


      end

    end

    if sleep then
      Citizen.Wait(1000)
    end

  end

end)

-- Cooldown system when the player is dead.
Citizen.CreateThread(function ()
  while true do
    Wait(1000)

    if DeathData.cooldown > 0 then

      DeathData.cooldown = DeathData.cooldown - 1

      if DeathData.cooldown <= 0 then
        DeathData.cooldown = 0
      end

    end

  end

end)

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

OnPlayerRespawn = function()

  local player    = PlayerPedId()
  local pedCoords = GetEntityCoords(player)

  local closestDistance = math.huge
  local closestLocation = nil
  local spawnedCoords   = nil

  for _, location in pairs(Config.OnPlayerDeath.RespawnLocations) do

    local locationCoords = vector3(location.Coords.x, location.Coords.y, location.Coords.z)
    local currentDistance = #(pedCoords - locationCoords)

    if currentDistance <= closestDistance then
      closestDistance = currentDistance
      closestLocation = location.Town
      spawnedCoords   = location.Coords
    end

  end

  ResurrectPlayer(spawnedCoords, false)
 -- TriggerServerEvent("tpzcore:getPlayerSkin")
end


local keepdown = false

ResurrectPlayer = function(currentHospital, hasBeenRevived)
  local player = PlayerPedId()

  ResurrectPed(player)

  Wait(200)

  if Config.OnPlayerDeath.DeathCamera then
    ClearDeathCam()
  end

  if Config.OnPlayerDeath.DeathCameraEffects then

    for index, effect in pairs (Config.OnPlayerDeath.DeathCameraEffects) do
      AnimpostfxStop(effect)
    end

  end

  TriggerServerEvent('tpz_core:savePlayerDeathStatus', 0)

  DeathData.isDead = false

  --setPVP()

  if currentHospital then -- set entitycoords with heading
    Citizen.InvokeNative(0x203BEFFDBE12E96A, player, currentHospital.x, currentHospital.y, currentHospital.z, currentHospital.heading, false, false, false)
  end

    TriggerServerEvent("tpz_core:requestCharacterSkin") -- requests skin reload.
  
  Wait(2000)

  if Config.OnPlayerDeath.RagdollOnResurrection and not hasBeenRevived then

    TriggerServerEvent('tpz_core:onPlayerDeathContents')

    keepdown = true
    CreateThread(function() -- tread to keep player down
        while keepdown do
          Wait(0)
          SetPedToRagdoll(PlayerPedId(), 4000, 4000, 0, 0, 0, 0)
          ResetPedRagdollTimer(PlayerPedId())
        end
    end)
         
    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)

    if innerHealth then
      SetEntityHealth(PlayerPedId(), Config.OnPlayerDeath.HealthOnRespawn + innerHealth)
    end

    if Config.OnPlayerDeath.PlayAnimPostFXPlay then
      AnimpostfxPlay("Title_Gen_FewHoursLater")
    end

    Wait(3000)

    DoScreenFadeIn(2000)

    if Config.OnPlayerDeath.PlayAnimPostFXPlay then
      AnimpostfxPlay("PlayerWakeUpInterrogation") 
    end

    DisplayRadar(true)

    Wait(Config.OnPlayerDeath.RagdollKeepDown)
    keepdown = false

  else
    DoScreenFadeIn(2000) 

    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)

    if innerHealth then
      SetEntityHealth(PlayerPedId(), Config.OnPlayerDeath.HealthOnRespawn + innerHealth)
    end

  end

  TriggerEvent('tpz_core:onPlayerRespawn')

  -- tpz_metabolism
  TriggerEvent("tpz_metabolism:setMetabolismValue", "HUNGER", "add", 100)
  TriggerEvent("tpz_metabolism:setMetabolismValue", "THIRST", "add", 100)

  TriggerEvent("tpz_metabolism:setMetabolismValue", "STRESS", "remove", 100)
  TriggerEvent("tpz_metabolism:setMetabolismValue", "ALCOHOL", "remove", 100)

  if not hasBeenRevived then
    TriggerEvent('tpz_core:isPlayerRespawned')
  end

end

StartDeathCam = function()
  ClearFocus()
  local playerPed = PlayerPedId()

  DeathData.cameraHandler = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
  SetCamActive(DeathData.cameraHandler, true)
  RenderScriptCams(true, true, 1000, true, false)

end

ClearDeathCam = function()
  NetworkSetInSpectatorMode(false, PlayerPedId())
  ClearFocus()

  RenderScriptCams(false, false, 0, true, false)
  DestroyCam(DeathData.cameraHandler, false)
  DeathData.cameraHandler = nil
end


ProcessCamControls = function()
  local newPos = nil

  if Config.OnPlayerDeath.UseControlsCamera then

      local playerPed = PlayerPedId()
      local pCoords = GetEntityCoords(playerPed)

      newPos = ProcessNewPosition()

      SetCamCoord(DeathData.cameraHandler, newPos.x, newPos.y, newPos.z)
      PointCamAtCoord(DeathData.cameraHandler, pCoords.x, pCoords.y, pCoords.z + 0.5)
  else
      newPos = GetEntityCoords(PlayerPedId())
  end

end

ProcessNewPosition = function()
    local mouseX = 0.0
    local mouseY = 0.0
    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 0x4D8FB4C1) * 1.5
        mouseY = GetDisabledControlNormal(1, 0xFDA83190) * 1.5
    else
        mouseX = GetDisabledControlNormal(1, 0x4D8FB4C1) * 0.5
        mouseY = GetDisabledControlNormal(1, 0xFDA83190) * 0.5
    end
    DeathData.cameraAngleZ = DeathData.cameraAngleZ - mouseX
    DeathData.cameraAngleY = DeathData.cameraAngleY + mouseY

    if (DeathData.cameraAngleY > 89.0) then DeathData.cameraAngleY = 89.0 elseif (DeathData.cameraAngleY < -89.0) then DeathData.cameraAngleY = -89.0 end
    local pCoords = GetEntityCoords(PlayerPedId())
    local behindCam = {
        x = pCoords.x + ((Cos(DeathData.cameraAngleZ) * Cos(DeathData.cameraAngleY)) + (Cos(DeathData.cameraAngleY) * Cos(DeathData.cameraAngleZ))) / 2 * (3.0 + 0.5),
        y = pCoords.y + ((Sin(DeathData.cameraAngleZ) * Cos(DeathData.cameraAngleY)) + (Cos(DeathData.cameraAngleY) * Sin(DeathData.cameraAngleZ))) / 2 * (3.0 + 0.5),
        z = pCoords.z + ((Sin(DeathData.cameraAngleY))) * (3.0 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1
        , PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

    local maxRadius = 3.0
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 3.0 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(DeathData.cameraAngleZ) * Cos(DeathData.cameraAngleY)) + (Cos(DeathData.cameraAngleY) * Cos(DeathData.cameraAngleZ))) / 2 * maxRadius,
        y = ((Sin(DeathData.cameraAngleZ) * Cos(DeathData.cameraAngleY)) + (Cos(DeathData.cameraAngleY) * Sin(DeathData.cameraAngleZ))) / 2 * maxRadius,
        z = ((Sin(DeathData.cameraAngleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return pos
end
