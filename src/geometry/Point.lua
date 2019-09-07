local MathUtils = require "libs.MathUtils"
local TableUtils = require "libs.TableUtils"

local Point = {}
local color = {1, 1, 1, 1}
local size = 1

--[[
	coloredPoints = {x, y, r, g, b, a}  
	point = {x, y}
	coords = x, y
]]
------------------------------ utility methods ------------------------------
--- Converts a mix of points and coord-pairs into coord-pairs.
function Point.unifyArgs(...) 
	local args, x, y = {...}
	local p = args[1]
	if type(p) == "table" then		--if is table
		x, y = p[1], p[2] 				--unpack table
	else							--else, is coord-pair
		x, y = args[1], args[2]
		table.remove(args, 1)
	end
	table.remove(args, 1)
	
	if (#args > 0) then return x, y, Point.unifyArgs(unpack(args)) 
	else return x, y end
end

------------------------------ math methods ------------------------------
--- @param #point p1 The first point.
-- @param #point p2 The second point.
-- @return #number The distance between p1 and p2
function Point.distance(p1, p2)
	return ((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2)^0.5
end

------------------------------ type checker methods ------------------------------
function Point.isColoredPoint(o)
	if type(o) ~= "table" then return false end
	if #o < 3 then return false end
	return TableUtils.containsSingleType(o, "number")
end

function Point.isPoint(o)
	if type(o) ~= "table" then return false end
	if #o ~= 2 then return false end
	return TableUtils.containsSingleType(o, "number")
end
--{1, 2}
------------------------------ conversion methods ------------------------------
--- @param #points p The point to convert.
-- @return #number, #number The coord-pair.
function Point.toCoords(p)
	if not Point.isPoint(p) then error("Point expected.") end
	return unpack(p)
end

--- @param #point_or_coord-pair ... Either a coord-pair, or a point
function Point.toString(...)
	local p = type(...) == "table" and ... or {...}
	return string.format("Point: (%d, %d)", p[1], p[2])
end

------------------------------ draw method ------------------------------
--- @param #array points An array of either points, or coloredPoints.
function Point.draw(points)
	love.graphics.push("all")
		love.graphics.setColor(color)
		love.graphics.setPointSize(size)
		love.graphics.points(points)
	love.graphics.pop()	
end

----------------- getters/setters for default size/color -----------------
--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Point.setColor(...)
	color = MathUtils.toLoveColor(...)
end
function Point.setSize(s)
	size = s
end

function Point.getColor()
	return color
end
function Point.getSize()
	return size
end

return Point