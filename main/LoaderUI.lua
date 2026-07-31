-- DUAL LOADER (Warp + Follow Bot)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoader"
gui.Parent = player:WaitForChild("PlayerGui")

local function createButton(text, yPos, link)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, yPos, 0)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.Font = Enum.Font.GothamBold
    button.Parent = gui
    
    button.MouseButton1Click:Connect(function()
        button.Text = "Loading..."
        button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        button.Active = false
        
        local success, result = pcall(function()
            local content = game:HttpGet(link)
            return loadstring(content)
        end)
        
        if success and result then
            local loadSuccess, err = pcall(result)
            if loadSuccess then
                button.Text = "✅ Loaded!"
                button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                task.wait(1)
                gui:Destroy()
            else
                button.Text = "❌ Error!"
                button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                print("Error:", err)
                task.wait(2)
                button.Text = text
                button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                button.Active = true
            end
        else
            button.Text = "❌ Failed!"
            button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(2)
            button.Text = text
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            button.Active = true
        end
    end)
    
    return button
end

-- Two buttons
createButton("Load Warp System", -0.1, "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/Loader.lua")
createButton("Load Follow Bot", 0.2, "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/follow.lua")
