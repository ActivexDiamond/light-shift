local Enum = require "metaclass.Enum"

local Dimensions = Enum [[ PLANT FIRE 
						WATER AIR ENDER]]
						
Dimensions.PLANTS.color = {0, 1, 0}
Dimensions.FIRE.color = {1, 0, 0}
Dimensions.WATER.color = {0, 0, 1}
Dimensions.AIR.color = {1, 1, 0}
Dimensions.ENDER.color = {1, 0, 1}
