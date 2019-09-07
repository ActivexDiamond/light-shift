local class = require "libs.middleclass"
local mathUtils = require "libs.mathUtils"
local GeoMath = require "geometry.GeoMath"

local Point = class "Point"
Point.static.size = 1
Point.static.color = {1, 1, 1, 1}

--[[
	coloredPoints = {x, y, r, g, b, a}  
	rawPoint = {x, y}
	rawCoords = x, y
]]
function Point:init(...)
	error("Attempt to initialize a static class:" .. self.class.name)
end


--- @param #array points An array of either rawCoords, rawPoints, or coloredPoints.
function Point.static.draw(points)
	love.graphics.push("all")
		love.graphics.setColor(Point.color)
		love.graphics.setPointSize(Point.size)
		love.graphics.points(points)
	love.graphics.pop()	
end

function Point.static.mapColor()

end

--- @return #number, #number A raw coords-pair.
function Point.static.toRawCoords(p)
	return p[1], p[2]
end

function Point.static.toString(p)
	return string.format("Point: (%d, %d)", p[1], p[2])
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

return Point