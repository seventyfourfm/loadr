-- SMART LOADER - Prevents duplicate loading
local warpLoaded = false

local function loadWarpScript()
    if warpLoaded then
        print("⚠️ Warp system already loaded!")
        return
    end
    
    print("🔄 Loading Warp System...")
    local success, result = pcall(function()
        local warpScript = game:HttpGet("https://raw.githubusercontent.com/seventyfourfm/loadr/main/main/Loader.lua")
        loadstring(warpScript)()
    end)
    
    if success then
        warpLoaded = true
        print("✅ Warp System Loaded Successfully!")
    else
        warn("❌ Failed to load:", result)
    end
end

-- Create UI button (same as above)
local button = createLoaderUI()
button.MouseButton1Click:Connect(loadWarpScript)
