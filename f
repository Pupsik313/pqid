local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function getServerList(placeId)
	local cursor
	local servers = {}
	repeat
		local response = HttpService:JSONDecode(HttpService:GetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor and "&cursor=" .. cursor or "")))
		for _, v in response.data do
			table.insert(servers, v)
		end
		cursor = response.nextPageCursor
	until not cursor
	return servers
end

local function teleportToMoneyPrinterPart(character)
	local moneyPrinter = workspace:FindFirstChild("Money Printer")
	if moneyPrinter then
		local parts = {}
		for _, child in moneyPrinter:GetChildren() do
			if child:IsA("BasePart") then
				table.insert(parts, child)
			end
		end
		if #parts > 0 then
			local randomPart = parts[math.random(1, #parts)]
			character:SetPrimaryPartCFrame(randomPart.CFrame)
		end
	else
		-- Call getServerList if Money Printer is not found
		local servers = getServerList(7239319209)
		print("Servers:", servers)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		teleportToMoneyPrinterPart(character)
	end)
end)

for _, player in Players:GetPlayers() do
	if player.Character then
		teleportToMoneyPrinterPart(player.Character)
	end
end

