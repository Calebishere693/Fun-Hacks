--//  Chat Sender (unlimited) LocalScript in StarterGui

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local localPlayer = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ChatSender"
gui.ResetOnSpawn = false
gui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 180)
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 26)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Chat Sender"
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 0, 34)
input.Position = UDim2.fromOffset(10, 36)
input.PlaceholderText = "Your message"
input.Text = ""
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(55,55,55)
input.ClearTextOnFocus = false
input.Parent = frame

local countBox = Instance.new("TextBox")
countBox.Size = UDim2.new(0, 80, 0, 30)
countBox.Position = UDim2.fromOffset(10, 78)
countBox.BackgroundColor3 = Color3.fromRGB(55,55,55)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Times (≤10)"
countBox.Text = "3"
countBox.Parent = frame

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 110, 0, 30)
delayBox.Position = UDim2.fromOffset(100, 78)
delayBox.BackgroundColor3 = Color3.fromRGB(55,55,55)
delayBox.TextColor3 = Color3.new(1,1,1)
delayBox.PlaceholderText = "Delay sec (≥2)"
delayBox.Text = "2"
delayBox.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 110, 0, 34)
startBtn.Position = UDim2.fromOffset(10, 116)
startBtn.Text = "Send"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 110, 0, 34)
stopBtn.Position = UDim2.fromOffset(130, 116)
stopBtn.Text = "Stop"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.BackgroundColor3 = Color3.fromRGB(140,60,60)
stopBtn.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.fromOffset(10, 152)
status.BackgroundTransparency = 1
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Text = "Ready."
status.Parent = frame

-- Helpers
local function trySend(message: string): boolean
	-- Prefer TextChatService (new chat), fall back to legacy event if present
	-- Returns true if a send call was attempted (not blocked by missing APIs)
	local sent = false

	pcall(function()
		if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			local channels = TextChatService:FindFirstChild("TextChannels")
			local general = channels and channels:FindFirstChild("RBXGeneral")
			if general and general.SendAsync then
				general:SendAsync(message)
				sent = true
			end
		end
	end)

	if not sent then
		local dcsce = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if dcsce and dcsce:FindFirstChild("SayMessageRequest") then
			dcsce.SayMessageRequest:FireServer(message, "All")
			sent = true
		end
	end

	return sent
end

local running = false
local MAX_MESSAGES = 1000000000000000000000000
local MIN_DELAY = 0 -- seconds (change it to anything)

startBtn.MouseButton1Click:Connect(function()
	if running then return end
	local msg = input.Text
	local n = tonumber(countBox.Text) or 1
	local d = tonumber(delayBox.Text) or MIN_DELAY

	n = math.clamp(n, 1, MAX_MESSAGES)
	d = math.max(d, MIN_DELAY)

	if msg == nil or msg == "" then
		status.Text = "Enter a message first."
		return
	end

	running = true
	status.Text = ("Sending %d time(s), %gs apart…"):format(n, d)

	for i = 1, n do
		if not running then break end
		local ok = trySend(msg)
		if not ok then
			status.Text = "Chat API blocked or not available in this experience."
			running = false
			break
		end
		task.wait(d)
	end

	if running then
		status.Text = "Done."
	end
	running = false
end)
