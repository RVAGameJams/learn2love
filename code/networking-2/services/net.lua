-- net.lua

local enet = require('enet')

-- Populate one or the other depending if we start a server or client host
local client_host
local server_host

-- As a server, we want to keep track of all the connected clients
local peers = {}
local received_data = false

-- The service we will be returning
local net = {}

net.start_server = function()
  server_host = enet.host_create('localhost:6789')
end

net.start_client = function()
  client_host = enet.host_create()
  server_host = client_host:connect('localhost:6789')
end

net.is_connected = function()
  return received_data
end

net.is_client = function()
  return client_host and true or false
end

net.is_server = function()
  return server_host and not client_host
end

net.update = function()
  local host = client_host or server_host
  if not host then return end
  local event = host:service()
  if event then
    received_data = true
    print('----')
    for k, v in pairs(event) do
      print(k, v)
    end
    if net.is_client() then
      event.peer:send('meow')
    else
      print(event.peer:connect_id())
      event.peer:send('bark')
    end
  end
end

net.disconnect = function()
  for _, peer in ipairs(peers) do
    peer:disconnect_now()
  end
  peers = {}

  if net.is_client() then
    server_host:disconnect_now()
    client_host = nil
  end

  server_host = nil
  received_data = false
end

return net
