-- main.lua

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
end

love.draw = function()
  menu_service.draw()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if net_service.is_connected() then
    love.graphics.print('peer connected (see console)', transform)
  end
end

love.update = function()
  menu_service.update()
  net_service.update()
end

love.quit = function()
  net_service.disconnect()
end
