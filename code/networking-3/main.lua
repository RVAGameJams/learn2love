-- main.lua

local entity_service = require('services/entity')
local input_service = require('services/input')
local menu_service = require('services/menu')
local net_service = require('services/net')

love.load = function()
  -- Keep text pixels sharp and intact instead of blurring
  -- https://love2d.org/wiki/FilterMode
  love.graphics.setDefaultFilter('nearest', 'nearest')

  menu_service.load('main-menu')
end

love.keypressed = function(pressed_key)
  menu_service.handle_keypress(pressed_key)
  input_service[pressed_key] = true
end

love.keyreleased = function(released_key)
  input_service[released_key] = false
end

love.draw = function()
  menu_service.draw()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if net_service.is_connected() and net_service.is_server() then
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.print('Server preview. See console for details.', transform)
  end
  for _, entity in pairs(entity_service.entities) do
    entity_service.draw(entity)
  end
end

love.update = function()
  menu_service.update()
  -- Check to see if a player has spawned and update its movement if any direction keys are being pressed
  if entity_service.player_id then
    local player = entity_service.entities[entity_service.player_id]
    local old_x = player.x_pos
    local old_y = player.y_pos
    entity_service.move()
    if player.x_pos ~= old_x or player.y_pos ~= old_y then
      net_service.send('move|' .. player.id .. '|' .. player.x_pos .. '|' .. player.y_pos)
    end
  end
  net_service.update()
end

love.quit = function()
  net_service.disconnect()
end
