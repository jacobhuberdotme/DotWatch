local lastTargetGUID = nil

function SetupTracker(frame)
  frame.healthBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
  frame.healthBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
  frame.healthBar:SetHeight(frame.iconSize / 5)

  frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, -2)
  frame.powerBar:SetPoint("TOPRIGHT", frame.healthBar, "BOTTOMRIGHT", 0, -2)
  frame.powerBar:SetHeight(frame.iconSize / 5)

  local function updateDots()
    local unit = "target"
    if UnitExists(unit) and not UnitIsFriend("player", unit) then
      lastTargetGUID = UnitGUID(unit)
    end

    local currentUnit = nil
    for _, u in ipairs({ "target", "focus", "mouseover" }) do
      if UnitExists(u) and UnitGUID(u) == lastTargetGUID and not UnitIsFriend("player", u) then
        currentUnit = u
        break
      end
    end

    if not currentUnit then
      frame:Hide()
      return
    end

    frame:Show()
    local health, healthMax = UnitHealth(currentUnit), UnitHealthMax(currentUnit)
    frame.healthBar:SetMinMaxValues(0, healthMax)
    frame.healthBar:SetValue(health)

    local power, powerMax = UnitPower(currentUnit), UnitPowerMax(currentUnit)
    local _, powerTypeToken = UnitPowerType(currentUnit)
    local powerColors = {
        MANA   = { r = 0.6, g = 0.8, b = 1.0 },
        RAGE   = { r = 1.0, g = 0.6, b = 0.6 },
        ENERGY = { r = 1.0, g = 1.0, b = 0.6 },
      }
      local color = powerColors[powerTypeToken] or { r = 0.8, g = 0.8, b = 0.8 }

    frame.powerBar:SetMinMaxValues(0, powerMax)
    frame.powerBar:SetValue(power)
    frame.powerBar:SetStatusBarColor(color.r, color.g, color.b)

    for spellId, i in pairs(DOTS) do
      local auraName = GetSpellInfo(spellId)
      local name, _, _, _, duration, expirationTime, source = AuraUtil.FindAuraByName(auraName, currentUnit, "HARMFUL")
      if name and source == "player" and duration and expirationTime then
        local timeLeft = expirationTime - GetTime()
        local color = DotColors[spellId] or { r = 0.5, g = 0.5, b = 0.5 }
        frame.dots[i]:SetColorTexture(color.r, color.g, color.b)
        if timeLeft > 0 and timeLeft < 8 then
          frame.dots[i].text:SetText(string.format("%.0f", timeLeft))
        else
          frame.dots[i].text:SetText("")
        end
      else
        frame.dots[i]:SetColorTexture(0.2, 0.2, 0.2)
        frame.dots[i].text:SetText("")
      end
    end
  end

  local f = CreateFrame("Frame")
  f:RegisterEvent("PLAYER_TARGET_CHANGED")
  f:RegisterEvent("UNIT_AURA")
  f:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_AURA" and unit == "target") then
      updateDots()
    end
  end)

  local ticker
  local function startTicker()
    if not ticker then
      ticker = C_Timer.NewTicker(0.2, function()
        updateDots()
      end)
    end
  end

  local function stopTicker()
    if ticker then
      ticker:Cancel()
      ticker = nil
    end
  end

  local combatFrame = CreateFrame("Frame")
  combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
  combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
  combatFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
      startTicker()
    elseif event == "PLAYER_REGEN_ENABLED" then
      stopTicker()
    end
  end)

  updateDots()
end