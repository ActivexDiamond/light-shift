local class = require "libs.middleclass"
local GeoMath = require "geometry.GeoMath"

local Ray = class "Ray"


function Ray:init(...)	--- takes points or direct x/y vals
	local x, y, dirX, dirY = GeoMath.unpackCoords(...)
	self.pos[1] = x or 0
	self.pos[2] = y or 0
	self.dir[1] = dirX or 0
	self.dir[2] = dirY or 0
end

function Ray:setPos(...)	--- takes point or x/y coords directly
	local x, y = GeoMath.unpackCoords(...)
	self.pos[1] = x or 0
	self.pos[2] = y or 0
end

function Ray:setDir(...)	--- takes point or x/y coords directly
	local x, y = GeoMath.unpackCoords(...)
	self.dir[1] = x or 0
	self.dir[2] = y or 0
end

function Ray:getPos()
	return {self.pos[1], self.pos[2]}
end

function Ray:getDir()
	return {self.dir[1], self.dir[2]}
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
	if type(polys[1]) ~= "table" then polys = {polys} end
	
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
	local x1, y1, x2, y2 = line[1][1], line[1][2], line[2][1], line[2][2]	
	local x3, y3 = self.pos[1], self.pos[2]
	local x4, y4 = self.pos[1] + self.dir[1], self.pos[2] + self.dir[2]
	
	local t, u, denom
	denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	if (denom == 0) then return end
	
	t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4) ) / denom
	u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3) ) / denom
		
	if (1 > t and t > 0) and u > 0 then
		local px, py = x1 + t * (x2 - x1), y1 + t * (y2 - y1)
		return {px, py}
	else return end
end

function Ray:distanceToPoint(p)	
	return ( (self.pos[1] - p[1])^2 + (self.pos[2] - p[2])^2 )^0.5
end

function Ray:__tostring()
	str = "Ray: Pos(%d, %d), Dir:(%d, %d)"
	return str:format(self.pos[1], self.pos[2], self.dir[1], self.dir[2])
end

return Ray