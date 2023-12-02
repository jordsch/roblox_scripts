local TweenService = game:GetService("TweenService")

local fireball = game.ServerStorage:WaitForChild("Fireball")

local explosion = game.ServerStorage:WaitForChild("Explosion")


local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://5715283763"

local maxRange = 200

local playerDebounces = {}

game.ReplicatedStorage.Fireball.OnServerEvent:Connect(function(player,direction)

	if table.find(playerDebounces, player) then return end -- If player is in the Debounce period, then just end the function as they cant use the fireball
	local character = player.Character
	local newFireball = fireball:Clone()
	local newExplosion = explosion:Clone()

	local anim = character.Humanoid:LoadAnimation(animation)

	local humrt = character.HumanoidRootPart

	if not humrt then return end --anti-exploit protection.

	local speed = 100 --how many studs a second the fireball should be moving (approximate)
	
	if(humrt.Position - direction).Magnitude > maxRange then return end --might remove this later
	
	local travelTime = (humrt.Position - direction).Magnitude/speed  --Tween uses a point A to point B within a time frame. With varying distances, i have to calculate the time that it should take if the tween was in a constant speed.



	local rightHand = player.Character:WaitForChild("RightHand")

	table.insert(playerDebounces, player)

	local ActiveTracks = character.Humanoid:GetPlayingAnimationTracks()
	
	for _, v in pairs(ActiveTracks) do
		v:Stop()
	end


	anim:Play()

	anim:GetMarkerReachedSignal("Activate"):Wait()
	wait(.1)
	

	

	local Damage = player.stats.Strength.Value * 3

	--[[local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	bodyVelocity.Velocity = direction.lookVector*100--(character.HumanoidRootPart.CFrame.lookVector*50)
	bodyVelocity.Parent = newFireball]]
	local size = newFireball.Size

	local offset = Vector3.new(0,0,-5)
	newFireball.CFrame = rightHand.CFrame * CFrame.new(0, -(rightHand.Size.Y/2 + size.Y + 1),0)
	
	newFireball.Parent = workspace
	
	newFireball.Anchored = true

	wait(.25)

	newFireball.Anchored = false
	

	local Ainfo = TweenInfo.new(travelTime,Enum.EasingStyle.Linear)
	
	local Atween = TweenService:Create(newFireball, Ainfo, {
		Position = direction
	})

	Atween:Play()

	local touchConn

	local touchConnExplosion

	touchConn = newFireball.Touched:Connect (function(hit)
		if hit:IsA("BasePart") then
			if not hit:IsDescendantOf(character) then
				local Humanoid = hit.Parent:FindFirstChild("Humanoid")
				
				local tempCFrame = newFireball.CFrame
							
				newFireball:Destroy()						
				
				newExplosion.Parent = workspace				
				newExplosion.CFrame = CFrame.new(tempCFrame.p,humrt.CFrame.p)
				
				local explosionPresent = true
												
				local maxDist

				spawn(function()
					while explosionPresent do
						
						maxDist = newExplosion.Size.X/2
						
						for i, plr in pairs(game.Workspace:GetChildren()) do
														
							if plr ~= character then
								
								local Ehum = plr:FindFirstChild ("Humanoid")								
								local Ehumrp = plr:FindFirstChild("HumanoidRootPart")
								
								if Ehum and Ehumrp then									
									local distance = (newExplosion.CFrame.p - Ehumrp.CFrame.p).magnitude									
									if distance <= maxDist and plr:FindFirstChild (character.Name.."ExplosionVER1_Debounce") == nil then										
										local ExplosionDebris = Instance.new("BoolValue", plr)										
										ExplosionDebris.Name = character.Name.."ExplosionVER1_Debounce"										
										game:GetService("Debris"):AddItem(ExplosionDebris, 2)										
										Ehum:TakeDamage(Damage)										
									end									
								end								
							end
						end
						wait(.1)
					end
				end)

						


				
				local Cgoal = {} -- first creating a goal (TweenService allows us to run multiple "animations"/size changes within the model				
				Cgoal.Size = newExplosion.Size + Vector3.new(30,30,30) -- this lets us set our end point for this particular object				
				local Cinfo = TweenInfo.new(.5,Enum.EasingStyle.Linear) --This is how long we want it to take to reach that goal				
				local Ctween = TweenService:Create(newExplosion,Cinfo,Cgoal) --creating the actual method				
				Ctween:Play() --play the method

				
				local Dgoal = {} 				
				Dgoal.Transparency = newExplosion.Transparency + (1 - newExplosion.Transparency)				
				local Dinfo = TweenInfo.new(.5,Enum.EasingStyle.Linear) 				
				local Dtween = TweenService:Create(newExplosion,Dinfo,Dgoal)				
				Dtween:Play()				
				wait(.5)				
				
				explosionPresent = false	
				
				newExplosion:Destroy()	
			end
						


		end

	end)
	


	Atween.Completed:Wait()

	if touchConn ~= nil then touchConn:Disconnect() end
	if newFireball then
		newFireball:Destroy()
	end
	delay(1, function()
		table.remove(playerDebounces, table.find(playerDebounces, player))
	end)

	
end)