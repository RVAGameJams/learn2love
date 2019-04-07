return function()
  local start_server = require('menu-actions/start-server')
  local start_client = require('menu-actions/start-client')
  local quit_game = require('menu-actions/quit-game')
  local element_previous = require('menu-actions/element-previous')
  local element_next = require('menu-actions/element-next')

  local default_color = { 1, 1, 0, 0.8 }

  local btn_host = {
    text = 'Host',
    color = default_color,
    input_actions = {
      ['return'] = start_server
    },
    pos_x = 0.4,
    pos_y = 0.3
  }

  local btn_join = {
    text = 'Join',
    color = default_color,
    input_actions = {
      ['return'] = start_client
    },
    pos_x = 0.4,
    pos_y = 0.4
  }

  local btn_quit = {
    text = 'Quit',
    color = default_color,
    input_actions = {
      ['return'] = quit_game
    },
    pos_x = 0.4,
    pos_y = 0.5
  }

  return {
    input_actions = {
      up = element_previous,
      down = element_next,
      escape = quit_game
    },
    elements = {
      btn_host,
      btn_join,
      btn_quit
    }
  }
end
