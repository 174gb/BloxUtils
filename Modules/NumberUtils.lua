--[[
@ WORK IN PROGRESS
]]


local NumberUtils = {Random = Random.new()}

function NumberUtils:Round(n, p)
	p = p and 10^p or 10
	local m = p*n
	local r = m%1
	if r < 1/2 then
		return math.floor(p*n)/p
	else
		return math.ceil(p*n)/p
	end
end

function NumberUtils:AddCommas(number)
   if typeof(number) ~= 'string' then
    number = tostring(number)
   end
   return #number % 3 == 0 and number:reverse():gsub("(%d%d%d)", "%1,"):reverse():sub(2) or number:reverse():gsub("(%d%d%d)", "%1,"):reverse()
end

function NumberUtils:Percentage(total, n)
	return n/1e2*total
end

function NumberUtils:IsNaN(number)
  if n ~= n then
    return true
  else
    return false
  end
end

function NumberUtils:GenerateUUID()
	local _time = os.time()
	local _next = self.Random:NextNumber() * 1
	local _concat = _time * _next
	return string.format('%x', _concat * math.random(1,500))
end

return NumberUtils
