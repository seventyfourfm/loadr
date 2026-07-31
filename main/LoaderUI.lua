-- DUAL LOADER - Warp System & Follow Bot (X Close Button)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create GUI with same style as Follow Bot
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DualLoaderGui"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (same style as Follow Bot)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title Bar (same style)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 1, 0) -- Leave room for X button
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Script Loader"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- X Close Button (on the right side of title bar)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = TitleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Close button hover effect
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

closeButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Line (same style)
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Container (same style)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -45)
Container.Position = UDim2.new(0, 0, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local ContainerLayout = Instance.new("UIListLayout")
ContainerLayout.Parent = Container
ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContainerLayout.Padding = UDim.new(0, 10)
ContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 220, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Select a script to load"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 12
StatusLabel.LayoutOrder = 1
StatusLabel.Parent = Container

-- Function to create buttons
local function createScriptButton(text, layoutOrder, scriptUrl)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 220, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    Button.LayoutOrder = layoutOrder
    Button.Parent = Container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = Button
    
    -- Click handler
    Button.MouseButton1Click:Connect(function()
        StatusLabel.Text = "Loading " .. text .. "..."
        Button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        Button.Text = "Loading..."
        Button.Active = false
        
        local success, result = pcall(function()
            local content = game:HttpGet(scriptUrl)
            return loadstring(content)
        end)
        
        if success and result then
            local loadSuccess, loadErr = pcall(result)
            
            if loadSuccess then
                Button.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                Button.Text = "✅ Loaded!"
                StatusLabel.Text = text .. " loaded successfully!"
                print(text .. " loaded successfully!")
                
                -- Check which script loaded
                if text:find("Warp") and _G.WarpSystem then
                    print("🔄 Warp System ready - Press E to charge and warp!")
                elseif text:find("Follow") and FollowBotActive ~= nil then
                    print("👤 Follow Bot ready - Enter target and toggle ON!")
                end
                
                task.wait(1.5)
                ScreenGui:Destroy()
            else
                Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                Button.Text = "❌ Error!"
                StatusLabel.Text = "Error loading " .. text
                print("Load error:", loadErr)
                task.wait(2)
                Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                Button.Text = text
                Button.Active = true
                StatusLabel.Text = "Select a script to load"
            end
        else
            Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            Button.Text = "❌ Failed!"
            StatusLabel.Text = "Failed to download " .. text
            print("Download error:", result)
            task.wait(2)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Button.Text = text
            Button.Active = true
            StatusLabel.Text = "Select a script to load"
        end
    end)
    
    return Button
end

-- Warp System Button
local warpButton = createScriptButton(
    "🚀 Warp System",
    2,
    "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/Loader.lua"
)

-- Follow Bot Button
local followButton = createScriptButton(
    "👤 Follow Bot",
    3,
    "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/follow"
)

print("✅ Dual Loader ready!")
