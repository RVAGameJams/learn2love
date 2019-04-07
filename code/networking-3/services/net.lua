local enet = require('enet')
local entity_service = require('services/entity')

-- Populate one or the other depending if we start a server or client host
local client_host
local server_host

-- As a server, we want to keep track of all the connected clients
local peers = {}
local received_data = false

-- Callbacks to invoke when certain events are received from a peer
-- Define a callback to handle every type of message in our application protocol
local message_handlers = {
  ['your-id'] = function(message)
    local player_id = message[2]
    local x_pos = message[3]
    local y_pos = message[4]
    entity_service.player_id = player_id
    entity_service.entities[player_id] = entity_service.spawn(player_id, x_pos, y_pos)
  end,
  ['peer-id'] = function(message)
    local player_id = message[2]
    local x_pos = message[3]
    local y_pos = message[4]
    entity_service.entities[player_id] = entity_service.spawn(player_id, x_pos, y_pos)
  end,
  ['move'] = function(message, event, is_server)
    local player_id = message[2]
    local x_pos = message[3]
    local y_pos = message[4]
    entity_service.entities[player_id].x_pos = x_pos
    entity_service.entities[player_id].y_pos = y_pos
    if is_server then
      -- Relay this message to the other players
      for id, peer in pairs(peers) do
        if id ~= player_id then
          peer:send(event.data)
        end
      end
    end
  end
}
-- These event types are defined by Lua-enet. A "receive" type of event
-- is a generic event that carries any of the messages above.
local event_handlers = {
  connect = function(event, is_server)
    -- Only the server needs to do stuff here on connect
    if is_server then
      -- event.peer:connect_id() provides us with a unique number.
      -- We'll convert that number to a string and use it as the player ID.
      local player = entity_service.spawn(tostring(event.peer:connect_id()), 100, 100)
      -- Store this player in the player table with the player ID as the key.
      entity_service.entities[player.id] = player
      -- Send the initial "your-id" message back to the connecting client so they can spawn this entity too.
      event.peer:send('your-id|' .. player.id .. '|' .. player.x_pos .. '|' .. player.y_pos)
      -- Let all the other peers know about this player
      for _, peer in pairs(peers) do
        local peer_player = entity_service.entities[tostring(peer:connect_id())]
        peer:send('peer-id|' .. player.id .. '|' .. player.x_pos .. '|' .. player.y_pos)
        event.peer:send('peer-id|' .. peer_player.id .. '|' .. peer_player.x_pos .. '|' .. peer_player.y_pos)
      end
      -- Add this peer to the peer list
      peers[tostring(event.peer:connect_id())] = event.peer
    end
  end,
  disconnect = function(event, is_server)
    -- TODO: Add code to remove entities when a client disconnects
  end,
  receive = function(event, is_server)
    -- Extract the message out from the event and call the appropriate callback above
    local message = {}
    for match in (event.data .. '|'):gmatch('(.-)|') do
      table.insert(message, match)
    end
    message_handlers[message[1]](message, event, is_server)
  end
}

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

net.send = function(message)
  if net.is_client() then
    server_host:send(message)
  else
    server_host:broadcast(message)
  end
end

net.update = function()
  local host = client_host or server_host
  if not host then return end
  local event = host:service()
  if event then
    received_data = true
    -- event.type will be either "connect", "disconnect", or "receive"
    event_handlers[event.type](event, net.is_server())
    -- Print out the event table for debug purposes
    print('----')
    for k, v in pairs(event) do
      print(k, v)
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
