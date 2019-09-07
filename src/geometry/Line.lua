local MathUtils = require "libs.MathUtils"
local TableUtils = require "libs.TableUtils"

local Line = {}
local color = {1, 1, 1, 1}
local size = 1

--[[
	line = {x1, y1, x2, y2}
	coords = x1, y1, x2, y2
]]
------------------------------ math methods ------------------------------
--- @param #line l1 The first line.
-- @param #line l2 The second line.
-- @return #point The point of intersection, or nil if none.
function Line.intersects(l1, l2)
	local x1, y1, x2, y2 = l1[1], l1[2], l1[3], l1[4]
	local x3, y3, x4, y4 = l2[1], l2[2], l2[3], l2[4]
	
	local t, u, denom
	denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	if (denom == 0) then return end
	
	t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4) ) / denom
	u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3) ) / denom
		
	if (1 > t and t > 0) and (1 > u and u > 0) then
		local px, py = x1 + t * (x2 - x1), y1 + t * (y2 - y1)
		return {px, py}
	else return end
end

function Line.intersectsPoint(l, p)
	error("Not implemented yet.")
end

------------------------------ type checker methods ------------------------------
function Line.isLine(o)
	if type(o) ~= "table" then return false end
	if #o ~= 4 then return false end
	return TableUtils.containsSingleType(o, "number")
end
--{1, 2}
------------------------------ conversion methods ------------------------------
--- @param #array points An array of points. Must be in multiples of 2.
-- @return #array An array of lines.
function Line.fromPoints(points)
	local lines = {}
	for i = 1, #points - 1, 2 do
		local x1, y1 = unpack(points[i])
		local x2, y2 = unpack(points[i + 1])
		table.insert(lines, {x1, y1, x2, y2})
	end
	return lines
end

--- @param #line l The line to convert.
-- @return #number, #number, #number, #number The coord-quad.
function Line.toCoords(l)
	if not Line.isLine(l) then error("Line expected.") end
	return unpack(l)
end

--- @param #line_or_coord-quad ... Either a coord-quad, or a line
function Line.toString(...)
	local l = type(...) == "table" and ... or {...}
	return string.format("Line: from (%d, %d), to (%d, %d)", l[1], l[2], l[3], l[4])
end

------------------------------ draw method ------------------------------
--- @param #array lines An array of lines
function Line.draw(arr)
	if type(arr[1]) ~= "table" then arr = {arr} end
	if not Line.isLine(arr[1]) then arr = Line.fromPoints(arr) end	
	love.graphics.push("all")
		love.graphics.setColor(color)
		love.graphics.setLineWidth(size)
		for _, v in ipairs(arr) do
			love.graphics.line(v)
		end
	love.graphics.pop()	
end

----------------- getters/setters for default size/color -----------------
--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Line.setColor(...)
	color = MathUtils.toLoveColor(...) 
end
function Line.setSize(s)
	size = s
end

function Line.getColor()
	return color
end
function Line.getSize()
	return size
end

return Line