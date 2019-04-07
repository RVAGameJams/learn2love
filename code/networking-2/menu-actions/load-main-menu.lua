local menu_service = require('services/menu')
local net_service = require('services/net')

return function()
  menu_service.load('main-menu')
  net_service.disconnect()
end
