local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz][_|\/#$%&*()"
local nums = "1234567890"

return function(n)
	local t = {}
	if n == nil then n = math.random(6, 15) end
	for i = 1, n do
		if math.random() < 3/4 then
			local j = math.random(1, string.len(letters))
			local u = string.sub(letters, j, j)
			if math.random() < 1/2 then
				u = string.lower(u)
			end
			t[i] = u
		else
			local j = math.random(1, string.len(nums))
			t[i] = string.sub(nums, j, j)
		end
	end
	return table.concat(t)
end