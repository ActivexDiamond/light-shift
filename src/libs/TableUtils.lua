
local TableUtils = {}

function TableUtils.containsSingleType(t, dataType)
	for _, v in pairs(t) do
		if type(v) ~= dataType then return false end
	end
	return true
end

function TableUtils.deepConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
end

return TableUtils