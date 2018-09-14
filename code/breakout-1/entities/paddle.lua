-- entities/paddle.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 200, 560, 'static')
entity.shape = love.physics.newRectangleShape(180, 20)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
