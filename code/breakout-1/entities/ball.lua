-- entities/ball.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 200, 200, 'dynamic')
entity.body:setMass(32)
entity.body:setLinearVelocity(300, 300)
entity.shape = love.physics.newCircleShape(0, 0, 10)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setRestitution(1)
entity.fixture:setUserData(entity)

return entity
