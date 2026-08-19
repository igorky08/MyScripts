--[[
Open source
Made by !vcsk0#1516
Credits to me

Credits to the Owner Who Made The ESP Script

]]

local CoreGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.9

getgenv().HitboxStatus = false
getgenv().TeamCheck = false

--// UI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/UI-Library/main/Source/MyUILib(Unamed).lua"))();
local Window = Library:Create("Hitbox Expander")

local HomeTab = Window:Tab("Home","rbxassetid://10888331510")

HomeTab:InfoLabel("only works on some games!")

HomeTab:Section("Settings")

HomeTab:TextBox("Hitbox Size", function(value)
    getgenv().HitboxSize = value
end)

HomeTab:TextBox("Hitbox Transparency", function(number)
    getgenv().HitboxTransparency = number
end)

HomeTab:Section("Main")

game:GetService('RunService').RenderStepped:Connect(function()
	if getgenv().HitboxStatus == true and getgenv().TeamCheck == false then
		for i,v in next, game:GetService('Players'):GetPlayers() do
			if v.Name ~= game:GetService('Players').LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
				pcall(function()
					v.Character.Head.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
					v.Character.Head.Transparency = getgenv().HitboxTransparency
					v.Character.Head.BrickColor = BrickColor.new("Really black")
					v.Character.Head.Material = "Neon"
					v.Character.Head.CanCollide = false
				end)
			end
		end
	elseif getgenv().HitboxStatus == true and getgenv().TeamCheck == true then
		for i,v in next, game:GetService('Players'):GetPlayers() do
			if game:GetService('Players').LocalPlayer.Team ~= v.Team and v.Character and v.Character:FindFirstChild("Head") then
				pcall(function()
					v.Character.Head.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
					v.Character.Head.Transparency = getgenv().HitboxTransparency
					v.Character.Head.BrickColor = BrickColor.new("Really black")
					v.Character.Head.Material = "Neon"
					v.Character.Head.CanCollide = false
				end)
			end
		end
	else
		for i,v in next, game:GetService('Players'):GetPlayers() do
			if v.Name ~= game:GetService('Players').LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
				pcall(function()
					v.Character.Head.Size = Vector3.new(1, 1, 1)
					v.Character.Head.Transparency = 1
					v.Character.Head.BrickColor = BrickColor.new("Medium stone grey")
					v.Character.Head.Material = "Plastic"
					v.Character.Head.CanCollide = false
				end)
			end
		end
	end
end)

HomeTab:Toggle("Status: ", function(state)
	getgenv().HitboxStatus = state
end)

HomeTab:Toggle("Team Check", function(state)
    getgenv().TeamCheck = state
end)

HomeTab:Keybind("Toggle UI", Enum.KeyCode.Insert, function()
    Library:ToggleUI()
end)
