local world = require('world')
local window_width, window_height = love.window.getMode()

local circle = {}
circle.category = tonumber('0000', 2)
circle.mask = tonumber('0000', 2)
circle.group = 0
circle.body = love.physics.newBody(
  world,
  math.floor(window_width * 0.82),
  math.floor(window_height * 0.98),
  'static'
)
circle.shape = love.physics.newCircleShape(100)
circle.fixture = love.physics.newFixture(circle.body, circle.shape)
circle.fixture:setFilterData(circle.category, circle.mask, circle.group)
circle.fixture:setUserData(circle)

-- Custom entity properties

circle.color = {1, 0.81, 0.67, 1}

circle.draw = function(self)
  love.graphics.setColor(self.color)
  local self_x, self_y = self.body:getWorldCenter()
  love.graphics.circle('fill', self_x, self_y, self.shape:getRadius())
end

return circle
