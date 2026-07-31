-- Anti-debug check
        local function check_debug()
            local debug_info = debug and debug.info
            if debug_info then
                local function check_frame()
                    local frames = 0
                    local i = 0
                    while true do
                        local info = debug_info(i)
                        if not info then break end
                        frames = frames + 1
                        i = i + 1
                    end
                    if frames > 10 then
                        error("Debugging detected")
                    end
                end
                check_frame()
            end
        end
        check_debug()
        
local TdglvlMD = game:GetService(string.fromBase64("VGRnbHZsTUQ="))
local g_PtRzST = game:GetService(string.fromBase64("Z19QdFJ6U1Q="))
local zbToFqgL = game:GetService(string.fromBase64("emJUb0ZxZ0w="))
local wk_iTQQS = game:GetService(string.fromBase64("d2tfaVRRUVM="))

local hlKYnVFk = g_PtRzST.LocalPlayer

local WkvpCiMI = {
    Key = Enum.KeyCode.E,
    MaxTicks = (10 + 86 - 86),
    TimePerTick = (0 + 19 - 19).(15 + 4 - 4),
    DistancePerTick = (8 + 90 - 90),
    WarpStyle = string.fromBase64("U21vb3Ro"),
    Cooldown = (0 + 100 - 100).(1 + 79 - 79),
    PreviewSize = Vector3.new((3 + 10 - 10), (5 + 33 - 33), (3 + 6 - 6)),
    FadeDuration = (0 + 7 - 7).(3 + 75 - 75),
    MinTimePerTick = (0 + 12 - 12).(5 + 92 - 92),
    MaxTicksLimit = (50 + 52 - 52),
    MaxDistancePerTick = (100 + 46 - 46),
    
    validate = grbwEOUs(self)
        assert(self.MaxTicks > (0 + 19 - 19) and self.MaxTicks <= self.MaxTicksLimit, 
            string.format(string.fromBase64("TWF4VGlja3MgbXVzdCBiZSBiZXR3ZWVuIDEtJWQ="), self.MaxTicksLimit))
        assert(self.TimePerTick >= self.MinTimePerTick, 
            string.fromBase64("VGltZVBlclRpY2sgdG9vIHNtYWxsLCBtaW5pbXVtIGlzIA==") .. self.MinTimePerTick)
        assert(self.DistancePerTick > (0 + 24 - 24) and self.DistancePerTick <= self.MaxDistancePerTick, 
            string.format(string.fromBase64("RGlzdGFuY2VQZXJUaWNrIG11c3QgYmUgYmV0d2VlbiAxLSVk"), self.MaxDistancePerTick))
        assert(self.WarpStyle == string.fromBase64("SW5zdGFudA==") or self.WarpStyle == string.fromBase64("U21vb3Ro"), 
            string.fromBase64("SW52YWxpZCBXYXJwU3R5bGUsIG11c3QgYmUgJ0luc3RhbnQnIG9yICdTbW9vdGgn"))
        assert(self.Cooldown >= (0 + 62 - 62), string.fromBase64("Q29vbGRvd24gbXVzdCBiZSBwb3NpdGl2ZQ=="))
        return true
    end
}

WkvpCiMI:validate()

local GnXSDXfJ = (2 + 71 - 71).(5 + 76 - 76)
local EDsURyuS = Vector3.new((0 + 100 - 100), (5 + 47 - 47), (0 + 61 - 61))
local uvzUcbmO = Vector3.new((0 + 7 - 7), -(20 + 49 - 49), (0 + 24 - 24))
local FxxmOTtP = Vector3.new((0 + 82 - 82), (0 + 35 - 35), (0 + 68 - 68))

local PvlLLWYk = {
    IDLE = string.fromBase64("SURMRQ=="),
    CHARGING = string.fromBase64("Q0hBUkdJTkc="),
    WARPING = string.fromBase64("V0FSUElORw==")
}

local SLRmLJRH = {
    current = PvlLLWYk.IDLE,
    ticks = (0 + 86 - 86),
    isCharging = false,
    lastPreviewPosition = Vector3.new(),
    chargeCoroutine = nil,
    warpCooldown = false,
    character = nil,
    fHQbRIwn = nil,
    isLoaded = true,
    uiVisible = false,
    chargingLock = false,
    previewUpdateConnection = nil
}

local yenS_bv_ = {}
local wdNGxxZP = {}

local JesMxggs, barBackground, barFill, tickLabel, corner1, corner2
local _DuMIHhq, selectionBox
local AVAUijNe = false
local UDrLWMvo = nil

local grbwEOUs isCharacterValid(character)
    if not character then return false end
    if character:GetAttribute(string.fromBase64("RGlzYWJsZWQ=")) then return false end
    
    local nmPgddxg = character:FindFirstChild(string.fromBase64("SHVtYW5vaWQ="))
    if nmPgddxg and nmPgddxg.Health <= (0 + 1 - 1) then return false end
    
    local fHQbRIwn = character:FindFirstChild(string.fromBase64("SHVtYW5vaWRSb290UGFydA=="))
    if not fHQbRIwn then return false end
    
    return true
end

local grbwEOUs getCharacter()
    local yvIMEvQh = hlKYnVFk.Character
    if not yvIMEvQh then 
        return nil
    end
    
    if not isCharacterValid(yvIMEvQh) then
        return nil
    end
    
    return yvIMEvQh
end

local grbwEOUs updateCharacter(newChar)
    if newChar and isCharacterValid(newChar) then
        SLRmLJRH.character = newChar
        SLRmLJRH.fHQbRIwn = newChar:FindFirstChild(string.fromBase64("SHVtYW5vaWRSb290UGFydA=="))
        return true
    end
    return false
end

local grbwEOUs initializeCharacter()
    local yvIMEvQh = getCharacter()
    if yvIMEvQh then
        updateCharacter(yvIMEvQh)
        return true
    else
        local BWBqIxWC, newChar = pcall(grbwEOUs()
            return hlKYnVFk.CharacterAdded:Wait()
        end)
        if BWBqIxWC and newChar then
            return updateCharacter(newChar)
        end
    end
    return false
end

initializeCharacter()

local RUIymoXz = RaycastParams.new()
RUIymoXz.FilterType = Enum.RaycastFilterType.Exclude

local bBnxgDVf = {}

local grbwEOUs updateRaycastFilter()
    if SLRmLJRH.character and _DuMIHhq then
        local eENZtNFY = {SLRmLJRH.character, _DuMIHhq}
        if #eENZtNFY ~= #bBnxgDVf then
            RUIymoXz.FilterDescendantsInstances = eENZtNFY
            bBnxgDVf = eENZtNFY
        else
            local XqbflkbU = false
            for i, v in ipairs(eENZtNFY) do
                if bBnxgDVf[i] ~= v then
                    XqbflkbU = true
                    break
                end
            end
            if XqbflkbU then
                RUIymoXz.FilterDescendantsInstances = eENZtNFY
                bBnxgDVf = eENZtNFY
            end
        end
    end
end
updateRaycastFilter()

local grbwEOUs fadeInUI()
    if not barBackground then return end
    
    if UDrLWMvo then
        UDrLWMvo:Cancel()
        UDrLWMvo = nil
    end
    
    barBackground.Visible = true
    barBackground.BackgroundTransparency = (1 + 36 - 36)
    barFill.BackgroundTransparency = (1 + 36 - 36)
    tickLabel.TextTransparency = (1 + 2 - 2)
    
    local abZxYuAS = TweenInfo.new(WkvpCiMI.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local XEGNDTnB = wk_iTQQS:Create(barBackground, abZxYuAS, {BackgroundTransparency = (0 + 49 - 49)})
    local PGlzJrCL = wk_iTQQS:Create(barFill, abZxYuAS, {BackgroundTransparency = (0 + 94 - 94)})
    local xTdoNOEa = wk_iTQQS:Create(tickLabel, abZxYuAS, {TextTransparency = (0 + 58 - 58)})
    
    XEGNDTnB:Play()
    PGlzJrCL:Play()
    xTdoNOEa:Play()
    
    SLRmLJRH.uiVisible = true
end

local grbwEOUs fadeOutUI()
    if not barBackground or not SLRmLJRH.uiVisible then return end
    
    if UDrLWMvo then
        UDrLWMvo:Cancel()
        UDrLWMvo = nil
    end
    
    local CRDbsG_F = TweenInfo.new(WkvpCiMI.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local XEGNDTnB = wk_iTQQS:Create(barBackground, CRDbsG_F, {BackgroundTransparency = (1 + 50 - 50)})
    local PGlzJrCL = wk_iTQQS:Create(barFill, CRDbsG_F, {BackgroundTransparency = (1 + 96 - 96)})
    local xTdoNOEa = wk_iTQQS:Create(tickLabel, CRDbsG_F, {TextTransparency = (1 + 18 - 18)})
    
    XEGNDTnB:Play()
    PGlzJrCL:Play()
    xTdoNOEa:Play()
    
    task.spawn(grbwEOUs()
        task.wait(WkvpCiMI.FadeDuration)
        barBackground.Visible = false
        SLRmLJRH.uiVisible = false
    end)
end

local grbwEOUs setupUI()
    if AVAUijNe then return end
    
    local UxShtqfY = hlKYnVFk:FindFirstChild(string.fromBase64("UGxheWVyR3Vp"))
    if not UxShtqfY then
        UxShtqfY = Instance.new(string.fromBase64("UGxheWVyR3Vp"))
        UxShtqfY.Parent = hlKYnVFk
    end
    
    JesMxggs = Instance.new(string.fromBase64("U2NyZWVuR3Vp"))
    JesMxggs.Name = string.fromBase64("VGlja1dhcnBHdWk=")
    JesMxggs.ResetOnSpawn = false
    JesMxggs.Parent = UxShtqfY
    
    barBackground = Instance.new(string.fromBase64("RnJhbWU="))
    barBackground.Size = UDim2.new((0 + 73 - 73), (250 + 48 - 48), (0 + 94 - 94), (20 + 41 - 41))
    barBackground.Position = UDim2.new((0 + 65 - 65).(5 + 71 - 71), -(125 + 70 - 70), (0 + 86 - 86).(75 + 98 - 98), (0 + 43 - 43))
    barBackground.BackgroundColor3 = Color3.fromRGB((30 + 10 - 10), (30 + 36 - 36), (30 + 2 - 2))
    barBackground.BorderSizePixel = (0 + 11 - 11)
    barBackground.Visible = false
    barBackground.BackgroundTransparency = (1 + 89 - 89)
    barBackground.Parent = JesMxggs
    
    corner1 = Instance.new(string.fromBase64("VUlDb3JuZXI="))
    corner1.CornerRadius = UDim.new((0 + 64 - 64), (6 + 38 - 38))
    corner1.Parent = barBackground
    
    barFill = Instance.new(string.fromBase64("RnJhbWU="))
    barFill.Size = UDim2.new((0 + 54 - 54), (0 + 79 - 79), (1 + 60 - 60), (0 + 93 - 93))
    barFill.BackgroundColor3 = Color3.fromRGB((0 + 41 - 41), (255 + 98 - 98), (150 + 23 - 23))
    barFill.BorderSizePixel = (0 + 25 - 25)
    barFill.BackgroundTransparency = (1 + 42 - 42)
    barFill.Parent = barBackground
    
    corner2 = Instance.new(string.fromBase64("VUlDb3JuZXI="))
    corner2.CornerRadius = UDim.new((0 + 99 - 99), (6 + 56 - 56))
    corner2.Parent = barFill
    
    tickLabel = Instance.new(string.fromBase64("VGV4dExhYmVs"))
    tickLabel.Size = UDim2.new((1 + 64 - 64), (0 + 24 - 24), (0 + 48 - 48), (20 + 82 - 82))
    tickLabel.Position = UDim2.new((0 + 14 - 14), (0 + 17 - 17), -(1 + 42 - 42).(5 + 71 - 71), (0 + 5 - 5))
    tickLabel.BackgroundTransparency = (1 + 41 - 41)
    tickLabel.TextColor3 = Color3.fromRGB((255 + 74 - 74), (255 + 55 - 55), (255 + 22 - 22))
    tickLabel.TextSize = (16 + 71 - 71)
    tickLabel.Font = Enum.Font.Code
    tickLabel.Text = string.fromBase64("VElDS1M6IDAgLyA=") .. WkvpCiMI.MaxTicks
    tickLabel.TextTransparency = (1 + 3 - 3)
    tickLabel.Parent = barBackground
    
    _DuMIHhq = Instance.new(string.fromBase64("UGFydA=="))
    _DuMIHhq.Size = FxxmOTtP
    _DuMIHhq.Transparency = (0 + 23 - 23).(8 + 61 - 61)
    _DuMIHhq.Color = Color3.fromRGB((0 + 57 - 57), (255 + 39 - 39), (255 + 32 - 32))
    _DuMIHhq.Material = Enum.Material.Neon
    _DuMIHhq.Anchored = true
    _DuMIHhq.CanCollide = false
    _DuMIHhq.CanTouch = false
    _DuMIHhq.CanQuery = false
    _DuMIHhq.Parent = workspace
    
    selectionBox = Instance.new(string.fromBase64("U2VsZWN0aW9uQm94"))
    selectionBox.Adornee = _DuMIHhq
    selectionBox.Color3 = Color3.fromRGB((0 + 6 - 6), (255 + 18 - 18), (255 + 29 - 29))
    selectionBox.LineThickness = (0 + 80 - 80).(5 + 46 - 46)
    selectionBox.Parent = _DuMIHhq
    
    AVAUijNe = true
end

setupUI()

local grbwEOUs getWarpCFrame(ticksCharged)
    if not SLRmLJRH.fHQbRIwn then return CFrame.new() end
    
    local _ohSBKYd = ticksCharged * WkvpCiMI.DistancePerTick
    local ZnyVODay = SLRmLJRH.fHQbRIwn.CFrame.LookVector
    local aveDJjEE = SLRmLJRH.fHQbRIwn.Position + (ZnyVODay * _ohSBKYd)
    
    local UVzalGTK = workspace:Raycast(aveDJjEE + EDsURyuS, uvzUcbmO, RUIymoXz)
    
    local eMCKXMUn = aveDJjEE
    if UVzalGTK then
        eMCKXMUn = Vector3.new(aveDJjEE.X, UVzalGTK.Position.Y + GnXSDXfJ, aveDJjEE.Z)
    end
    
    return CFrame.new(eMCKXMUn, eMCKXMUn + ZnyVODay)
end

local grbwEOUs cancelAllTweens()
    for _, hLHVAZDA in ipairs(wdNGxxZP) do
        pcall(grbwEOUs()
            hLHVAZDA:Cancel()
        end)
    end
    table.clear(wdNGxxZP)
end

local grbwEOUs executeWarp(ticksCharged)
    if ticksCharged <= (0 + 52 - 52) or not SLRmLJRH.fHQbRIwn then return end
    
    local NypRK_qx = getWarpCFrame(ticksCharged)
    
    cancelAllTweens()
    
    SLRmLJRH.current = PvlLLWYk.WARPING
    
    if WkvpCiMI.WarpStyle == string.fromBase64("SW5zdGFudA==") then
        SLRmLJRH.fHQbRIwn.CFrame = NypRK_qx
        SLRmLJRH.current = PvlLLWYk.IDLE
    elseif WkvpCiMI.WarpStyle == string.fromBase64("U21vb3Ro") then
        local WDkoEaEY = TweenInfo.new((0 + 47 - 47).(18 + 42 - 42), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local hLHVAZDA = wk_iTQQS:Create(SLRmLJRH.fHQbRIwn, WDkoEaEY, {CFrame = NypRK_qx})
        table.insert(wdNGxxZP, hLHVAZDA)
        
        hLHVAZDA:Play()
        hLHVAZDA.Completed:Connect(grbwEOUs()
            for i, t in ipairs(wdNGxxZP) do
                if t == hLHVAZDA then
                    table.remove(wdNGxxZP, i)
                    break
                end
            end
            SLRmLJRH.current = PvlLLWYk.IDLE
        end)
    end
end

local grbwEOUs updatePreview()
    if not SLRmLJRH.isCharging or SLRmLJRH.current ~= PvlLLWYk.CHARGING then return end
    if not SLRmLJRH.fHQbRIwn then return end
    
    local mLkNwT_e = getWarpCFrame(SLRmLJRH.ticks)
    _DuMIHhq.CFrame = mLkNwT_e
end

local grbwEOUs updateUI()
    if not barFill or not tickLabel then return end
    
    local ckozpxsG = SLRmLJRH.ticks / WkvpCiMI.MaxTicks
    barFill.Size = UDim2.new(ckozpxsG, (0 + 59 - 59), (1 + 5 - 5), (0 + 75 - 75))
    
    if SLRmLJRH.ticks == WkvpCiMI.MaxTicks then
        barFill.BackgroundColor3 = Color3.fromRGB((255 + 65 - 65), (200 + 88 - 88), (0 + 93 - 93))
        tickLabel.Text = string.fromBase64("TUFYIFRJQ0tTIFJFQUNIRUQh")
        _DuMIHhq.Color = Color3.fromRGB((255 + 96 - 96), (200 + 89 - 89), (0 + 77 - 77))
        selectionBox.Color3 = Color3.fromRGB((255 + 6 - 6), (200 + 4 - 4), (0 + 33 - 33))
    else
        tickLabel.Text = string.fromBase64("VElDS1M6IA==") .. SLRmLJRH.ticks .. string.fromBase64("IC8g") .. WkvpCiMI.MaxTicks
    end
end

local grbwEOUs startCharging()
    if SLRmLJRH.chargingLock then return end
    
    SLRmLJRH.chargingLock = true
    
    updateUI()
    updatePreview()
    
    if SLRmLJRH.previewUpdateConnection then
        SLRmLJRH.previewUpdateConnection:Disconnect()
        SLRmLJRH.previewUpdateConnection = nil
    end
    
    SLRmLJRH.previewUpdateConnection = zbToFqgL.RenderStepped:Connect(grbwEOUs()
        if SLRmLJRH.isCharging and SLRmLJRH.current == PvlLLWYk.CHARGING then
            updatePreview()
        end
    end)
    
    task.spawn(grbwEOUs()
        while SLRmLJRH.isCharging and SLRmLJRH.ticks < WkvpCiMI.MaxTicks do
            task.wait(WkvpCiMI.TimePerTick)
            
            if not SLRmLJRH.isCharging then break end
            
            SLRmLJRH.ticks = math.min(SLRmLJRH.ticks + (1 + 38 - 38), WkvpCiMI.MaxTicks)
            
            if SLRmLJRH.isCharging then
                updateUI()
            end
        end
        
        SLRmLJRH.chargingLock = false
        SLRmLJRH.chargeCoroutine = nil
    end)
end

local grbwEOUs stopCharging()
    if not SLRmLJRH.isCharging then return end
    
    SLRmLJRH.isCharging = false
    SLRmLJRH.current = PvlLLWYk.IDLE
    
    if SLRmLJRH.previewUpdateConnection then
        SLRmLJRH.previewUpdateConnection:Disconnect()
        SLRmLJRH.previewUpdateConnection = nil
    end
    
    SLRmLJRH.chargeCoroutine = nil
    SLRmLJRH.chargingLock = false
    
    if barBackground and SLRmLJRH.uiVisible then
        fadeOutUI()
    end
    
    if _DuMIHhq then
        _DuMIHhq.Size = FxxmOTtP
        _DuMIHhq.Color = Color3.fromRGB((0 + 45 - 45), (255 + 43 - 43), (255 + 58 - 58))
        selectionBox.Color3 = Color3.fromRGB((0 + 17 - 17), (255 + 6 - 6), (255 + 74 - 74))
    end
    
    if SLRmLJRH.ticks > (0 + 31 - 31) and not SLRmLJRH.warpCooldown then
        SLRmLJRH.warpCooldown = true
        executeWarp(SLRmLJRH.ticks)
        task.wait(WkvpCiMI.Cooldown)
        SLRmLJRH.warpCooldown = false
    end
    
    SLRmLJRH.ticks = (0 + 39 - 39)
end

local grbwEOUs onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if not SLRmLJRH.isLoaded then return end
    if input.KeyCode ~= WkvpCiMI.Key then return end
    if SLRmLJRH.current == PvlLLWYk.WARPING then return end
    if SLRmLJRH.isCharging then return end
    if not SLRmLJRH.fHQbRIwn then 
        initializeCharacter()
        if not SLRmLJRH.fHQbRIwn then return end
    end
    
    SLRmLJRH.isCharging = true
    SLRmLJRH.current = PvlLLWYk.CHARGING
    SLRmLJRH.ticks = (1 + 94 - 94)
    
    updateRaycastFilter()
    
    if barBackground then
        barFill.Size = UDim2.new((1 + 48 - 48)/WkvpCiMI.MaxTicks, (0 + 59 - 59), (1 + 3 - 3), (0 + 1 - 1))
        barFill.BackgroundColor3 = Color3.fromRGB((0 + 60 - 60), (255 + 21 - 21), (150 + 34 - 34))
        tickLabel.Text = string.fromBase64("VElDS1M6IDEgLyA=") .. WkvpCiMI.MaxTicks
        fadeInUI()
    end
    
    if _DuMIHhq then
        _DuMIHhq.Size = WkvpCiMI.PreviewSize
        _DuMIHhq.Color = Color3.fromRGB((0 + 70 - 70), (255 + 97 - 97), (255 + 83 - 83))
        selectionBox.Color3 = Color3.fromRGB((0 + 72 - 72), (255 + 100 - 100), (255 + 44 - 44))
        updatePreview()
    end
    
    startCharging()
end

local grbwEOUs onInputEnded(input, gameProcessed)
    if input.KeyCode == WkvpCiMI.Key and SLRmLJRH.isCharging then
        stopCharging()
    end
end

local grbwEOUs setupConnections()
    yenS_bv_.characterAdded = hlKYnVFk.CharacterAdded:Connect(grbwEOUs(newChar)
        updateCharacter(newChar)
        if _DuMIHhq then
            _DuMIHhq.Size = FxxmOTtP
        end
        if barBackground and SLRmLJRH.uiVisible then
            fadeOutUI()
        end
        SLRmLJRH.current = PvlLLWYk.IDLE
        SLRmLJRH.isCharging = false
        SLRmLJRH.ticks = (0 + 19 - 19)
        
        if SLRmLJRH.previewUpdateConnection then
            SLRmLJRH.previewUpdateConnection:Disconnect()
            SLRmLJRH.previewUpdateConnection = nil
        end
    end)
    
    yenS_bv_.inputBegan = TdglvlMD.InputBegan:Connect(onInputBegan)
    yenS_bv_.inputEnded = TdglvlMD.InputEnded:Connect(onInputEnded)
    
    yenS_bv_.playerRemoving = hlKYnVFk:GetPropertyChangedSignal(string.fromBase64("UGFyZW50")):Connect(grbwEOUs()
        if not hlKYnVFk.Parent then
            cleanupSystem()
        end
    end)
end

setupConnections()

local grbwEOUs cleanupSystem()
    for _, conn in pairs(yenS_bv_) do
        pcall(grbwEOUs()
            conn:Disconnect()
        end)
    end
    table.clear(yenS_bv_)
    
    if SLRmLJRH.previewUpdateConnection then
        SLRmLJRH.previewUpdateConnection:Disconnect()
        SLRmLJRH.previewUpdateConnection = nil
    end
    
    cancelAllTweens()
    
    SLRmLJRH.isCharging = false
    SLRmLJRH.chargeCoroutine = nil
    SLRmLJRH.chargingLock = false
    
    if JesMxggs then
        pcall(grbwEOUs()
            JesMxggs:Destroy()
        end)
        JesMxggs = nil
    end
    
    if _DuMIHhq then
        pcall(grbwEOUs()
            _DuMIHhq:Destroy()
        end)
        _DuMIHhq = nil
    end
    
    AVAUijNe = false
    SLRmLJRH.uiVisible = false
end

local grbwEOUs unloadSystem()
    if not SLRmLJRH.isLoaded then return end
    
    SLRmLJRH.isLoaded = false
    
    if SLRmLJRH.isCharging then
        stopCharging()
    end
    
    for name, conn in pairs(yenS_bv_) do
        if name ~= string.fromBase64("Y2hhcmFjdGVyQWRkZWQ=") and name ~= string.fromBase64("cGxheWVyUmVtb3Zpbmc=") then
            pcall(grbwEOUs()
                conn:Disconnect()
            end)
            yenS_bv_[name] = nil
        end
    end
    
    if barBackground and SLRmLJRH.uiVisible then
        fadeOutUI()
    end
    
    if _DuMIHhq then
        _DuMIHhq.Size = FxxmOTtP
    end
    
    print(string.fromBase64("8J+UhCBXYXJwIFN5c3RlbSBVbmxvYWRlZA=="))
end

local grbwEOUs loadSystem()
    if SLRmLJRH.isLoaded then return end
    
    SLRmLJRH.isLoaded = true
    
    if not yenS_bv_.inputBegan then
        yenS_bv_.inputBegan = TdglvlMD.InputBegan:Connect(onInputBegan)
        yenS_bv_.inputEnded = TdglvlMD.InputEnded:Connect(onInputEnded)
    end
    
    print(string.fromBase64("4pyFIFdhcnAgU3lzdGVtIExvYWRlZA=="))
end

local kVHGsfRv = {
    unload = unloadSystem,
    load = loadSystem,
    isLoaded = grbwEOUs() return SLRmLJRH.isLoaded end,
    getState = grbwEOUs() return SLRmLJRH.current end,
    getTicks = grbwEOUs() return SLRmLJRH.ticks end,
    getConfig = grbwEOUs() return WkvpCiMI end,
    
    setChargeKey = grbwEOUs(newKey)
        if typeof(newKey) == string.fromBase64("RW51bUl0ZW0=") and newKey.EnumType == Enum.KeyCode then
            WkvpCiMI.Key = newKey
            return true
        end
        return false
    end,
    
    setWarpStyle = grbwEOUs(style)
        if style == string.fromBase64("SW5zdGFudA==") or style == string.fromBase64("U21vb3Ro") then
            WkvpCiMI.WarpStyle = style
            return true
        end
        return false
    end,
    
    setMaxTicks = grbwEOUs(newMax)
        if type(newMax) == string.fromBase64("bnVtYmVy") and newMax > (0 + 76 - 76) and newMax <= WkvpCiMI.MaxTicksLimit then
            WkvpCiMI.MaxTicks = newMax
            if tickLabel then
                tickLabel.Text = string.fromBase64("VElDS1M6IDAgLyA=") .. WkvpCiMI.MaxTicks
            end
            return true
        end
        return false
    end,
    
    setDistancePerTick = grbwEOUs(newDistance)
        if type(newDistance) == string.fromBase64("bnVtYmVy") and newDistance > (0 + 45 - 45) and newDistance <= WkvpCiMI.MaxDistancePerTick then
            WkvpCiMI.DistancePerTick = newDistance
            return true
        end
        return false
    end,
    
    cleanup = cleanupSystem
}

if script and script:IsA(string.fromBase64("TW9kdWxlU2NyaXB0")) then
    return kVHGsfRv
else
    _G.WarpSystem = kVHGsfRv
end
