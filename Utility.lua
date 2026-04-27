local util = {}

local service_cache = {}
local connections = {}

local gs = game.GetService

util.services = setmetatable({}, {
    __index = function(self, index)
        local cached = service_cache[index]
        if not cached then
            cached = gs(game, index)
            service_cache[index] = cached
        end
        return cached
    end,
    __call = function(self, index)
        local cached = service_cache[index]
        if not cached then
            cached = gs(game, index)
            service_cache[index] = cached
        end
        return cached
    end
})

local Players = services.Players
util.LocalPlayer = Players.LocalPlayer
util.LocalCharacter = util.LocalPlayer.Character
util.LocalRoot = util.LocalCharacter:FindFirstChild("HumanoidRootPart")
util.LocalHumanoid = util.LocalCharacter:FindFirstChild("Humanoid")

util.LocalPlayer.CharacterAdded:Connect(function(character)
    util.LocalCharacter = character
    util.LocalRoot = util.LocalCharacter:WaitForChild("HumanoidRootPart", 5)
    util.LocalHumanoid = util.LocalCharacter:WaitForChild("Humanoid", 5)
end)

util.IsValid = function(obj)
    return obj and obj.Parent ~= nil
end

util.GetPosition = function(obj)
    if not obj then return nil end
    
    if obj:IsA("BasePart") then
        return obj.Position
    end
    
    if obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart.Position
        end
        
        local pivot = obj:GetPivot()
        if pivot then
            return pivot.Position
        end
        
        local part = obj:FindFirstChildWhichIsA("BasePart")
        if part then
            return part.Position
        end
    end
    
    return nil
end

util.GetDistanceBetweenObjects = function(a, b)
    local posA = util.GetPosition(a)
    local posB = util.GetPosition(b)
    
    if not posA or not posB then
        return math.huge
    end
    
    return (posA - posB).Magnitude
end

util.GetClosest = function(children)
    if not util.IsValid(util.LocalCharacter) then
		return nil
	end
	local target, distance = nil, math.huge
    for _, obj in children do
    	if obj == util.LocalCharacter then continue end
        local compare = util.GetDistanceBetweenObjects(util.LocalCharacter, obj)
        if compare < distance then
            target = generator
            distance = compare
        end
    end
    return target, distance
end

util.TeleportToObject = function(obj)
    util.LocalCharacter:PivotTo(CFrame.new(util.GetPosition(obj)))
end

util.MakeConnection = function(event, callback)
    local conn = event:Connect(callback)
    table.add(connections, conn)
    return conn
end

util.DisconnectConnection = function(target)
    for i, conn in ipairs(connections) do
        if conn == target then
            conn:Disconnect()
            table.remove(connections, i)
            return true
        end
    end
    return false
end

util.DisconnectAllConnections = function()
    for i, conn in ipairs(connections) do
        conn:Disconnect()
    end
    table.clear(connections)
    return true
end

return util