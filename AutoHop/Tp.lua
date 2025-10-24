--// 🧠 Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--// 🌐 Server Info
local PlaceId = game.PlaceId

--// 📦 UI สร้าง Frame หลัก
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ServerJoinUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

--// 🧭 Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🌐 Server Joiner UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

--// 📋 ช่องกรอก Server ID
local TextBox = Instance.new("TextBox", Frame)
TextBox.PlaceholderText = "ใส่ Server ID ที่ต้องการเข้า..."
TextBox.Size = UDim2.new(1, -40, 0, 30)
TextBox.Position = UDim2.new(0, 20, 0, 60)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Text = ""
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

--// 🧾 ปุ่ม Copy Server ID
local CopyButton = Instance.new("TextButton", Frame)
CopyButton.Size = UDim2.new(0.45, -10, 0, 35)
CopyButton.Position = UDim2.new(0.05, 0, 0, 110)
CopyButton.Text = "📋 Copy Server ID"
CopyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 14
Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 8)

--// 🚪 ปุ่ม Join Server
local JoinButton = Instance.new("TextButton", Frame)
JoinButton.Size = UDim2.new(0.45, -10, 0, 35)
JoinButton.Position = UDim2.new(0.5, 10, 0, 110)
JoinButton.Text = "🚀 Join Server"
JoinButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinButton.Font = Enum.Font.GothamBold
JoinButton.TextSize = 14
Instance.new("UICorner", JoinButton).CornerRadius = UDim.new(0, 8)

--// 🔙 ปุ่ม Close
local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

--// 🧠 ระบบปุ่ม
CopyButton.MouseButton1Click:Connect(function()
	local currentServerId = game.JobId
	setclipboard(currentServerId)
	CopyButton.Text = "✅ Copied!"
	task.wait(1)
	CopyButton.Text = "📋 Copy Server ID"
end)

JoinButton.MouseButton1Click:Connect(function()
	local serverId = TextBox.Text
	if serverId == "" then
		JoinButton.Text = "⚠️ ใส่ Server ID ก่อน!"
		task.wait(1.5)
		JoinButton.Text = "🚀 Join Server"
		return
	end
	JoinButton.Text = "🔁 กำลังเชื่อมต่อ..."
	pcall(function()
		TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
	end)
end)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
