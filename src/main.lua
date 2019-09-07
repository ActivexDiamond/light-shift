local Mapper = require "Mapper"

local imgData, img, w, h, x, y, scale, gridSize, map

local filepath = "spr/testMap.png"
local sw, sh = love.window.getMode()

function love.load()
	love.graphics.setDefaultFilter("nearest")
	img = love.graphics.newImage(filepath)
	imgData = love.image.newImageData(filepath)
	w, h = imgData:getWidth() - 1, imgData:getHeight() - 1
	scale = 8
	gridSize = 32
	
	
	
	map = Mapper.dimsFromMap(filepath, gridSize)
end

function love.update(dt)

end

function love.draw()
	x, y = sw - (w*scale), sh - (h*scale)
	love.graphics.draw(img, x, y, 0, scale, scale)
	
end

--[==[
local MathUtils = require "libs.MathUtils"

local Point = require "geometry.Point"
local Line = require "geometry.Line"
local Polygon = require "geometry.Polygon"
local Ray = require "geometry.Ray"


sw, sh = love.window.getMode()

function love.load()
	ls = {}
	for i = 1, 360, 1 do	
		local a = math.rad(i)
		ls[#ls + 1] = Ray(sw / 2, sh / 2, a)
	end
	
	polys = {}
	polys[1] = genRectangle(0, 0, sw, sh)
	polys[2] = genRandomPoly(20)
--	polys[2] = genPoly()		
	
	point = {50, 50}
end

function love.mousemoved(x, y, dx, dy)
	for _, v in ipairs(ls) do
		v:setPos(x, y)
	end
--	ray:setDir(x, y)
end

function love.mousepressed(x, y)
	point = {x, y}
end

function love.draw()	
	Polygon.draw(polys)
	
	Point.setColor(255, 0, 0)
	Point.setSize(4)
	Point.draw(point)
	for _, v in ipairs(ls) do
		transSource(v, polys)
--		opaqueSource(v, polys)
	end
	local count = Polygon.intersectsPoint(polys[2], point)
	love.graphics.print(tostring(count), 20, 20)
end

function opaqueSource(ray, polys)
	local pos = ray:getPos()
	local dest = ray:cast(polys)
	if not dest then return end
	Line.setColor(255, 255, 255, 255)
	Line.draw({pos, dest})
end

function transSource(ray, polys)
	local pos = ray:getPos()
	local path = ray:castThrough(polys)
	if not path then return end
	
	table.insert(path, 1, pos)
	
	for i = 1, #path - 1 do
		local a = MathUtils.map(i, 1, #path, 255, 0)
		Line.setColor(255, 255, 255, a)
		Line.draw({path[i], path[i+1]})
	end
end

function genPoly()
	return {
		200, 200,
		250, 300,
		400, 400,
		700, 700,
		300, 400,
		250, 400,
		200, 300,
		150, 150,
		200, 200
	}
end

function genRandomPoly(n)
	local poly = {}
	for i = 1, n do
		local x = math.random(0, sw)
		local y = math.random(0, sh)
		table.insert(poly, x)
		table.insert(poly, y)
	end
	return poly
end

function genRectangle(x, y, w, h)
	return {
		x, y,
		w, y,
		w, h,
		x, h,
		x, y 
	}
end

function convertToLoveLine(p)
	local lp = {}
	for _, v in ipairs(p) do
		lp[#lp + 1] = v.x
		lp[#lp + 1] = v.y
	end
	return lp
end
--]==]


---------------------------------------------------------------------------------


--[[ TEST CODE
local Ray = require "Ray"

local imgData, img, w, h, x, y, s, sPos
local pixels = {}

local filepath = "spr/testMap.png"

local sw, sh = love.window.getMode()

function love.load()
	love.graphics.setDefaultFilter("nearest")
	img = love.graphics.newImage(filepath)
	imgData = love.image.newImageData(filepath)
	w, h = imgData:getDimensions()
	s = 8
	
	sPos = 8
	
	local offset = 8
	for x = 0, w - 1 do
		for y = 0, h - 1 do
--			local pixel = {x*s, y*s, imgData:getPixel(x, y)}
			pixel = {sPos + x*s, sPos + y*s, 1, 1, 1}
			table.insert(pixels, pixel)
		end
	end
	
	local ray = Ray(42, 5, 3.14)
	print(ray)
end

function love.update(dt)

end

function love.draw()
	x, y = sw - (w*s), sh - (h*s)
	x, y = sPos, sPos
	love.graphics.draw(img, x, y, 0, s, s)
	love.graphics.setPointSize(4)
	love.graphics.points(pixels)
	
end

local points = {}
	

--local val = #points ~= 0 and points or nil
--print(val)

local val = #points ~= 0 and points or nil
print(val)

print("---")
local points = {3, 3, 3}

local val = #points ~= 0 and points or nil
print(val)

local function tableDeepConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
end

t1 = {1, 2, 3}
t2 = {4, 5, 6}
tableDeepConcat(t1, t2)
for k, v in ipairs(t1) do
	print ("k: " .. k, "v:" .. v)
end

]]
