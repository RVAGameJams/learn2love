-- entities/brick.lua

local state = require('state')
local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  -- How many times the brick can be hit before it is destroyed
  entity.health = 2
  -- Used to check during update if this entity is a brick
  -- If no bricks are found then the level was cleared
  entity.type = 'brick'

  entity.draw = function(self)
    -- Draw the brick in a different color depending on health
    love.graphics.setColor(state.palette[self.health] or state.palette[5])
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    -- Reset graphics drawer back to the default color (white)
    love.graphics.setColor(state.palette[5])
  end

  entity.end_contact = function(self)
    self.health = self.health - 1
  end

  return entity
end
