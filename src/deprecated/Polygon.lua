local class = require "libs.middleclass"

local Polygon = class "Polygon"

function Polygon:init(points)
	self.points = points or {}
end



function Polygon:draw()

end

function Polygon:addPoint(p)
	
end

function Polygon:getPoints()
	return self.points
end

--points = {p0, p1, p2}
--p0 = {x, y}