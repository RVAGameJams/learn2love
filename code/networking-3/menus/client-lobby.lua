return function()
  local load_main_menu = require('menu-actions/load-main-menu')
  local start_game_as_client = require('menu-actions/start-game-as-client')

  local default_color = { 1, 1, 0, 0.8 }

  local btn_host = {
    text = 'Go back',
    color = default_color,
    pos_x = 0.4,
    pos_y = 0.3
  }

  local btn_join = {
    text = 'Waiting for server...',
    color = default_color,
    pos_x = 0.4,
    pos_y = 0.4
  }

  return {
    input_actions = {
      escape = load_main_menu,
      ['return'] = load_main_menu
    },
    elements = {
      btn_host,
      btn_join
    },
    update = start_game_as_client
  }
end
