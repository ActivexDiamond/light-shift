local MathUtils = require "libs.MathUtils"
local TableUtils = require "libs.TableUtils"

local Rectangle = {}
local color = {1, 1, 1, 1}
local size = 1
local fill = false

--[[
	rectangle = {x, y, w, h}
	coords = x, y, w, h
]]
------------------------------ math methods ------------------------------
--- @param #rectangle r1 The first rectangle.
-- @param #line r2 The second rectangle.
-- @return #boolean Whether the rectangles intersect or not.
function Rectangle.intersects(r1, r2)
	error("Not implemented yet.")
end

function Rectangle.intersectsLine(r, l)
	error("Not implemented yet.")
end

function Rectangle.intersectsPoint(r, p)
	error("Not implemented yet.")
end
------------------------------ type checker methods ------------------------------
function Rectangle.isRectangle(o)
	if type(o) ~= "table" then return false end
	if #o ~= 4 then return false end
	return TableUtils.containsSingleType(o, "number")
end
--{1, 2}
------------------------------ conversion methods ------------------------------
--- @param #rectangle r The rectangle to convert.
-- @return #number, #number, #number, #number The coord-bound.
function Rectangle.toCoords(r)
	if not Rectangle.isRectangle(r) then error("Rectangle expected.") end
	return unpack(r)
end

--- @param #rectangle_or_coord-bounds ... Either a coord-bounds, or a rectangle
function Rectangle.toString(...)
	local r = type(...) == "table" and ... or {...}
	return string.format("Rectangle: (%d, %d, %d, %d)", r[1], r[2], r[3], r[4])
end

------------------------------ draw method ------------------------------
--- @param #array rectangles An array of rectangles.
function Rectangle.draw(rects)
	if type(rects[1]) ~= "table" then rects = {rects} end
	love.graphics.push("all")
		love.graphics.setColor(color)
		love.graphics.setLineWidth(size)
		for _, v in ipairs(rects) do
			local m = fill and "fill" or "line"
			love.graphics.rectangle(m, v[1], v[2], v[3], v[4])
		end
	love.graphics.pop()	
end

----------------- getters/setters for default size/color -----------------
--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Rectangle.setColor(...)
	color = MathUtils.toLoveColor(...) 
end
function Rectangle.setSize(s)
	size = s
end
function Rectangle.setFill(f)
	fill = f
end

function Rectangle.getColor()
	return color
end
function Rectangle.getSize()
	return size
end
function Rectangle.getFill()
	return fill
end

return Rectangle