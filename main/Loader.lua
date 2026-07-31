

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ⚙️ CONFIGURATION SYSTEM
local Config = {
    Key = Enum.KeyCode.E,
    MaxTicks = 10,
    TimePerTick = 0.15,
    DistancePerTick = 8,
    WarpStyle = "Smooth",
    Cooldown = 0.1,
    PreviewSize = Vector3.new(3, 5, 3),
    FadeDuration = 0.3,
    MinTimePerTick = 0.05,
    MaxTicksLimit = 50,
    MaxDistancePerTick = 100,
    
    validate = function(self)
        assert(self.MaxTicks > 0 and self.MaxTicks <= self.MaxTicksLimit, 
            string.format("MaxTicks must be between 1-%d", self.MaxTicksLimit))
        assert(self.TimePerTick >= self.MinTimePerTick, 
            "TimePerTick too small, minimum is " .. self.MinTimePerTick)
        assert(self.DistancePerTick > 0 and self.DistancePerTick <= self.MaxDistancePerTick, 
            string.format("DistancePerTick must be between 1-%d", self.MaxDistancePerTick))
        assert(self.WarpStyle == "Instant" or self.WarpStyle == "Smooth", 
            "Invalid WarpStyle, must be 'Instant' or 'Smooth'")
        assert(self.Cooldown >= 0, "Cooldown must be positive")
        return true
    end
}

Config:validate()

-- ⚙️ INTERNAL CONSTANTS
local HALF_CHARACTER_HEIGHT = 2.5
local RAY_OFFSET = Vector3.new(0, 5, 0)
local RAY_DIRECTION = Vector3.new(0, -20, 0)
local HIDDEN_SIZE = Vector3.new(0, 0, 0)

-- 🔄 STATE MANAGEMENT
local WarpState = {
    IDLE = "IDLE",
    CHARGING = "CHARGING",
    WARPING = "WARPING"
}

local state = {
    current = WarpState.IDLE,
    ticks = 0,
    isCharging = false,
    lastPreviewPosition = Vector3.new(),
    chargeCoroutine = nil,
    warpCooldown = false,
    character = nil,
    hrp = nil,
    isLoaded = true,
    uiVisible = false,
    chargingLock = false,
    previewUpdateConnection = nil -- For continuous updates
}

-- 🔌 CONNECTION MANAGEMENT
local connections = {}
local activeTweens = {}

-- 📺 CACHED UI ELEMENTS
local screenGui, barBackground, barFill, tickLabel, corner1, corner2
local previewPart, selectionBox
local uiSetupDone = false
local fadeTween = nil

-- 🎯 CHARACTER MANAGEMENT
local function isCharacterValid(character)
    if not character then return false end
    if character:GetAttribute("Disabled") then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    return true
end

local function getCharacter()
    local char = player.Character
    if not char then 
        return nil
    end
    
    if not isCharacterValid(char) then
        return nil
    end
    
    return char
end

local function updateCharacter(newChar)
    if newChar and isCharacterValid(newChar) then
        state.character = newChar
        state.hrp = newChar:FindFirstChild("HumanoidRootPart")
        return true
    end
    return false
end

local function initializeCharacter()
    local char = getCharacter()
    if char then
        updateCharacter(char)
        return true
    else
        local success, newChar = pcall(function()
            return player.CharacterAdded:Wait()
        end)
        if success and newChar then
            return updateCharacter(newChar)
        end
    end
    return false
end

initializeCharacter()

-- 🧮 CACHED RAYCAST PARAMS
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local filterCache = {}

local function updateRaycastFilter()
    if state.character and previewPart then
        local newFilter = {state.character, previewPart}
        if #newFilter ~= #filterCache then
            raycastParams.FilterDescendantsInstances = newFilter
            filterCache = newFilter
        else
            local different = false
            for i, v in ipairs(newFilter) do
                if filterCache[i] ~= v then
                    different = true
                    break
                end
            end
            if different then
                raycastParams.FilterDescendantsInstances = newFilter
                filterCache = newFilter
            end
        end
    end
end
updateRaycastFilter()

-- 📺 UI FADE FUNCTIONS
local function fadeInUI()
    if not barBackground then return end
    
    if fadeTween then
        fadeTween:Cancel()
        fadeTween = nil
    end
    
    barBackground.Visible = true
    barBackground.BackgroundTransparency = 1
    barFill.BackgroundTransparency = 1
    tickLabel.TextTransparency = 1
    
    local fadeInTweenInfo = TweenInfo.new(Config.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local tween1 = TweenService:Create(barBackground, fadeInTweenInfo, {BackgroundTransparency = 0})
    local tween2 = TweenService:Create(barFill, fadeInTweenInfo, {BackgroundTransparency = 0})
    local tween3 = TweenService:Create(tickLabel, fadeInTweenInfo, {TextTransparency = 0})
    
    tween1:Play()
    tween2:Play()
    tween3:Play()
    
    state.uiVisible = true
end

local function fadeOutUI()
    if not barBackground or not state.uiVisible then return end
    
    if fadeTween then
        fadeTween:Cancel()
        fadeTween = nil
    end
    
    local fadeOutTweenInfo = TweenInfo.new(Config.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local tween1 = TweenService:Create(barBackground, fadeOutTweenInfo, {BackgroundTransparency = 1})
    local tween2 = TweenService:Create(barFill, fadeOutTweenInfo, {BackgroundTransparency = 1})
    local tween3 = TweenService:Create(tickLabel, fadeOutTweenInfo, {TextTransparency = 1})
    
    tween1:Play()
    tween2:Play()
    tween3:Play()
    
    task.spawn(function()
        task.wait(Config.FadeDuration)
        barBackground.Visible = false
        state.uiVisible = false
    end)
end

-- 📺 UI SETUP
local function setupUI()
    if uiSetupDone then return end
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        playerGui = Instance.new("PlayerGui")
        playerGui.Parent = player
    end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TickWarpGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    barBackground = Instance.new("Frame")
    barBackground.Size = UDim2.new(0, 250, 0, 20)
    barBackground.Position = UDim2.new(0.5, -125, 0.75, 0)
    barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    barBackground.BorderSizePixel = 0
    barBackground.Visible = false
    barBackground.BackgroundTransparency = 1
    barBackground.Parent = screenGui
    
    corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 6)
    corner1.Parent = barBackground
    
    barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    barFill.BorderSizePixel = 0
    barFill.BackgroundTransparency = 1
    barFill.Parent = barBackground
    
    corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 6)
    corner2.Parent = barFill
    
    tickLabel = Instance.new("TextLabel")
    tickLabel.Size = UDim2.new(1, 0, 0, 20)
    tickLabel.Position = UDim2.new(0, 0, -1.5, 0)
    tickLabel.BackgroundTransparency = 1
    tickLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    tickLabel.TextSize = 16
    tickLabel.Font = Enum.Font.Code
    tickLabel.Text = "TICKS: 0 / " .. Config.MaxTicks
    tickLabel.TextTransparency = 1
    tickLabel.Parent = barBackground
    
    previewPart = Instance.new("Part")
    previewPart.Size = HIDDEN_SIZE
    previewPart.Transparency = 0.8
    previewPart.Color = Color3.fromRGB(0, 255, 255)
    previewPart.Material = Enum.Material.Neon
    previewPart.Anchored = true
    previewPart.CanCollide = false
    previewPart.CanTouch = false
    previewPart.CanQuery = false
    previewPart.Parent = workspace
    
    selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = previewPart
    selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
    selectionBox.LineThickness = 0.05
    selectionBox.Parent = previewPart
    
    uiSetupDone = true
end

setupUI()

-- 🧮 CALCULATION LOGIC
local function getWarpCFrame(ticksCharged)
    if not state.hrp then return CFrame.new() end
    
    local totalDistance = ticksCharged * Config.DistancePerTick
    local forwardDirection = state.hrp.CFrame.LookVector
    local targetPosition = state.hrp.Position + (forwardDirection * totalDistance)
    
    local raycastResult = workspace:Raycast(targetPosition + RAY_OFFSET, RAY_DIRECTION, raycastParams)
    
    local finalPos = targetPosition
    if raycastResult then
        finalPos = Vector3.new(targetPosition.X, raycastResult.Position.Y + HALF_CHARACTER_HEIGHT, targetPosition.Z)
    end
    
    return CFrame.new(finalPos, finalPos + forwardDirection)
end

-- 🚀 WARP MECHANICS
local function cancelAllTweens()
    for _, tween in ipairs(activeTweens) do
        pcall(function()
            tween:Cancel()
        end)
    end
    table.clear(activeTweens)
end

local function executeWarp(ticksCharged)
    if ticksCharged <= 0 or not state.hrp then return end
    
    local endCFrame = getWarpCFrame(ticksCharged)
    
    cancelAllTweens()
    
    state.current = WarpState.WARPING
    
    if Config.WarpStyle == "Instant" then
        state.hrp.CFrame = endCFrame
        state.current = WarpState.IDLE
    elseif Config.WarpStyle == "Smooth" then
        local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(state.hrp, tweenInfo, {CFrame = endCFrame})
        table.insert(activeTweens, tween)
        
        tween:Play()
        tween.Completed:Connect(function()
            for i, t in ipairs(activeTweens) do
                if t == tween then
                    table.remove(activeTweens, i)
                    break
                end
            end
            state.current = WarpState.IDLE
        end)
    end
end

-- 🔄 UPDATE PREVIEW (INSTANT - NOW WITH CONTINUOUS UPDATES)
local function updatePreview()
    if not state.isCharging or state.current ~= WarpState.CHARGING then return end
    if not state.hrp then return end
    
    -- Use current ticks for preview position
    local newCFrame = getWarpCFrame(state.ticks)
    previewPart.CFrame = newCFrame
end

-- 📊 UPDATE UI
local function updateUI()
    if not barFill or not tickLabel then return end
    
    local ratio = state.ticks / Config.MaxTicks
    barFill.Size = UDim2.new(ratio, 0, 1, 0)
    
    if state.ticks == Config.MaxTicks then
        barFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        tickLabel.Text = "MAX TICKS REACHED!"
        previewPart.Color = Color3.fromRGB(255, 200, 0)
        selectionBox.Color3 = Color3.fromRGB(255, 200, 0)
    else
        tickLabel.Text = "TICKS: " .. state.ticks .. " / " .. Config.MaxTicks
    end
end

-- 🔄 START CHARGING
local function startCharging()
    if state.chargingLock then return end
    
    state.chargingLock = true
    
    -- Update first tick immediately
    updateUI()
    updatePreview()
    
    -- 🔥 START CONTINUOUS PREVIEW UPDATES
    -- This runs on RenderStepped for smooth updates while moving
    if state.previewUpdateConnection then
        state.previewUpdateConnection:Disconnect()
        state.previewUpdateConnection = nil
    end
    
    state.previewUpdateConnection = RunService.RenderStepped:Connect(function()
        if state.isCharging and state.current == WarpState.CHARGING then
            updatePreview()
        end
    end)
    
    task.spawn(function()
        while state.isCharging and state.ticks < Config.MaxTicks do
            task.wait(Config.TimePerTick)
            
            if not state.isCharging then break end
            
            state.ticks = math.min(state.ticks + 1, Config.MaxTicks)
            
            if state.isCharging then
                updateUI()
                -- Preview will be updated by RenderStepped
            end
        end
        
        state.chargingLock = false
        state.chargeCoroutine = nil
    end)
end

-- 🛑 STOP CHARGING
local function stopCharging()
    if not state.isCharging then return end
    
    state.isCharging = false
    state.current = WarpState.IDLE
    
    -- Stop continuous preview updates
    if state.previewUpdateConnection then
        state.previewUpdateConnection:Disconnect()
        state.previewUpdateConnection = nil
    end
    
    state.chargeCoroutine = nil
    state.chargingLock = false
    
    if barBackground and state.uiVisible then
        fadeOutUI()
    end
    
    if previewPart then
        previewPart.Size = HIDDEN_SIZE
        previewPart.Color = Color3.fromRGB(0, 255, 255)
        selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
    end
    
    if state.ticks > 0 and not state.warpCooldown then
        state.warpCooldown = true
        executeWarp(state.ticks)
        task.wait(Config.Cooldown)
        state.warpCooldown = false
    end
    
    state.ticks = 0
end

-- 🖱️ INPUT HANDLING
local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if not state.isLoaded then return end
    if input.KeyCode ~= Config.Key then return end
    if state.current == WarpState.WARPING then return end
    if state.isCharging then return end
    if not state.hrp then 
        initializeCharacter()
        if not state.hrp then return end
    end
    
    state.isCharging = true
    state.current = WarpState.CHARGING
    state.ticks = 1
    
    updateRaycastFilter()
    
    if barBackground then
        barFill.Size = UDim2.new(1/Config.MaxTicks, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        tickLabel.Text = "TICKS: 1 / " .. Config.MaxTicks
        fadeInUI()
    end
    
    if previewPart then
        previewPart.Size = Config.PreviewSize
        previewPart.Color = Color3.fromRGB(0, 255, 255)
        selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
        updatePreview()
    end
    
    startCharging()
end

local function onInputEnded(input, gameProcessed)
    if input.KeyCode == Config.Key and state.isCharging then
        stopCharging()
    end
end

-- 🔌 SETUP CONNECTIONS
local function setupConnections()
    connections.characterAdded = player.CharacterAdded:Connect(function(newChar)
        updateCharacter(newChar)
        if previewPart then
            previewPart.Size = HIDDEN_SIZE
        end
        if barBackground and state.uiVisible then
            fadeOutUI()
        end
        state.current = WarpState.IDLE
        state.isCharging = false
        state.ticks = 0
        
        -- Clean up preview connection
        if state.previewUpdateConnection then
            state.previewUpdateConnection:Disconnect()
            state.previewUpdateConnection = nil
        end
    end)
    
    connections.inputBegan = UserInputService.InputBegan:Connect(onInputBegan)
    connections.inputEnded = UserInputService.InputEnded:Connect(onInputEnded)
    
    connections.playerRemoving = player:GetPropertyChangedSignal("Parent"):Connect(function()
        if not player.Parent then
            cleanupSystem()
        end
    end)
end

setupConnections()

-- 🧹 CLEANUP SYSTEM
local function cleanupSystem()
    for _, conn in pairs(connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    table.clear(connections)
    
    if state.previewUpdateConnection then
        state.previewUpdateConnection:Disconnect()
        state.previewUpdateConnection = nil
    end
    
    cancelAllTweens()
    
    state.isCharging = false
    state.chargeCoroutine = nil
    state.chargingLock = false
    
    if screenGui then
        pcall(function()
            screenGui:Destroy()
        end)
        screenGui = nil
    end
    
    if previewPart then
        pcall(function()
            previewPart:Destroy()
        end)
        previewPart = nil
    end
    
    uiSetupDone = false
    state.uiVisible = false
end

-- 📦 UNLOAD/LOAD SYSTEM
local function unloadSystem()
    if not state.isLoaded then return end
    
    state.isLoaded = false
    
    if state.isCharging then
        stopCharging()
    end
    
    for name, conn in pairs(connections) do
        if name ~= "characterAdded" and name ~= "playerRemoving" then
            pcall(function()
                conn:Disconnect()
            end)
            connections[name] = nil
        end
    end
    
    if barBackground and state.uiVisible then
        fadeOutUI()
    end
    
    if previewPart then
        previewPart.Size = HIDDEN_SIZE
    end
    
    print("🔄 Warp System Unloaded")
end

local function loadSystem()
    if state.isLoaded then return end
    
    state.isLoaded = true
    
    if not connections.inputBegan then
        connections.inputBegan = UserInputService.InputBegan:Connect(onInputBegan)
        connections.inputEnded = UserInputService.InputEnded:Connect(onInputEnded)
    end
    
    print("✅ Warp System Loaded")
end

-- 🌐 EXPOSE FUNCTIONS
local WarpModule = {
    unload = unloadSystem,
    load = loadSystem,
    isLoaded = function() return state.isLoaded end,
    getState = function() return state.current end,
    getTicks = function() return state.ticks end,
    getConfig = function() return Config end,
    
    setChargeKey = function(newKey)
        if typeof(newKey) == "EnumItem" and newKey.EnumType == Enum.KeyCode then
            Config.Key = newKey
            return true
        end
        return false
    end,
    
    setWarpStyle = function(style)
        if style == "Instant" or style == "Smooth" then
            Config.WarpStyle = style
            return true
        end
        return false
    end,
    
    setMaxTicks = function(newMax)
        if type(newMax) == "number" and newMax > 0 and newMax <= Config.MaxTicksLimit then
            Config.MaxTicks = newMax
            if tickLabel then
                tickLabel.Text = "TICKS: 0 / " .. Config.MaxTicks
            end
            return true
        end
        return false
    end,
    
    setDistancePerTick = function(newDistance)
        if type(newDistance) == "number" and newDistance > 0 and newDistance <= Config.MaxDistancePerTick then
            Config.DistancePerTick = newDistance
            return true
        end
        return false
    end,
    
    cleanup = cleanupSystem
}

if script and script:IsA("ModuleScript") then
    return WarpModule
else
    _G.WarpSystem = WarpModule
end

print("✅ Warp System v2.2 Loaded Successfully! (Continuous Preview Updates)")
print("📊 Settings:")
print("  - Max Ticks: " .. Config.MaxTicks)
print("  - Distance per Tick: " .. Config.DistancePerTick .. " studs")
print("  - Max Distance: " .. (Config.MaxTicks * Config.DistancePerTick) .. " studs")
print("  - Warp Style: " .. Config.WarpStyle)
print("  - Charge Key: " .. tostring(Config.Key))
print("  - Fade Duration: " .. Config.FadeDuration .. "s (Smooth)")
print("\n✨ Preview now updates continuously while charging!")
