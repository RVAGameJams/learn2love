local world = require('world')
local window_width, window_height = love.window.getMode()

local ground = {}
ground.category = tonumber('1000', 2)
ground.mask = tonumber('1111', 2)
ground.group = 0
ground.body = love.physics.newBody(world, window_width / 2, window_height - 10, 'static')
ground.shape = love.physics.newRectangleShape(window_width, 20)
ground.fixture = love.physics.newFixture(ground.body, ground.shape)
ground.fixture:setFilterData(ground.category, ground.mask, ground.group)
ground.fixture:setUserData(ground)

-- Custom entity properties
ground.color = {0.16, 0.21, 0.23}

ground.draw = function(self)
  love.graphics.setColor(ground.color)
  love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

return ground
