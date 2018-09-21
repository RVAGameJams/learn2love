-- entities/pause-text.lua

local input = require('input')

return function()
  local window_width, window_height = love.window.getMode()

  local entity = {}

  entity.draw = function(self)
    if input.paused then
      love.graphics.print(
        {{ 0.2, 1, 0.2, 1 }, 'PAUSED'},
        math.floor(window_width / 2) - 54,
        math.floor(window_height / 2),
        0,
        2,
        2
      )
    end
  end

  return entity
end
