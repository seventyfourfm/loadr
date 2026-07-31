-- UPDATED LOADER (Loads Warp + Follow)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create a button
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 50) -- Made wider for longer text
button.Position = UDim2.new(0.5, -125, 0.5, -25)
button.Text = "Load Scripts (Warp + Follow)"
button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.Parent = gui

-- Function to load a script from a URL
local function loadScriptFromURL(url, scriptName)
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url)
        return loadstring(scriptContent)
    end)

    if not success or not result then
        return false, "Failed to download " .. scriptName .. ": " .. tostring(result)
    end

    local loadSuccess, loadErr = pcall(result)
    if not loadSuccess then
        return false, "Failed to execute " .. scriptName .. ": " .. tostring(loadErr)
    end

    return true, scriptName .. " loaded successfully!"
end

-- Load script when clicked
button.MouseButton1Click:Connect(function()
    button.Text = "Loading..."
    button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    button.Active = false

    -- Define your script URLs
    local scriptsToLoad = {
        { url = "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/Loader.lua", name = "Warp System" },
        { url = "https://raw.githubusercontent.com/seventyfourfm/loadr/refs/heads/main/main/follow", name = "Follow Bot" }
    }

    local loadedCount = 0
    local errors = {}

    for _, scriptInfo in ipairs(scriptsToLoad) do
        local success, message = loadScriptFromURL(scriptInfo.url, scriptInfo.name)
        if success then
            loadedCount = loadedCount + 1
            print(message) -- Optional: print success to console
        else
            table.insert(errors, message)
            print(message) -- Optional: print error to console
        end
    end

    -- Check results
    if loadedCount == #scriptsToLoad then
        button.Text = "✅ All Loaded!"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        task.wait(1.5)
        gui:Destroy()
    else
        button.Text = "❌ " .. loadedCount .. "/" .. #scriptsToLoad .. " Loaded!"
        button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("Errors encountered:", table.concat(errors, "; "))
        task.wait(3)
        button.Text = "Try Again"
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        button.Active = true
    end
end)
