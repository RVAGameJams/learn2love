-- entities/ball.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity_max_speed = 880

  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'dynamic')
  entity.body:setLinearVelocity(300, 300)
  entity.shape = love.physics.newCircleShape(0, 0, 10)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setFriction(0)
  entity.fixture:setRestitution(1)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    local self_x, self_y = self.body:getWorldCenter()
    love.graphics.circle('fill', self_x, self_y, self.shape:getRadius())
  end

  entity.update = function(self)
    local vel_x, vel_y = self.body:getLinearVelocity()
    local speed = math.abs(vel_x) + math.abs(vel_y)

    local vel_x_is_critical = math.abs(vel_x) > entity_max_speed * 2
    local vel_y_is_critical = math.abs(vel_y) > entity_max_speed * 2
    -- Ball is bouncing too fast to reasonably hit.
    -- Cut down its speed by 75% if so.
    if vel_x_is_critical or vel_y_is_critical then
      self.body:setLinearVelocity(vel_x * .75, vel_y * .75)
    end
    if speed > entity_max_speed then
      self.body:setLinearDamping(0.1)
    else
      self.body:setLinearDamping(0)
    end
  end

  return entity
end
