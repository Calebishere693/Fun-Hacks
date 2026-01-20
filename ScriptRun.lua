--[[
    Xeno Script Runner GUI
    Context: Client-Sided (Standard Exploit Environment)
    Description: A minimalist GUI to input Lua code and execute it using the executor's loadstring environment.
    
    Instructions:
    1. Copy the script below.
    2. Paste it into your Xeno executor.
    3. Run.
    4. A GUI will appear. Paste your script into the box and click "Execute".
    
    Note: This script uses game:GetService("CoreGui") for protection. 
    If your executor does not support CoreGui, change the parent to game.Players.LocalPlayer.PlayerGui.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Cleanup existing GUI if re-executed
if CoreGui:FindFirstChild("XenoScriptRunner") then
    CoreGui.XenoScriptRunner:Destroy()
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XenoScriptRunner"
ScreenGui.ResetOnSpawn = false
-- Try parenting to CoreGui for security, fallback to PlayerGui
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centered
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Script Runner"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Quick hack to flatten bottom corners of title bar
local TitleCover = Instance.new("Frame")
TitleCover.Parent = TitleBar
TitleCover.BackgroundColor3 = TitleBar.BackgroundColor3
TitleCover.BorderSizePixel = 0
TitleCover.Position = UDim2.new(0, 0, 1, -5)
TitleCover.Size = UDim2.new(1, 0, 0, 5)

-- Scroll Frame for Input
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "Container"
ScrollFrame.Parent = MainFrame
ScrollFrame.Active = true
ScrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Position = UDim2.new(0, 10, 0, 40)
ScrollFrame.Size = UDim2.new(1, -20, 1, -80)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto resize handled by script
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local InputBox = Instance.new("TextBox")
InputBox.Name = "CodeInput"
InputBox.Parent = ScrollFrame
InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputBox.BackgroundTransparency = 1
InputBox.Size = UDim2.new(1, 0, 1, 0) -- Fill scroll frame
InputBox.ClearTextOnFocus = false
InputBox.Font = Enum.Font.Code
InputBox.MultiLine = true
InputBox.PlaceholderText = "-- Paste your Lua script here..."
InputBox.Text = ""
InputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
InputBox.TextSize = 12
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top

-- Auto-resize text box height based on content
InputBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
    local textHeight = InputBox.TextBounds.Y
    if textHeight > ScrollFrame.AbsoluteSize.Y then
        InputBox.Size = UDim2.new(1, 0, 0, textHeight + 20)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, textHeight + 20)
    else
        InputBox.Size = UDim2.new(1, 0, 1, 0)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    end
end)

-- Buttons
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Parent = MainFrame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 10, 1, -35)
ButtonContainer.Size = UDim2.new(1, -20, 0, 30)

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "Execute"
ExecuteButton.Parent = ButtonContainer
ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ExecuteButton.Size = UDim2.new(0.48, 0, 1, 0)
ExecuteButton.Font = Enum.Font.GothamBold
ExecuteButton.Text = "EXECUTE"
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextSize = 12

local ExecCorner = Instance.new("UICorner")
ExecCorner.CornerRadius = UDim.new(0, 4)
ExecCorner.Parent = ExecuteButton

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "Clear"
ClearButton.Parent = ButtonContainer
ClearButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ClearButton.Position = UDim2.new(0.52, 0, 0, 0)
ClearButton.Size = UDim2.new(0.48, 0, 1, 0)
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Text = "CLEAR"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 12

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 4)
ClearCorner.Parent = ClearButton

-- Draggable Logic
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Execution Logic
ExecuteButton.MouseButton1Click:Connect(function()
    local source = InputBox.Text
    if source == "" then return end
    
    -- Visual feedback
    local originalColor = ExecuteButton.BackgroundColor3
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    ExecuteButton.Text = "RUNNING..."
    
    -- Execution
    task.spawn(function()
        -- Use loadstring if available (standard for exploits)
        local func, compileError = loadstring(source)
        
        if not func then
            warn("Script Compiler Error: " .. tostring(compileError))
            -- Output error to console (F9)
        else
            -- Run the compiled function safely
            local success, runtimeError = pcall(func)
            if not success then
                warn("Script Runtime Error: " .. tostring(runtimeError))
            end
        end
        
        task.wait(0.2)
        ExecuteButton.BackgroundColor3 = originalColor
        ExecuteButton.Text = "EXECUTE"
    end)
end)

ClearButton.MouseButton1Click:Connect(function()
    InputBox.Text = ""
    -- Reset size
    InputBox.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end)

-- Toggle GUI visibility with RightControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("Xeno Script Runner Loaded. Press RightControl to toggle.")
