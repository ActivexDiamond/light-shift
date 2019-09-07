local class = require "libs.middleclass"

local GeoMath = class "Point"

function GeoMath:init(...)
	error("Attempt to initialize a static class: " .. self.class.name)
end

--[[
	point = Point object, where {x = x, y = y}
	lightPoint = same Point structure(no OOP/methods)  
	rawPoint = {x, y}
	rawCoords = x, y
]]

--- Converts a mix of points, lightPoins, rawPoints and rawCoords into rawCoords.
function GeoMath.static.unpackCoords(...) 
	local args, x, y = {...}
	local p = args[1]
	if type(p) == "table" then		--if is table
		if p.isInstanceOf then x, y = p:getRawCoords()		--if is point
		else if p.x then x, y = p.x, p.y					--else if is lightPoint
		else x, y = p[1], p[2]  end							--else it is a rawPoint
	end
	else							--else, is rawCoords
		x, y = args[1], args[2]
		table.remove(args, 1)
	end
	table.remove(args, 1)
	
	if (#args > 0) then return x, y, GeoMath.unpackCoords(unpack(args)) 
	else return x, y end
end

return GeoMath