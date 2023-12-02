
local animRightPunch = Instance.new("Animation")
animRightPunch.Name = "RightPunch"
animRightPunch.AnimationId = "rbxassetid://5737723226"

local animLeftPunch = Instance.new("Animation")
animLeftPunch.Name = "LeftPunch"
animLeftPunch.AnimationId = "rbxassetid://5737745234"

local playerDebounces = {}

local rightPunched = {}


game.ReplicatedStorage.Punch.onServerEvent:Connect(function(player)
	
	if table.find(playerDebounces, player) then return end
	
	local character = player.Character
	
	local humanoid = player.Character:WaitForChild("Humanoid")
	
	local animRight = humanoid:LoadAnimation(animRightPunch)
	
	local animLeft = humanoid:LoadAnimation(animLeftPunch)
	
	local rightHand = player.Character:WaitForChild("RightHand")
	
	local leftHand = player.Character:WaitForChild("LeftHand")
	
	local damage = player.stats.Strength.Value
	
	table.insert(playerDebounces, player)
	
	if table.find(rightPunched, player) then
		animLeft:Play()
		table.remove(rightPunched, table.find(rightPunched, player))
	else
		animRight:Play()
		table.insert(rightPunched, player)
	end

	local isRightPunching -- For some reason even with the debounce debris it still does multiple instances of damage so I had to add another precaution to prevent multiple instances of damage occuring from a punch.
	animRight:GetMarkerReachedSignal("RightPunch"):Connect(function()
		isRightPunching = true
		wait(.1)
		isRightPunching = false

	end)
	
	local isLeftPunching -- For some reason even with the debounce debris it still does multiple instances of damage so I had to add another precaution to prevent multiple instances of damage occuring from a punch.
	animLeft:GetMarkerReachedSignal("PunchLeft"):Connect(function()
		isLeftPunching = true
		wait(.1)
		isLeftPunching = false
	end)
	
	rightHand.Touched:Connect(function(hit)
		if hit:IsA("BasePart") and isRightPunching then
			if not hit:IsDescendantOf(character) then
				local Humanoid = hit.Parent:FindFirstChild("Humanoid")
				if Humanoid.Parent:FindFirstChild(character.Name.."PunchRightDebounce") == nil then
					
					local punchDebris = Instance.new("BoolValue", Humanoid.Parent)
					punchDebris.Name = character.Name..("PunchRightDebounce")
					game:GetService("Debris"):AddItem(punchDebris, .2)
					print("Hit Right!")
					
					Humanoid:TakeDamage(damage)
				end
				
			end
		end
	end)
	
	leftHand.Touched:Connect(function(hit)
		if hit:IsA("BasePart") and isLeftPunching then
			if not hit:IsDescendantOf(character) then
				local Humanoid = hit.Parent:FindFirstChild("Humanoid")
				if Humanoid.Parent:FindFirstChild(character.Name.."PunchLeftDebounce") == nil then
					
					local punchDebris2 = Instance.new("BoolValue", Humanoid.Parent)
					punchDebris2.Name = character.Name..("PunchLeftDebounce")
					game:GetService("Debris"):AddItem(punchDebris2, .2)
					print("Hit Left!")
					
					Humanoid:TakeDamage(damage)
				end
				
			end
		end
	end)

	wait(.2)
	
	table.remove(playerDebounces, table.find(playerDebounces, player))
end)