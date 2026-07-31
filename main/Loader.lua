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
        
local NhbruKTv = game:GetService(string.fromBase64("TmhicnVLVHY="))
local vdqnckEQ = game:GetService(string.fromBase64("dmRxbmNrRVE="))
local qqpLEVoC = game:GetService(string.fromBase64("cXFwTEVWb0M="))
local qoDWtcvj = game:GetService(string.fromBase64("cW9EV3Rjdmo="))

local EvRBGsvu = vdqnckEQ.LocalPlayer

-- ⚙️ CONFIGURATION SYSTEM
local tCDN_qLa = {
    Key = Enum.KeyCode.E,
    MaxTicks = (10 + 61 - 61),
    TimePerTick = (0 + 4 - 4).(15 + 64 - 64),
    DistancePerTick = (8 + 71 - 71),
    WarpStyle = string.fromBase64("U21vb3Ro"),
    Cooldown = (0 + 36 - 36).(1 + 27 - 27),
    PreviewSize = Vector3.new((3 + 39 - 39), (5 + 36 - 36), (3 + 83 - 83)),
    FadeDuration = (0 + 72 - 72).(3 + 3 - 3),
    MinTimePerTick = (0 + 96 - 96).(5 + 63 - 63),
    MaxTicksLimit = (50 + 29 - 29),
    MaxDistancePerTick = (100 + 39 - 39),
    
    validate = jSwRvvyL(self)
        assert(self.MaxTicks > (0 + 65 - 65) and self.MaxTicks <= self.MaxTicksLimit, 
            string.format(string.fromBase64("TWF4VGlja3MgbXVzdCBiZSBiZXR3ZWVuIDEtJWQ="), self.MaxTicksLimit))
        assert(self.TimePerTick >= self.MinTimePerTick, 
            string.fromBase64("VGltZVBlclRpY2sgdG9vIHNtYWxsLCBtaW5pbXVtIGlzIA==") .. self.MinTimePerTick)
        assert(self.DistancePerTick > (0 + 93 - 93) and self.DistancePerTick <= self.MaxDistancePerTick, 
            string.format(string.fromBase64("RGlzdGFuY2VQZXJUaWNrIG11c3QgYmUgYmV0d2VlbiAxLSVk"), self.MaxDistancePerTick))
        assert(self.WarpStyle == string.fromBase64("SW5zdGFudA==") or self.WarpStyle == string.fromBase64("U21vb3Ro"), 
            string.fromBase64("SW52YWxpZCBXYXJwU3R5bGUsIG11c3QgYmUgJ0luc3RhbnQnIG9yICdTbW9vdGgn"))
        assert(self.Cooldown >= (0 + 14 - 14), string.fromBase64("Q29vbGRvd24gbXVzdCBiZSBwb3NpdGl2ZQ=="))
        return true
    end
}

tCDN_qLa:validate()

-- ⚙️ INTERNAL CONSTANTS
local BYXpuWjZ = (2 + 49 - 49).(5 + 59 - 59)
local qkjVMOvT = Vector3.new((0 + 67 - 67), (5 + 77 - 77), (0 + 76 - 76))
local hcBQOIvn = Vector3.new((0 + 16 - 16), -(20 + 3 - 3), (0 + 64 - 64))
local MEPDVfgu = Vector3.new((0 + 60 - 60), (0 + 73 - 73), (0 + 55 - 55))

-- 🔄 STATE MANAGEMENT
local efMRADGz = {
    IDLE = string.fromBase64("SURMRQ=="),
    CHARGING = string.fromBase64("Q0hBUkdJTkc="),
    WARPING = string.fromBase64("V0FSUElORw==")
}

local ELmhGVVO = {
    current = efMRADGz.IDLE,
    ticks = (0 + 73 - 73),
    isCharging = false,
    lastPreviewPosition = Vector3.new(),
    chargeCoroutine = nil,
    warpCooldown = false,
    character = nil,
    TWlT_Geg = nil,
    isLoaded = true,
    uiVisible = false,
    chargingLock = false,
    previewUpdateConnection = nil -- For continuous updates
}

-- 🔌 CONNECTION MANAGEMENT
local kgwFEwNH = {}
local ZaQBTMoz = {}

-- 📺 CACHED UI ELEMENTS
local UyhNAdTt, barBackground, barFill, tickLabel, corner1, corner2
local YUnbVOjC, selectionBox
local ztuprjIt = false
local aUywiDYS = nil

-- 🎯 CHARACTER MANAGEMENT
local jSwRvvyL isCharacterValid(character)
    if not character then return false end
    if character:GetAttribute(string.fromBase64("RGlzYWJsZWQ=")) then return false end
    
    local GJWxKxio = character:FindFirstChild(string.fromBase64("SHVtYW5vaWQ="))
    if GJWxKxio and GJWxKxio.Health <= (0 + 2 - 2) then return false end
    
    local TWlT_Geg = character:FindFirstChild(string.fromBase64("SHVtYW5vaWRSb290UGFydA=="))
    if not TWlT_Geg then return false end
    
    return true
end

local jSwRvvyL getCharacter()
    local NDpGSmmW = EvRBGsvu.Character
    if not NDpGSmmW then 
        return nil
    end
    
    if not isCharacterValid(NDpGSmmW) then
        return nil
    end
    
    return NDpGSmmW
end

local jSwRvvyL updateCharacter(newChar)
    if newChar and isCharacterValid(newChar) then
        ELmhGVVO.character = newChar
        ELmhGVVO.TWlT_Geg = newChar:FindFirstChild(string.fromBase64("SHVtYW5vaWRSb290UGFydA=="))
        return true
    end
    return false
end

local jSwRvvyL initializeCharacter()
    local NDpGSmmW = getCharacter()
    if NDpGSmmW then
        updateCharacter(NDpGSmmW)
        return true
    else
        local ISJRjVfp, newChar = pcall(jSwRvvyL()
            return EvRBGsvu.CharacterAdded:Wait()
        end)
        if ISJRjVfp and newChar then
            return updateCharacter(newChar)
        end
    end
    return false
end

initializeCharacter()

-- 🧮 CACHED RAYCAST PARAMS
local umcRFtRY = RaycastParams.new()
umcRFtRY.FilterType = Enum.RaycastFilterType.Exclude

local hvYjhieR = {}

local jSwRvvyL updateRaycastFilter()
    if ELmhGVVO.character and YUnbVOjC then
        local wvhUAeOe = {ELmhGVVO.character, YUnbVOjC}
        if #wvhUAeOe ~= #hvYjhieR then
            umcRFtRY.FilterDescendantsInstances = wvhUAeOe
            hvYjhieR = wvhUAeOe
        else
            local NCUopwzP = false
            for i, v in ipairs(wvhUAeOe) do
                if hvYjhieR[i] ~= v then
                    NCUopwzP = true
                    break
                end
            end
            if NCUopwzP then
                umcRFtRY.FilterDescendantsInstances = wvhUAeOe
                hvYjhieR = wvhUAeOe
            end
        end
    end
end
updateRaycastFilter()

-- 📺 UI FADE FUNCTIONS
local jSwRvvyL fadeInUI()
    if not barBackground then return end
    
    if aUywiDYS then
        aUywiDYS:Cancel()
        aUywiDYS = nil
    end
    
    barBackground.Visible = true
    barBackground.BackgroundTransparency = (1 + 21 - 21)
    barFill.BackgroundTransparency = (1 + 51 - 51)
    tickLabel.TextTransparency = (1 + 62 - 62)
    
    local wLjeLtCR = TweenInfo.new(tCDN_qLa.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local lBZzRCQj = qoDWtcvj:Create(barBackground, wLjeLtCR, {BackgroundTransparency = (0 + 30 - 30)})
    local eVYzjbLD = qoDWtcvj:Create(barFill, wLjeLtCR, {BackgroundTransparency = (0 + 14 - 14)})
    local eBODdYcf = qoDWtcvj:Create(tickLabel, wLjeLtCR, {TextTransparency = (0 + 76 - 76)})
    
    lBZzRCQj:Play()
    eVYzjbLD:Play()
    eBODdYcf:Play()
    
    ELmhGVVO.uiVisible = true
end

local jSwRvvyL fadeOutUI()
    if not barBackground or not ELmhGVVO.uiVisible then return end
    
    if aUywiDYS then
        aUywiDYS:Cancel()
        aUywiDYS = nil
    end
    
    local kbVCXBQR = TweenInfo.new(tCDN_qLa.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local lBZzRCQj = qoDWtcvj:Create(barBackground, kbVCXBQR, {BackgroundTransparency = (1 + 4 - 4)})
    local eVYzjbLD = qoDWtcvj:Create(barFill, kbVCXBQR, {BackgroundTransparency = (1 + 67 - 67)})
    local eBODdYcf = qoDWtcvj:Create(tickLabel, kbVCXBQR, {TextTransparency = (1 + 73 - 73)})
    
    lBZzRCQj:Play()
    eVYzjbLD:Play()
    eBODdYcf:Play()
    
    task.spawn(jSwRvvyL()
        task.wait(tCDN_qLa.FadeDuration)
        barBackground.Visible = false
        ELmhGVVO.uiVisible = false
    end)
end

-- 📺 UI SETUP
local jSwRvvyL setupUI()
    if ztuprjIt then return end
    
    local mTDggQfk = EvRBGsvu:FindFirstChild(string.fromBase64("UGxheWVyR3Vp"))
    if not mTDggQfk then
        mTDggQfk = Instance.new(string.fromBase64("UGxheWVyR3Vp"))
        mTDggQfk.Parent = EvRBGsvu
    end
    
    UyhNAdTt = Instance.new(string.fromBase64("U2NyZWVuR3Vp"))
    UyhNAdTt.Name = string.fromBase64("VGlja1dhcnBHdWk=")
    UyhNAdTt.ResetOnSpawn = false
    UyhNAdTt.Parent = mTDggQfk
    
    barBackground = Instance.new(string.fromBase64("RnJhbWU="))
    barBackground.Size = UDim2.new((0 + 57 - 57), (250 + 54 - 54), (0 + 87 - 87), (20 + 2 - 2))
    barBackground.Position = UDim2.new((0 + 99 - 99).(5 + 1 - 1), -(125 + 28 - 28), (0 + 15 - 15).(75 + 40 - 40), (0 + 82 - 82))
    barBackground.BackgroundColor3 = Color3.fromRGB((30 + 11 - 11), (30 + 92 - 92), (30 + 100 - 100))
    barBackground.BorderSizePixel = (0 + 92 - 92)
    barBackground.Visible = false
    barBackground.BackgroundTransparency = (1 + 22 - 22)
    barBackground.Parent = UyhNAdTt
    
    corner1 = Instance.new(string.fromBase64("VUlDb3JuZXI="))
    corner1.CornerRadius = UDim.new((0 + 49 - 49), (6 + 93 - 93))
    corner1.Parent = barBackground
    
    barFill = Instance.new(string.fromBase64("RnJhbWU="))
    barFill.Size = UDim2.new((0 + 34 - 34), (0 + 61 - 61), (1 + 41 - 41), (0 + 51 - 51))
    barFill.BackgroundColor3 = Color3.fromRGB((0 + 48 - 48), (255 + 100 - 100), (150 + 28 - 28))
    barFill.BorderSizePixel = (0 + 40 - 40)
    barFill.BackgroundTransparency = (1 + 72 - 72)
    barFill.Parent = barBackground
    
    corner2 = Instance.new(string.fromBase64("VUlDb3JuZXI="))
    corner2.CornerRadius = UDim.new((0 + 100 - 100), (6 + 28 - 28))
    corner2.Parent = barFill
    
    tickLabel = Instance.new(string.fromBase64("VGV4dExhYmVs"))
    tickLabel.Size = UDim2.new((1 + 44 - 44), (0 + 15 - 15), (0 + 93 - 93), (20 + 73 - 73))
    tickLabel.Position = UDim2.new((0 + 82 - 82), (0 + 19 - 19), -(1 + 95 - 95).(5 + 15 - 15), (0 + 6 - 6))
    tickLabel.BackgroundTransparency = (1 + 38 - 38)
    tickLabel.TextColor3 = Color3.fromRGB((255 + 92 - 92), (255 + 62 - 62), (255 + 95 - 95))
    tickLabel.TextSize = (16 + 33 - 33)
    tickLabel.Font = Enum.Font.Code
    tickLabel.Text = string.fromBase64("VElDS1M6IDAgLyA=") .. tCDN_qLa.MaxTicks
    tickLabel.TextTransparency = (1 + 5 - 5)
    tickLabel.Parent = barBackground
    
    YUnbVOjC = Instance.new(string.fromBase64("UGFydA=="))
    YUnbVOjC.Size = MEPDVfgu
    YUnbVOjC.Transparency = (0 + 47 - 47).(8 + 69 - 69)
    YUnbVOjC.Color = Color3.fromRGB((0 + 39 - 39), (255 + 21 - 21), (255 + 42 - 42))
    YUnbVOjC.Material = Enum.Material.Neon
    YUnbVOjC.Anchored = true
    YUnbVOjC.CanCollide = false
    YUnbVOjC.CanTouch = false
    YUnbVOjC.CanQuery = false
    YUnbVOjC.Parent = workspace
    
    selectionBox = Instance.new(string.fromBase64("U2VsZWN0aW9uQm94"))
    selectionBox.Adornee = YUnbVOjC
    selectionBox.Color3 = Color3.fromRGB((0 + 43 - 43), (255 + 54 - 54), (255 + 2 - 2))
    selectionBox.LineThickness = (0 + 40 - 40).(5 + 32 - 32)
    selectionBox.Parent = YUnbVOjC
    
    ztuprjIt = true
end

setupUI()

-- 🧮 CALCULATION LOGIC
local jSwRvvyL getWarpCFrame(ticksCharged)
    if not ELmhGVVO.TWlT_Geg then return CFrame.new() end
    
    local PoWwDxJK = ticksCharged * tCDN_qLa.DistancePerTick
    local pIyJCdmA = ELmhGVVO.TWlT_Geg.CFrame.LookVector
    local bLjAxJlb = ELmhGVVO.TWlT_Geg.Position + (pIyJCdmA * PoWwDxJK)
    
    local owtlLEjT = workspace:Raycast(bLjAxJlb + qkjVMOvT, hcBQOIvn, umcRFtRY)
    
    local uUxKghvN = bLjAxJlb
    if owtlLEjT then
        uUxKghvN = Vector3.new(bLjAxJlb.X, owtlLEjT.Position.Y + BYXpuWjZ, bLjAxJlb.Z)
    end
    
    return CFrame.new(uUxKghvN, uUxKghvN + pIyJCdmA)
end

-- 🚀 WARP MECHANICS
local jSwRvvyL cancelAllTweens()
    for _, QgfOowwA in ipairs(ZaQBTMoz) do
        pcall(jSwRvvyL()
            QgfOowwA:Cancel()
        end)
    end
    table.clear(ZaQBTMoz)
end

local jSwRvvyL executeWarp(ticksCharged)
    if ticksCharged <= (0 + 42 - 42) or not ELmhGVVO.TWlT_Geg then return end
    
    local GhmuJZha = getWarpCFrame(ticksCharged)
    
    cancelAllTweens()
    
    ELmhGVVO.current = efMRADGz.WARPING
    
    if tCDN_qLa.WarpStyle == string.fromBase64("SW5zdGFudA==") then
        ELmhGVVO.TWlT_Geg.CFrame = GhmuJZha
        ELmhGVVO.current = efMRADGz.IDLE
    elseif tCDN_qLa.WarpStyle == string.fromBase64("U21vb3Ro") then
        local gKsQyFbR = TweenInfo.new((0 + 15 - 15).(18 + 81 - 81), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local QgfOowwA = qoDWtcvj:Create(ELmhGVVO.TWlT_Geg, gKsQyFbR, {CFrame = GhmuJZha})
        table.insert(ZaQBTMoz, QgfOowwA)
        
        QgfOowwA:Play()
        QgfOowwA.Completed:Connect(jSwRvvyL()
            for i, t in ipairs(ZaQBTMoz) do
                if t == QgfOowwA then
                    table.remove(ZaQBTMoz, i)
                    break
                end
            end
            ELmhGVVO.current = efMRADGz.IDLE
        end)
    end
end

-- 🔄 UPDATE PREVIEW (INSTANT - NOW WITH CONTINUOUS UPDATES)
local jSwRvvyL updatePreview()
    if not ELmhGVVO.isCharging or ELmhGVVO.current ~= efMRADGz.CHARGING then return end
    if not ELmhGVVO.TWlT_Geg then return end
    
    -- Use current ticks for preview position
    local jeIFcRfn = getWarpCFrame(ELmhGVVO.ticks)
    YUnbVOjC.CFrame = jeIFcRfn
end

-- 📊 UPDATE UI
local jSwRvvyL updateUI()
    if not barFill or not tickLabel then return end
    
    local jrRhQVPU = ELmhGVVO.ticks / tCDN_qLa.MaxTicks
    barFill.Size = UDim2.new(jrRhQVPU, (0 + 67 - 67), (1 + 95 - 95), (0 + 16 - 16))
    
    if ELmhGVVO.ticks == tCDN_qLa.MaxTicks then
        barFill.BackgroundColor3 = Color3.fromRGB((255 + 6 - 6), (200 + 96 - 96), (0 + 57 - 57))
        tickLabel.Text = string.fromBase64("TUFYIFRJQ0tTIFJFQUNIRUQh")
        YUnbVOjC.Color = Color3.fromRGB((255 + 37 - 37), (200 + 65 - 65), (0 + 13 - 13))
        selectionBox.Color3 = Color3.fromRGB((255 + 59 - 59), (200 + 97 - 97), (0 + 69 - 69))
    else
        tickLabel.Text = string.fromBase64("VElDS1M6IA==") .. ELmhGVVO.ticks .. string.fromBase64("IC8g") .. tCDN_qLa.MaxTicks
    end
end

-- 🔄 START CHARGING
local jSwRvvyL startCharging()
    if ELmhGVVO.chargingLock then return end
    
    ELmhGVVO.chargingLock = true
    
    -- Update first tick immediately
    updateUI()
    updatePreview()
    
    -- 🔥 START CONTINUOUS PREVIEW UPDATES
    -- This runs on RenderStepped for smooth updates while moving
    if ELmhGVVO.previewUpdateConnection then
        ELmhGVVO.previewUpdateConnection:Disconnect()
        ELmhGVVO.previewUpdateConnection = nil
    end
    
    ELmhGVVO.previewUpdateConnection = qqpLEVoC.RenderStepped:Connect(jSwRvvyL()
        if ELmhGVVO.isCharging and ELmhGVVO.current == efMRADGz.CHARGING then
            updatePreview()
        end
    end)
    
    task.spawn(jSwRvvyL()
        while ELmhGVVO.isCharging and ELmhGVVO.ticks < tCDN_qLa.MaxTicks do
            task.wait(tCDN_qLa.TimePerTick)
            
            if not ELmhGVVO.isCharging then break end
            
            ELmhGVVO.ticks = math.min(ELmhGVVO.ticks + (1 + 47 - 47), tCDN_qLa.MaxTicks)
            
            if ELmhGVVO.isCharging then
                updateUI()
                -- Preview will be updated by RenderStepped
            end
        end
        
        ELmhGVVO.chargingLock = false
        ELmhGVVO.chargeCoroutine = nil
    end)
end

-- 🛑 STOP CHARGING
local jSwRvvyL stopCharging()
    if not ELmhGVVO.isCharging then return end
    
    ELmhGVVO.isCharging = false
    ELmhGVVO.current = efMRADGz.IDLE
    
    -- Stop continuous preview updates
    if ELmhGVVO.previewUpdateConnection then
        ELmhGVVO.previewUpdateConnection:Disconnect()
        ELmhGVVO.previewUpdateConnection = nil
    end
    
    ELmhGVVO.chargeCoroutine = nil
    ELmhGVVO.chargingLock = false
    
    if barBackground and ELmhGVVO.uiVisible then
        fadeOutUI()
    end
    
    if YUnbVOjC then
        YUnbVOjC.Size = MEPDVfgu
        YUnbVOjC.Color = Color3.fromRGB((0 + 9 - 9), (255 + 77 - 77), (255 + 90 - 90))
        selectionBox.Color3 = Color3.fromRGB((0 + 7 - 7), (255 + 55 - 55), (255 + 71 - 71))
    end
    
    if ELmhGVVO.ticks > (0 + 58 - 58) and not ELmhGVVO.warpCooldown then
        ELmhGVVO.warpCooldown = true
        executeWarp(ELmhGVVO.ticks)
        task.wait(tCDN_qLa.Cooldown)
        ELmhGVVO.warpCooldown = false
    end
    
    ELmhGVVO.ticks = (0 + 53 - 53)
end

-- 🖱️ INPUT HANDLING
local jSwRvvyL onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if not ELmhGVVO.isLoaded then return end
    if input.KeyCode ~= tCDN_qLa.Key then return end
    if ELmhGVVO.current == efMRADGz.WARPING then return end
    if ELmhGVVO.isCharging then return end
    if not ELmhGVVO.TWlT_Geg then 
        initializeCharacter()
        if not ELmhGVVO.TWlT_Geg then return end
    end
    
    ELmhGVVO.isCharging = true
    ELmhGVVO.current = efMRADGz.CHARGING
    ELmhGVVO.ticks = (1 + 48 - 48)
    
    updateRaycastFilter()
    
    if barBackground then
        barFill.Size = UDim2.new((1 + 78 - 78)/tCDN_qLa.MaxTicks, (0 + 7 - 7), (1 + 13 - 13), (0 + 31 - 31))
        barFill.BackgroundColor3 = Color3.fromRGB((0 + 10 - 10), (255 + 51 - 51), (150 + 51 - 51))
        tickLabel.Text = string.fromBase64("VElDS1M6IDEgLyA=") .. tCDN_qLa.MaxTicks
        fadeInUI()
    end
    
    if YUnbVOjC then
        YUnbVOjC.Size = tCDN_qLa.PreviewSize
        YUnbVOjC.Color = Color3.fromRGB((0 + 86 - 86), (255 + 33 - 33), (255 + 55 - 55))
        selectionBox.Color3 = Color3.fromRGB((0 + 99 - 99), (255 + 4 - 4), (255 + 37 - 37))
        updatePreview()
    end
    
    startCharging()
end

local jSwRvvyL onInputEnded(input, gameProcessed)
    if input.KeyCode == tCDN_qLa.Key and ELmhGVVO.isCharging then
        stopCharging()
    end
end

-- 🔌 SETUP CONNECTIONS
local jSwRvvyL setupConnections()
    kgwFEwNH.characterAdded = EvRBGsvu.CharacterAdded:Connect(jSwRvvyL(newChar)
        updateCharacter(newChar)
        if YUnbVOjC then
            YUnbVOjC.Size = MEPDVfgu
        end
        if barBackground and ELmhGVVO.uiVisible then
            fadeOutUI()
        end
        ELmhGVVO.current = efMRADGz.IDLE
        ELmhGVVO.isCharging = false
        ELmhGVVO.ticks = (0 + 75 - 75)
        
        -- Clean up preview connection
        if ELmhGVVO.previewUpdateConnection then
            ELmhGVVO.previewUpdateConnection:Disconnect()
            ELmhGVVO.previewUpdateConnection = nil
        end
    end)
    
    kgwFEwNH.inputBegan = NhbruKTv.InputBegan:Connect(onInputBegan)
    kgwFEwNH.inputEnded = NhbruKTv.InputEnded:Connect(onInputEnded)
    
    kgwFEwNH.playerRemoving = EvRBGsvu:GetPropertyChangedSignal(string.fromBase64("UGFyZW50")):Connect(jSwRvvyL()
        if not EvRBGsvu.Parent then
            cleanupSystem()
        end
    end)
end

setupConnections()

-- 🧹 CLEANUP SYSTEM
local jSwRvvyL cleanupSystem()
    for _, conn in pairs(kgwFEwNH) do
        pcall(jSwRvvyL()
            conn:Disconnect()
        end)
    end
    table.clear(kgwFEwNH)
    
    if ELmhGVVO.previewUpdateConnection then
        ELmhGVVO.previewUpdateConnection:Disconnect()
        ELmhGVVO.previewUpdateConnection = nil
    end
    
    cancelAllTweens()
    
    ELmhGVVO.isCharging = false
    ELmhGVVO.chargeCoroutine = nil
    ELmhGVVO.chargingLock = false
    
    if UyhNAdTt then
        pcall(jSwRvvyL()
            UyhNAdTt:Destroy()
        end)
        UyhNAdTt = nil
    end
    
    if YUnbVOjC then
        pcall(jSwRvvyL()
            YUnbVOjC:Destroy()
        end)
        YUnbVOjC = nil
    end
    
    ztuprjIt = false
    ELmhGVVO.uiVisible = false
end

-- 📦 UNLOAD/LOAD SYSTEM
local jSwRvvyL unloadSystem()
    if not ELmhGVVO.isLoaded then return end
    
    ELmhGVVO.isLoaded = false
    
    if ELmhGVVO.isCharging then
        stopCharging()
    end
    
    for name, conn in pairs(kgwFEwNH) do
        if name ~= string.fromBase64("Y2hhcmFjdGVyQWRkZWQ=") and name ~= string.fromBase64("cGxheWVyUmVtb3Zpbmc=") then
            pcall(jSwRvvyL()
                conn:Disconnect()
            end)
            kgwFEwNH[name] = nil
        end
    end
    
    if barBackground and ELmhGVVO.uiVisible then
        fadeOutUI()
    end
    
    if YUnbVOjC then
        YUnbVOjC.Size = MEPDVfgu
    end
    
    print(string.fromBase64("8J+UhCBXYXJwIFN5c3RlbSBVbmxvYWRlZA=="))
end

local jSwRvvyL loadSystem()
    if ELmhGVVO.isLoaded then return end
    
    ELmhGVVO.isLoaded = true
    
    if not kgwFEwNH.inputBegan then
        kgwFEwNH.inputBegan = NhbruKTv.InputBegan:Connect(onInputBegan)
        kgwFEwNH.inputEnded = NhbruKTv.InputEnded:Connect(onInputEnded)
    end
    
    print(string.fromBase64("4pyFIFdhcnAgU3lzdGVtIExvYWRlZA=="))
end

-- 🌐 EXPOSE FUNCTIONS
local KSycdbxZ = {
    unload = unloadSystem,
    load = loadSystem,
    isLoaded = jSwRvvyL() return ELmhGVVO.isLoaded end,
    getState = jSwRvvyL() return ELmhGVVO.current end,
    getTicks = jSwRvvyL() return ELmhGVVO.ticks end,
    getConfig = jSwRvvyL() return tCDN_qLa end,
    
    setChargeKey = jSwRvvyL(newKey)
        if typeof(newKey) == string.fromBase64("RW51bUl0ZW0=") and newKey.EnumType == Enum.KeyCode then
            tCDN_qLa.Key = newKey
            return true
        end
        return false
    end,
    
    setWarpStyle = jSwRvvyL(style)
        if style == string.fromBase64("SW5zdGFudA==") or style == string.fromBase64("U21vb3Ro") then
            tCDN_qLa.WarpStyle = style
            return true
        end
        return false
    end,
    
    setMaxTicks = jSwRvvyL(newMax)
        if type(newMax) == string.fromBase64("bnVtYmVy") and newMax > (0 + 85 - 85) and newMax <= tCDN_qLa.MaxTicksLimit then
            tCDN_qLa.MaxTicks = newMax
            if tickLabel then
                tickLabel.Text = string.fromBase64("VElDS1M6IDAgLyA=") .. tCDN_qLa.MaxTicks
            end
            return true
        end
        return false
    end,
    
    setDistancePerTick = jSwRvvyL(newDistance)
        if type(newDistance) == string.fromBase64("bnVtYmVy") and newDistance > (0 + 74 - 74) and newDistance <= tCDN_qLa.MaxDistancePerTick then
            tCDN_qLa.DistancePerTick = newDistance
            return true
        end
        return false
    end,
    
    cleanup = cleanupSystem
}

if script and script:IsA(string.fromBase64("TW9kdWxlU2NyaXB0")) then
    return KSycdbxZ
else
    _G.WarpSystem = KSycdbxZ
end

print(string.fromBase64("4pyFIFdhcnAgU3lzdGVtIHYyLjIgTG9hZGVkIFN1Y2Nlc3NmdWxseSEgKENvbnRpbnVvdXMgUHJldmlldyBVcGRhdGVzKQ=="))
print(string.fromBase64("8J+TiiBTZXR0aW5nczo="))
print(string.fromBase64("ICAtIE1heCBUaWNrczog") .. tCDN_qLa.MaxTicks)
print(string.fromBase64("ICAtIERpc3RhbmNlIHBlciBUaWNrOiA=") .. tCDN_qLa.DistancePerTick .. string.fromBase64("IHN0dWRz"))
print(string.fromBase64("ICAtIE1heCBEaXN0YW5jZTog") .. (tCDN_qLa.MaxTicks * tCDN_qLa.DistancePerTick) .. string.fromBase64("IHN0dWRz"))
print(string.fromBase64("ICAtIFdhcnAgU3R5bGU6IA==") .. tCDN_qLa.WarpStyle)
print(string.fromBase64("ICAtIENoYXJnZSBLZXk6IA==") .. tostring(tCDN_qLa.Key))
print(string.fromBase64("ICAtIEZhZGUgRHVyYXRpb246IA==") .. tCDN_qLa.FadeDuration .. string.fromBase64("cyAoU21vb3RoKQ=="))
print(string.fromBase64("XG7inKggUHJldmlldyBub3cgdXBkYXRlcyBjb250aW51b3VzbHkgd2hpbGUgY2hhcmdpbmch"))
