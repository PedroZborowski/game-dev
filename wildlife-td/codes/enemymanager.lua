--Os códigos "spawner.lua" e "enemymanager.lua" estão interligados. O código "spawner" é o contexto do servidor, 
--enquanto o código "enemymanager" é o contexto do cliente, programado de maneira a economizar processamento do
--lado do servidor para garantir uma experiência fluida.

local path = require(game:GetService("ReplicatedStorage"):WaitForChild("PathGenerator"))
local EnemySpawned = game:GetService("ReplicatedStorage"):WaitForChild("EnemySpawned")
local tweenservice = game:GetService("TweenService")
local walkanimevent = script:WaitForChild("WalkAnim")
local runegol = 0

EnemySpawned.OnClientEvent:Connect(function(enemy, index, manapoints, life, shield, rune)
	local clone = game:GetService("ReplicatedStorage").Enemies:FindFirstChild(enemy):Clone()
	clone.Parent = game.Workspace.localenemies
	clone.Name = index
	clone:SetPrimaryPartCFrame(path[1])
	for i, v in pairs(clone.info:GetChildren()) do
		local temp = v:Clone()
		temp.Parent = clone
	end
	if rune then
		task.spawn(function()
			runegol += 1
			if runegol == 1 then
				tweenservice:Create(game.Players.LocalPlayer.PlayerGui.Wave.runegol, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
				tweenservice:Create(game.Players.LocalPlayer.PlayerGui.Wave.runegol.UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
			else
				game.Players.LocalPlayer.PlayerGui.Wave.runegol.Text = "A rune golem has spawned! (x"..tostring(runegol)..")"
			end
			task.wait(5)
			runegol -= 1
			if runegol == 0 then
				tweenservice:Create(game.Players.LocalPlayer.PlayerGui.Wave.runegol, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
				tweenservice:Create(game.Players.LocalPlayer.PlayerGui.Wave.runegol.UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
				task.wait(0.5)
				game.Players.LocalPlayer.PlayerGui.Wave.runegol.Text = "A rune golem has spawned!"
			end
		end)
		for i, v in ipairs(clone:GetChildren()) do
			if v:IsA("Part") and v.Material == Enum.Material.Neon then
				task.spawn(function()
					v.Color = Color3.new(1, 0, 0)
					while v.Parent do
						repeat task.wait() v.Color = Color3.new(v.Color.R, v.Color.G+0.003921568627, v.Color.B) until v.Color.G == 1
						repeat task.wait() v.Color = Color3.new(v.Color.R-0.003921568627, v.Color.G, v.Color.B) until v.Color.R == 0
						repeat task.wait() v.Color = Color3.new(v.Color.R, v.Color.G, v.Color.B+0.003921568627) until v.Color.B == 1
						repeat task.wait() v.Color = Color3.new(v.Color.R, v.Color.G-0.003921568627, v.Color.B) until v.Color.G == 0
						repeat task.wait() v.Color = Color3.new(v.Color.R+0.003921568627, v.Color.G, v.Color.B) until v.Color.R == 1
						repeat task.wait() v.Color = Color3.new(v.Color.R, v.Color.G, v.Color.B-0.003921568627) until v.Color.B == 0
					end
				end)
			end
		end
	end
	clone.info:Destroy()
	clone.Humanoid.MaxHealth = life
	clone.Humanoid.Health = life
	if shield then
		clone.buffs.shield.Value = shield
		clone.buffs.maxshield.Value = shield
	end
	local Humanoid = game.Workspace.enemies:FindFirstChild(index).Humanoid
	local hpbar = clone.Head.HealthBarGUI.HealthBar
	local maxshield = clone.buffs.maxshield.Value
	local shield = clone.buffs.shield.Value
	if shield <= 0 then
		hpbar.Bar.Size = UDim2.new(Humanoid.MaxHealth / Humanoid.MaxHealth, 0, 1, 0)
		hpbar.HealthShadow.Size = UDim2.new(Humanoid.MaxHealth / Humanoid.MaxHealth, 0, 1, 0)
		hpbar.HealthLight.Size = UDim2.new(Humanoid.MaxHealth / Humanoid.MaxHealth, 0, 0.22, 0)
		hpbar.HP.Text = math.floor(Humanoid.MaxHealth) .. "/" .. math.floor(Humanoid.MaxHealth)
		hpbar.Bar.BackgroundColor3 = Color3.fromRGB(198, 0, 3)
		hpbar.HealthLight.BackgroundColor3 = Color3.fromRGB(204, 77, 90)
		hpbar.HealthShadow.BackgroundColor3 = Color3.fromRGB(117, 6, 7)
		clone.Head.Heart.ImageLabel.Image = "rbxassetid://113619825215244"
		clone.Head.HealthBarGUI.ImageLabel.Image = "rbxassetid://83665826979069"
	else
		hpbar.HP.Text = math.floor(shield) .. "/" .. math.floor(maxshield)
		hpbar.Bar.Size = UDim2.new(shield / maxshield, 0, 1, 0)
		hpbar.HealthShadow.Size = UDim2.new(shield / maxshield, 0, 1, 0)
		hpbar.HealthLight.Size = UDim2.new(shield/ maxshield, 0, 0.22, 0)
		hpbar.Bar.BackgroundColor3 = Color3.fromRGB(108, 47, 198)
		hpbar.HealthLight.BackgroundColor3 = Color3.fromRGB(130, 91, 198)
		hpbar.HealthShadow.BackgroundColor3 = Color3.fromRGB(72, 32, 132)
		clone.Head.Heart.ImageLabel.Image = "rbxassetid://100628099220646"
		clone.Head.HealthBarGUI.ImageLabel.Image = "rbxassetid://135273372906742"
		if game.Players.LocalPlayer.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			clone.Shield.Shield:Emit(1)
			clone.ForceField.ForceField:Emit(1)
			clone.Shield.Shield.Enabled = true
			clone.ForceField.ForceField.Enabled = true
		end
	end
	
	if manapoints > 0 and not rune then
		for i,v in ipairs(clone:GetChildren()) do
			if v:IsA("Part") and v.Material == Enum.Material.Neon then
				v.Color = Color3.fromRGB(186, 130, 255)
			end
		end
	end
	
	local walkanim = clone.Humanoid.Animator:LoadAnimation(clone.AnimationWalk)
	walkanimevent:Fire(walkanim, clone)
	walkanim:Play()
	
	local connection = Humanoid:GetAttributeChangedSignal("Step"):Connect(function()
		local tween = tweenservice:Create(clone.PrimaryPart, TweenInfo.new(0.166), {CFrame = path[Humanoid:GetAttribute("Step")]})
		tween:Play()
		tween.Completed:Wait()
		tween:Destroy()
	end)
	local connection2
	connection2 = Humanoid.Parent.Destroying:Connect(function()
		connection:Disconnect()
		connection2:Disconnect()
		walkanim:Stop()
		clone:Destroy()
	end)
end)