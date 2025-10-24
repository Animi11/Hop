--// ⚙️ CONFIG
local PLACE_ID = game.PlaceId
local SEA_FOLDER_NAME = "SeaMonster" -- โฟลเดอร์ SeaMonster ใน Workspace

--// 🧠 SERVICES
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

--// 📁 ระบบกันเข้าเซิร์ฟซ้ำ
local DataFile = "VisitedServers.json"
local VisitedServers = {}

-- โหลด server ที่เคยเข้าไว้
pcall(function()
	if isfile and isfile(DataFile) then
		VisitedServers = HttpService:JSONDecode(readfile(DataFile))
	end
end)

-- ฟังก์ชันบันทึก
local function SaveVisitedServer(id)
	VisitedServers[id] = true
	if writefile then
		writefile(DataFile, HttpService:JSONEncode(VisitedServers))
	end
end

-- ฟังก์ชันเช็คว่ามีโมเดลใน workspace.SeaMonster มั้ย
local function HasModelInSeaMonster()
	local folder = Workspace:FindFirstChild(SEA_FOLDER_NAME)
	if folder then
		for _, obj in ipairs(folder:GetChildren()) do
			if obj:IsA("Model") then
				return true
			end
		end
	end
	return false
end

-- ถ้ามี SeaMonster ตอนนี้ → หยุดเลย
if HasModelInSeaMonster() then
	warn("[✅] พบโมเดลใน workspace.SeaMonster แล้ว! หยุด Server Hop.")
	return
end

-- ฟังก์ชันหาห้องใหม่
local function GetNewServer()
	local cursor = ""
	while true do
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(
				("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s")
				:format(PLACE_ID, cursor ~= "" and "&cursor=" .. cursor or "")
			))
		end)

		if success and result and result.data then
			for _, server in ipairs(result.data) do
				if server.playing < server.maxPlayers and not VisitedServers[server.id] then
					SaveVisitedServer(server.id)
					return server.id
				end
			end
			if result.nextPageCursor then
				cursor = result.nextPageCursor
			else
				break
			end
		else
			task.wait(2)
		end
	end
	return nil
end

-- ฟังก์ชัน Hop เซิร์ฟ
local function Hop()
	while task.wait(3) do -- รอเช็คทุก 3 วิ (ไว)
		if HasModelInSeaMonster() then
			warn("[✅] พบโมเดลใน workspace.SeaMonster แล้ว! หยุด Server Hop.")
			break
		end

		local newServer = GetNewServer()
		if newServer then
			warn("[🌊] ย้ายไปเซิร์ฟใหม่: " .. newServer)
			pcall(function()
				TeleportService:TeleportToPlaceInstance(PLACE_ID, newServer, LocalPlayer)
			end)
			task.wait(5)
		else
			warn("[⚠️] ไม่พบเซิร์ฟใหม่แล้ว! ลองอีกครั้ง...")
			task.wait(10)
		end
	end
end

-- เริ่มกระบวนการ
Hop()
