--Os códigos "spawner.lua" e "enemymanager.lua" estão interligados. O código "spawner" é o contexto do servidor, 
--enquanto o código "enemymanager" é o contexto do cliente, programado de maneira a economizar processamento do
--lado do servidor para garantir uma experiência fluida.

local wave
local playeramt = 0
local currentwave = 1
local enemies = game.Workspace:WaitForChild("enemies")
local currentenemies = 0
local waves = 15 --quantas waves vão ter
local nextwave = game:GetService("ReplicatedStorage"):WaitForChild("NextWave")
local currwave = game:GetService("ReplicatedStorage"):WaitForChild("CurrentWave")
local wavecleared = game:GetService("ReplicatedStorage"):WaitForChild("wavecleared")
local voteevent = game:GetService("ReplicatedStorage"):WaitForChild("DiffVote")
local diffchosen = game:GetService("ReplicatedStorage"):WaitForChild("DiffChosen")
local EarnStuff = game:GetService("ReplicatedStorage"):WaitForChild("EarnStuff")
local Win = game:GetService("ReplicatedStorage"):WaitForChild("Win")
local Loss = game:GetService("ReplicatedStorage"):WaitForChild("Loss")
local lost = false
local EndButton = game:GetService("ReplicatedStorage"):WaitForChild("EndButton")
local PlayAgain = game:GetService("ReplicatedStorage"):WaitForChild("PlayAgain")
local EnemySpawned = game:GetService("ReplicatedStorage"):WaitForChild("EnemySpawned")
local path = require(game:GetService("ReplicatedStorage"):WaitForChild("PathGenerator"))
local moneyEarned = 0
local xpEarned = 0
local plrsloaded = 0
local plrsshouldbe
local diffmulti = 1
local plrmulti = 1
local wavemoney = 100
local tpserv = game:GetService("TeleportService")


local function hp(value)
	return math.round(value*plrmulti)
end

local function shl(value)
	return math.round(value*plrmulti)
end

local function mon(value)
	return math.round(value*diffmulti)
end

local function xp(value)
	return math.round(value*diffmulti)
end

if game:GetService("RunService"):IsStudio() then
	plrsshouldbe = 1
else
	local connection2
	connection2 = game:GetService("ReplicatedStorage"):WaitForChild("FirstLoad").OnServerEvent:Connect(function(plr, teleportdata)
		plrsshouldbe = teleportdata.playeramount
		connection2:Disconnect()
		connection2 = nil
	end)
end
local timeout = 0
local textcooldown = 0
local wavegenerating = false
local skipwavecount = 0
local skipped = false

local votehasended = false
local conn
conn = game.Players.PlayerAdded:Connect(function(lpr)
	local plramt = #game.Players:GetChildren()
	if plramt == 2 then
		plrmulti = 1.5
	elseif plramt == 3 then
		plrmulti = 2
	elseif plramt == 4 then
		plrmulti = 2.5
	elseif plramt == 5 then
		plrmulti = 3
	end
		local obj = Instance.new("IntValue")
		obj.Name = "money"
		obj.Value = 0
		obj.Parent = lpr
		obj = nil
end)
local conn2
conn2 = game.Players.PlayerAdded:Connect(function(lpr)
	local obj = Instance.new("IntValue")
	obj.Name = "mana"
	obj.Value = 0
	obj.Parent = lpr
	obj = nil
end)

local connection

connection = game:GetService("ReplicatedStorage").PlayerLoaded.OnServerEvent:Connect(function()
	plrsloaded += 1
end)

repeat task.wait(0.2) timeout += 0.2 game:GetService("ReplicatedStorage").PlayerLoaded:FireAllClients(plrsloaded, plrsshouldbe, timeout) until plrsloaded == plrsshouldbe or timeout >= 60
connection:Disconnect()
connection = nil
conn:Disconnect()
conn = nil
conn2:Disconnect()
conn2 = nil
task.wait(1)

for i, v in pairs(game:GetService("Players"):GetChildren()) do
	v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame").Visible = true
end

local votes = {Easy = 0, Medium = 0, Hard = 0, Impossible = 0}
local playervotes = {}
local cooldown = {}
local conn3
conn3 = voteevent.OnServerEvent:Connect(function(plr, vote)
	if not cooldown[plr] then
		cooldown[plr] = true
		if vote == 1 then
			votes.Easy += 1
			if votes[playervotes.plr] then
				votes[playervotes.plr] -= 1
			end
			playervotes.plr = "Easy"
			voteevent:FireAllClients(votes, false)
		elseif vote == 2 then
			votes.Medium += 1
			if votes[playervotes.plr] then
				votes[playervotes.plr] -= 1
			end
			playervotes.plr = "Medium"
			voteevent:FireAllClients(votes, false)
		elseif vote == 3 then
			votes.Hard += 1
			if votes[playervotes.plr] then
				votes[playervotes.plr] -= 1
			end
			playervotes.plr = "Hard"
			voteevent:FireAllClients(votes, false)
		elseif vote == 4 then
			votes.Impossible += 1
			if votes[playervotes.plr] then
				votes[playervotes.plr] -= 1
			end
			playervotes.plr = "Impossible"
			voteevent:FireAllClients(votes, false)
		end
		cooldown[plr] = false
	end
end)

local temptimer = 2 -- tempo para escolher a dificuldade
while not votehasended do
	task.wait(1)
	temptimer -= 1
	voteevent:FireAllClients(false, true, temptimer)
	if temptimer == 0 then
		votehasended = true
	end
end

local difficultychosen
playervotes = nil
cooldown = nil
conn3 = nil
votehasended = nil
local morevotes = 0
for i, v in pairs(votes) do
	if v >= morevotes then
		morevotes = v
		difficultychosen = i
	end
end
votes = nil
morevotes = nil
for i, v in pairs(game:GetService("Players"):GetChildren()) do
	local cor 
		cor = coroutine.create(function()
			diffchosen:FireClient(v, difficultychosen)
			v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Easy"):WaitForChild("TextButton").Interactable = false
			v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Medium"):WaitForChild("TextButton").Interactable = false
			v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Hard"):WaitForChild("TextButton").Interactable = false
			v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild("Impossible"):WaitForChild("TextButton").Interactable = false
			task.wait(5)
			v.PlayerGui:WaitForChild("Wave"):WaitForChild("Frame"):Destroy()
			cor = nil
		end)
	coroutine.resume(cor)
end

local wave1, wave2, wave3, wave4, wave5, wave6, wave7, wave8, wave9, wave10,
wave11, wave12, wave13, wave14, wave15, wave16, wave17, wave18, wave19, wave20,
wave21, wave22, wave23, wave24, wave25, wave26, wave27, wave28, wave29, wave30,
allwaves

--Spawna a quantidade "amount" de um inimigo cujo nome é "enemy" a cada "cooldown" segundos.
local function spawnenemies(enemy, amount, cooldown, life, shield)
	for i = 1, amount do
		task.wait(cooldown)
		task.spawn(function()
			local model = Instance.new("Model")
			model.Parent = enemies
			local info = game.ReplicatedStorage.Enemies:FindFirstChild(enemy):FindFirstChild("info"):GetChildren()
			for i, v in pairs(info) do
				local temp = v:Clone()
				temp.Parent = model
			end
			model.Humanoid.MaxHealth = hp(life)
			model.Humanoid.Health = hp(life)
			if shield and shield > 0 then
				model.buffs.maxshield.Value = shl(shield)
				model.buffs.shield.Value = shl(shield)
			else
				model.buffs.maxshield.Value = 0
				model.buffs.shield.Value = 0
			end
			model.Name = "enemy"..tostring(currentenemies + 1)
			currentenemies += 1
			
			local manachance = math.random(1000,1000)
			local runegolem = false
			if manachance == 1000 then
				runegolem = true
			elseif manachance > 200 then
				model.Mana.Value = 0
			end
			EnemySpawned:FireAllClients(enemy, model.Name, model.Mana.Value, model.Humanoid.MaxHealth, model.buffs.shield.Value, runegolem)
		end)
	end
end

--Argumentos:
--[1]: Nome do inimigo pelo pelo replicated storage
--[2]: Quantos desse inimigo vão spawnar
--[3]: Cooldown entre os inimigos spawnando
--[4]: Vida do inimigo
--[5]: Quantidade de escudo (Opcional)

if difficultychosen == "Easy" then
	wave1 = {
		{"MiniGolem", 1, 2, 10, 0},
		{"TankGolem", 1, 2, 50, 30},
	}

	wave2 = {
		{"TankGolem", 1, 2, 50, 30},
		{"MiniGolem", 5, 2, 20},
	}

	wave3 = {
		{"TankGolem", 0, 0.5, 40, 50},
		{"MiniGolem", 0, 2, 40},
	}

	wave4 = {
		{"TankGolem", 0, 0.5, 60, 60},
		{"MiniGolem", 0, 2, 40},
	}
	
	wave5 = {
		{"TankGolem", 0, 0.5, 60, 70},
		{"MiniGolem", 0, 2, 60, 0},
	}

	wave6 = {
		{"TankGolem", 0, 0.5, 70, 80},
		{"MiniGolem", 0, 2, 60, 20},
	}

	wave7 = {
		{"TankGolem", 0, 0.5, 80, 90},
		{"MiniGolem", 0, 2, 60, 30},
	}

	wave8 = {
		{"TankGolem", 0, 0.5, 100, 100},
		{"MiniGolem", 0, 2, 60, 30},
	}
	wave9 = {
		{"TankGolem", 0, 0.5, 100, 110},
		{"MiniGolem", 0, 2, 60, 40},
	}

	wave10 = {
		{"TankGolem", 0, 0.5, 120, 100},
		{"MiniGolem", 0, 2, 60, 40},
	}

	wave11 = {
		{"TankGolem", 0, 0.5, 130, 110},
		{"MiniGolem", 0, 2, 60, 50},
	}

	wave12 = {
		{"TankGolem", 0, 0.5, 140, 110},
		{"MiniGolem", 0, 2, 60, 50},
	}
	
	wave13 = {
		{"TankGolem", 0, 0.5, 150, 110},
		{"MiniGolem", 0, 2, 60, 50},
	}

	wave14 = {
		{"TankGolem", 0, 0.5, 150, 130},
		{"MiniGolem", 0, 2, 60, 50},
	}

	wave15 = {
		{"TankGolem", 1, 1, 4000, 0},
		{"MiniGolem", 0, 2, 60, 50},
	}
	allwaves = {wave1,wave2,wave3,wave4,wave5,wave6,wave7,wave8,wave9,wave10,wave11,wave12,wave13,wave14,wave15}
elseif difficultychosen == "Medium" then
	waves = 20
	diffmulti = 1.25
	
elseif difficultychosen == "Hard" then
	waves = 25
	diffmulti = 1.5
	
elseif difficultychosen == "Impossible" then
	waves = 30
	diffmulti = 2
	
end


task.wait(5)
-- gera a wave
local function startWave(waveNumber)
	wavegenerating = true
	if diffchosen == "Easy" or "Medium" or "Hard" then
		if waveNumber == waves then
			game.ReplicatedStorage.BossWave:FireAllClients()	
		end
	elseif diffchosen == "Impossible" then
		if waveNumber == waves or waveNumber == waves/2 then
			game.ReplicatedStorage.BossWave:FireAllClients()	
		end
	end
	wave = coroutine.create(function()
		if waveNumber <= waves then
			for i=1, #allwaves[waveNumber] do
				spawnenemies(allwaves[waveNumber][i][1], allwaves[waveNumber][i][2], allwaves[waveNumber][i][3], allwaves[waveNumber][i][4], allwaves[waveNumber][i][5])-- Personalize conforme necessário (tipo e quantidade de inimigos)	
			end
		end
		wavegenerating = false	
		if waveNumber < waves then
			game.ReplicatedStorage.SkipWaveVisible:FireAllClients(skipwavecount, true, true)
		end
		if waveNumber == waves + 1 then
			EarnStuff:Fire(mon(50), xp(200))
			moneyEarned += mon(500)
			xpEarned += xp(500)
			Win:FireAllClients(moneyEarned, xpEarned)
			local Replay = {}
			local AlreadyBack = {}
			local timer = 10
			local onCooldown = {}
			EndButton.OnServerEvent:Connect(function(plr, request)
				if not onCooldown[plr] then
					onCooldown[plr] = true
					if request == 1 then
						pcall(function()
							if table.find(Replay, plr) then
								table.remove(Replay, table.find(Replay, plr))
							end
							table.insert(AlreadyBack, plr.UserId)
							tpserv:Teleport(127411676086128, plr) -- Id do lobby
						end)
					else
						if not table.find(Replay, plr) and not table.find(AlreadyBack, plr.UserId) then
							table.insert(Replay, plr)
						end
					end
				end
				task.wait(0.5)
				onCooldown[plr] = false
			end)
			while timer >= 0 do
				PlayAgain:FireAllClients(#Replay, timer)
				task.wait(1)
				timer -= 1
			end
			if #Replay > 0 then
				pcall(function()
					local tpoptions = Instance.new("TeleportOptions")
					tpoptions:SetTeleportData({playeramount = #Replay})
					tpserv:TeleportAsync(74887417310623, Replay, tpoptions) -- Id da mesma place
				end)
			end
		else
			if waveNumber > 5 then
				EarnStuff:Fire(mon(5), xp(100))
				moneyEarned += mon(5)
				xpEarned += xp(100)
			end
		end
	end)
	coroutine.resume(wave)
end

--dinheiro da wave
local function WaveMoney()
	for i,v in ipairs(game.Players:GetPlayers()) do
		v.money.Value += wavemoney
	end
	
	wavemoney += 20
end

--botao de skip
game.ReplicatedStorage.SkipWave.OnServerInvoke = function()	
	skipwavecount += 1
	game.ReplicatedStorage.SkipWaveVisible:FireAllClients(skipwavecount, true, false)
	if skipwavecount == #game.Players:GetChildren() then
		skipped = true
		game.ReplicatedStorage.SkipWaveVisible:FireAllClients(skipwavecount, false, false)
		
		skipwavecount = 0
		wavecleared:FireAllClients(currentwave)
		WaveMoney()
		currentwave += 1
		wait(3)
		nextwave:FireAllClients(currentwave)
		wait(3)
		currwave:FireAllClients(currentwave)
		startWave(currentwave)
		skipped	= false
		
	end	
end

--fim da wave
game.Workspace.enemies.ChildRemoved:Connect(function()
	if #game.Workspace.enemies:GetChildren() == 0 and wavegenerating == false and skipped == false and not lost then
		if currentwave == waves then
			currentwave += 1
			startWave(currentwave)
		else
			wavecleared:FireAllClients(currentwave)
			WaveMoney()
			currentwave += 1
			game.ReplicatedStorage.SkipWaveVisible:FireAllClients(skipwavecount, false)
			skipwavecount = 0
			wait(3)
			nextwave:FireAllClients(currentwave)
			wait(3)
			currwave:FireAllClients(currentwave)
			startWave(currentwave)
		end
	end
end)

game.Players.PlayerRemoving:Connect(function()
	local plramt = #game.Players:GetChildren()
	if plramt == 1 then
		plrmulti = 1
	elseif plramt == 2 then
		plrmulti = 1.5
	elseif plramt == 3 then
		plrmulti = 2
	elseif plramt == 4 then
		plrmulti = 2.5
	end
end)

game.Workspace:WaitForChild("base"):WaitForChild("Health"):GetPropertyChangedSignal("Value"):Connect(function()
	if game.Workspace.base.Health.Value <= 0 then
		lost = true
		local Replay = {}
		local AlreadyBack = {}
		local timer = 10
		Loss:FireAllClients(moneyEarned, xpEarned)
		coroutine.close(wave)
		local onCooldown = {}
		EndButton.OnServerEvent:Connect(function(plr, request)
			if not onCooldown[plr] then
				onCooldown[plr] = true
				if request == 1 then
					pcall(function()
						if table.find(Replay, plr) then
							table.remove(Replay, table.find(Replay, plr))
						end
						table.insert(AlreadyBack, plr.UserId)
						tpserv:Teleport(127411676086128, plr) -- Id do lobby
					end)
				else
					if not table.find(Replay, plr) and not table.find(AlreadyBack, plr.UserId) then
						table.insert(Replay, plr)
					end
				end
			end
			task.wait(0.5)
			onCooldown[plr] = false
		end)
		while timer >= 0 do
			PlayAgain:FireAllClients(#Replay, timer)
			task.wait(1)
			timer -= 1
		end
		if #Replay > 0 then
			pcall(function()
				local tpoptions = Instance.new("TeleportOptions")
				tpoptions:SetTeleportData({playeramount = #Replay})
				tpserv:TeleportAsync(74887417310623, Replay, tpoptions) -- Id da mesma place
			end)
		end
	end
end)

--inicio
nextwave:FireAllClients(currentwave)
task.wait(3)
startWave(currentwave)
currwave:FireAllClients(currentwave)