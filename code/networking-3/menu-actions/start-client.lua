local menu_service = require('services/menu')
local net_service = require('services/net')

return function()
  menu_service.load('client-lobby')
  net_service.start_client()
end
