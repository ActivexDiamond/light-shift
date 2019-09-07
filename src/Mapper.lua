local Polygon = require "geometry.Polygon"

local Mapper = {}

------------------- Local Globals -----------------------
local dirs = {TOP = 1, BOT = 2, LEFT = 3, RIGHT = 4}
local map
------------------- Pixel Color Operations -----------------------
local function getColoredPixel(x, y)
	print('x', x, 'y', y)
	return {x, y, c = {map:getPixel(x, y)}}
end
local function matchColor(px1, px2)
	for k, v in ipairs(px1.c) do
		if px2.c[k] ~= v then return false end
	end
	return true
end

------------------- Pixel Geometric Operations -----------------------
local function centerPixel(px)
	return {px[1] + 0.5, px[2] + 0.5}
end
local function pixelIntersectsAnyPoly(px, polys)
	local p = centerPixel(px)
	for _, v in ipairs(polys) do
		if Polygon.intersectsPoint(v ,p) then return true end
	end
	return false
end

------------------- Line Creation -----------------------
local function createLine(px, dir, lines)		--- create line bordering edge dir of px.
	local x, y, line = px[1], px[2]
	
	if dir == dirs.LEFT then 
		line = {x, y, x, y + 1}
	elseif dir == dirs.RIGHT then 
		line = {x - 1, y, x - 1, y + 1}
	elseif dir == dirs.TOP then 
		line = {x, y, x + 1, y}
	elseif dir == dirs.BOT then 
		line = {x, y + 1, x + 1, y + 1}
	end
	table.insert(lines, line)
end

------------------- Direction Checking Abstraction -----------------------
local function checkPixel(bool, nx, ny, px, dir, lines)
		if bool then createLine(px, dir, lines) ; return end					--if out-of-bounds, createLine, return nil
		local npx = getColoredPixel(nx, ny)								--else, fetch newPixel - coords and color 
		if not matchColor(px, npx) then createLine(px, dir, lines) ; return		--if npx.c ~= px.c, createLine, return nil
		else return npx end														--else, return npx (as npx.c == px
end

local function checkDir(px, dir, lines)
	local x, y, w, h = px[1], px[2], map:getWidth() - 1, map:getHeight() - 1
	local npx, nx, ny, bool
	
	local outArgs = {px, dir, lines}
	if dir == dirs.LEFT then 
		nx, ny = x - 1, y
		bool = nx < 0
		print('nx', nx, 'ny', ny, 'bool', bool)
		return checkPixel(bool, nx, ny, unpack(outArgs))
	elseif dir == dirs.RIGHT then 
		nx, ny = x + 1, y
		bool = nx > w
		return checkPixel(bool, nx, ny, unpack(outArgs))
	elseif dir == dirs.TOP then 
		nx, ny = x, y - 1
		bool = ny < 0
		return checkPixel(bool, nx, ny, unpack(outArgs))
	elseif dir == dirs.BOT then 
		nx, ny = x, y + 1
		bool = ny > h
		return checkPixel(bool, nx, ny, unpack(outArgs))				
	end
end

------------------- Recursive BucketFill -----------------------
local bucketFill
function bucketFill(px, lines)
	for k ,v in pairs(dirs) do
		local npx = checkDir(px, v, lines)
		if npx then bucketFill(npx, lines) end
	end 
end
------------------- Finalization Operations -----------------------


------------------- Entry Point -----------------------
local function getRegion(px)	--- returns polygon
	local x, y, lines = px[1], px[2], {}
	bucketFill(px, lines)
--	sortLines(lines)
	return lines
end

------------------- External API -----------------------
function Mapper.dimsFromMap(filepath, gridSize)
	map = love.image.newImageData(filepath)
	local w, h = map:getWidth() - 1, map:getHeight() - 1
	local polys = {}
	
	for x = 0, w do
		for y = 0, h do
			local px = getColoredPixel(x, y, map)
			if not pixelIntersectsAnyPoly(px, polys) then
				local poly = getRegion(px, map)
				table.insert(polys, poly)
			end 
		end
	end
	return polys
end

return Mapper

--[[
Input: map: 2D image representing the regions of the world.
Output: poly[]: list of polygons in map, segmented based on color.
1: Select pixel (px) from map.
	Order is insignificant, given that all pixels of map are iterated.

2: Bucket fill from pixel, 
	caching lines (l[]) that border different color.

3: Iterate over l[], joining adjacent lines,
 	where: a = the angle between the 2 lines, 
 			c = the center (shared) point, 
			p1/p2 = the 2 points furthest from each other.
			
	- if a = 180, remove c, and join l1 and l2 into a single line,
		from p1 to p2
	- if abs(a) = 90, join l1 and l2 into a single line,
		from p1, to c, to p2
		
	#3 results in a single polygon (poly), 
	covering the entire region bucket-filled from px.
	Add poly to poly[].
	 
4: Select next pixel (np), if it instersects any poly of poly[], skip it.
5: Repeat #2 and #3 on np.
6: Break once all pixels of map are iterated.
--]]

--[[
--img = love.graphics.newImage(filename,flags)
--imgData = img:getData()
--imgData = love.image.

imgData:getPixel(0, 0)			--works
imgData:getPixel(w-1, h-1)		--works
imgData:getPixel(-1, -1)		--out-of-range 
imgData:getPixel(w+1, h+1)	--out-of-range
--]]