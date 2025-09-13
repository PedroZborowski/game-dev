local pf = game:GetService("PathfindingService")
local monster = script.Parent:WaitForChild("Humanoid")
local mroot = script.Parent:WaitForChild("HumanoidRootPart")
local positions = {Vector3.new(95.577, 0.5, 60.141),
	Vector3.new(53.477, 0.5, 133.403),
	Vector3.new(101.777, 0.5, 193.103),
	Vector3.new(38.477, 0.5, 211.203),
	Vector3.new(-67.232, 0.5, 139.703),
	Vector3.new(-91.961, 1.401, 93.258),
	Vector3.new(-19.861, 1.401, -18.542)}
local head = script.Parent:WaitForChild("Head")
local path
local waypoints
mroot:SetNetworkOwner(nil)
function findtarget()
	local target
	local dist = 1000000000
	local finaltarget
	for i, v in pairs(game.Players:GetChildren()) do
		if v.Character then
			local hroot = v.Character:FindFirstChild("HumanoidRootPart")
			local human = v.Character:FindFirstChild("Humanoid")
			if human.Health > 0 and checksight(hroot) then
				target = hroot
			end
		end
		if target then
			if (mroot.Position - target.Position).Magnitude < dist then
				finaltarget = target
				dist = (mroot.Position - target.Position).Magnitude
			end
		end
		end
	return finaltarget
end

function checksight(target)
	local ray = Ray.new(mroot.Position, (target.Position - head.Position).Unit * 1000)
	local hit,position = workspace:FindPartOnRayWithIgnoreList(ray, {script.Parent})
	if hit then
		if hit:IsDescendantOf(target.Parent) then
			return true
		end
	end
	return false
end

function walkrandomly()
	local random = math.random(1, 7)
	local goal = nil
	local connection
	for i, v in pairs(positions) do
		if i == random then
			goal = v
		end
	end
	path = pf:CreatePath({["AgentCanJump"] = false})
	path:ComputeAsync(mroot.Position, goal)
	waypoints = path:GetWaypoints()
	if path.Status == Enum.PathStatus.Success then
		for i, v in pairs(waypoints) do
			local target = findtarget()
			if target then
				path:Destroy()
				break
			end
			monster:MoveTo(v.Position)
			local timeout = monster.MoveToFinished:Wait(1)
			if not timeout then
				path:Destroy()
				break
			end
		end
		path:Destroy()
	end
end

function trytocatchup(target)
	path = pf:CreatePath({["AgentCanJump"] = false})
	path:ComputeAsync(mroot.Position, target.Position)
	waypoints = path:GetWaypoints()
	local connection
	if path.Status == Enum.PathStatus.Success then
		for i, v in pairs(waypoints) do
			if checksight(target) then
				break
			end
			monster:MoveTo(v.Position)
			local timeout = monster.MoveToFinished:Wait(1)
			if not timeout then
				break
			end
		end
		path:Destroy()
	end
end

function walktotarget(target)
	path = pf:CreatePath({["AgentCanJump"] = false})
	path:ComputeAsync(mroot.Position, target.Position)
	waypoints = path:GetWaypoints()
	if path.Status == Enum.PathStatus.Success then
		monster:MoveTo(waypoints[1].Position)
		path:Destroy()
	end
	repeat
		monster:MoveTo(target.Position)
		wait()
		if target == nil or target.Parent.Humanoid.Health < 1 then
			break
		end
	until checksight(target) == false or target.Parent.Humanoid.Health < 1
	trytocatchup(target)
	if not checksight(target) then
		target.Parent.chasebegan.Disabled = true
		target.Parent.chaseended.Disabled = false
		head.heartbeat.TimePosition = 0
		head.heartbeat.Playing = false
	end
end

while true do
	local target = findtarget()
	if target then
		monster.WalkSpeed = 14
		target.Parent.chasebegan.Disabled = false
		target.Parent.chaseended.Disabled = true
		head.heartbeat.TimePosition = 0
		head.heartbeat.Playing = true
		walktotarget(target)
	else
		monster.WalkSpeed = 10
		walkrandomly()
	end
end
