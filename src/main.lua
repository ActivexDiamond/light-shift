local Ray = require "Ray"

sw, sh = love.window.getMode()

function love.load()
	ls = {}
	for i = 1, 360, 1 do	
		local a = math.rad(i)
		ls[#ls + 1] = Ray(sw / 2, sh / 2, math.cos(a), math.sin(a))
	end
	
	polys = {}
	polys[1] = genRectangle(0, 0, sw, sh)
	polys[2] = genRandomPoly(20)
	
end

function love.mousemoved(x, y, dx, dy)
	for _, v in ipairs(ls) do
		v:setPos(x, y)
	end
end

function love.draw()
	for _, v in ipairs(ls) do
		transSource(v, polys)
	end
	
	local loveRect = convertToLoveLine(polys[1])
	love.graphics.line(loveRect)
	
	local lovePoly = convertToLoveLine(polys[2])
	love.graphics.line(lovePoly)
end

function transSource(ray, poly)
	local pos = ray:getPos()
	local path = ray:castThrough(poly)
	if not path then return end
	
	local points = {}
	points[1] = {pos.x, pos.y}
	
	for k, v in ipairs(path) do
		points[#points + 1] = {v.x, v.y}
	end
		
	love.graphics.push('all')
	for i = 1, #points - 1 do
		local a = map(i, 1, #points, 1, 0)
		love.graphics.setColor(1, 1, 1, a)
--		love.graphics.setBlendMode("add")
		local p0x, p0y = unpack(points[i])
		local p1x, p1y = unpack(points[i + 1])
--		local p0x, p0y, p1x, p1y = unpack(points[i]), unpack(points[i + 1])

		love.graphics.line(p0x, p0y, p1x, p1y)
	end
	love.graphics.pop()
end

function genRandomPoly(n)
	local poly = {}
	for i = 1, n do
		local x = math.random(0, sw)
		local y = math.random(0, sh)
		table.insert(poly, {x = x, y = y})
	end
	return poly
end

function genRectangle(x, y, w, h)
	local v0, v1, v2, v3, v4
	v0 = {x = x, y = y}
	v1 = {x = w, y = y}
	v2 = {x = w, y = h}
	v3 = {x = x, y = h}
	v4 = {x = x, y = y}
	return {v0, v1, v2, v3, v4}
end

function convertToLoveLine(p)
	local lp = {}
	for _, v in ipairs(p) do
		lp[#lp + 1] = v.x
		lp[#lp + 1] = v.y
	end
	return lp
end

function map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

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
