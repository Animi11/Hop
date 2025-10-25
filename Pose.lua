--// Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local StarterGui = Player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- ฟังก์ชันหลัก
local function SetupToggleUI()
	local Gui = StarterGui:WaitForChild("MainGui")
	local StarterFrame = Gui:WaitForChild("StarterFrame")
	local LegacyPoseFrame = StarterFrame:WaitForChild("LegacyPoseFrame")
	local SecondSea = LegacyPoseFrame:WaitForChild("SecondSea")

	local isVisible = true

	-- UI ปุ่มเปิดปิด
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ToggleUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = Player:WaitForChild("PlayerGui")

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0, 80, 0, 30)
	Button.Position = UDim2.new(0, 20, 0, 200)
	Button.Text = "🔘 UI ON"
	Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.SourceSansBold
	Button.TextSize = 16
	Button.BorderSizePixel = 0
	Button.AutoButtonColor = true
	Button.Parent = ScreenGui

	local UICorner = Instance.new("UICorner", Button)
	UICorner.CornerRadius = UDim.new(0, 8)

	-- ฟังก์ชันเปิด/ปิด
	local function toggleUI()
		isVisible = not isVisible
		LegacyPoseFrame.Visible = isVisible
		SecondSea.Visible = isVisible
		Button.Text = isVisible and "🔘 UI ON" or "⚫ UI OFF"
	end

	Button.MouseButton1Click:Connect(toggleUI)

	-- กดปุ่ม F ก็เปิด/ปิดได้ด้วย
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == Enum.KeyCode.F then
			toggleUI()
		end
	end)
end

-- เรียกใช้เมื่อเริ่มเกม
Player.CharacterAdded:Connect(function()
	task.wait(3) -- รอโหลด PlayerGui ให้ครบ
	SetupToggleUI()
end)

-- เรียกครั้งแรกเมื่อเข้ามา
if Player.Character then
	task.wait(3)
	SetupToggleUI()
end
