local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local function Rejoin()
   local success, errorMessage = pcall(function()
       TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end)
   if not success then
       warn("Rejoin failed: " .. errorMessage)
   end
end
Rejoin()
