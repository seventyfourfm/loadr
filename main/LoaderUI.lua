-- 🚀 ADVANCED LOADER GUI - Run this script once
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ⚙️ CONFIGURATION - Change these!
local CONFIG = {
    ScriptURL = "https://raw.githubusercontent.com/seventyfourfm/loadr/main/main/Loader.lua", -- Your warp script link
    ButtonText = "⚡ LOAD WARP",
    LoadingText = "⏳ LOADING...",
    LoadedText = "✅ LOADED!",
    ErrorText = "❌ ERROR",
    ThemeColor = Color3.fromRGB(0, 150, 255), -- Blue
    HoverColor = Color3.fromRGB(0, 200, 255), -- Lighter blue
    SuccessColor = Color3.fromRGB(0, 255, 150), -- Green
    ErrorColor = Color3.fromRGB(255, 50, 50), -- Red
}

-- 🎨 CREATE THE MAIN GUI
local function createLoaderUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoaderGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- 🔲 Main Frame (Glass effect)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Glass blur effect (optional, if enabled)
    if syn and syn.protect_gui then
        syn.protect_gui(mainFrame)
    end
    
    -- Corner radius
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    -- Border glow
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 2
    border.BorderColor3 = CONFIG.ThemeColor
    border.Parent = mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 16)
    borderCorner.Parent = border
    
    -- 📊 Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🚀 SCRIPT LOADER"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 28
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 80)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Click the button to load the warp system"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- 🎯 Main Button
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 70)
    button.Position = UDim2.new(0.1, 0, 0.5, -35)
    button.BackgroundColor3 = CONFIG.ThemeColor
    button.BackgroundTransparency = 0.2
    button.Text = CONFIG.ButtonText
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 24
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = mainFrame
    
    -- Button corner
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = button
    
    -- 🔲 Loading animation frame (hidden initially)
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0.8, 0, 0, 4)
    loadingFrame.Position = UDim2.new(0.1, 0, 0.5, 45)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    loadingFrame.BackgroundTransparency = 0.5
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Visible = false
    loadingFrame.Parent = mainFrame
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 2)
    loadingCorner.Parent = loadingFrame
    
    -- Loading fill bar (animates)
    local loadingFill = Instance.new("Frame")
    loadingFill.Size = UDim2.new(0, 0, 1, 0)
    loadingFill.BackgroundColor3 = CONFIG.ThemeColor
    loadingFill.BorderSizePixel = 0
    loadingFill.Parent = loadingFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = loadingFill
    
    -- ℹ️ Status text
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0, 30)
    statusText.Position = UDim2.new(0, 0, 0.5, 70)
    statusText.BackgroundTransparency = 1
    statusText.Text = "🔹 Ready to load"
    statusText.TextColor3 = Color3.fromRGB(200, 200, 220)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = mainFrame
    
    -- 🎨 Decorative gradient line
    local gradientLine = Instance.new("Frame")
    gradientLine.Size = UDim2.new(1, 0, 0, 2)
    gradientLine.Position = UDim2.new(0, 0, 0, 0)
    gradientLine.BackgroundColor3 = CONFIG.ThemeColor
    gradientLine.BackgroundTransparency = 0.8
    gradientLine.BorderSizePixel = 0
    gradientLine.Parent = mainFrame
    
    -- Close button (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 220)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    closeButton.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        button = button,
        loadingFrame = loadingFrame,
        loadingFill = loadingFill,
        statusText = statusText,
        border = border,
        gradientLine = gradientLine
    }
end

-- 🎭 ANIMATION FUNCTIONS
local function animateButton(button, targetColor, scale)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(button, tweenInfo, {
        BackgroundColor3 = targetColor,
        BackgroundTransparency = 0.2
    }):Play()
    
    if scale then
        TweenService:Create(button, tweenInfo, {
            Size = UDim2.new(0.8, 0, 0, 70 * scale)
        }):Play()
    end
end

local function animateLoading(loadingFill, progress)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
    TweenService:Create(loadingFill, tweenInfo, {
        Size = UDim2.new(progress, 0, 1, 0)
    }):Play()
end

local function pulseBorder(border)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(border, tweenInfo, {
        BackgroundTransparency = 0.5
    }):Play()
end

-- 🚀 LOADING FUNCTION
local function loadWarpScript(ui)
    if ui.loaded then
        ui.statusText.Text = "⚠️ Already loaded!"
        return
    end
    
    -- Show loading state
    ui.button.Text = CONFIG.LoadingText
    animateButton(ui.button, Color3.fromRGB(255, 165, 0), 0.95)
    ui.loadingFrame.Visible = true
    ui.statusText.Text = "⏳ Downloading script..."
    ui.statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
    ui.button.Active = false
    
    -- Animate loading bar
    animateLoading(ui.loadingFill, 0.3)
    task.wait(0.5)
    animateLoading(ui.loadingFill, 0.6)
    
    -- Attempt to load the script
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(CONFIG.ScriptURL)
        ui.statusText.Text = "⏳ Executing script..."
        animateLoading(ui.loadingFill, 0.8)
        task.wait(0.3)
        loadstring(scriptContent)()
        animateLoading(ui.loadingFill, 1)
        return true
    end)
    
    if success then
        -- Success!
        ui.loaded = true
        ui.button.Text = CONFIG.LoadedText
        animateButton(ui.button, CONFIG.SuccessColor, 1.05)
        ui.statusText.Text = "✅ Script loaded successfully!"
        ui.statusText.TextColor3 = CONFIG.SuccessColor
        
        -- Pulse border green
        ui.border.BorderColor3 = CONFIG.SuccessColor
        pulseBorder(ui.border)
        ui.gradientLine.BackgroundColor3 = CONFIG.SuccessColor
        
        -- Hide loading bar with delay
        task.wait(1)
        TweenService:Create(ui.loadingFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ui.loadingFrame.Visible = false
        ui.loadingFill.Size = UDim2.new(0, 0, 1, 0)
        
        ui.button.Active = true
        
        -- Auto-close after 3 seconds
        task.wait(3)
        local frame = ui.mainFrame
        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.5)
        ui.screenGui:Destroy()
        
    else
        -- Error!
        ui.button.Text = CONFIG.ErrorText
        animateButton(ui.button, CONFIG.ErrorColor, 0.95)
        ui.statusText.Text = "❌ Error: " .. tostring(result)
        ui.statusText.TextColor3 = CONFIG.ErrorColor
        ui.border.BorderColor3 = CONFIG.ErrorColor
        ui.gradientLine.BackgroundColor3 = CONFIG.ErrorColor
        animateLoading(ui.loadingFill, 0)
        
        ui.button.Active = true
        
        -- Reset button after 3 seconds
        task.wait(3)
        ui.button.Text = CONFIG.ButtonText
        animateButton(ui.button, CONFIG.ThemeColor, 1)
        ui.statusText.Text = "🔹 Ready to load"
        ui.statusText.TextColor3 = Color3.fromRGB(200, 200, 220)
        ui.border.BorderColor3 = CONFIG.ThemeColor
        ui.gradientLine.BackgroundColor3 = CONFIG.ThemeColor
        ui.loadingFrame.Visible = false
        ui.loadingFill.Size = UDim2.new(0, 0, 1, 0)
    end
end

-- 🎨 DRAG FUNCTIONALITY
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- 🚀 INITIALIZE
local ui = createLoaderUI()
makeDraggable(ui.mainFrame)

-- Button hover effects
ui.button.MouseEnter:Connect(function()
    if ui.button.Active ~= false then
        TweenService:Create(ui.button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0.82, 0, 0, 75)
        }):Play()
    end
end)

ui.button.MouseLeave:Connect(function()
    if ui.button.Active ~= false then
        TweenService:Create(ui.button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            Size = UDim2.new(0.8, 0, 0, 70)
        }):Play()
    end
end)

-- Button click
ui.button.MouseButton1Click:Connect(function()
    loadWarpScript(ui)
end)

-- 🎵 WELCOME ANIMATION
local frame = ui.mainFrame
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 350, 0, 450),
    Position = UDim2.new(0.5, -175, 0.5, -225)
}):Play()

print("🚀 Loader GUI created! Click the button to load your script.")
