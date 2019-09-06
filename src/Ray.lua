local class = require "middleclass"

local Ray = class "Ray"
local unpackCoords
function unpackCoords(...)
	local args, x, y = {...}
	
	if type(args[1]) == "table" then
		x, y = args[1].x, args[1].y
	else
		x, y = args[1], args[2]
		table.remove(args, 1)
	end
	table.remove(args, 1)
	
	if (#args > 0) then return x, y, unpackCoords(unpack(args)) 
	else return x, y end
end

function Ray:init(...)	--- takes points or direct x/y vals
	local x, y, dirX, dirY = unpackCoords(...)
	self.x = x or 0
	self.y = y or 0
	self.dirX = dirX or 0
	self.dirY = dirY or 0
end

function Ray:setPos(...)	--- takes point or x/y coords directly
	local x, y = unpackCoords(...)
	self.x = x or 0
	self.y = y or 0
end

function Ray:setDir(...)	--- takes point or x/y coords directly
	local x, y = unpackCoords(...)
	self.dirX = x or 0
	self.dirY = y or 0
end

function Ray:getPos()
	return {x = self.x, y = self.y}
end

function Ray:getDir()
	return {x = self.dirX, y = self.dirY}
end

local function tableDeepConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
end

local function castThrough(self, poly)	--- cast against a single poly	
	local points = {}
	for i = 1, #poly - 1 do	--loop every line in poly, and check intersection
		local p0, p1 = poly[i], poly[i + 1]
--		print("p0/1", p0, p1)
		local np = self:intersects({p0, p1})	
		if (np) then table.insert(points, np) end 
	end
	return #points ~= 0 and points or nil
end

function Ray:castThrough(polys) --- return all points
	if type(polys[1][1]) ~= "table" then polys = {polys} end
	
	local points = {}
	for _, v in ipairs(polys) do
		local npoints = castThrough(self, v)
		if npoints then tableDeepConcat(points, npoints) end
	end
	if #points == 0 then return end
	
	table.sort(points, function (p0, p1)
		return self:distanceToPoint(p0) < self:distanceToPoint(p1)
	end)
	return points
end

function Ray:cast(polys) --- return closest point
	local points = self:castThrough(polys)
	if not points then return end
	return points[1]
end

function Ray:intersects(line) --- cast against a single line
	local x1, y1, x2, y2 = line[1].x, line[1].y, line[2].x, line[2].y	
	local x3, y3 = self.x, self.y
	local x4, y4 = self.x + self.dirX, self.y + self.dirY

--	local x3, y3, x4, y4 = self.x, self.y, self.dirX, self.dirY
 
	
	local t, u, denom
	denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	if (denom == 0) then return end
	
	t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4) ) / denom
	u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3) ) / denom
		
	if (1 > t and t > 0) and u > 0 then
		local px, py = x1 + t * (x2 - x1), y1 + t * (y2 - y1)
		return {x = px, y = py}
	else return end
end

function Ray:distanceToPoint(p)	
	return ( (self.x - p.x)^2 + (self.y - p.y)^2 )^0.5
end

function Ray:__tostring()
	str = "Ray: Pos(%d, %d), Dir:(%d, %d)"
	return str:format(self.x, self.y, self.dirX, self.dirY)
end

return Ray