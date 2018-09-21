-- entities/brick.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  -- How many times the brick can be hit before it is destroyed
  entity.health = 2

  entity.draw = function(self)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
  end

  entity.end_contact = function(self)
    self.health = self.health - 1
  end

  return entity
end
