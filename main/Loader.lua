-- Warp System - Fixed Nil Error
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Terminate any existing instance
if _G.WarpSystem then
    pcall(function()
        _G.WarpSystem:cleanup()
    end)
    _G.WarpSystem = nil
end

-- Check if GUI already exists and destroy it (with nil check)
local playerGui = player:FindFirstChild("PlayerGui")
if playerGui then
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui.Name == "TickWarpGui" then
            pcall(function()
                gui:Destroy()
            end)
        end
    end
end

local Config = {
    Key = Enum.KeyCode.E,
    MaxTicks = 10,
    TimePerTick = 0.15,
    DistancePerTick = 8,
    WarpStyle = "Smooth",
    Cooldown = 0.1,
    PreviewSize = Vector3.new(3, 5, 3),
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

local HALF_CHARACTER_HEIGHT = 2.5
local RAY_OFFSET = Vector3.new(0, 5, 0)
local RAY_DIRECTION = Vector3.new(0, -20, 0)
local HIDDEN_SIZE = Vector3.new(0, 0, 0)

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
    chargingLock = false,
    previewUpdateConnection = nil,
    isRespawning = false,
    isTerminating = false
}

local connections = {}
local activeTweens = {}

local screenGui, mainFrame, barBackground, barFill, tickLabel
local previewPart, selectionBox
local uiSetupDone = false

local function isCharacterValid(character)
    if not character then return false end
    if character:GetAttribute("Disabled") then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    if humanoid.Health <= 0 then return false end
    
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
        state.isRespawning = false
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

-- Reset UI function - ensures GUI is properly reset
local function resetUI()
    if mainFrame then
        mainFrame.Visible = true
        mainFrame.BackgroundTransparency = 0
    end
    if barBackground then
        barBackground.BackgroundTransparency = 0
    end
    if barFill then
        barFill.BackgroundTransparency = 0
        barFill.Size = UDim2.new(0, 0, 1, 0)
    end
    if tickLabel then
        tickLabel.TextTransparency = 0
        tickLabel.Text = "TICKS: 0 / " .. Config.MaxTicks
        tickLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

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
    if syn and syn.protect_gui then syn.protect_gui(screenGui) end
    screenGui.Parent = playerGui
    
    -- Main Frame
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 80)
    mainFrame.Position = UDim2.new(0.5, -125, 0.75, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = true
    mainFrame.BackgroundTransparency = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Warp System"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Keybind indicator
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0, 60, 1, 0)
    keyLabel.Position = UDim2.new(1, -70, 0, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "[E]"
    keyLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    keyLabel.Font = Enum.Font.SourceSansBold
    keyLabel.TextSize = 13
    keyLabel.TextXAlignment = Enum.TextXAlignment.Right
    keyLabel.Parent = titleBar
    
    -- Line
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 0, 30)
    line.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    line.BorderSizePixel = 0
    line.Parent = mainFrame
    
    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -35)
    container.Position = UDim2.new(0, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = mainFrame
    
    -- Bar Background
    barBackground = Instance.new("Frame")
    barBackground.Size = UDim2.new(0, 220, 0, 16)
    barBackground.Position = UDim2.new(0.5, -110, 0.5, -8)
    barBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    barBackground.BorderSizePixel = 0
    barBackground.BackgroundTransparency = 0
    barBackground.Parent = container
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = barBackground
    
    -- Bar Fill
    barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    barFill.BorderSizePixel = 0
    barFill.BackgroundTransparency = 0
    barFill.Parent = barBackground
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = barFill
    
    -- Tick Label
    tickLabel = Instance.new("TextLabel")
    tickLabel.Size = UDim2.new(0, 220, 0, 20)
    tickLabel.Position = UDim2.new(0.5, -110, 1, 4)
    tickLabel.BackgroundTransparency = 1
    tickLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    tickLabel.TextSize = 12
    tickLabel.Font = Enum.Font.SourceSans
    tickLabel.Text = "TICKS: 0 / " .. Config.MaxTicks
    tickLabel.TextTransparency = 0
    tickLabel.Parent = container
    
    -- Preview Part
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

local function cancelAllTweens()
    for i = #activeTweens, 1, -1 do
        pcall(function()
            activeTweens[i]:Cancel()
        end)
        table.remove(activeTweens, i)
    end
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

local function updatePreview()
    if not state.isCharging or state.current ~= WarpState.CHARGING then return end
    if not state.hrp then return end
    
    local newCFrame = getWarpCFrame(state.ticks)
    if previewPart then
        previewPart.CFrame = newCFrame
    end
end

local function updateUI()
    if not barFill or not tickLabel then return end
    
    local ratio = state.ticks / Config.MaxTicks
    barFill.Size = UDim2.new(ratio, 0, 1, 0)
    
    if state.ticks == Config.MaxTicks then
        barFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        tickLabel.Text = "MAX TICKS REACHED!"
        tickLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        if previewPart then
            previewPart.Color = Color3.fromRGB(255, 200, 0)
            selectionBox.Color3 = Color3.fromRGB(255, 200, 0)
        end
    else
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        tickLabel.Text = "TICKS: " .. state.ticks .. " / " .. Config.MaxTicks
        tickLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function startCharging()
    if state.chargingLock then return end
    
    state.chargingLock = true
    
    updateUI()
    updatePreview()
    
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
            end
        end
        
        state.chargingLock = false
        state.chargeCoroutine = nil
    end)
end

local function stopCharging()
    if not state.isCharging then return end
    
    state.isCharging = false
    state.current = WarpState.IDLE
    
    if state.previewUpdateConnection then
        state.previewUpdateConnection:Disconnect()
        state.previewUpdateConnection = nil
    end
    
    state.chargeCoroutine = nil
    state.chargingLock = false
    
    -- Reset UI to idle state but keep visible
    resetUI()
    
    if previewPart then
        previewPart.Size = HIDDEN_SIZE
        previewPart.Color = Color3.fromRGB(0, 255, 255)
        selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
    end
    
    if state.ticks > 0 and not state.warpCooldown and not state.isRespawning then
        state.warpCooldown = true
        executeWarp(state.ticks)
        task.wait(Config.Cooldown)
        state.warpCooldown = false
    end
    
    state.ticks = 0
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if not state.isLoaded then return end
    if state.isTerminating then return end
    if input.KeyCode ~= Config.Key then return end
    if state.current == WarpState.WARPING then return end
    if state.isCharging then return end
    if state.isRespawning then return end
    
    -- Check if character exists, if not try to initialize
    if not state.hrp then 
        if not initializeCharacter() then
            return
        end
    end
    
    -- Reset UI before starting new charge
    resetUI()
    
    state.isCharging = true
    state.current = WarpState.CHARGING
    state.ticks = 1
    
    updateRaycastFilter()
    
    if mainFrame then
        barFill.Size = UDim2.new(1/Config.MaxTicks, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        tickLabel.Text = "TICKS: 1 / " .. Config.MaxTicks
        tickLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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

local function setupConnections()
    connections.characterAdded = player.CharacterAdded:Connect(function(newChar)
        -- Mark respawning
        state.isRespawning = true
        
        -- Clean up old character references
        state.hrp = nil
        state.character = nil
        
        -- Stop any ongoing charging
        if state.isCharging then
            state.isCharging = false
            state.current = WarpState.IDLE
            
            if state.previewUpdateConnection then
                state.previewUpdateConnection:Disconnect()
                state.previewUpdateConnection = nil
            end
        end
        
        -- Update to new character after a small delay
        task.wait(0.1)
        updateCharacter(newChar)
        
        if previewPart then
            previewPart.Size = HIDDEN_SIZE
        end
        
        state.current = WarpState.IDLE
        state.isCharging = false
        state.ticks = 0
        state.isRespawning = false
        
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

local function cleanupSystem()
    if state.isTerminating then return end
    state.isTerminating = true
    
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
    state.isLoaded = false
    
    -- Clear global reference
    _G.WarpSystem = nil
    
    print("Warp System Cleaned Up")
end

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
    
    if previewPart then
        previewPart.Size = HIDDEN_SIZE
    end
    
    print("Warp System Unloaded")
end

local function loadSystem()
    if state.isLoaded then return end
    
    state.isLoaded = true
    state.isTerminating = false
    
    if not connections.inputBegan then
        connections.inputBegan = UserInputService.InputBegan:Connect(onInputBegan)
        connections.inputEnded = UserInputService.InputEnded:Connect(onInputEnded)
    end
    
    print("Warp System Loaded")
end

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
    print("Warp System Loaded - Press E to charge and warp!")
end
