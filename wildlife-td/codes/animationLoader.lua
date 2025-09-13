--Esse foi o código usado para carregar as animações do cliente solicitadas pelo servidor.
--Aqui, foram trabalhados diversos conceitos de física e álgebra linear em cálculos
--de trajetória, orientação e rotação, entre diversas outras aplicações.

local dmgGUI = game:GetService("ReplicatedStorage"):WaitForChild("DamageGUI")
local moneyGUI = game:GetService("ReplicatedStorage"):WaitForChild("MoneyGUI")
local manaGUI = game:GetService("ReplicatedStorage"):WaitForChild("ManaGUI")
local walkanimevent = script.Parent:WaitForChild("EnemyManager"):WaitForChild("WalkAnim")
local animations = script:WaitForChild("Animations")
local dmgindicator = script:WaitForChild("dmgindicator")
local particles = script:WaitForChild("Particles")
local path = require(game:GetService("ReplicatedStorage"):WaitForChild("PathGenerator"))
local plr = game.Players.LocalPlayer
local TS = game:GetService("TweenService")
local alreadyadded = {}
local attackanims = {}

local function updateHPBar(target, info, dmg)
	if target:FindFirstChild("Head") then
		local hpbar = target.Head.HealthBarGUI.HealthBar
		local maxhp = target.Humanoid.MaxHealth
		local newshield
		if hpbar.Bar.BackgroundColor3 == Color3.fromRGB(108, 47, 198) then
		local temptext = {}
		for char in (string.gmatch(hpbar.HP.Text, ".")) do
			if char == "/" then
				break
			else
				table.insert(temptext, char)
			end
		end
		newshield = (table.concat(temptext))
		else
			newshield = -1
		end
		if info.buffs:FindFirstChild("shield") and tonumber(newshield)-dmg > 0 then
			local maxshield = info.buffs:FindFirstChild("maxshield")
			local temptext = {}
			for char in (string.gmatch(hpbar.HP.Text, ".")) do
				if char == "/" then
					break
				else
					table.insert(temptext, char)
				end
			end
			target.Head.HitShield:Play()
			newshield = tonumber(table.concat(temptext))-dmg
			hpbar.HP.Text = math.floor(newshield) .. "/" .. math.floor(maxshield.Value)
			hpbar.Bar.Size = UDim2.new(newshield / maxshield.Value, 0, 1, 0)
			hpbar.HealthShadow.Size = UDim2.new(newshield / maxshield.Value, 0, 1, 0)
			hpbar.HealthLight.Size = UDim2.new(newshield/ maxshield.Value, 0, 0.22, 0)
			hpbar.Bar.BackgroundColor3 = Color3.fromRGB(108, 47, 198)
			hpbar.HealthLight.BackgroundColor3 = Color3.fromRGB(130, 91, 198)
			hpbar.HealthShadow.BackgroundColor3 = Color3.fromRGB(72, 32, 132)
			target.Head.Heart.ImageLabel.Image = "rbxassetid://100628099220646"
			target.Head.HealthBarGUI.ImageLabel.Image = "rbxassetid://135273372906742"
			
		elseif tonumber(newshield)-dmg <= 0 then
			if hpbar.Bar.BackgroundColor3 == Color3.fromRGB(108, 47, 198) then
				target.Head.HitShield:Play()
				local temptext = {}
				for char in (string.gmatch(hpbar.HP.Text, ".")) do
					if char == "/" then
						break
					else
						table.insert(temptext, char)
					end
				end
				local newhp = maxhp-(dmg-tonumber(table.concat(temptext)))
				
				if math.floor(newhp) <= 0 then
					hpbar.Visible = false
					target.Head.Heart.ImageLabel.Visible = false
					target.Head.HealthBarGUI.ImageLabel.Visible = false
					target.Head.GolemName.GolemName.Visible = false
				end
					hpbar.HP.Text = math.floor(newhp) .. "/" .. math.floor(maxhp)
					hpbar.Bar.Size = UDim2.new(newhp / maxhp, 0, 1, 0)
					hpbar.HealthShadow.Size = UDim2.new(newhp / maxhp, 0, 1, 0)
					hpbar.HealthLight.Size = UDim2.new(newhp / maxhp, 0, 0.22, 0)
					hpbar.Bar.BackgroundColor3 = Color3.fromRGB(198, 0, 3)
					hpbar.HealthLight.BackgroundColor3 = Color3.fromRGB(204, 77, 90)
					hpbar.HealthShadow.BackgroundColor3 = Color3.fromRGB(117, 6, 7)
					target.Head.Heart.ImageLabel.Image = "rbxassetid://113619825215244"
					target.Head.HealthBarGUI.ImageLabel.Image = "rbxassetid://83665826979069"
				if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
					target.ForceField.Break1:Emit(1)
					target.ForceField.Circle:Emit(1)
					task.wait(0.03)
					target.ForceField.Break2:Emit(1)
					task.wait(0.10)
					target.Head.BreakShield:Play()
					task.wait(0.05)
					target.ForceField.Break3:Emit(1)
					target.ForceField.Pulse:Emit(1)
					local particle = target.Shield.Shield:Clone()
					particle.Parent = target.Shield
					particle.Name  = "temp"
					particle.Enabled = false
					local particle2 = target.ForceField.ForceField:Clone()
					particle2.Parent = target.ForceField
					particle2.Name  = "temp2"
					particle2.Enabled = false
					target.Shield.Shield:Destroy()
					target.ForceField.ForceField:Destroy()
					particle.Name = "Shield"
					particle2.Name = "ForceField"
				end
			else
				target.Head.HitSoundFx:Play()
				local temptext = {}
				for char in (string.gmatch(hpbar.HP.Text, ".")) do
					if char == "/" then
						break
					else
						table.insert(temptext, char)
					end
				end
				local newhp = tonumber(table.concat(temptext))-dmg
				
				if math.floor(newhp) <= 0 then
					hpbar.Visible = false
					target.Head.Heart.ImageLabel.Visible = false
					target.Head.HealthBarGUI.ImageLabel.Visible = false
					target.Head.GolemName.GolemName.Visible = false
				else
					hpbar.HP.Text = math.floor(newhp) .. "/" .. math.floor(maxhp)
					hpbar.Bar.Size = UDim2.new(newhp / maxhp, 0, 1, 0)
					hpbar.HealthShadow.Size = UDim2.new(newhp / maxhp, 0, 1, 0)
					hpbar.HealthLight.Size = UDim2.new(newhp / maxhp, 0, 0.22, 0)
					hpbar.Bar.BackgroundColor3 = Color3.fromRGB(198, 0, 3)
					hpbar.HealthLight.BackgroundColor3 = Color3.fromRGB(204, 77, 90)
					hpbar.HealthShadow.BackgroundColor3 = Color3.fromRGB(117, 6, 7)
				end
			end
		end
	end
end

--Damage and idle animations
game:GetService("ReplicatedStorage"):WaitForChild("PlayAnimation").OnClientEvent:Connect(function(animmodel, animtype, model, targetname, targetpos, atkspd, dmg)
	local target
	local info
	if targetname then
		target = game.Workspace.localenemies:FindFirstChild(targetname)
		info = game.Workspace.enemies:FindFirstChild(targetname)
	end
	if string.match(animmodel, "squirrel") then
		if animtype == "attack" then
			if animations.Value then
				local projectile
				pcall(function()
					local attackanim
					if not alreadyadded[model.AnimationAttack] then
						attackanim = model.Humanoid.Animator:LoadAnimation(model.AnimationAttack)
						attackanims[model.AnimationAttack] = attackanim
						alreadyadded[model.AnimationAttack] = true
					else
						attackanim = attackanims[model.AnimationAttack]
					end
					TS:Create(model.PrimaryPart, TweenInfo.new(0.3), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
					model.Projectile.Transparency = 0
					model.Projectile.Position = model.HumanoidRootPart.Position + model.HumanoidRootPart.CFrame.LookVector * 1 + Vector3.new(0,-1,0) -- coloca a noz no chao, na frente do esquilo
					projectile = model.Projectile:Clone()
					projectile.Transparency = 1
					projectile.Parent = game.Workspace.GameParticles
					projectile.Position = model.HumanoidRootPart.Position
					attackanim:Play() -- animação de ataque
					attackanim:AdjustSpeed(1.6*atkspd)
					task.wait(0.2/(1.6*atkspd))
					local tween = TS:Create(model.Projectile, TweenInfo.new(0.56/(1.6*atkspd), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), {Position = model.Projectile.Position + Vector3.new(0,8,0)})
					tween:Play() -- joga a noz pra cima e desce
					task.wait(0.95/(1.6*atkspd))
					tween:Destroy()
					if particles.Value then
						model.Projectile.Shockwave:Emit(1)
						model.Projectile.Strikes:Emit(2)
					end
					model.Projectile.Transparency = 1
					projectile.Anchored = false
					projectile.Transparency = 0
					local position1 = model.HumanoidRootPart.Position
					local direction = target.torso.Position - position1
					local duration = math.log(1.001 + direction.Magnitude * 0.01)
					local force = direction / duration + Vector3.new(0, game.Workspace.Gravity * duration * 0.5, 0)
					model.Head.HitAcornSoundFx:Play()
					projectile:ApplyImpulse(force * projectile.AssemblyMass)
					task.wait(direction.Magnitude/140) -- tempo até a noz chegar no target
					projectile:Destroy()
				end)
				if projectile then
					projectile:Destroy()
				end
			else
				local position1 = model.HumanoidRootPart.Position
				local direction = target.torso.Position - position1
				task.wait(1.15/(1.6*atkspd) + direction.Magnitude/140)
			end
		elseif animtype == "idle" then
			local anim = model.Humanoid.Animator:LoadAnimation(model.AnimationIdle)
			local animpos = model.Humanoid.Animator:LoadAnimation(model.AnimationPosition)
			animpos:Play()
			task.wait(animpos.Length)
			anim:Play()
			anim.Looped = true
		end
		
	elseif string.match(animmodel, "toucan") then
		if animtype == "attack" then
			if animations.Value then
				local attackanim
				if not alreadyadded[model.AnimationAttack] then
					attackanim = model.Humanoid.Animator:LoadAnimation(model.AnimationAttack)
					attackanims[model.AnimationAttack] = attackanim
					alreadyadded[model.AnimationAttack] = true
				else
					attackanim = attackanims[model.AnimationAttack]
				end
				local tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(0.213/atkspd, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false), {CFrame = CFrame.lookAt(model.HumanoidRootPart.Position + Vector3.new(0,20,0), Vector3.new(targetpos.X,0,targetpos.Z))})
				attackanim:Play()
				task.wait()
				local originalpos = (model.HumanoidRootPart.CFrame)
				task.wait(0.043/atkspd)
				tween:Play()
				model.Head.FlySoundFx:Play()
				task.wait(0.193/atkspd)
				model.Head.FlySoundFx:Stop()
				task.wait(0.02/atkspd)
				local con
				pcall(function()
					local goal = Vector3.new(path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*6/atkspd)].Position.X,
						target.torso.Position.Y,
						path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*6/atkspd)].Position.Z)
						local remainingtime = 0.1/atkspd
						con = info.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
							goal = Vector3.new(path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*6/atkspd)].Position.X,
								target.torso.Position.Y,
								path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*6/atkspd)].Position.Z)
							tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(remainingtime,
								Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false),
								{CFrame = CFrame.lookAlong(goal, (goal-model.HumanoidRootPart.Position).Unit)})
							tween:Play()
						end)
					tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(0.1/atkspd,
						Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false),
						{CFrame = CFrame.lookAlong(goal, (goal-model.HumanoidRootPart.Position).Unit)})
					tween:Play()
					model.Head.DiveSoundFx:Play()
					task.spawn(function()
						repeat local t = task.wait() remainingtime -= t until remainingtime <= 0.02
					end)
					task.wait(0.1/atkspd)
				end)
				if con then
					con:Disconnect()
				end
				model.Head.DiveSoundFx:Stop()
				model.Head.BiteSoundFx:Play()
				task.spawn(function()
					attackanim.TimePosition = 5.27
					tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(0.213/atkspd, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false), {CFrame = CFrame.lookAt(model.HumanoidRootPart.Position + Vector3.new(0,20,0), Vector3.new(originalpos.Position.X,0,originalpos.Position.Z))})
					tween:Play()
					model.Head.FlySoundFx:Play()
					task.wait(0.113/atkspd)
					attackanim:AdjustSpeed(1/(0.1/atkspd))
					task.wait(0.08/atkspd)
					model.Head.FlySoundFx:Stop()
					task.wait(0.02/atkspd)
					tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(0.1/atkspd,
						Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false),
						{CFrame = CFrame.lookAlong(Vector3.new(originalpos.Position.X, originalpos.Position.Y, originalpos.Position.Z),
							(Vector3.new(originalpos.Position.X, originalpos.Position.Y, originalpos.Position.Z) - model.HumanoidRootPart.CFrame.Position).Unit)})
					tween:Play()
					model.Head.DiveSoundFx:Play()
					task.wait(0.08/atkspd)
					model.Head.DiveSoundFx:Stop()
					model.Head.FlySoundFx:Play()
					attackanim.TimePosition = 10
					tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(0.1/atkspd,
						Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false),
						{CFrame = originalpos})
					tween:Play()
					task.wait(0.1/atkspd)
					model.Head.FlySoundFx:Stop()
				end)
			else
				task.wait(0.256 + 0.1/atkspd)
			end
		elseif animtype == "idle" then
			local anim = model.Humanoid.Animator:LoadAnimation(model.AnimationIdle)
			local originalpos = model.HumanoidRootPart.CFrame
			local originalpos2 = model:WaitForChild("tree").Position
			model:SetPrimaryPartCFrame(CFrame.new(originalpos.Position - Vector3.new(0, 8.5, 0)))
			local tween = TS:Create(model.HumanoidRootPart, TweenInfo.new(2), {CFrame = originalpos})
			local tween2 = TS:Create(model.tree, TweenInfo.new(2), {Position = originalpos2})
			tween:Play()
			tween2:Play()
			model.Rumble.RumbleSoundFx:Play()
			task.spawn(function()
				while tween.PlaybackState == Enum.PlaybackState.Playing do
					task.wait()
					if #model.Humanoid.Animator:GetPlayingAnimationTracks() > 0 then
						tween:Cancel()
						tween:Destroy()
						tween2:Cancel()
						tween2:Destroy()
						model.Rumble.RumbleSoundFx:Stop()
						model:SetPrimaryPartCFrame(originalpos)
						model.tree.Position = originalpos2
					end
				end
			end)
			tween.Completed:Wait()
			anim:Play()
			anim.Looped = true
		end
		
	elseif string.match(animmodel, "tiger") then
		if animtype == "attack" then
			if animations.Value then
				local factor = 0.55/atkspd -- Fator = tempo padrão do atkspd no nível 1 / atkspd
				pcall(function()
					local attackanim
					if not alreadyadded[model.AnimationAttack] then
						attackanim = model.Humanoid.Animator:LoadAnimation(model.AnimationAttack)
						attackanims[model.AnimationAttack] = attackanim
						alreadyadded[model.AnimationAttack] = true
					else
						attackanim = attackanims[model.AnimationAttack]
					end
					local tween
					tween = TS:Create(model.PrimaryPart, TweenInfo.new(0.3*factor), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
					attackanim:Play()
					attackanim:AdjustSpeed(1/factor)
					task.spawn(function()
						task.wait(0.65*factor)
						tween = TS:Create(model.PrimaryPart, TweenInfo.new(0.3*factor), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
						model.Head.SlashSoundfx:Play()
						model.Head.SlashSoundfx.PlaybackSpeed = 1/factor
						if particles.Value then
							for i,v in ipairs(model.ClawAttack:GetChildren()) do
								if v.Name == "Attachment" then
									v.Claw:Emit(1)
								elseif v.Name == "Attachment2" then
									v.Scratch2:Emit(1)
									v.dots:Emit(5)
								end
							end
						end
						task.wait(0.37*factor)
						tween = TS:Create(model.PrimaryPart, TweenInfo.new(0.3*factor), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
						model.Head.SlashSoundfx:Play()
						model.Head.SlashSoundfx.PlaybackSpeed = 1/factor
						if particles.Value then
							for i,v in ipairs(model.ClawAttack2:GetChildren()) do
								if v.Name == "Attachment" then
									v.Claw:Emit(1)
								elseif v.Name == "Attachment2" then
									v.Scratch2:Emit(1)
									v.dots:Emit(5)
								end
							end
						end
						task.wait(0.47*factor)
						tween = TS:Create(model.PrimaryPart, TweenInfo.new(0.3*factor), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
						model.Head.SlashSoundfx:Play()
						model.Head.SlashSoundfx.PlaybackSpeed = 1/factor
					end)
				end)
				task.wait(0.73*factor)
			else
				local factor = 0.55/atkspd
				task.wait(0.73*factor)
			end
		elseif animtype == "skill" then
			local factor = 0.55/atkspd
			if animations.Value then
				pcall(function()
					local skillanim
					if not alreadyadded[model.AnimationSkill] then
						skillanim = model.Humanoid.Animator:LoadAnimation(model.AnimationSkill)
						attackanims[model.AnimationSkill] = skillanim
						alreadyadded[model.AnimationSkill] = true
					else
						skillanim = attackanims[model.AnimationSkill]
					end
					TS:Create(model.PrimaryPart, TweenInfo.new(0.3*factor), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
					skillanim:Play()
					skillanim:AdjustSpeed(1/factor)
					task.spawn(function()
						task.wait(0.8)
						model.Head.SkillSoundfx:Play()
					end)
					if particles.Value then
						model.MouthParticle.MainCore.Enabled = true
						model.MouthParticle.Charge.Enabled = true
						model.MouthParticle.dots.Enabled = true
						task.wait(0.8)
						model.MouthParticle.Wind.Enabled = true
						task.wait(0.23)
						model.MouthParticle.MainCore.Enabled = false
						model.MouthParticle.Charge.Enabled = false
						model.MouthParticle.dots.Enabled = false
						model.MouthParticle.Shockwave:Emit(4)
						model.MouthParticle.Circle:Emit(5)
						model.MouthParticle.Explosion.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,30)})
						model.MouthParticle.Explosion:Emit(3)
						task.wait(0.5)
						model.MouthParticle.Wind.Enabled = false
					end
				end)
			end
		elseif animtype == "idle" then
			local anim = model.Humanoid.Animator:LoadAnimation(model.AnimationIdle)
			local animpos = model.Humanoid.Animator:LoadAnimation(model.AnimationPosition)
			animpos:Play()
			task.wait(animpos.Length)
			anim:Play()
			anim.Looped = true
		end
	elseif string.match(animmodel, "monkey") then
		if animtype == "attack" then
			if animations.Value then
				local factor = 0.5/atkspd
				pcall(function()
					local attackanim
					if not alreadyadded[model.AnimationAttack] then
						attackanim = model.Humanoid.Animator:LoadAnimation(model.AnimationAttack)
						attackanims[model.AnimationAttack] = attackanim
						alreadyadded[model.AnimationAttack] = true
					else
						attackanim = attackanims[model.AnimationAttack]
					end
					TS:Create(model.PrimaryPart, TweenInfo.new(0.3), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
					attackanim:Play()
					attackanim:AdjustSpeed(1/factor)
					task.wait(0.433*factor)
					attackanim.TimePosition = 0.433
					model.Monkey:Play()
					model.Monkey.PlaybackSpeed = 1/factor
					local banana = model.banana
					banana.Boomerang:Play()
					banana.Boomerang.PlaybackSpeed = 1/factor
					local cframe = banana.CFrame
					local c0 = model.t5.banana.C0
					model.t5.banana:Destroy()
					banana.Anchored = true
					local toss = true
					task.spawn(function()
						while toss do
							banana.CFrame *= CFrame.Angles(math.rad(25), 0, 0)
							task.wait()
						end
					end)
					local pos1 = cframe.Position
					local pos5 = Vector3.new(path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*30/atkspd)].Position.X,
						target.torso.Position.Y,
						path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*30/atkspd)].Position.Z)
					local direction = (pos5-pos1).Unit
					local radius = (pos1-pos5).Magnitude/2
					local mid = (pos1 + pos5)/2
					local middotcframe = CFrame.new(mid)
					middotcframe = CFrame.lookAlong(middotcframe.Position, direction)
					middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
					local pos4 = middotcframe.Position + middotcframe.LookVector * radius
					local pos8 = middotcframe.Position - middotcframe.LookVector * radius
					middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
					local pos3 = middotcframe.Position + middotcframe.LookVector * radius
					local pos7 = middotcframe.Position - middotcframe.LookVector * radius
					middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
					local pos2 = middotcframe.Position + middotcframe.LookVector * radius
					local pos6 = middotcframe.Position - middotcframe.LookVector * radius
					local con = info.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
						pos5 = Vector3.new(path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*30/atkspd)].Position.X,
							target.torso.Position.Y,
							path[info.Humanoid:GetAttribute("Step") + math.round(info.Humanoid.WalkSpeed*30/atkspd)].Position.Z)
						direction = (pos5-pos1).Unit
						radius = (pos1-pos5).Magnitude/2
						mid = (pos1 + pos5)/2
						middotcframe = CFrame.new(mid)
						middotcframe = CFrame.lookAlong(middotcframe.Position, direction)
						middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
						pos4 = middotcframe.Position + middotcframe.LookVector * radius
						pos8 = middotcframe.Position - middotcframe.LookVector * radius
						middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
						pos3 = middotcframe.Position + middotcframe.LookVector * radius
						pos7 = middotcframe.Position - middotcframe.LookVector * radius
						middotcframe *= CFrame.Angles(0, math.rad(-45), 0)
						pos2 = middotcframe.Position + middotcframe.LookVector * radius
						pos6 = middotcframe.Position - middotcframe.LookVector * radius
					end)
					local tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos2})
					tween:Play()
					task.wait(0.125*factor)
					tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos3})
					tween:Play()
					task.wait(0.125*factor)
					tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos4})
					tween:Play()
					task.wait(0.125*factor)
					tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos5})
					tween:Play()
					task.wait(0.125*factor)
					task.spawn(function()
						tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos6})
						tween:Play()
						task.spawn(function()
							attackanim:Play()
							attackanim:AdjustSpeed(1/factor)
							task.wait(0.433*factor)
							attackanim:AdjustSpeed(0)
							attackanim.TimePosition = 0.433
						end)
						task.wait(0.125*factor)
						tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos7})
						tween:Play()
						task.wait(0.125*factor)
						tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos8})
						tween:Play()
						task.wait(0.125*factor)
						tween = game:GetService("TweenService"):Create(banana, TweenInfo.new(0.125*factor, Enum.EasingStyle.Linear), {Position = pos1})
						tween:Play()
						task.wait(0.125*factor)
						toss = false
						banana.CFrame = cframe
						local joint = Instance.new("Motor6D")
						joint.Parent = model.t5
						joint.Part0 = model.t5
						joint.Part1 = model.banana
						joint.Name = "banana"
						joint.C0 = c0
						banana.Anchored = false
						attackanim:AdjustSpeed(1/factor)
						con:Disconnect()
					end)
				end)
			end
		elseif animtype == "idle" then
			--[[
			local anim = model.Humanoid.Animator:LoadAnimation(model.AnimationIdle)
			local animpos = model.Humanoid.Animator:LoadAnimation(model.AnimationPosition)
			animpos:Play()
			task.wait(animpos.Length)
			anim:Play()
			anim.Looped = true--]]
		end
	elseif string.match(animmodel, "boar") then
	if animtype == "attack" then
		if animations.Value then
			local attackanim
			if not alreadyadded[model.AnimationAttack] then
				attackanim = model.Humanoid.Animator:LoadAnimation(model.AnimationAttack)
				attackanims[model.AnimationAttack] = attackanim
				alreadyadded[model.AnimationAttack] = true
			else
				attackanim = attackanims[model.AnimationAttack]
			end
			local factor = 2/atkspd
			pcall(function()
				TS:Create(model.PrimaryPart, TweenInfo.new(0.3), {CFrame = CFrame.lookAt(model.PrimaryPart.Position, Vector3.new(target.PrimaryPart.Position.X, model.PrimaryPart.Position.Y, target.PrimaryPart.Position.Z))}):Play()
				attackanim:Play()
			end)
			task.wait(0.4*factor)
			--If a projectile was created, it is destroyed here.
		end
	elseif animtype == "idle" then
		local anim = model.Humanoid.Animator:LoadAnimation(model.AnimationIdle)
		local animpos = model.Humanoid.Animator:LoadAnimation(model.AnimationPosition)
		animpos:Play()
		task.wait(animpos.Length)
		anim:Play()
		anim.Looped = true
	end
	elseif string.match(animmodel, "troopname") then
	end
	if dmg and target then
		updateHPBar(target, info, dmg)
	end
end)

--Damage shown
game:GetService("ReplicatedStorage"):WaitForChild("ShowDamage").OnClientEvent:Connect(function(targetpos, dmg, target)
	if dmgindicator.Value then
		local clone = dmgGUI:Clone()
		clone.Parent = workspace.GameParticles
		clone.dmg.Text = tostring(dmg)

		if target:FindFirstChild("buffs") and target.buffs.shield.Value > 0 then
			clone.dmg.TextColor3 = Color3.fromRGB(125, 99, 255)
		end

		local temppart = Instance.new("Part")
		temppart.Parent = workspace.GameParticles
		temppart.Orientation = Vector3.new(0, 0, math.random(-25,25))
		local lv = Instance.new("LinearVelocity")
		lv.Parent = temppart
		local attachment = Instance.new("Attachment")
		attachment.Parent = temppart
		lv.VectorVelocity = temppart.CFrame.UpVector * 20
		local tween1 = TS:Create(lv, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {VectorVelocity = Vector3.new(lv.VectorVelocity.X, 0, lv.VectorVelocity.Z)})
		tween1:Play()
		local tween2 = TS:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
		lv.Attachment0 = attachment
		temppart.Transparency = 1
		temppart.CanCollide = false
		temppart.Size = Vector3.new(0.1, 0.1, 0.1)
		if target then
			temppart.Position = game.Workspace.localenemies:FindFirstChild(target.Name).Head.Position
		end
		clone.Adornee = temppart
		task.wait(0.4)
		lv.Enabled = false
		tween2:Play()
		task.wait(1)
		clone:Destroy()
		temppart:Destroy()
	end
end)

--Money dropped particles
game:GetService("ReplicatedStorage"):WaitForChild("EnemyMoney").OnClientEvent:Connect(function(money, targetpos, enemy)
	local clone = moneyGUI:Clone()
	clone.Parent = workspace.GameParticles
	clone.Frame.TextLabel.Text = "+"..tostring(money)
	local temppart = Instance.new("Part")
	temppart.Parent = workspace.GameParticles
	temppart.Orientation = Vector3.new(0, 0, math.random(-25,25))
	local lv = Instance.new("LinearVelocity")
	lv.Parent = temppart
	local attachment = Instance.new("Attachment")
	attachment.Parent = temppart
	lv.VectorVelocity = temppart.CFrame.UpVector * 5
	local tween1 = TS:Create(lv, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {VectorVelocity = Vector3.new(lv.VectorVelocity.X, 0, lv.VectorVelocity.Z)})
	tween1:Play()
	local tween2 = TS:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
	lv.Attachment0 = attachment
	temppart.Transparency = 1
	temppart.CanCollide = false
	temppart.Size = Vector3.new(0.1, 0.1, 0.1)
	temppart.Position = game.Workspace.localenemies:FindFirstChild(enemy.Name).Head.Position
	clone.Adornee = temppart
	task.wait(1.5)
	lv.Enabled = false    
	tween2:Play()
	task.wait(1)
	clone:Destroy()
	temppart:Destroy()	
end)

--Mana dropped particles
game:GetService("ReplicatedStorage"):WaitForChild("EnemyMana").OnClientEvent:Connect(function(manapoint, targetpos, enemy)
	local clone = manaGUI:Clone()
	clone.Parent = workspace.GameParticles
	clone.Frame.TextLabel.Text = "+"..tostring(manapoint)
	local temppart = Instance.new("Part")
	temppart.Parent = workspace.GameParticles
	temppart.Orientation = Vector3.new(0, 0, math.random(-25,25))
	local lv = Instance.new("LinearVelocity")
	lv.Parent = temppart
	local attachment = Instance.new("Attachment")
	attachment.Parent = temppart
	lv.VectorVelocity = temppart.CFrame.UpVector * 2
	local tween1 = TS:Create(lv, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {VectorVelocity = Vector3.new(lv.VectorVelocity.X, 0, lv.VectorVelocity.Z)})
	tween1:Play()
	local tween2 = TS:Create(clone, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
	lv.Attachment0 = attachment
	temppart.Transparency = 1
	temppart.CanCollide = false
	temppart.Size = Vector3.new(0.1, 0.1, 0.1)
	temppart.Position = game.Workspace.localenemies:FindFirstChild(enemy.Name).Head.Position
	clone.Adornee = temppart
	task.wait(1.5)
	lv.Enabled = false    
	tween2:Play()
	task.wait(1)
	clone:Destroy()
	temppart:Destroy()
end)

--Dead Golem particles
game:GetService("ReplicatedStorage"):WaitForChild("VFXEvents"):WaitForChild("DieGolem").OnClientEvent:Connect(function(targetpos, manapoint, enemyname)
	local enemy = game.Workspace.localenemies:FindFirstChild(enemyname)
	
	if manapoint == 0 then
		local deathanim = enemy.Humanoid.Animator:LoadAnimation(enemy.AnimationDeath)
		deathanim:Play()
		
		deathanim.Stopped:Connect(function()
			deathanim.TimePosition = deathanim.Length
			deathanim:AdjustSpeed(0)
		end)
		
		task.wait(2)
		if particles.Value then
			local particle = game.ReplicatedStorage.VFXParticles.DieGolemVFX:Clone()
			particle.Parent = game.Workspace.GameParticles
			particle.Transparency = 1
			particle.Size = Vector3.new(0.1,0.1,0.1)
			particle.Position = targetpos + Vector3.new(0,1,0)
			particle.Break1:Emit(1)
			particle.Break2:Emit(1)
			particle.Break3:Emit(1)
			particle.Break4:Emit(1)
			particle.Shockwave:Emit(1)
			particle.Smoke:Emit(15)
			particle.dots:Emit(12)
			particle.Circle:Emit(5)
			particle["Surrounding Aura"]:Emit(1)
			task.wait(3)
			particle:Destroy()
		end
	elseif manapoint == 1 then
		enemy.Humanoid.Animator:LoadAnimation(enemy.AnimationDeath):Play()
		task.wait(2)
		if particles.Value then
			local particle = game.ReplicatedStorage.VFXParticles.DieManaGolemVFX:Clone()
			particle.Parent = game.Workspace.GameParticles
			particle.Transparency = 1
			particle.Size = Vector3.new(0.1,0.1,0.1)
			particle.Position = targetpos + Vector3.new(0,1,0)
			particle.Break1:Emit(1)
			particle.Break2:Emit(1)
			particle.Break3:Emit(1)
			particle.Break4:Emit(1)
			particle.Shockwave:Emit(1)
			particle.Smoke:Emit(15)
			particle.dots:Emit(12)
			particle.Circle:Emit(5)
			particle["Surrounding Aura"]:Emit(1)
			wait(3)
			particle:Destroy()
		end
	end
end)

local walkanims = {}
local isFrozen = {}
local isShocked = {}
local isThrowback = {}
local currentSpeed = {}
walkanimevent.Event:Connect(function(walkanim, enemy)
	walkanims[enemy.Name] = walkanim
	isFrozen[enemy.Name] = false
	isShocked[enemy.Name] = false
	isThrowback[enemy.Name] = false
	currentSpeed[enemy.Name] = 1
	local con
	con = enemy.Destroying:Connect(function()
		walkanims[enemy.Name] = nil
		isFrozen[enemy.Name] = nil
		isShocked[enemy.Name] = nil
		isThrowback[enemy.Name] = nil
		currentSpeed[enemy.Name] = nil
		if walkanim then
			walkanim:Destroy()
		end
		con:Disconnect()
		con = nil
	end)
end)

--Debuff VFX
game:GetService("ReplicatedStorage"):WaitForChild("VFXEvents"):WaitForChild("Debuff").OnClientEvent:Connect(function(debuff, target, duration)
	local enemy = game.Workspace.localenemies:FindFirstChild(target)
	if debuff == "slowness" then
		currentSpeed[target] = 1/duration
		walkanims[target]:AdjustSpeed(1/duration)
		task.wait(3)
		if target then
			currentSpeed[target] = 1
			walkanims[target]:AdjustSpeed(1)
		end
	elseif debuff == "stun" then
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			enemy.HeadParticle.Shockwave:Emit(1)
			enemy.HeadParticle.Shockwave.Enabled = true
		end
		local anim = enemy.Humanoid.Animator:LoadAnimation(enemy.AnimationStun)
		anim:Play()
		task.wait(duration)
		anim:Stop()
		anim:Destroy()
		enemy.HeadParticle.Shockwave.Enabled = false
	elseif debuff == "freeze" then
		isFrozen[target] = true
		walkanims[target]:AdjustSpeed(0)
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			enemy.HeadParticle.Freeze.Enabled = true
		end
		task.wait(duration)
		isFrozen[target] = false
		if not isShocked[target] and not isThrowback[target] then
			walkanims[target]:AdjustSpeed(currentSpeed[target])
		end
		enemy.HeadParticle.Freeze.Enabled = false
	elseif debuff == "bleed" then
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			enemy.HeadParticle.Splash.Enabled = true
		end
		task.wait(10)
		enemy.HeadParticle.Splash.Enabled = false
	elseif debuff == "poison" then
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			enemy.HeadParticle.Bubbles.Enabled = true
		end
		task.wait(10)
		enemy.HeadParticle.Bubbles.Enabled = false
	elseif debuff == "shock" then
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			enemy.HeadParticle.Electric.Enabled = true
		end
		for i = 1,duration do
			task.wait(1)
			isShocked[target] = true
			walkanims[target]:AdjustSpeed(0)
			task.wait(0.5)
			isShocked[target] = true
			if not isFrozen[target] and not isThrowback[target] then
				walkanims[target]:AdjustSpeed(1)
			end
		end
		enemy.HeadParticle.Electric.Enabled = false
	elseif debuff == "throwback" then
		isThrowback[target] = true
		walkanims[target]:AdjustSpeed(0)
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			for i, v in pairs(enemy.HumanoidRootPart:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = true
				end
			end
		end
		task.wait(2)
		isThrowback[target] = false
		if plr.PlayerGui.Wave.SettingsFrame.Frame.GameParticles:FindFirstChild("On") then
			for i, v in pairs(enemy.HumanoidRootPart:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = false
				end
			end
		end
		if not isFrozen[target] and not isShocked[target] then
			walkanims[target]:AdjustSpeed(1)
		end
	end
end)