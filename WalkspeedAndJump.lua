-- Create a ScreenGui to hold our GUI elements
local gui = Instance.new("ScreenGui")
gui.Name = "WalkspeedJumpPowerGUI"
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Function to create and show the Walkspeed and Jump Power GUI
local function createGUI()
    -- Create a Frame to hold the controls
    local frame = Instance.new("Frame")
    frame.Name = "WalkspeedJumpPowerFrame"
    frame.Size = UDim2.new(0, 200, 0, 120)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    frame.Active = true  -- Enable user input on the frame
    frame.Draggable = true  -- Make the frame draggable

    -- Create labels and input boxes for walkspeed and jumppower
    local walkspeedLabel = Instance.new("TextLabel")
    walkspeedLabel.Parent = frame
    walkspeedLabel.Text = "Walkspeed:"
    walkspeedLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    walkspeedLabel.Size = UDim2.new(0.4, 0, 0.2, 0)
    walkspeedLabel.TextScaled = true
    walkspeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local walkspeedInput = Instance.new("TextBox")
    walkspeedInput.Parent = frame
    walkspeedInput.Position = UDim2.new(0.5, 0, 0.1, 0)
    walkspeedInput.Size = UDim2.new(0.4, 0, 0.2, 0)
    walkspeedInput.Text = tostring(game.Players.LocalPlayer.Character.Humanoid.WalkSpeed)
    walkspeedInput.TextScaled = true
    walkspeedInput.TextColor3 = Color3.fromRGB(0, 0, 0)

    local jumppowerLabel = Instance.new("TextLabel")
    jumppowerLabel.Parent = frame
    jumppowerLabel.Text = "Jump Power:"
    jumppowerLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
    jumppowerLabel.Size = UDim2.new(0.4, 0, 0.2, 0)
    jumppowerLabel.TextScaled = true
    jumppowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local jumppowerInput = Instance.new("TextBox")
    jumppowerInput.Parent = frame
    jumppowerInput.Position = UDim2.new(0.5, 0, 0.4, 0)
    jumppowerInput.Size = UDim2.new(0.4, 0, 0.2, 0)
    jumppowerInput.Text = tostring(game.Players.LocalPlayer.Character.Humanoid.JumpPower)
    jumppowerInput.TextScaled = true
    jumppowerInput.TextColor3 = Color3.fromRGB(0, 0, 0)

    -- Function to update walkspeed
    walkspeedInput.FocusLost:Connect(function()
        local newWalkspeed = tonumber(walkspeedInput.Text)
        if newWalkspeed then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = newWalkspeed
        end
    end)

    -- Function to update jumppower
    jumppowerInput.FocusLost:Connect(function()
        local newJumppower = tonumber(jumppowerInput.Text)
        if newJumppower then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = newJumppower
        end
    end)

    -- Add an X button to close the GUI
    local xButton = Instance.new("TextButton")
    xButton.Parent = frame
    xButton.Text = "X"
    xButton.Size = UDim2.new(0, 20, 0, 20)
    xButton.Position = UDim2.new(1, -25, 0, 5)
    xButton.TextScaled = true
    xButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    xButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    xButton.BorderSizePixel = 0
    xButton.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    -- Add the frame to the ScreenGui
    frame.Parent = gui
end

-- Initially create the GUI
createGUI()

-- Function to reopen the GUI
local function reopenGUI()
    local existingGUI = gui:FindFirstChild("WalkspeedJumpPowerFrame")
    if existingGUI then
        existingGUI:Destroy()
    end
    createGUI()
end

-- Create a button to reopen the GUI
local openButton = Instance.new("TextButton")
openButton.Parent = gui
openButton.Text = "Open Walkspeed/Jump Power GUI"
openButton.Size = UDim2.new(0, 200, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 140)
openButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true

-- Enable touch input for mobile devices
local touchControl = nil
openButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        touchControl = input
    end
end)
openButton.InputChanged:Connect(function(input)
    if input == touchControl and input.UserInputType == Enum.UserInputType.Touch then
        openButton.Position = UDim2.new(0, input.Position.X - openButton.AbsoluteSize.X / 2, 0, input.Position.Y - openButton.AbsoluteSize.Y / 2)
    end
end)
openButton.InputEnded:Connect(function(input)
    if input == touchControl and input.UserInputType == Enum.UserInputType.Touch then
        touchControl = nil
    end
end)

-- Handle button click to reopen GUI
openButton.MouseButton1Click:Connect(reopenGUI)
