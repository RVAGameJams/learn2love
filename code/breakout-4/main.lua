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
    local index = 1
    while index <= #entities do
      local entity = entities[index]
      if entity.update then entity:update(dt) end
      -- When an entity has no health (brick has been hit enough times
      -- then we remove it from the list of entities. Don't increment
      -- the index number if doing that though because we have shrunk
      -- the table and made all the items shift down by 1 in the index.
      if entity.health == 0 then
        table.remove(entities, index)
        entity.fixture:destroy()
      else
        index = index + 1
      end
    end
    world:update(dt)
  end
end
