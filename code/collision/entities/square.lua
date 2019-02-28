local world = require('world')
local window_width = love.window.getMode()

local square = {}
square.category = tonumber('0001', 2)
square.mask = tonumber('1110', 2)
square.group = 0
square.body = love.physics.newBody(world, 80, 400, 'dynamic')
square.body:setFixedRotation(true)
square.body:setMass(20)
square.shape = love.physics.newRectangleShape(60, 100)
square.fixture = love.physics.newFixture(square.body, square.shape)
square.fixture:setFilterData(square.category, square.mask, square.group)
square.fixture:setFriction(10)
square.fixture:setUserData(square)

-- Custom entity properties

square.color = {0.6, 0.7, 0.6, 1}
square.speed = 240
square.jump_impulse = 2000

-- If the entity is contacting something (ie, the ground) then it can jump.
-- If can_jump == 0 then the square is not contact
-- Obviously not the most sophisticated way to handle platform jumping as
-- you could be contacting anything or from any side.
square.can_jump = 0

square.draw = function(self)
  love.graphics.setColor(self.color)
  love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
end

square.update = function(self, inputs)
  -- Maintain y velocity as to not interrupt jumping and falling
  local pos_x, _ = self.body:getPosition()
  local vel_x, vel_y = self.body:getLinearVelocity()
  -- Move left
  if inputs.left then
    vel_x = -self.speed
  -- Move right
  elseif inputs.right then
    vel_x = self.speed
  end
  -- Don't let the entity run off the screen
  if pos_x - 32 < 0 then
    vel_x = math.max(vel_x, 0)
  elseif pos_x + 30 > window_width then
    vel_x = math.min(vel_x, 0)
  end
  -- Apply velocity changes
  self.body:setLinearVelocity(vel_x, vel_y)
  -- Jump only when touching the ground
  if inputs.jump and self.can_jump > 0 then
    self.body:applyLinearImpulse(0, -self.jump_impulse)
  end
end

square.begin_contact = function(self)
  self.can_jump = self.can_jump + 1
end

square.end_contact = function(self)
  self.can_jump = self.can_jump - 1
end

return square
