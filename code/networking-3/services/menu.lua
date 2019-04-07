local menu_service = {}

-- Used to calculate the relative positions of the menu elements on screen
local window_width, window_height = love.graphics:getDimensions()
-- Index of usable menus in the menus folder
local menus = {
  ['main-menu'] = require('menus/main-menu'),
  ['client-lobby'] = require('menus/client-lobby'),
  ['server-lobby'] = require('menus/server-lobby')
}

-- Value is set to a menu table when a menu is loaded
menu_service.active_menu = nil

menu_service.load = function(menu_name)
  -- Do some basic error checking to make sure we can load
  -- this menu and return a helpful error message if not
  assert(
    type(menu_name) == 'string',
    'Expected menu_name, but got ' .. type(menu_name)
  )
  local menu_factory = menus[menu_name]
  assert(
    type(menu_factory) == 'function',
    'Looking for a menu function by the name of ' .. menu_name .. ' but got ' .. type(menu_factory)
  )
  local menu = menu_factory()
  assert(
    type(menu) == 'table',
    'Expecting menu to return a table, but got ' .. type(menu)
  )
  -- Set the active menu
  menu_service.active_menu = menu
  -- Activate the first option on the menu
  menu.active_element = menu.active_element or menu.elements[1]
end

menu_service.unload = function()
  menu_service.active_menu = nil
end

menu_service.draw = function()
  local menu = menu_service.active_menu
  -- Nothing to do here if no menu is loaded
  if not menu then return end
  -- Register
  for _, element in ipairs(menu.elements) do
    local color = {
      element.color[1],
      element.color[2],
      element.color[3],
      element.color[4] or 0.8
    }
    if element == menu.active_element then
      color[1] = 1
      color[2] = 1
      color[3] = 1
      color[4] = 1
    end
    love.graphics.print(
      { color, element.text },
      math.floor(element.pos_x * window_width),
      math.floor(element.pos_y * window_height),
      0,
      2
    )
  end
end

menu_service.handle_keypress = function(pressed_key)
  local menu = menu_service.active_menu
  -- Nothing to do here if no menu is loaded
  if not menu then return end
  -- Check to see if the active element has any key bindings for this key
  local input_action
  if (menu.active_element.input_actions) then
    input_action = menu.active_element.input_actions[pressed_key]
  end
  -- Fall back to any menu input actions if the element has none
  input_action = input_action or menu.input_actions[pressed_key]
  -- Return if we found nothing to do
  if not input_action then return end
  -- Invoke that action, passing it the active menu data in case it wants
  -- to manipulate it (for instance cycle the active menu option/element)
  input_action(menu)
end

menu_service.update = function()
  local menu = menu_service.active_menu
  if not menu then return end
  if not menu.update then return end
  menu.update()
end

return menu_service
