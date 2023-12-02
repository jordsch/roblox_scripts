local player = game.Players.LocalPlayer
local character = player.Character
if not character then character = player.CharacterAdded:wait() end
local userInput = game:GetService("UserInputService")
local humanoid = character.Humanoid

player = game.Players.LocalPlayer.stats
--[[
humanoid.MaxHealth = 100*(player.Level.Value)
humanoid.Health = 100*(player.Level.Value)



player.Level.Changed:Connect(function(val)
	humanoid.MaxHealth = 100*(player.Level.Value)
end)
]]

--variables (Sprint Script)

local dSpeed = 20
local sprinting = false
character.Humanoid.WalkSpeed = dSpeed --default walkspeed is 16, sets default walkspeed to dSpeed

local maxMSpeed = 60

userInput.InputBegan:Connect(function(input) -- checks when a user inputs anything, it'll run the function

	if input.KeyCode == Enum.KeyCode.LeftControl then --if the player input LeftControl, then it will run the while loop.

		if(sprinting == false)then

			if (dSpeed*2*((((player.Agility.Value)/2000) + 1)) > maxMSpeed) then
				character.Humanoid.WalkSpeed = maxMSpeed
			else
				character.Humanoid.WalkSpeed = dSpeed*2*(((player.Agility.Value)/2000) + 1)
			end
				
			sprinting = true
		else
			character.Humanoid.WalkSpeed = dSpeed
			sprinting = false
		end

		--while userInput:IsKeyDown(Enum.KeyCode.LeftControl) do wait() end -- wait until key is unheld
		--character.Humanoid.WalkSpeed = dSpeed --return walkspeed to normal
	end
end)



wait(.2)
--variables (MultiJump Script)
local jumps = 0 -- default value of jumps when standing on ground
local maxjumps = 1*((player.Agility.Value)/100) -- max amount of jumps possible
humanoid.JumpPower = 75 -- how high you want the person to jump. default jump height is 50.


userInput.InputBegan:connect(function(input)
	--if input.UserInputType == Enum.UserInputType.Keyboard then --I commented this out cause a controller cannot input left shift.
	if input.KeyCode == Enum.KeyCode.Space and (jumps < maxjumps) then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		jumps = (jumps+1)
	end
	--end
end)

humanoid.StateChanged:connect(function(oldState, newState)
	-- If player stops jumping, reset
	if newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Climbing or newState == Enum.HumanoidStateType.GettingUp then
		jumps = 0  -- reset number of jump values when landing.
	end
end)
