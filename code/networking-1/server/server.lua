-- server/server.lua
local enet = require('enet')

local host
local peer
local received_data = false
local server = {}

server.start = function()
  host = enet.host_create('127.0.0.1:6789')
end

server.is_connected = function()
  return received_data
end

server.update = function()
  if not host then return end
  local event = host:service()
  if event then
    received_data = true
    peer = event.peer
    print('----')
    for k, v in pairs(event) do
      print(k, v)
    end
    event.peer:send('bark')
  end
end

server.disconnect = function()
  if peer then
    peer:disconnect_now()
    peer = nil
  end
  host = nil
  received_data = false
end

return server
