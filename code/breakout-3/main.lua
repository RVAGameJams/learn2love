-- main.lua

local entities = require('entities')
local input = require('input')
local world = require('world')

love.draw = function()
  for _, entity in ipairs(entities) do
    if entity.draw then entity:draw() end
  end
end

love.focus = function(focused)
  input.toggle_focus(focused)
end

love.keypressed = function(pressed_key)
  input.press(pressed_key)
end

love.keyreleased = function(released_key)
  input.release(released_key)
end

love.update = function(dt)
  if not input.paused then
    for _, entity in ipairs(entities) do
      if entity.update then entity:update(dt) end
    end
    world:update(dt)
  end
end
