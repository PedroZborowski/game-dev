--Principal código de gerenciamento de dados do jogo, utilizando o DataStoreService oferecido
--pela própria engine do Roblox Studio. Representa algumas escolhas arbitrárias de modelagem
--de banco de dados e formas de carregamento otimizadas, utilizando versionamento.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local levelgui = game.ServerStorage:WaitForChild("LevelGUI")
local titlegui = game.ServerStorage:WaitForChild("TitleGUI")
local DataTemplate = require(script.DataTemplate)
local Equip = game:GetService("ReplicatedStorage"):WaitForChild("Equip")
local LoadedInventory = game:GetService("ReplicatedStorage"):WaitForChild("LoadedInventory")
local TroopAdded = game:GetService("ReplicatedStorage"):WaitForChild("TroopAdded")
local NewTroopData = game:GetService("ReplicatedStorage"):WaitForChild("NewTroopData")
local EnchantTroop = game:GetService("ReplicatedStorage"):WaitForChild("EnchantTroop")
local RuneRemote = game:GetService("ReplicatedStorage"):WaitForChild("RuneRemote")
local Template = game:GetService("ServerStorage"):WaitForChild("Template")
local DataVersion = script:GetAttribute("DataVersion")
local DataStore = DataStoreService:GetDataStore("PlayerStore")
local KeyPrefix = "PlayerData-"
local Connections = {}
local LoadedData = {}
local owners = {161874479, 177750809}
local XP = 500
local levelTitles = {
	{"Mana Novice", 1, 2, Color3.fromRGB(150, 150, 150), {Color3.fromRGB(200, 200, 200), Color3.fromRGB(150, 150, 150)}},
	{"Arcane Initiate", 3, 5, Color3.fromRGB(100, 149, 237), {Color3.fromRGB(135, 206, 250), Color3.fromRGB(70, 130, 180)}},
	{"Mana Trainee", 6, 9, Color3.fromRGB(144, 238, 144), {Color3.fromRGB(173, 255, 173), Color3.fromRGB(0, 100, 0)}},
	{"Apprentice Mage", 10, 14, Color3.fromRGB(255, 215, 0), {Color3.fromRGB(255, 239, 186), Color3.fromRGB(255, 165, 0)}},
	{"Elemental Adept", 15, 19, Color3.fromRGB(70, 130, 180), {Color3.fromRGB(100, 149, 237), Color3.fromRGB(25, 25, 112)}},
	{"Nature Guardian", 20, 24, Color3.fromRGB(34, 139, 34), {Color3.fromRGB(50, 205, 50), Color3.fromRGB(0, 100, 0)}},
	{"Arcane Explorer", 25, 29, Color3.fromRGB(153, 50, 204), {Color3.fromRGB(186, 85, 211), Color3.fromRGB(148, 0, 211)}},
	{"Mana Protector", 30, 34, Color3.fromRGB(255, 140, 0), {Color3.fromRGB(255, 165, 0), Color3.fromRGB(205, 133, 63)}},
	{"Spirit Seeker", 35, 39, Color3.fromRGB(255, 255, 224), {Color3.fromRGB(255, 250, 205), Color3.fromRGB(255, 215, 0)}},
	{"Mystic Defender", 40, 44, Color3.fromRGB(70, 130, 180), {Color3.fromRGB(176, 196, 222), Color3.fromRGB(25, 25, 112)}},
	{"Wild Mage", 45, 49, Color3.fromRGB(218, 112, 214), {Color3.fromRGB(221, 160, 221), Color3.fromRGB(148, 0, 211)}},
	{"Nature’s Ally", 50, 54, Color3.fromRGB(60, 179, 113), {Color3.fromRGB(144, 238, 144), Color3.fromRGB(0, 100, 0)}},
	{"Arcane Warrior", 55, 59, Color3.fromRGB(178, 34, 34), {Color3.fromRGB(240, 128, 128), Color3.fromRGB(139, 0, 0)}},
	{"Mana Champion", 60, 64, Color3.fromRGB(255, 215, 0), {Color3.fromRGB(255, 223, 0), Color3.fromRGB(218, 165, 32)}},
	{"Elemental Warden", 65, 69, Color3.fromRGB(0, 191, 255), {Color3.fromRGB(135, 206, 235), Color3.fromRGB(0, 105, 148)}},
	{"Arcane Sentinel", 70, 74, Color3.fromRGB(72, 61, 139), {Color3.fromRGB(123, 104, 238), Color3.fromRGB(75, 0, 130)}},
	{"Mystic Guardian", 75, 79, Color3.fromRGB(199, 21, 133), {Color3.fromRGB(255, 105, 180), Color3.fromRGB(139, 0, 139)}},
	{"Mana Sage", 80, 84, Color3.fromRGB(218, 165, 32), {Color3.fromRGB(255, 215, 0), Color3.fromRGB(184, 134, 11)}},
	{"Grand Mage", 85, 89, Color3.fromRGB(0, 255, 255), {Color3.fromRGB(224, 255, 255), Color3.fromRGB(0, 139, 139)}},
	{"Archmage", 90, 94, Color3.fromRGB(255, 69, 0), {Color3.fromRGB(255, 99, 71), Color3.fromRGB(139, 0, 0)}},
	{"Wildlife Protector", 95, 99, Color3.fromRGB(34, 139, 34), {Color3.fromRGB(50, 205, 50), Color3.fromRGB(0, 100, 0)}},
	{"Elder Magus", 100, 109, Color3.fromRGB(186, 85, 211), {Color3.fromRGB(218, 112, 214), Color3.fromRGB(148, 0, 211)}},
	{"Mana Master", 110, 119, Color3.fromRGB(255, 140, 0), {Color3.fromRGB(255, 165, 0), Color3.fromRGB(205, 133, 63)}},
	{"Nature’s Sentinel", 120, 129, Color3.fromRGB(0, 128, 0), {Color3.fromRGB(60, 179, 113), Color3.fromRGB(0, 100, 0)}},
	{"Arcane Keeper", 130, 149, Color3.fromRGB(70, 130, 180), {Color3.fromRGB(100, 149, 237), Color3.fromRGB(25, 25, 112)}},
	{"Mystic Warden", 150, 169, Color3.fromRGB(138, 43, 226), {Color3.fromRGB(186, 85, 211), Color3.fromRGB(148, 0, 211)}},
	{"Elemental Sovereign", 170, 199, Color3.fromRGB(255, 0, 255), {Color3.fromRGB(255, 105, 180), Color3.fromRGB(139, 0, 139)}},
	{"Guardian of Life", 200, 249, Color3.fromRGB(0, 250, 154), {Color3.fromRGB(144, 238, 144), Color3.fromRGB(0, 100, 0)}},
	{"Mana Overlord", 250, 299, Color3.fromRGB(255, 215, 0), {Color3.fromRGB(255, 223, 0), Color3.fromRGB(218, 165, 32)}},
	{"Arcane Ascendant", 300, math.huge, Color3.fromRGB(255, 0, 0), {Color3.fromRGB(255, 69, 0), Color3.fromRGB(139, 0, 0)}}
}
local troopdata = require(script.TroopData)

local function GetTitle(level)
	for i,v in ipairs(levelTitles) do
		if level >= v[2] and level <= v[3] then
			return {v[1], v[4], v[5]}
		end
	end
end

local function UpdateLevels(player, character, level)
	local ClonedGui = character:WaitForChild("Head"):WaitForChild("LevelGUI")
	local ClonedTitleGui = character:WaitForChild("Head", 5):WaitForChild("TitleGUI", 5)
	local info = GetTitle(level)

	ClonedGui.Frame.TextLabel.Text = "Lv."..tostring(level)
	ClonedTitleGui.Frame.TextLabel.Text = info[1]
	ClonedTitleGui.Frame.TextLabel.TextColor3 = info[2]
	ClonedTitleGui.Frame.TextLabel.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, info[3][1]), ColorSequenceKeypoint.new(1, info[3][2])})

	for i,v in ipairs(owners)  do
		if player.UserId == v then
			ClonedTitleGui.Frame.TextLabel.Text = "Owner"
			ClonedTitleGui.Frame.TextLabel.TextColor3 = Color3.fromRGB(247, 196, 42)
			ClonedTitleGui.Frame.TextLabel.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(217, 131, 32)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(247, 247, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(247, 247, 0))})
		end
	end
end

local function getXPForNextLevel(level)
	return XP * (level)
end

local function WaitForRequestBudget(RequestType)
	local CurrentBudget = DataStoreService:GetRequestBudgetForRequestType(RequestType)
	while CurrentBudget < 1 do
		CurrentBudget = DataStoreService:GetRequestBudgetForRequestType(RequestType)
		task.wait(5)
	end
end

local function GetData(Player)
	local Data = LoadedData[Player]
	if not Data then return end

	return Data
end

local function LoadInventory(Player, Data, Index)
	local Key = KeyPrefix .. tostring(Player.UserId)
	local Success, Error
	if Data then
		local Name = Data.inventory[Index].Name
		if Data.inventory[Index].ver == troopdata[Name].ver then
			return
		end
		Success, Error = pcall(function()
			local enchant = Data.inventory[Index].enchantment
			Data.inventory[Index] = troopdata[Name]
			Data.inventory[Index].enchantment = enchant
		end)
		if not Success then
			warn("Failed to load data: "..tostring(Error))
		end
		return
	else
		warn("No data found for player.")
	end
end

local function Save(Player, onShutdown)
	local Key = KeyPrefix .. tostring(Player.UserId)
	local Success, Error
	local Data = GetData(Player)

	if not Data then return end

	repeat
		if not onShutdown then WaitForRequestBudget(Enum.DataStoreRequestType.UpdateAsync) end
		Success, Error = pcall(function()
			DataStore:UpdateAsync(Key, function(PreviousData)
				return Data
			end)
		end)
	until Success
	if not Success then
		warn("Failed to save data " .. tostring(Error))
		return false
	end
	return true
end

local function OnLeave(Player)
	Save(Player)
	LoadedData[Player] = nil
	--[[for i = 1, #Connections[Player.UserId] do
		Connections[Player.UserId][i]:Disconnect()
		Connections[Player.UserId][i] = nil
		Connections[Player.UserId] = nil
	end]]
	return true
end

local function Load(Player)
	local Key = KeyPrefix .. tostring(Player.UserId)
	local Data
	local Success, Error
	local Inventory = Player.PlayerGui:WaitForChild("InventoryGui"):WaitForChild("Inventory"):WaitForChild("Troops")
	local TroopsGUI = Player.PlayerGui:WaitForChild("TroopsGui")

	repeat
		WaitForRequestBudget(Enum.DataStoreRequestType.GetAsync)
		Success, Error = pcall(function()
			Data = DataStore:GetAsync(Key)
		end)
	until Success or not Players:FindFirstChild(tostring(Player))

	if not Success then
		warn("Failed to load data " .. tostring(Error))
		Player:Kick("Failed to load data. Please rejoin.")
		return false
	end
	
	if not Data then Data = DataTemplate end

	LoadedData[Player] = Data
	
	for i, v in pairs(LoadedData[Player].inventory) do
		LoadInventory(Player, LoadedData[Player], i)
	end

	for i, v in pairs(LoadedData[Player].inventory) do
		local image = Template:Clone()
		local currentslot = 0
		for i2, v2 in pairs(LoadedData[Player].equipped) do
			if v2 == i then
				currentslot = i2
			end
		end
		image.Parent = Inventory
		image.Image = "rbxassetid://"..v.imageID
		image.Name = i
		image.name.Value = v.Name
		image:WaitForChild("level1"):WaitForChild("atkspd").Value = v.level1[2]
		image:WaitForChild("level1"):WaitForChild("cost").Value = v.level1[4]
		image:WaitForChild("level1"):WaitForChild("dmg").Value = v.level1[1]
		image:WaitForChild("level1"):WaitForChild("range").Value = v.level1[3]
		image:WaitForChild("CurrentSlot").Value = currentslot
		--Enchantments:
		if Data.inventory[i].enchantment ~= 0 then
			if Data.inventory[i].enchantment == 1 then
				image:WaitForChild("level1"):WaitForChild("dmg").Value = math.ceil(image:WaitForChild("level1"):WaitForChild("dmg").Value*11)/10
			end
		end
		if currentslot ~= 0 then
			TroopsGUI:WaitForChild(currentslot):WaitForChild("frame").Image = "rbxassetid://"..v.imageID
			TroopsGUI:FindFirstChild(currentslot).TextLabel.Text = "$"..v.level1[4]
		end
		TroopAdded:FireClient(Player, image)
	end

	RuneRemote:FireClient(Player, Data.runeinv)

	local moneyValue = Instance.new("IntValue")
	moneyValue.Name = "cash"
	moneyValue.Parent = Player	
	moneyValue.Value = Data.money
	local expValue = Instance.new("IntValue")
	expValue.Name = "exp"
	expValue.Parent = Player	
	expValue.Value = Data.exp
	local lvlValue = Instance.new("IntValue")
	lvlValue.Name = "lvl"
	lvlValue.Parent = Player
	lvlValue.Value = Data.lvl
	local legendarypityValue = Instance.new("IntValue")
	legendarypityValue.Name = "legendarypity"
	legendarypityValue.Parent = Player
	legendarypityValue.Value = Data.legendarypity
	local mythicpityValue = Instance.new("IntValue")
	mythicpityValue.Name = "mythicpity"
	mythicpityValue.Parent = Player
	mythicpityValue.Value = Data.mythicpity
	local character = Player.Character or Player.CharacterAdded:Wait()
	local ClonedGui = levelgui:Clone()
	local ClonedTitleGui = titlegui:Clone()
	ClonedGui.Parent = character:WaitForChild("Head")
	ClonedTitleGui.Parent = character:WaitForChild("Head")
	while expValue.Value >= getXPForNextLevel(lvlValue.Value) do
		expValue.Value -= getXPForNextLevel(lvlValue.Value)
		lvlValue.Value += 1 
		Data.lvl += 1
		Data.exp -= getXPForNextLevel(lvlValue.Value-1)
	end
	UpdateLevels(Player, character, lvlValue.Value)
	local level = Data.lvl
	if level >= 15 then
		TroopsGUI:WaitForChild("5"):FindFirstChildOfClass("ImageButton").locked:Destroy()
		if level >= 25 then
			TroopsGUI:WaitForChild("6"):FindFirstChildOfClass("ImageButton").locked:Destroy()
		end
	end
	Player:WaitForChild("PlayerGui"):WaitForChild("CashGui"):WaitForChild("money").Text = moneyValue.Value
	local Connection1
	Connection1 = moneyValue:GetPropertyChangedSignal("Value"):Connect(function()
		Data.money = Player.cash.Value
		Player:WaitForChild("PlayerGui"):WaitForChild("CashGui"):WaitForChild("money").Text = moneyValue.Value
	end)
	local Connection2
	Connection2 = legendarypityValue:GetPropertyChangedSignal("Value"):Connect(function()
		Data.legendarypity = Player.legendarypity.Value
	end)
	local Connection3
	Connection3 = mythicpityValue:GetPropertyChangedSignal("Value"):Connect(function()
		Data.mythicpity = Player.mythicpity.Value
	end)
	Connections[Player.UserId] = {}
	table.insert(Connections[Player.UserId], Connection1)
	table.insert(Connections[Player.UserId], Connection2)
	table.insert(Connections[Player.UserId], Connection3)
	LoadedInventory:FireClient(Player)
	return true
end

local function OnGameClose(Player)
	if RunService:IsStudio() then task.wait(2); return end

	local AllPlayersSaved = Instance.new("BindableEvent")
	local AllPlayers = Players:GetPlayers()
	local RemainingPlayers = #AllPlayers

	for i, player in ipairs(AllPlayers) do
		task.spawn(function()
			Save(Player, true)
			RemainingPlayers -= 1

			if RemainingPlayers < 1 then
				AllPlayersSaved:Fire()
			end
		end)
	end
	AllPlayersSaved.Event:Wait()
end

Players.PlayerAdded:Connect(Load)
Players.PlayerRemoving:Connect(OnLeave)

NewTroopData.Event:Connect(function(plr, troop, index)
	local Data = GetData(plr)
	Data.inventory[index] = troopdata[troop]
end)

Equip.OnServerEvent:Connect(function(plr, troopselected, slot)
	local Data = GetData(plr)
	local currentslot = 0
	--Isso aqui só pode acontecer se o cara tiver de hack, mas precisa cobrir essa opção
	if Data.inventory[troopselected] == nil then
		warn("The troop selected does not exist in the player inventory.")
		return
	end
	--Se o slot estiver bloqueado, não faz nada.
	local level = Data.lvl
	if level < 25 then
		if slot == 6 then
			return
		end
		if level < 15 then
			if slot == 5 then
				return
			end
		end
	end
	--Checa entre os equipados. Se já estiver equipado,
	--define o currentslot como o próprio. Se não estiver equipado ainda,
	--porém, existe uma outra tropa com o mesmo nome equipada,
	--desequipa essa outra tropa com o mesmo nome.
	for i, v in pairs(Data.equipped) do
		if v == troopselected then
			currentslot = i
		elseif Data.inventory[v] then
			if Data.inventory[v].Name == Data.inventory[troopselected].Name and tonumber(v) ~= tonumber(troopselected) then
				Data.equipped[i] = 0
			end
		end
	end
	--Se a tropa já está equipada, muda ela de slot para o novo,
	if currentslot ~= 0 then
		if currentslot ~= slot then
			Data.equipped[currentslot] = 0
			Data.equipped[slot] = troopselected
		end
	--Se a tropa não está equipada, simplesmente equipa ela.
	else
		Data.equipped[slot] = troopselected
	end
end)

EnchantTroop.OnServerInvoke = function(plr, troop, enchantment)
	local Data = GetData(plr)
	if Data.runeinv[enchantment] > 0 then
		Data.runeinv[enchantment] -= 1
		Data.inventory[tonumber(troop.Name)].enchantment = enchantment
		return true, troopdata[troop.name.Value]
	else
		return false
	end
end

game:BindToClose(OnGameClose)