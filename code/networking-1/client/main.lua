-- client/main.lua
-- Our client application
local client = require('client')

love.load = function()
  -- Keep text pixels sharp and intact instead of blurring
  -- https://love2d.org/wiki/FilterMode
  love.graphics.setDefaultFilter('nearest', 'nearest')

  client.start()
end

love.draw = function()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if client.is_connected() then
    love.graphics.print('connected to server (see console)', transform)
  else
    love.graphics.print('establishing a connection...', transform)
  end
end

love.keypressed = function(pressed_key)
  if pressed_key == 'escape' then
    love.event.quit()
  end
end

love.update = function()
  client.update()
end

love.quit = function()
  client.disconnect()
end
