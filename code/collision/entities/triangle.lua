local world = require('world')
local window_width = love.window.getMode()

local triangle = {}
triangle.category = tonumber('0100', 2)
triangle.mask = tonumber('1001', 2)
triangle.group = 0
triangle.body = love.physics.newBody(world, 500, 400, 'dynamic')
triangle.body:setFixedRotation(true)
triangle.body:setMass(20)
triangle.shape = love.physics.newPolygonShape(50, 0, 100, 100, 0, 100)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)
triangle.fixture:setFilterData(triangle.category, triangle.mask, triangle.group)
triangle.fixture:setFriction(0)
triangle.fixture:setUserData(triangle)

-- Custom entity properties

triangle.speed = 160
triangle.body:setLinearVelocity(-triangle.speed, 0)
triangle.direction = 'left'

triangle.draw = function(self)
  local color = {0.8, 0.1, 0.1, 1}
  love.graphics.setColor(color)
  love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

triangle.update = function(self)
  local pos_x = self.body:getPosition()
  local _, vel_y = self.body:getLinearVelocity()
  if pos_x > window_width * 0.9 then
    self.direction = 'left'
  elseif pos_x < window_width * 0.3 then
    self.direction = 'right'
  end
  if self.direction == 'left' then
    self.body:setLinearVelocity(-self.speed, vel_y)
  elseif self.direction == 'right' then
    self.body:setLinearVelocity(self.speed, vel_y)
  end
end

return triangle
