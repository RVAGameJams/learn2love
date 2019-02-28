local window_width, window_height = love.window.getMode()

local background = {}

-- Going for a sunset look
background.colors = {
  {0.21, 0.36, 0.49, 1},
  {0.42, 0.36, 0.48, 1},
  {0.75, 0.42, 0.52, 1},
  {0.96, 0.45, 0.50, 1},
  {0.97, 0.69, 0.58, 1}
}

background.draw = function(self)
  local number_of_colors = #self.colors
  for i = 1, number_of_colors do
    love.graphics.setColor(self.colors[i])
    love.graphics.rectangle(
      'fill',
      0,
      math.floor((window_height / number_of_colors) * (i - 1)),
      window_width,
      window_height / number_of_colors
      )
  end
end

return background
