local class = require "libs.middleclass"
local TableUtils = require "libs.TableUtils"

local Point = require "geometry.Point"
local Line = require "geometry.Line"

local Ray = class "Ray"


function Ray:init(...)	--- takes points or direct x/y vals
	local x, y, dirX, dirY = Point.unifyArgs(...)
	self[1] = x or 0
	self[2] = y or 0
	self:setDir(dirX or 0, dirY)	
end

function Ray:setPos(...)	--- Takes a single point or coord-pair directly.
	local x, y = Point.unifyArgs(...)
	self[3] = self[3] + x - self[1]
	self[4] = self[4] + y - self[2]
	self[1] = x
	self[2] = y
end
function Ray:setDir(...)	--- Takes a single point or coord-pair directly, or angle(in radians).
	local dirX, dirY = Point.unifyArgs(...)
	if not dirY then
		self[3] = self[1] + math.cos(dirX)
		self[4] = self[2] + math.sin(dirX)
	else
		self[3] = dirX
		self[4] = dirY
	end
end

function Ray:getPos()
	return {self[1], self[2]}
end
function Ray:getPosCoords()
	return self[1], self[2]
end

function Ray:getDir()
	return {self[3], self[4]}
end
function Ray:getDirCoords()
	return self[3], self[4]
end


local function castThrough(self, poly)	--- cast against a single poly	
	local points = {}
	for i = 1, #poly - 3, 2 do	--loop every line in poly, and check intersection
		local x1, y1, x2, y2 = poly[i], poly[i + 1], poly[i + 2], poly[i + 3]
		local np = self:intersects({x1, y1, x2, y2})	
		if (np) then table.insert(points, np) end 
	end
	return #points ~= 0 and points or nil
end

function Ray:castThrough(polys) --- return all points
	if type(polys[1]) ~= "table" then polys = {polys} end
	
	local points = {}
	for _, v in ipairs(polys) do
		local npoints = castThrough(self, v)
		if npoints then TableUtils.deepConcat(points, npoints) end
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
    local x1, y1, x2, y2 = Line.toCoords(line)
    local x3, y3, x4, y4 = self[1], self[2], self[3], self[4]
	
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
	return Point.distance(self:getPos(), p)
end

function Ray:__tostring()
	str = "Ray: Pos(%d, %d), Dir:(%.3f, %.3f)"
	return str:format(self[1], self[2], self[3], self[4])
end

return Ray