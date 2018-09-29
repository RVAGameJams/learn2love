-- state.lua

-- The state of the game. This way our data is separate from our functionality.

return {
  button_left = false,
  button_right = false,
  game_over = false,
  palette = {
    {1.0, 0.0, 0.0, 1.0},  -- red
    {0.0, 1.0, 0.0, 1.0},  -- green
    {0.4, 0.4, 1.0, 1.0},  -- blue
    {0.9, 1.0, 0.2, 1.0},  -- yellow
    {1.0, 1.0, 1.0, 1.0}   -- white
  },
  paused = false,
  stage_cleared = false
}
