-- input.lua

local state = require('state')

-- Map specific user inputs to game states
local press_functions = {
  left = function()
    state.button_left = true
  end,
  right = function()
    state.button_right = true
  end,
  escape = function()
    love.event.quit()
  end,
  space = function()
    if state.game_over or state.stage_cleared then
      return
    end
    state.paused = not state.paused
  end
}

local release_functions = {
  left = function()
    state.button_left = false
  end,
  right = function()
    state.button_right = false
  end
}


-- This table is the service and will contain some functions
-- that can be accessed from entities or the main.lua.
return {
  -- Look up in the map for actions that correspond to specific key presses
  press = function(pressed_key)
    if press_functions[pressed_key] then
      press_functions[pressed_key]()
    end
  end,
  -- Look up in the map for actions that correspond to specific key releases
  release = function(released_key)
    if release_functions[released_key] then
      release_functions[released_key]()
    end
  end,
  -- Handle window focusing/unfocusing
  toggle_focus = function(focused)
    if not focused then
      state.paused = true
    end
  end
}
