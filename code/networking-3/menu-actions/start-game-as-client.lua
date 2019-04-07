-- Start the game when the client receives a server response
local menu_service = require('services/menu')
local net_service = require('services/net')

return function()
  if net_service.is_connected() then
    menu_service.unload()
  end
end
