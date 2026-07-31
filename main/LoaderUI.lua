-- DUAL SCRIPT LOADER (Warp & Follow)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoader"
gui.Parent = player:WaitForChild("PlayerGui")

-- Function to create a button
local function createButton(text, positionY, scriptLink)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, positionY, 0)
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
            local scriptContent = game:HttpGet(scriptLink)
            return loadstring(scriptContent)
        end)

        if success and result then
            local loadSuccess, loadErr = pcall(result)
            if loadSuccess then
                button.Text = "✅ Loaded!"
                button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                print(text .. " loaded successfully!")
                task.wait(1)
                gui:Destroy() -- Remove GUI after any script loads
            else
                button.Text = "❌ Error!"
                button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                print("Load error for " .. text .. ":", loadErr)
                task.wait(2)
                button.Text = text
                button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                button.Active = true
            end
        else
            button.Text = "❌ Download Failed!"
            button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            print("Download error for " .. text .. ":", result)
            task.wait(2)
            button.Text = text
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            button.Active = true
        end
    end)

    return button
end

-- Create the two buttons
local warpButton = createButton(
    "Load Warp System",          -- Button Text
    -0.1,                        -- Y Position (centered)
    "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/Loader.lua" -- Script Link
)

local followButton = createButton(
    "Load Follow Bot",           -- Button Text
    0.2,                         -- Y Position (below warp button)
    "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/follow" -- Script Link
)
