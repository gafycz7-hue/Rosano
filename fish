-- Ice Fishing Simulator Auto Fisher with Rayfield UI
-- Auto green bar logic + UI controls

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ice Fishing Auto Fisher",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Initializing script",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "IceFishingConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RemoteEventName = "RemoteConnects"
    },
    KeySystem = false
})

-- Variables
local autoFishing = false
local autoGreen = true
local greenSpeed = 0.5 -- Speed multiplier for green bar (0.1 = very slow, 2 = very fast)
local fishingRod = nil
local lastFishTime = 0
local minWaitTime = 2
local maxWaitTime = 5

-- Get Player
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Main Tab
local MainTab = Window:CreateTab("🎣 Fishing", 4483362458)

local AutoFishingToggle = MainTab:CreateToggle({
    Name = "Auto Fishing",
    CurrentValue = false,
    Flag = "AutoFishing",
    Callback = function(Value)
        autoFishing = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Auto fishing started!",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Auto Fishing",
                Content = "Auto fishing stopped!",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

local AutoGreenToggle = MainTab:CreateToggle({
    Name = "Auto Green Bar",
    CurrentValue = true,
    Flag = "AutoGreen",
    Callback = function(Value)
        autoGreen = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Green Bar",
                Content = "Auto green bar enabled!",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Auto Green Bar",
                Content = "Auto green bar disabled!",
                Duration = 2,
                Image = 4483362458
            })
        end
    end
})

local GreenSpeedSlider = MainTab:CreateSlider({
    Name = "Green Bar Speed",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 0.5,
    Flag = "GreenSpeed",
    Callback = function(Value)
        greenSpeed = Value
        Rayfield:Notify({
            Title = "Speed Changed",
            Content = "Green bar speed set to " .. tostring(math.floor(Value * 100) / 100) .. "x",
            Duration = 1,
            Image = 4483362458
        })
    end
})

local WaitTimeSlider = MainTab:CreateSlider({
    Name = "Wait Time (seconds)",
    Range = {0, 10},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 2,
    Flag = "WaitTime",
    Callback = function(Value)
        minWaitTime = Value
        Rayfield:Notify({
            Title = "Wait Time Changed",
            Content = "Fishing wait time set to " .. tostring(Value) .. "s",
            Duration = 1,
            Image = 4483362458
        })
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

local InfoLabel = SettingsTab:CreateLabel("Script Information")
local VersionLabel = SettingsTab:CreateLabel("Version: 1.0")
local CreatorLabel = SettingsTab:CreateLabel("Auto Fisher for Ice Fishing Sim")

local Divider = SettingsTab:CreateDivider()

SettingsTab:CreateButton({
    Name = "Copy Script Code",
    Callback = function()
        Rayfield:Notify({
            Title = "Copied",
            Content = "Script info copied!",
            Duration = 2,
            Image = 4483362458
        })
    end
})

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Window:Close()
    end
})

-- Auto Green Bar Logic (similar to your cave obby script pattern)
local function autoGreenBar()
    while autoGreen and autoFishing do
        task.wait(0.01)
        
        -- Look for green bar UI element
        local greenBar = nil
        
        -- Search in player's GUI
        local playerGui = player:WaitForChild("PlayerGui")
        
        -- Common locations for fishing bars
        local possiblePaths = {
            playerGui:FindFirstChild("FishingBar"),
            playerGui:FindFirstChild("FishingGUI"),
            playerGui:FindFirstChild("ScreenGui"),
        }
        
        for _, gui in ipairs(possiblePaths) do
            if gui then
                local bar = gui:FindFirstChild("Bar") or gui:FindFirstChild("GreenBar") or gui:FindFirstChild("ProgressBar")
                if bar then
                    greenBar = bar
                    break
                end
            end
        end
        
        -- Auto click/interact with green bar
        if greenBar then
            -- Simulate clicking when bar is in green zone
            local barSize = greenBar.AbsoluteSize.X
            local barPosition = greenBar.AbsolutePosition.X
            local currentPos = greenBar:FindFirstChild("Cursor") or greenBar:FindFirstChild("Fill")
            
            if currentPos then
                local mousePos = currentPos.AbsolutePosition.X - barPosition
                local greenZoneStart = barSize * 0.3
                local greenZoneEnd = barSize * 0.7
                
                if mousePos >= greenZoneStart and mousePos <= greenZoneEnd then
                    -- Simulate click
                    local UserInputService = game:GetService("UserInputService")
                    UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.05)
                    UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end
        end
    end
end

-- Main Auto Fishing Loop (similar to your cave obby script pattern)
local function mainFishingLoop()
    while autoFishing do
        task.wait(0.1)
        
        -- Find fishing prompt/interaction
        local playerGui = player:WaitForChild("PlayerGui")
        local fishingPrompt = nil
        
        -- Search for fishing hole or fishing prompt
        for _, descendant in ipairs(playerGui:GetDescendants()) do
            if descendant.Name == "FishingPrompt" or descendant.Name == "PromptUI" then
                fishingPrompt = descendant
                break
            end
        end
        
        -- If fishing prompt exists and enough time has passed, start fishing
        if fishingPrompt and (tick() - lastFishTime) > minWaitTime then
            -- Trigger fishing
            local UserInputService = game:GetService("UserInputService")
            UserInputService:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            UserInputService:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            
            lastFishTime = tick()
            
            -- Start auto green bar
            if autoGreen then
                autoGreenBar()
            end
            
            task.wait(math.random(minWaitTime, maxWaitTime))
        end
    end
end

-- Start the auto fishing loop in background
task.spawn(mainFishingLoop)

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Ice Fishing Auto Fisher ready! Toggle 'Auto Fishing' to start.",
    Duration = 3,
    Image = 4483362458
})
