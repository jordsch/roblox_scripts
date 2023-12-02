local Players = game:GetService("Players")
local DS = game:GetService("DataStoreService")
local TDS = DS:GetDataStore("DefaultStats")

local data = {  --list of all the default stats
	["Level"] = 1,
	["Experience"] = 0,
	["LevelUpExp"] = 100,
	["Gold"] = 100,
	["Strength"] = 10,
	["Agility"] = 10
}

game.Players.PlayerAdded:Connect(function(Player)  --Loading Data For Players/Creating new Data for players
	local DataFromStore = nil

	local stats = Instance.new("Folder")
	stats.Name = "stats"
	stats.Parent = Player
	for name, value in pairs(data) do --assigns the player the default stats
		local new = Instance.new("NumberValue")
		new.Name = name
		new.Value = value
		new.Parent = stats
	end

	
	local s, e = pcall(function()
		DataFromStore = TDS:GetAsync(tostring(Player.userId))
	end) --This pcall function returns true if there is no error

	if s then
		print("Getting Data For: " .. Player.Name)
	elseif e then
		warn("Error getting Data For: " .. Player.Name)
	end

	if DataFromStore then
		for name, value in pairs(DataFromStore) do
			Player.stats[name].Value = value
		end
		print ("Data Loaded For: "..Player.Name)
	else
		print("Created New Data For: "..Player.Name)
	end


	
	local experiencePlaceHolder -- made it so subtracting xp from current xp doesnt recurse through the next function

	
	stats.Experience.Changed:Connect(function(val)
		
		if stats.Experience.Value >= stats.LevelUpExp.Value then
			experiencePlaceHolder = stats.Experience.Value
			
			while(experiencePlaceHolder >= stats.LevelUpExp.Value) do
				stats.Level.Value = stats.Level.Value + 1

				experiencePlaceHolder = experiencePlaceHolder - stats.LevelUpExp.Value
				
				stats.Agility.Value = stats.Level.Value * 5

				stats.Strength.Value = stats.Level.Value * 3

				stats.LevelUpExp.Value = 200* stats.Level.Value

				Player.Character:WaitForChild("Humanoid").MaxHealth = 100 * stats.Level.Value + stats.Strength.Value*10
			end
			
			stats.LevelUpExp.Value = 200* stats.Level.Value
			stats.Experience.Value = experiencePlaceHolder
			saveData(Player)

		end
	end)
	if Player.Character and Player.Character:FindFirstChild("Humanoid") then
		
		Player.Character.Humanoid.MaxHealth = 100 * stats.Level.Value + stats.Strength.Value*10
		Player.Character.Humanoid.Health = 100 * stats.Level.Value + stats.Strength.Value*10
		
	end


	Player.CharacterAdded:Connect(function(character)
		local human = character:WaitForChild("Humanoid")
		wait(1)
		human.MaxHealth = 100 * stats.Level.Value + stats.Strength.Value*10
		human.Health = 100 * stats.Level.Value + stats.Strength.Value*10
	end)





	
	
end)

function saveData(Player)

	local PlayerFolder = game.Players:WaitForChild(Player.Name)
	local Stats = PlayerFolder.stats


	--[[local Data = {}

	for _,stat in pairs(Stats:GetChildren()) do --This iterates through the player's leaderstats, which means that it goes through Level, Experience, ... and creates a new list with it.
		Data[stat.Name] = stat.Value
	end]]

	local success, err = pcall(function()	
		TDS:UpdateAsync(Player.userId, function(oldData)

			local saveTable = oldData or {}

				for i, v in pairs(Stats:GetChildren()) do
					saveTable[v.Name] = v.Value
				end

			return saveTable
		end)
	end)
end

workspace:WaitForChild("GiveEXP").ClickDetector.MouseClick:Connect(function(player)
	game.Players[player.Name].stats.Experience.Value = game.Players[player.Name].stats.Experience.Value + 100

	
end)

game.Players.PlayerRemoving:Connect(function(Player)
	saveData(Player)
end)





