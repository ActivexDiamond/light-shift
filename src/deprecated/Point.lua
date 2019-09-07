local class = require "libs.middleclass"
local GeoMath = require "geometry.GeoMath"

local Point = class "Point"
Point.size = 1
Point.color = {1, 1, 1, 1}

--[[
	point = Point object, where {x = x, y = y}
	lightPoint = same Point structure(no OOP/methods)  
	rawPoint = {x, y}
	rawCoords = x, y
]]
function Point:init(...)
	local x, y = GeoMath.unpackCoords(...)
	self.x = x or 0
	self.y = y or 0
end

--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Point.static.setColor(...)
	Point.color = type(...) == "table" and ... or {...} 
	
end

function Point.static.setSize(s)
	Point.size = s
end

function Point.static.getColor()
	return Point.color
end

function Point.static.getSize()
	return Point.size
end

--- @param #class:Point[] points An array of Point objects.
function Point.static.draw(points)
	local p = {}
	for _, v in ipairs(points) do
		p[#p + 1] = v:getRawPoint()
	end
	love.graphics.push("all")
		love.graphics.setColor(Point.color)
		love.graphics.setPointSize(Point.size)
		love.graphics.points(p)
	love.graphics.pop()	
end

function Point:draw()
	love.graphics.push("all")
		love.graphics.setColor(Point.color)
		love.graphics.setPointSize(Point.size)
		love.graphics.points(self.x, self.y)
	love.graphics.pop()
end

--- @return #table A decoarated hashtable point. NOT a Point object.
function Point:getLightPoint()
	return {x = self.x, y = self.y}
end

--- @return #table A love2d-style array representing a single point.
function Point:getRawPoint()
	return {self:getRawCoords()}
end

--- @return #number, #number A raw coords-pair.
function Point:getRawCoords()
	return self.x, self.y
end

function Point:__tostring()
	return string.format("Point: (%d, %d)", self:getRawCoords())
end

return Point