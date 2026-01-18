-- Script Description:
-- This script is designed for use in Roblox games and manipulates players' positions using client-sided CFrame adjustments.
-- It allows you to move players to a specified range in front of your character and set their walk speed to 0.
-- what does this mean it mean like you can use tool and thing for example you have sword and gun in game Which this script made for Manipulate Hitbox client sided
-- you can use those tool to Damage/hit/kill player that Bringed to you
--even though this script is client sided but even is client sided other player can still see themselves died/Hitted/damaged
-- This may not work in games with robust anti-cheat systems or hitbox checks.
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "FE kill all GUI v4 by MawinCK", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
    Name = "Tab",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = Tab:AddSection({
    Name = "Section"
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local localroot = character:WaitForChild("HumanoidRootPart")

local tableEnemy = {}
for _, v in pairs(game.Workspace:GetDescendants()) do
    if v:IsA("Model") and v.Name ~= player.Name and v:FindFirstChild("HumanoidRootPart") then
        table.insert(tableEnemy, v.Name)
    end
end

game:GetService("Workspace").ChildAdded:Connect(function()
    tableEnemy = {}
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name ~= player.Name and v:FindFirstChild("HumanoidRootPart") then
            table.insert(tableEnemy, v.Name)
        end
    end
end)

game:GetService("Workspace").ChildRemoved:Connect(function()
    tableEnemy = {}
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name ~= player.Name and v:FindFirstChild("HumanoidRootPart") then
            table.insert(tableEnemy, v.Name)
        end
    end
end)

local selectedEnemy = nil
Tab:AddDropdown({
    Name = "Select Objective Thing to bring",
    Default = "",
    Options = tableEnemy,
    Callback = function(Value)
        selectedEnemy = Value
    end
})

local InputNumber = -5
Tab:AddTextbox({
    Name = "Distance of Bring(MUST USE NEGATIVE NUMBER)",
    Default = tostring(InputNumber),
    TextDisappear = true,
    Callback = function(Value)
        InputNumber = tonumber(Value)
    end
})

local TargetSelectedEnemyToggle = false
local function TargetSelectedEnemy()
    if TargetSelectedEnemyToggle and selectedEnemy then
        spawn(function()
            while TargetSelectedEnemyToggle and selectedEnemy do
                local WorkEnemy = game.Workspace:FindFirstChild(selectedEnemy)
                if WorkEnemy then
                    local EnemyRoot = WorkEnemy:FindFirstChild("HumanoidRootPart")
                    local EnemyHumanoid = WorkEnemy:FindFirstChild("Humanoid")
                    if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 then
                        EnemyRoot.CFrame = localroot.CFrame * CFrame.new(0, 0, InputNumber)
                    end
                end
                game:GetService("RunService").Heartbeat:Wait()
            end
        end)
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    localroot = character:WaitForChild("HumanoidRootPart")
end)

Tab:AddToggle({
    Name = "Target Selected Object",
    Default = false,
    Callback = function(state)
        TargetSelectedEnemyToggle = state
        if state then
            TargetSelectedEnemy()
        end
    end
})

local TargetAllToggle = false
local function TargetAll(state)
    TargetAllToggle = state
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                local JN = v.Character:FindFirstChild("HumanoidRootPart")
                local WR = v.Character:FindFirstChild("Humanoid")
                if JN and WR and WR.Health > 0 then
                    spawn(function()
                        while TargetAllToggle and JN and WR.Health > 0 do
                            JN.CFrame = localroot.CFrame * CFrame.new(0, 0, InputNumber)
                            game:GetService("RunService").Heartbeat:Wait()
                        end
                    end)
                end
            end
        end
    end
end

Tab:AddToggle({
    Name = "Target All",
    Default = false,
    Callback = function(state)
        TargetAll(state)
    end
})

local TargetAllWithTeamCheckToggle = false
local function targetAllWithTeamCheck(state)
    TargetAllWithTeamCheckToggle = state
    if state then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character then
                local JNR = v.Character:FindFirstChild("HumanoidRootPart")
                local JK = v.Character:FindFirstChild("Humanoid")
                if JNR and JK and JK.Health > 0 then
                    spawn(function()
                        while TargetAllWithTeamCheckToggle and JNR and JK.Health > 0 do
                            JNR.CFrame = localroot.CFrame * CFrame.new(0, 0, InputNumber)
                            game:GetService("RunService").Heartbeat:Wait()
                        end
                    end)
                end
            end
        end
    end
end

Tab:AddToggle({
    Name = "Target All But With Team Check",
    Default = false,
    Callback = function(state)
        targetAllWithTeamCheck(state)
    end
})

OrionLib:Init()
