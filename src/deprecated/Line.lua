local class = require "libs.middleclass"
local GeoMath = require "geometry.GeoMath"
local Line = class "Line"

--[[
	line = Line object, where [1]{x = x1, y = y1}, [2]{x = x2, y = y2}
	lightLine = same Line structure(no OOP/methods) 
	rawLine = {x1, y1, x2, y2}
	rawCoords = x1, y1, x2, y2
]]

function Line:init(...)
	local x1, y1, x2, y2 = GeoMath.unpackCoords(...)
	self[1].x = x1 or 0
	self[1].y = y1 or 0
	self[2].x = x2 or 0
	self[2].y = y2 or 0
end


--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Line.static.setColor(...)
	Line.color = type(...) == "table" and ... or {...} 
	
end

function Line.static.setSize(s)
	Line.size = s
end

--- @param #class:Point[] points An array of Point objects.
function Line.static.draw(points)
	local p = {}
	for _, v in ipairs(points) do
		p[#p + 1] = v:getRawPoint()
	end
	love.graphics.push("all")
		love.graphics.setColor(Line.color)
		love.graphics.setPointSize(Line.size)
		love.graphics.points(p)
	love.graphics.pop()	
end

function Line:draw()
	love.graphics.push("all")
		love.graphics.setColor(Line.color)
		love.graphics.setPointSize(Line.size)
		love.graphics.points(self.x, self.y)
	love.graphics.pop()
end

--- @return #table A decoarated hashtable point. NOT a Point object.
function Line:getLightLine()
	return {{x = self[1].x, y = self[1].y}, {x = self[2].x, y = self[2].y}}
end

--- @return #table A love2d-style array representing a single line.
function Line:getRawLine()
	return {self:getRawCoords()}
end

--- @return #number, #number A raw coords-quad.
function Line:getRawCoords()
	return self[1].x, self[1].y, self[2].x, self[2].y
end

function Line:__tostring()
	return string.format("Line: from (%d, %d), to (%d, %d)", self:getRawCoords())
end

return Line