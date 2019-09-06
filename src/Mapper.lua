local class = require "middleclass"

local Mapper = class "Mapper"

local function bucketFill(p, map)	--- returns polygon

end

local function intersectsPoly(p, polys)
	return false
end

function Mapper.static:dimsFromMap(filepath, gridsize)
	local map = love.image.newImageData(filepath)
	local w, h = map:getDimensions()
	local polys = {}
	
	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local px = {x = x, y = y}
			if not intersectsPoly(px, polys) then
				local poly = bucketFill(px, map)
				table.insert(polys, poly)
			end 
			
			local preC = {}
			local c = {map:getPixel(x, y)}
			
			
		end
	end
end

private bool IsPointInPolygon(PointF[] polygon, PointF point)
{
	bool isInside = false;
	for (int i = 0, j = polygon.Length - 1; i < polygon.Length; j = i++)
	for i = 0, len do
		if (( (polygon[i].Y > point.Y) != (polygon[j].Y > point.Y)) 
			&& (point.X < (polygon[j].X - polygon[i].X) * (point.Y - polygon[i].Y) / (polygon[j].Y - polygon[i].Y) + polygon[i].X))
		{
			isInside = !isInside;
		}
	end

	return isInside;
}

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
]]


--img = love.graphics.newImage(filename,flags)
--imgData = img:getData()
--imgData = love.image.
