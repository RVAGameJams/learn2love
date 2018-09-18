-- entities/paddle.lua

local world = require('world')

return function(pos_x, pos_y)
  local entity = {}
  entity.body = love.physics.newBody(world, pos_x, pos_y, 'static')
  entity.shape = love.physics.newRectangleShape(180, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end

  return entity
end
