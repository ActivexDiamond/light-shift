local MathUtils = require "libs.MathUtils"
local TableUtils = require "libs.TableUtils"

local Ray = require "geometry.Ray"

local Polygon = {}
local color = {1, 1, 1, 1}
local size = 1
local fill = false

--[[
	polygon = {x1, y1, x2, y2, ...}
	coords = x1, y1, x2, y2, ...}
]]
------------------------------ math methods ------------------------------
function Polygon.intersects(p1, p2)
	error("Not implemented yet.")
end

function Polygon.intersectsRectangle(p, r)
	error("Not implemented yet.")
end

function Polygon.intersectsLine(p, l)
	error("Not implemented yet.")
end

--TODO: handle points on the polygon's border.
function Polygon.intersectsPoint(poly, p)	--uses the raycasting algorithm
	local count = #(Ray(p, 0):castThrough(poly) or {})
	return count % 2 == 1					-- if count == odd, return true 
end
------------------------------ type checker methods ------------------------------
function Polygon.isPolygon(o)
	if type(o) ~= "table" then return false end
	if #o < 4 then return false end
	return TableUtils.containsSingleType(o, "number")
end
--{1, 2}
------------------------------ conversion methods ------------------------------
--- @param #rectangle r The rectangle to convert.
-- @return #number, #number, #number, #number The raw coord-list.
function Polygon.toCoords(p)
	if not Polygon.isPolygon(p) then error("Polygon expected.") end
	return unpack(p)
end

--- @param #polygon_or_coord-list ... Either a coord-list, or a polygon
function Polygon.toString(...)
	local p = type(...) == "table" and ... or {...}
	local str = ""
	for _, v in ipairs(p) do
		str = string.format("%s%d, ", str, v)
	end
	str:sub(str:len() - 2)
	return string.format("Polygon: (%s)", str)
end

------------------------------ draw method ------------------------------
--- @param #array polys An array of polygons.
function Polygon.draw(polys)
	if type(polys[1]) ~= "table" then polys = {polys} end
	love.graphics.push("all")
		love.graphics.setColor(color)
		love.graphics.setLineWidth(size)
		for _, v in ipairs(polys) do
			local m = fill and "fill" or "line"
--			love.graphics.polygon(m, v)
			love.graphics.line(v)
		end
	love.graphics.pop()	
end

----------------- getters/setters for default size/color -----------------
--- @param #color ... Takes either a table of {r, g, b, a}, or their values directly.
function Polygon.setColor(...)
	color = MathUtils.toLoveColor(...) 
end
function Polygon.setSize(s)
	size = s
end
function Polygon.setFill(f)
	fill = f
end

function Polygon.getColor()
	return color
end
function Polygon.getSize()
	return size
end
function Polygon.getFill()
	return fill
end

return Polygon