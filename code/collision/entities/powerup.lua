local world = require('world')

local powerup = {}
powerup.category = tonumber('0010', 2)
powerup.mask = tonumber('1001', 2)
powerup.group = 0
powerup.body = love.physics.newBody(world, 340, 400, 'dynamic')
powerup.body:setFixedRotation(true)
powerup.body:setMass(20)
powerup.shape = love.physics.newPolygonShape(20, 12, 40, 12, 45, 16, 45, 20, 30, 36, 15, 20, 15, 16)
powerup.fixture = love.physics.newFixture(powerup.body, powerup.shape)
powerup.fixture:setFilterData(powerup.category, powerup.mask, powerup.group)
powerup.fixture:setFriction(10)
powerup.fixture:setUserData(powerup)

-- Custom entity properties

powerup.color = {0, 1, 0, 1}
powerup.taken = false

powerup.draw = function(self)
  if self.taken == false then
    love.graphics.setColor(self.color)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
  end
end

powerup.begin_contact = function(self, other_entity)
  -- Only care about contact with players and not contact with the floor
  if other_entity.jump_impulse then
    self.taken = true
    self.fixture:destroy()
    other_entity.color = {0, 0.9, 0, 1}
    other_entity.jump_impulse = 3000
  end
end

return powerup
