--[[
local DynamicTable = require(path.to.this.module)

local PlayerTable = DynamicTable.new({
	Name = 'John',
  Age = 25,
  
  Personality = {
    Humor = 'Good',
  },
})

PlayerTable.Changed:Connect(function(index, newValue)
  print(string.format('PlayerTable Changed: %s: %s', index, newValue))
end)

PlayerTable.Age = 26 --> Output: PlayerTable Changed: Age: 26
task.wait(1)
PlayerTable.Personality.Humor = 'Bad' --> Output: PlayerTable Changed: Personality/Humor: Bad
]]

local DynamicTable = {}
DynamicTable.ClassName = "DynamicTable"

local meta = {}

function meta.__index(self, index)
	local copy = self._copy
	
	if DynamicTable[index] then
		return DynamicTable[index]
		
	elseif index == "Changed" then
		return self._changed
		
	elseif copy[index] then
		return copy[index]
	end
end

function meta.__newindex(self, index, value)
	local copy = self._copy
	local valueType = type(value)
	if valueType == "table" then
		local oldValue = copy[index]
		if type(oldValue) == "table" then
			oldValue:Destroy()
		end
		local dynamicTable = DynamicTable.new(value)
		dynamicTable.Changed:Connect(function(i, v)
			self._changedEvent:Fire(index.."/"..i, v)
		end)
		copy[index] = dynamicTable
		self._changedEvent:Fire(index, dynamicTable)
	else
		local oldValue = copy[index]
		if oldValue ~= value then
			copy[index] = value
			self._changedEvent:Fire(index, value)
		end
	end
end

function DynamicTable.new(tab)
	local self = {}
	local copy = {}
	self._copy = copy

	local changedEvent = Instance.new("BindableEvent")
	self._changedEvent = changedEvent
	self._changed = changedEvent.Event

	for index, value in tab do
		local valueType = type(value)
		if valueType == "table" then
			local dynamicTable = DynamicTable.new(value)
			dynamicTable.Changed:Connect(function(i, v)
				changedEvent:Fire(index.."/"..i, v)
			end)
			copy[index] = dynamicTable
		else
			copy[index] = value
		end
	end

	return setmetatable(self, meta)
end

function DynamicTable:Serialize()
	local copy = self._copy
	local serialized = {}
	for index, value in copy do
		if type(value) == "table" then
			serialized[index] = value:Serialize()
		else
			serialized[index] = value
		end
	end
	return serialized
end

function DynamicTable:Destroy()
	local copy = self._copy
	for index, value in copy do
		if type(value) == "table" then
			value:Destroy()
		end
		copy[index] = nil
	end
	if self._changedEvent then
		self._changedEvent:Destroy()
	end
	setmetatable(self, nil)
end

return DynamicTable
