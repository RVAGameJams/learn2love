-- server/main.lua
-- Our server application
local server = require('server')

love.load = function()
  -- Keep text pixels sharp and intact instead of blurring
  -- https://love2d.org/wiki/FilterMode
  love.graphics.setDefaultFilter('nearest', 'nearest')

  server.start()
end

love.draw = function()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if server.is_connected() then
    love.graphics.print('client connected to us (see console)', transform)
  else
    love.graphics.print('server started... awaiting clients', transform)
  end
end

-- It's convenient to be able to press escape to close the program
love.keypressed = function(pressed_key)
  if pressed_key == 'escape' then
    love.event.quit()
  end
end

love.update = function()
  server.update()
end

love.quit = function()
  server.disconnect()
end
