-- client/client.lua
local enet = require('enet')
local client = {}
local host
local peer
local received_data = false

client.start = function()
  host = enet.host_create()
  peer = host:connect('127.0.0.1:6789')
end

client.is_connected = function()
  return received_data
end

client.update = function()
  if host then
    local event = host:service()
    if event then
      received_data = true
      print('----')
      for k, v in pairs(event) do
        print(k, v)
      end
      event.peer:send('meow')
    end
  end
end

client.disconnect = function()
  if peer then
    peer:disconnect_now()
    peer = nil
  end
  host = nil
  received_data = false
end

return client
