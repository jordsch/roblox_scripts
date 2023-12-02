local TweenService = game:GetService("TweenService")

local stompFold = game.ServerStorage:WaitForChild("Stomp")

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://5728044200"

local playerDebounces = {}


game.ReplicatedStorage.Stomp.OnServerEvent:Connect(function(player)
	
	if table.find(playerDebounces, player) then return end
	
	local damage = player.stats.Strength.Value * 10
	
	local sizeMultiplier = 1
	if (player.stats.Strength.Value > 500) then sizeMultiplier = 2 end
	
	local character = player.Character
	
	local humanRoot = character:WaitForChild("HumanoidRootPart")
	if not humanRoot then return end
	
	table.insert(playerDebounces, player)
	
	local anim = character.Humanoid:LoadAnimation(animation)
	local activeTracks = character.Humanoid:GetPlayingAnimationTracks()
	for _, v in pairs(activeTracks) do
		v:Stop()
	end
	
	anim:Play()
	anim:GetMarkerReachedSignal("Activation"):Wait()
	wait(.1)
	
	
	local stompEffectsFold = Instance.new("Folder", workspace)
	stompEffectsFold.Name = player.Name.." stompEffects"
	
	local mainStompPiece = stompFold:WaitForChild("MainStomp"):Clone()
	mainStompPiece.CFrame = CFrame.new((humanRoot.CFrame * CFrame.new(0,-2,0)).p)
	mainStompPiece.Parent = stompEffectsFold
	
	local groundWhirl = stompFold:WaitForChild("StompWhirl"):Clone()
	groundWhirl.CFrame = CFrame.new((humanRoot.CFrame * CFrame.new(0,-2,0)).p)
	groundWhirl.Parent = stompEffectsFold
	
	local airWhirl = stompFold:WaitForChild("AirWhirl"):Clone()
	airWhirl.CFrame = CFrame.new((humanRoot.CFrame * CFrame.new(0,5,0)).p)
	airWhirl.Parent = stompEffectsFold
	
	local airWhirlTwo = stompFold:WaitForChild("AirWhirl"):Clone()
	airWhirlTwo.CFrame = CFrame.new((humanRoot.CFrame * CFrame.new(0,7,0)).p)
	airWhirlTwo.Parent = stompEffectsFold
	
	local stompShock = stompFold:WaitForChild("StompShock"):Clone()
	stompShock.CFrame = CFrame.new((humanRoot.CFrame * CFrame.new(0,5,0)).p)
	stompShock.Parent = stompEffectsFold
	--Damaging Function
	local stompPresent = true
	
	spawn(function()
		while stompPresent do
			local maxDist = airWhirl.Size.X/3
			
			for i, plr in pairs(game.Workspace:GetChildren()) do
				
				if plr ~= character then
					
					local Ehum = plr:FindFirstChild("Humanoid")
					local Ehumrp = plr:FindFirstChild("HumanoidRootPart")
					
					if Ehum and Ehumrp then
						local distance = (airWhirl.CFrame.p - Ehumrp.CFrame.p).magnitude
						if distance <= maxDist and plr:FindFirstChild(character.Name.."StompAOE_Debounce") == nil then
							local StompAOEDebris = Instance.new("BoolValue", plr)
							StompAOEDebris.Name = character.Name.."StompAOE_Debounce"
							game:GetService("Debris"):AddItem(StompAOEDebris, 1.5)
							Ehum:TakeDamage(damage)
						end
					end
				end
			end
			wait()
		end
	end)
	-- SizeTween for Stomp
	local Agoal = {} Agoal.Size = mainStompPiece.Size * 4 * sizeMultiplier
	local Bgoal = {} Bgoal.Size = groundWhirl.Size * 6.5 * sizeMultiplier
	local Cgoal = {} Cgoal.Size = airWhirl.Size * 6.5 * sizeMultiplier
	local Dgoal = {} Dgoal.Size = airWhirlTwo.Size * 6.5 * sizeMultiplier
	local AAgoal = {} AAgoal.Size = stompShock.Size * 40 * sizeMultiplier
	local Ainfo = TweenInfo.new(.6, Enum.EasingStyle.Quad)
	local Binfo = TweenInfo.new(.9, Enum.EasingStyle.Quad)
	local Cinfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)

	
	local Atween = TweenService:Create(mainStompPiece, Ainfo, Agoal)
	local Btween = TweenService:Create(groundWhirl, Binfo, Bgoal)
	local Ctween = TweenService:Create(airWhirl, Binfo, Cgoal)
	local Dtween = TweenService:Create(airWhirlTwo, Binfo, Dgoal)
	local AAtween = TweenService:Create(stompShock, Cinfo, AAgoal)
	-- SpinTween for Stomp
	local Egoal = {} Egoal.Orientation = airWhirl.Orientation + Vector3.new(0, 600, 0)
	local Fgoal = {} Fgoal.Orientation = airWhirlTwo.Orientation + Vector3.new(0, -600, 0)
	local Hgoal = {} Hgoal.Orientation = airWhirl.Orientation + Vector3.new(0, 1200, 0)
	
	local Etween = TweenService:Create(mainStompPiece,Cinfo, Hgoal)
	local Ftween = TweenService:Create(groundWhirl,Cinfo, Fgoal)
	local Gtween = TweenService:Create(airWhirl,Cinfo, Egoal)
	local Htween = TweenService:Create(airWhirlTwo,Cinfo, Fgoal)
	
	for _, v in pairs(stompEffectsFold:GetChildren()) do
		
		local ABgoal = {} ABgoal.Transparency = v.Transparency + (1 - v.Transparency)
		local ABinfo = TweenInfo.new(1,Enum.EasingStyle.Linear)
		local ABtween = TweenService:Create(v , ABinfo, ABgoal)
		ABtween:Play()
		
	end
	
	
	Atween:Play()
	Btween:Play()
	Ctween:Play()
	Dtween:Play()
	Etween:Play()
	Ftween:Play()
	Gtween:Play()
	Htween:Play()
	AAtween:Play()
	wait(1)

	stompPresent = false;
	stompEffectsFold:Destroy()
	wait(2.9)
	table.remove(playerDebounces, table.find(playerDebounces, player))
	
	
end)