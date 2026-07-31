-- FIXED LOADER
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create a button
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.Text = "Load Warp System"
button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 20
button.Font = Enum.Font.GothamBold
button.Parent = gui

-- Load script when clicked
button.MouseButton1Click:Connect(function()
    button.Text = "Loading..."
    button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    button.Active = false
    
    local scriptLink = "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/Loader.lua"
    
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(scriptLink)
        return loadstring(scriptContent)
    end)
    
    if success and result then
        local loadSuccess, loadErr = pcall(result)
        
        if loadSuccess then
            button.Text = "✅ Loaded!"
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            -- Access the loaded module
            local warpSystem = _G.WarpSystem
            if warpSystem then
                print("Warp System loaded successfully!")
                print("Current state:", warpSystem.getState())
            end
            
            task.wait(1)
            gui:Destroy()
        else
            button.Text = "❌ Script Error!"
            button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            print("Load error:", loadErr)
            task.wait(2)
            button.Text = "Try Again"
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            button.Active = true
        end
    else
        button.Text = "❌ Failed to Download!"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("Download error:", result)
        task.wait(2)
        button.Text = "Try Again"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        button.Active = true
    end
end)
