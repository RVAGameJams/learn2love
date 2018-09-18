-- entities/ball.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'dynamic')
  entity.body:setMass(32)
  entity.body:setLinearVelocity(300, 300)
  entity.shape = love.physics.newCircleShape(0, 0, 10)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setRestitution(1)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    local self_x, self_y = self.body:getWorldCenter()
    love.graphics.circle('fill', self_x, self_y, self.shape:getRadius())
  end

  return entity
end
