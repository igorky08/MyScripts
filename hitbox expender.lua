-------------------------------------------------
--// HITBOX LOGIC
-------------------------------------------------
RunService.RenderStepped:Connect(function()
	if getgenv().HitboxStatus == true and getgenv().TeamCheck == false then
		for i,v in next, Players:GetPlayers() do
			if v.Name ~= Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
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
		for i,v in next, Players:GetPlayers() do
			local localTeam = Players.LocalPlayer.Team
			local enemyTeam = v.Team
			if localTeam and enemyTeam and localTeam ~= enemyTeam then
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
		for i,v in next, Players:GetPlayers() do
			if v.Name ~= Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
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
La différence : ajout de vérifications localTeam et enemyTeam pour éviter les erreurs quand un joueur n'a pas d'équipe assignée (nil).

refait moi le code 
--[[
Open source
Made by !vcsk0#1516
Credits to me
]]

-------------------------------------------------
--// SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-------------------------------------------------
--// VARIABLES
-------------------------------------------------
getgenv().HitboxSize = 6
getgenv().HitboxTransparency = 0.9
getgenv().HitboxStatus = false
getgenv().TeamCheck = false

-------------------------------------------------
--// FUNCTIONS
-------------------------------------------------
local function CreateSlider(parent, name, order, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Parent = parent
	SliderFrame.Size = UDim2.new(1, 0, 0, 40)
	SliderFrame.BackgroundTransparency = 1
	SliderFrame.LayoutOrder = order

	local Label = Instance.new("TextLabel")
	Label.Parent = SliderFrame
	Label.Size = UDim2.new(0.6, 0, 0, 16)
	Label.Position = UDim2.new(0, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Parent = SliderFrame
	ValueLabel.Size = UDim2.new(0.4, 0, 0, 16)
	ValueLabel.Position = UDim2.new(0.6, 0, 0, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = tostring(default)
	ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

	local SliderBG = Instance.new("Frame")
	SliderBG.Parent = SliderFrame
	SliderBG.Size = UDim2.new(1, 0, 0, 6)
	SliderBG.Position = UDim2.new(0, 0, 0, 26)
	SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	SliderBG.BorderSizePixel = 0

	local BGCorner = Instance.new("UICorner")
	BGCorner.CornerRadius = UDim.new(0, 3)
	BGCorner.Parent = SliderBG

	local SliderFill = Instance.new("Frame")
	SliderFill.Parent = SliderBG
	SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	SliderFill.BorderSizePixel = 0

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(0, 3)
	FillCorner.Parent = SliderFill

	local SliderKnob = Instance.new("Frame")
	SliderKnob.Parent = SliderBG
	SliderKnob.Size = UDim2.new(0, 14, 0, 14)
	SliderKnob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
	SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SliderKnob.BorderSizePixel = 0
	SliderKnob.ZIndex = 2

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = SliderKnob

	local dragging = false

	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
		local value = math.floor((min + (max - min) * pos) * 10 + 0.5) / 10
		SliderFill.Size = UDim2.new(pos, 0, 1, 0)
		SliderKnob.Position = UDim2.new(pos, -7, 0.5, -7)
		ValueLabel.Text = tostring(value)
		callback(value)
	end

	SliderBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
		end
	end)

	SliderBG.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
end

local function CreateToggle(parent, name, order, default, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Parent = parent
	ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
	ToggleFrame.BackgroundTransparency = 1
	ToggleFrame.LayoutOrder = order

	local Label = Instance.new("TextLabel")
	Label.Parent = ToggleFrame
	Label.Size = UDim2.new(0.6, 0, 1, 0)
	Label.Position = UDim2.new(0, 0, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Parent = ToggleFrame
	ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
	ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
	ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(60, 60, 60)
	ToggleBtn.Text = ""
	ToggleBtn.BorderSizePixel = 0

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 10)
	BtnCorner.Parent = ToggleBtn

	local Circle = Instance.new("Frame")
	Circle.Parent = ToggleBtn
	Circle.Size = UDim2.new(0, 16, 0, 16)
	Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.BorderSizePixel = 0

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local toggled = default

	ToggleBtn.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
			Circle.Position = UDim2.new(1, -18, 0.5, -8)
		else
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Circle.Position = UDim2.new(0, 2, 0.5, -8)
		end
		callback(toggled)
	end)
end

local function CreateButton(parent, name, order, callback)
	local Button = Instance.new("TextButton")
	Button.Parent = parent
	Button.Size = UDim2.new(1, 0, 0, 30)
	Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(200, 200, 200)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 13
	Button.BorderSizePixel = 0
	Button.LayoutOrder = order

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = Button

	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
	end)

	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end)

	Button.MouseButton1Click:Connect(function()
		callback()
	end)
end

-------------------------------------------------
--// GUI
-------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxExpanderGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-------------------------------------------------
--// TITLE + DRAG
-------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Soft Aim.exe"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.ZIndex = 2

local TitleLine = Instance.new("Frame")
TitleLine.Parent = MainFrame
TitleLine.Size = UDim2.new(0.8, 0, 0, 1)
TitleLine.Position = UDim2.new(0.1, 0, 0, 40)
TitleLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLine.BorderSizePixel = 0

local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

Title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-------------------------------------------------
--// CONTENT
-------------------------------------------------
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainFrame
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = Content
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 8)

CreateSlider(Content, "Hitbox Size", 1, 0, 6, 6, function(value)
	getgenv().HitboxSize = value
end)

CreateSlider(Content, "Transparency", 2, 0, 1, 0.9, function(value)
	getgenv().HitboxTransparency = value
end)

CreateToggle(Content, "Status", 3, false, function(state)
	getgenv().HitboxStatus = state
end)

CreateToggle(Content, "Team Check", 4, false, function(state)
	getgenv().TeamCheck = state
end)

CreateButton(Content, "No Recoil Gun", 5, function()
	-- à connecter plus tard
end)

-------------------------------------------------
--// TOGGLE GUI (INSERT)
-------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.Insert then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)

-------------------------------------------------
--// HITBOX LOGIC
-------------------------------------------------
RunService.RenderStepped:Connect(function()
	if getgenv().HitboxStatus == true and getgenv().TeamCheck == false then
		for i,v in next, Players:GetPlayers() do
			if v.Name ~= Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
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
		for i,v in next, Players:GetPlayers() do
			local localTeam = Players.LocalPlayer.Team
			local enemyTeam = v.Team
			if localTeam and enemyTeam and localTeam ~= enemyTeam then
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
		for i,v in next, Players:GetPlayers() do
			if v.Name ~= Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("Head") then
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
