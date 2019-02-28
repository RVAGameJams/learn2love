-- main.lua

local world = require('world')
local background = require('entities/background')
local circle = require('entities/circle')
local ground = require('entities/ground')
local square = require('entities/square')
local powerup = require('entities/powerup')
local triangle = require('entities/triangle')

-- Inputs change between true and false as keys are pressed and released
local inputs = {
  left = false,
  right = false,
  jump = false
}

love.draw = function()
  background:draw()
  circle:draw()
  ground:draw()
  square:draw()
  powerup:draw()
  triangle:draw()
end

love.keypressed = function(_, pressed_key)
  local actions = {
    left = function() inputs.left = true end,
    right = function() inputs.right = true end,
    space = function() inputs.jump = true end,
    escape = function() love.event.quit() end
  }
  if actions[pressed_key] then
    actions[pressed_key]()
  end
end

love.keyreleased = function(_, released_key)
  local actions = {
    left = function() inputs.left = false end,
    right = function() inputs.right = false end,
    space = function() inputs.jump = false end
  }
  if actions[released_key] then
    actions[released_key]()
  end
end

love.update = function(dt)
  square:update(inputs)
  triangle:update()
  world:update(dt)
end
