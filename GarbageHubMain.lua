-- The invite crasher script has sadly been patched as of the 09/09/2022 game update. Thanks to everyone who used it, it was fun while it lasted.
repeat wait() until game:IsLoaded()
local qtp = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
qtp([[loadstring(game:HttpGet("https://raw.githubusercontent.com/availablegithubname/GarbageHubForRoblox/main/GarbageHubMain.lua", true))()]])
while wait(2) do
  game.StarterGui:SetCore("SendNotification", {Title = "gbh", Text = "patched", Duration = 2})
end
-- no more clientside crasher..
