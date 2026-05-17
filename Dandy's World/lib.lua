if not game:IsLoaded() then game.Loaded:Wait() end

local util = loadstring(game:HttpGet("https://raw.githubusercontent.com/riddance-club/library/refs/heads/main/Utility.lua"))()
local services = util.services

local Info = workspace:FindFirstChild("Info")
local InGamePlayers = workspace:FindFirstChild("InGamePlayers")
local CurrentRoom = workspace:FindFirstChild("CurrentRoom")
local Elevators = workspace:FindFirstChild("Elevators")
local Elevator = Elevators and Elevators:FindFirstChild("Elevator")

local lib = {}
local cache = {}

if Info then
	cache.InfoData = {}
	for _, v in Info:GetChildren() do
		if v:IsA("ValueBase") then
			cache.InfoData[v.Name] = v
		end
	end
end

lib.Game = {}
lib.Generators = {}
lib.Players = {}
lib.Twisteds = {}
lib.Items = {}
lib.Map = {}
lib.Utility = util

-- Game

lib.Game.IsRun = function()
	return util.IsValid(CurrentRoom)
end

lib.Game.IsLobby = function()
	return not lib.Game.IsRun()
end

lib.Game.GetMap = function()
	if util.IsValid(cache.CurrentMap) then
		return cache.CurrentMap
	end
	cache.CurrentMap = CurrentRoom:FindFirstChildOfClass("Model")
	return cache.CurrentMap
end

lib.Game.GetPlayersFolder = function()
	return InGamePlayers
end

lib.Game.GetInfoFolder = function()
	return Info
end

lib.Game.GetInfoData = function()
	return cache.InfoData
end

lib.Game.GetInfoValueObject = function(target)
	if not target then return end
	local search = string.lower(target)
	for key, value in pairs(cache.InfoData) do
		if string.find(string.lower(key), search, 1, true) then
			return value
		end
	end
	return
end

lib.Game.GetInfoValue = function(value)
	return value.Value
end

lib.Game.GetGameState = function()
    if Info.Voting.Value then
        return "Voting"
    elseif Info.FloorActive.Value then
        return "FloorActive"
    else
        return "Intermission"
    end
end

-- Generators

-- [new]: returns boolean if the machine is possessed by connie
lib.Generators.IsPossessed = function(machine)
    local stats = machine:FindFirstChild("Stats")
    return stats and stats.Connie.Value or false
end

-- [new]: returns boolean if the machine is default
lib.Generators.IsDefault = function(machine)
	return machine and machine:GetAttribute("MachineFamily") == "SINGLE" or false
end

-- [new]: returns boolean if the machine is dual
lib.Generators.IsDual = function(machine)
	return not lib.Generators.IsDefault(machine)
end

-- [new]: returns the type of the machine, "Dual" or "Default"
lib.Generators.GetType = function(machine)
	return lib.Generators.IsDefault(machine) and "Default" or "Dual"
end

-- [new]: returns "Default", "Circle" or "Treadmill", if it's a Dual machine, returns a table like { ["1"] = "Treadmill", ["2"] = "Circle" }
lib.Generators.GetMinigameType = function(machine)
	if not machine then return nil end

	if lib.Generators.IsDefault(machine) then
		return machine:GetAttribute("MinigameType")
	else
		return {
			["1"] = machine:GetAttribute("MinigameType"),
			["2"] = machine:GetAttribute("Prompt2MinigameType")
		}
	end
end

lib.Generators.GetCompleted = function()
	return Info.GeneratorsCompleted.Value
end

lib.Generators.GetRequired = function()
	return Info.RequiredGenerators.Value
end

lib.Generators.GetRemaining = function()
	return lib.Generators.GetRequired() - lib.Generators.GetCompleted()
end

lib.Generators.IsLast = function()
	return lib.Generators.GetRemaining() == 1
end

lib.Generators.GetTotalProgressDecimal = function()
    return lib.Generators.GetCompleted() / lib.Generators.GetTotal()
end

lib.Generators.GetTotalProgressPercent = function()
    return lib.Generators.GetProgressDecimal() * 100
end

lib.Generators.GetAll = function()
	if not lib.Game.GetMap() then return {} end
	local generators = lib.Game.GetMap():FindFirstChild("Generators")
	return generators and generators:GetChildren() or {}
end

lib.Generators.IsCompleted = function(machine)
    local stats = machine:FindFirstChild("Stats")
    return stats and stats.Completed.Value or false
end

-- [update]: now supports Dual machines
lib.Generators.IsAvailable = function(machine)
	local stats = machine and machine:FindFirstChild("Stats")
	if not stats then return false end
		
	if lib.Generators.IsDual(machine) then
		return stats.ActivePlayer.Value == nil and stats.ActivePlayer2.Value == nil
	end
	
	return stats.ActivePlayer.Value == nil
end

lib.Generators.IsUncompleted = function(machine)
    return not lib.Generators.IsCompleted(machine)
end

-- [update]: now supports Dual machines
lib.Generators.IsUnavailable = function(machine)
    return not lib.Generators.IsAvailable(machine)
end

lib.Generators.GetAnyCompleted = function()
	for _, machine in lib.Generators.GetAll() do
		if lib.Generators.IsCompleted(machine) then
			return machine
		end
	end
end

lib.Generators.GetAnyUncompleted = function()
	for _, machine in lib.Generators.GetAll() do
		if lib.Generators.IsUncompleted(machine) then
			return machine
		end
	end
end

-- [update]: now supports Dual machines
lib.Generators.GetAnyAvailable = function()
	for _, machine in lib.Generators.GetAll() do
		if lib.Generators.IsAvailable(machine) then
			return machine
		end
	end
end

-- [update]: now supports Dual machines
lib.Generators.GetAnyUnavailable = function()
	for _, machine in lib.Generators.GetAll() do
		if lib.Generators.IsAvailable(machine) then
			return machine
		end
	end
end

lib.Generators.GetClosest = function()
    return util.GetClosest(lib.Generators.GetAll())
end

lib.Generators.GetCurrentAmount = function(machine)
    local stats = machine:FindFirstChild("Stats")
    return stats and stats.CurrentAmount.Value or 0
end

lib.Generators.GetRequiredAmount = function(machine)
    local stats = machine:FindFirstChild("Stats")
    return stats and stats.RequiredAmount.Value or 0
end

lib.Generators.GetProgress = function(machine)
    return lib.Generators.GetCurrentAmount(machine) / lib.Generators.GetRequiredAmount(machine)
end

-- Players

lib.Players.GetAll = function()
	return services.Players:GetPlayers()
end

lib.Players.GetLocal = function()
	return util.LocalPlayer
end

lib.Players.GetLocalCharacter = function()
	return util.LocalCharacter
end

lib.Players.GetCharacter = function(player)
	return player.Character
end

lib.Players.GetHealth = function(player)
	local character = lib.Players.GetCharacter(player)
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			return humanoid.Health
		end
	end
	return 0
end

lib.Players.IsAlive = function(player)
	if InGamePlayers:FindFirstChild(player.Name) then
		return true
	end
	return false
end

lib.Players.IsDead = function(player)
	return not lib.Players.IsAlive(player)
end

lib.Players.GetAlive = function()
	local list = {}
	for _, v in lib.Players.GetAll() do
		if lib.Players.IsAlive(v) then
			table.add(list, v)
		end
	end
	return list
end

lib.Players.GetDead = function()
	local list = {}
	for _, v in lib.Players.GetAll() do
		if lib.Players.IsDead(v) then
			table.add(list, v)
		end
	end
	return list
end

lib.Players.GetAliveCharacters = function()	
	return InGamePlayers:GetChildren()
end

lib.Players.GetClosest = function()
    return services.Players:GetPlayerFromCharacter(util.GetClosest(lib.Players.GetAliveCharacters()))
end

lib.Players.GetStats = function(player)
	local character = lib.Players.GetCharacter(player)
    return character and character:FindFirstChild("Stats")
end

lib.Players.GetCurrentStamina = function(player)
	local stats = lib.Players.GetStats(player)
    return stats and stats.CurrentStamina.Value or 0
end

lib.Players.GetMaxStamina = function(player)
	local stats = lib.Players.GetStats(player)
    return stats and stats.Stamina.Value or 100
end

lib.Players.GetStaminaRemaining = function(player)
    return lib.Players.GetMaxStamina() - lib.Players.GetCurrentStamina()
end

lib.Players.GetInventory = function(player)
	local character = lib.Players.GetCharacter(player)
	if character then
		local inventory = character:FindFirstChild("Inventory")
		if inventory then
			local invdata = {}
			for _, v in inventory:GetChildren() do
				invdata[v.Name] = v.Value
			end
			return invdata
		end
	end
	return {}
end

lib.Players.IsExtracting = function(player)
    local character = lib.Players.GetCharacter(player)
	if character then
		local decoding = character:FindFirstChild("Decoding")
		if decoding then
			return decoding.Value ~= nil
		end
	end
    return false
end

-- Twisteds

lib.Twisteds.GetAll = function()
    if not lib.Game.GetMap() then return {} end
    local monsters = lib.Game.GetMap():FindFirstChild("Monsters")
    return monsters and monsters:GetChildren() or {}
end

lib.Twisteds.GetClosest = function()
	return util.GetClosest(lib.Twisteds.GetAll())
end

-- Items

lib.Items.GetAll = function()
	if not lib.Game.GetMap() then return {} end
	local items = lib.Game.GetMap():FindFirstChild("Items")
	return items and items:GetChildren() or {}
end

lib.Items.GetClosest = function()
	return util.GetClosest(lib.Items.GetAll())
end

-- Map

lib.Map.GetElevator = function()
	return Elevator
end

lib.Map.GetFakeElevator = function()
	local map = lib.Game.GetMap()
	if not map then return nil end
	
	local area = map:FindFirstChild("FreeArea")
	return area and area:FindFirstChild("FakeElevator") or nil
end

return lib
