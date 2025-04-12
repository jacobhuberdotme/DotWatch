function CreateDotWatchFrame()
    local ICON_SIZE = 40
    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    frame.iconSize = ICON_SIZE
    frame:SetSize(ICON_SIZE, ICON_SIZE)
    frame:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      edgeSize = 4,
      insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(0.1, 0.1, 0.1, 0.85)
    frame:SetBackdropBorderColor(0.3, 0.7, 1.0, 0.9)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
  
    frame.healthBar = CreateFrame("StatusBar", nil, frame)
    frame.healthBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame.healthBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    frame.healthBar:SetHeight(frame.iconSize / 5)
    frame.healthBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    frame.healthBar:SetStatusBarColor(0.6, 1.0, 0.6)

    frame.healthText = frame.healthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.healthText:SetPoint("CENTER", frame.healthBar, "CENTER", 0, 0)
    frame.healthText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    frame.healthText:SetJustifyH("CENTER")
    frame.healthText:SetJustifyV("MIDDLE")
    frame.healthText:SetText("")
  
    frame.powerBar = CreateFrame("StatusBar", nil, frame)
    frame.powerBar:SetPoint("TOPLEFT", frame.healthBar, "BOTTOMLEFT", 0, -2)
    frame.powerBar:SetPoint("TOPRIGHT", frame.healthBar, "BOTTOMRIGHT", 0, -2)
    frame.powerBar:SetHeight(frame.iconSize / 5)
    frame.powerBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
  
    frame.dots = {}
    local DOT_WIDTH = (frame.iconSize - 4) / 4
    local DOT_HEIGHT = frame.iconSize / 2
  
    for i = 1, 4 do
      local dot = frame:CreateTexture(nil, "ARTWORK")
      dot:SetSize(DOT_WIDTH, DOT_HEIGHT)
      dot:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2 + (i - 1) * DOT_WIDTH, 2)
      dot:SetColorTexture(0.2, 0.2, 0.2)
      frame.dots[i] = dot
  
      local text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
      text:SetPoint("CENTER", dot, "CENTER")
      text:SetJustifyH("CENTER")
      text:SetJustifyV("MIDDLE")
      text:SetDrawLayer("OVERLAY", 7)
      text:SetText("")
      dot.text = text
    end
  
    return frame
  end