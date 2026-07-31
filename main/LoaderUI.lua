-- SIMPLE LOADER - Copy and paste this
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create a button
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Load Script"
button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 20
button.Font = Enum.Font.GothamBold
button.Parent = gui

-- Load script when clicked
button.MouseButton1Click:Connect(function()
    button.Text = "Loading..."
    button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    -- YOUR GITHUB LINK HERE
    local scriptLink = "https://raw.githubusercontent.com/seventyfourfm/loadr/main/main/Loader.lua"
    
    local success, err = pcall(function()
        local script = game:HttpGet(scriptLink)
        loadstring(script)()
    end)
    
    if success then
        button.Text = "✅ Loaded!"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        wait(1)
        gui:Destroy() -- Remove button after loading
    else
        button.Text = "❌ Failed!"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        wait(1)
        button.Text = "Try Again"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    end
end)
