# Networking (part 1)

When creating a program such as a game, one of the first things to consider should be whether it is a networked application.
Such a choice will radically change the structure and complexity of the application.
To build a networked ("online") multiplayer game, we must understand some networking basics.
Some of this information is oversimplified, but let's establish a baseline of knowledge.

## Internet protocol (IP)

Networks are possible because computers agree on a way to communicate with each other.
Like ogres, messages sent across the internet have many layers.
Each layer represents a different protocol that interprets how the message should be handled.
The internet protocol (IP) tells computers how to relay messages to their intended destination.
There are two things we need to know about this protocol: **IP addresses** and **ports**.

Every device connected to the internet has an IP address assigned to it when it connects.
Messages sent out from your device are sent with a destination IP address attached so it knows where to go.
Messages are relayed from one machine to another until it reaches the destination machine's address.

If you open your terminal or command prompt and type `ping google.com` you will get a response back that tells you the destination IP address; The IP address of the server running the google.com homepage you see.
You may even be able to type that IP address into your web browser and it will direct you to the website in the same fashion typing google.com in the address bar would (although this won't work for all websites because of unrelated, complicated reasons).
Let's say you connected to google.com through the IP address 172.217.7.14.
You're actually connecting to that IP through a specific port.
Ports are represented as numbers, so that IP like most every other website on the internet is accessed through port 443.

IP ports are like the maritime ports that harbor ships.
A single destination can have multiple ports for different purposes.
If I were bringing in a military vessel I may go to a different port than a commercial vessel.

Depending on your intentions for a network connection you will use different IP ports.
For instance, if you are trying to view a website located at 172.217.7.14 you will use port 443 for an HTTPS connection, port 80 for an HTTP connection (if allowed), and if I am an administrator of the machine running on 172.217.7.14 I will use a completely different port to establish a backdoor connection such as port 22.

For our example program we will try connecting to a special reserved IP address, 127.0.0.1.
This IP address is your machine's own IP address it uses when it wants to connect to itself.
Since we'll be testing our program by running both copies on the same computer we won't need to worry about multiple IP addresses for now.
For the port you have a range from 0 to 65535 and it doesn't really matter which one you use so long as it's not already in use or being reserved for other purposes.
We'll pick a random one that is unlikely to be in use by other programs... 6789.

## Transport layer

The transport layer decides how your data will be packaged and streamed.
You have a choice on a few different protocols for the transport layer.
Understanding the details of each protocol in the transport layer isn't too important for this section of the book but let's discuss why we may want to use one or the other.

- **TCP** - This protocol provides different features to make sure data doesn't get corrupt. Most notably, it waits for a confirmation response from the other end to make sure the message was received. If a response isn't received by a certain timeout then the connection is considered a failure. Websites use TCP 99% of the time because of its reliability and ensuring you've received the site's full content.
- **UDP** - This protocol sends data to a server and expects no response back. Sending data without confirming it reaches the destination could lead to less reliable data transportation. However, less back and forth communication could mean a faster connection. This protocol is used by applications needing to send lots of data quickly, like an audio stream or a video game. This is the protocol we'll use.

Imagine you have two players needing to communicate their position with each other so we decide to use UDP.
You may send messages back and forth several times a second to communicate your positions.
Since you are sending data so rapidly, if one of those messages is lost then the player position can be re-synchronized next message.
This is fast and unless one of the players has a faulty internet connection you typically won't notice a small jitter or hiccup every now and then.

Now imagine another scenario where we want to send a message that a player gained an extra life.
If we were using UDP and that message got lost, we could have two online players with out-of-sync information that would ultimately jeopardize gameplay.
One solution around this would be to use TCP for mission-critical messages and UDP for everything else.
Another solution is to keep all messages in UDP, but to write a callback in Lua around our mission-critical messages to check that we get a reply.
Yup, you can have your application send UDP messages and expect a response but even though UDP doesn't have this feature as part of its protocol you can still program in your application a timeout that expects a response.
This sounds like a lot of work, but Lua and many other languages have libraries available you can require in your project that do this for you.
We'll see how easy this is later on.

## Application layer

Finally we have the protocol we create for each running copy of a game to know how to communicate once a connection is established.
For instance if a message with the string `"ping"` is being received, we may want to respond `"pong"`.
The more complicated the game is, the more complicated the protocol will be.
Let's check out one of the libraries Lua offers for networking and build a test program with a basic application protocol where the server responds to `"meow"` with `"bark"` and the client responds to `"bark"` with `"meow"`.
As you can guess this will lead to an infinite back-and-forth conversation between the two hosts if we are successful.

## ENet

There are several third-party libraries for Lua for networking.
LÖVE includes two of the most popular, [LuaSocket](http://w3.impa.br/~diego/software/luasocket/) and [lua-enet](http://leafo.net/lua-enet/).
LuaSocket is very flexible and allows you to create TCP and UDP connections.
Lua-enet is built on top of the ENet library, a simple yet high performance networking library.
It uses UDP, but handles everything around the transport layer for us so we can focus on our application layer.
It even does message confirmation over UDP for us when we need it to so we get the best of both worlds.
Let's create a server and client program in LÖVE and we'll run them separately, connecting them to each other.

## Our server application

Create a folder called `server` and in it create a file named `server.lua`.
We'll start by requiring `enet`:

```lua
-- server/server.lua
local enet = require('enet')
```

This file will return a table of functions for starting and stopping the server.
To start the server, we need to create a host and tell it which IP address and port it is running on.
Let's create a `server.start` function that does just that:

```lua
-- server/server.lua
local enet = require('enet')

local host
local server = {}

server.start = function()
  host = enet.host_create('127.0.0.1:6789')
end

return server
```

The IP address is `127.0.0.1` as we said we would use.
That is telling ENet we want to start the server on our machine's local address.
The IP address is followed by a colon (`:`) then the port number (`6789`) which is an arbitrary port that should be free to use.
If we create a main.lua file we can require server.lua and create a server when LÖVE starts.

```lua
-- server/main.lua
-- Our server application
local server = require('server')

love.load = function()
  server.start()
end
```

If we try and run this, nothing will happen.
Let's define `love.draw` and print some text to tell us when someone connects to our server:

```lua
-- server/main.lua
-- Our server application
local server = require('server')

love.load = function()
  -- Keep text pixels sharp and intact instead of blurring
  -- https://love2d.org/wiki/FilterMode
  love.graphics.setDefaultFilter('nearest', 'nearest')

  server.start()
end

love.draw = function()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if server.is_connected() then
    love.graphics.print('client connected to us (see console)', transform)
  else
    love.graphics.print('server started... awaiting clients', transform)
  end
end

-- It's convenient to be able to press escape to close the program
love.keypressed = function(pressed_key)
  if pressed_key == 'escape' then
    love.event.quit()
  end
end
```

With this done, we need to figure out how the server knows someone is connected.
We call `server.is_connected()` in `love.draw`, so let's start by defining that:

```lua
-- server/server.lua
local enet = require('enet')

local host
local received_data = false
local server = {}

server.start = function()
  host = enet.host_create('127.0.0.1:6789')
end

server.is_connected = function()
  return received_data
end

return server
```

Ok, so `server.is_connected()` will return the value of `received_data` which defaults to `false`.
Now the part that does all the action:

```lua
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

return server
```

Let's take a close look at `server.update` piece by piece.
First thing is an `if` statement to check that `host` is defined.
If `server.update` is called before `server.start` then it won't be so there is no server update to be made.
If our server host was created and we get past the if-statement check, we call `host:service()`.
If we read the documentation for [`host:service`](http://leafo.net/lua-enet/#hostservicetimeout) we can see the purpose of calling this is to check for any incoming packets (messages) and send out any we have queued up.
If we receive any, we will get back an `event` table.
If we do get an event table, we'll change `received_data` to `true` (which in turn means `server.is_connected()` now returns `true`).
Next we will capture the peer (the client) that sent us this data which we can use to send messages to later:

```lua
peer = event.peer
```

While we have the event table, let's just iterate over it and print its contents to the console:

```lua
for k, v in pairs(event) do
  print(k, v)
end
```

Then finally we'll send the client a message that simply reads "bark".

```lua
event.peer:send('bark')
```

We can now call `server.update` inside our game loop's `love.update` function:

```lua
love.update = function()
  server.update()
end
```

We need to test our server, but to test our server, we need a client.

## Our client application

Create a "client" folder like the "server" folder created above.
Most of the code will be identical to our server.
The main difference is that when we create a host we won't pass it an IP address and port to serve on, but instead will tell it to connect to the address and port the server is running on.

```lua
-- client/main.lua
-- Our client application
local client = require('client')

love.load = function()
  -- Keep text pixels sharp and intact instead of blurring
  -- https://love2d.org/wiki/FilterMode
  love.graphics.setDefaultFilter('nearest', 'nearest')

  client.start()
end

love.draw = function()
  -- Scale up the size of the text being printed
  local transform = love.math.newTransform(0, 0, 0, 3)
  if client.is_connected() then
    love.graphics.print('connected to server (see console)', transform)
  else
    love.graphics.print('establishing a connection...', transform)
  end
end

love.keypressed = function(pressed_key)
  if pressed_key == 'escape' then
    love.event.quit()
  end
end

love.update = function()
  client.update()
end
```

```lua
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

return client
```

If we receive a message from the server we'll "meow" back at it.

## Testing things out

If you run the server you will see a message saying "server started... awaiting clients".
Since we are printing to the console, if you are running this code on Windows remember that you will need to enable the console.
This can be done by creating a conf.lua file in both the client and server folders.

```lua
-- LÖVE configuration file

love.conf = function(t)
  t.console = true        -- Enable the debug console for Windows.
  t.window.width = 800    -- Game's screen width (number of pixels)
  t.window.height = 600   -- Game's screen height (number of pixels)
end
```

If the server is up and running with the console enabled, go ahead and start the client with its console enabled too.
You should immediately see a flood of events printing out in the server and client consoles.

Server console:
```
----
peer    127.0.0.1:58384
channel 0
data    meow
type    receive
```

Client console:
```
----
peer    127.0.0.1:6789
channel 0
data    bark
type    receive
```

This will go back and forth until you close either one of them.
If you close one though, the messages will stop and it will just sit there.
If you close the server first, for instance, the client will sit there then after several seconds a message will appear:

```
----
peer    127.0.0.1:6789
data    0
type    disconnect
```

Normally a disconnect like this wouldn't be detected with UDP, but the ENet library sends "heartbeat" messages back and forth to make sure both peers are still connected to each other.
The timeout is defined to be somewhere between 5 and 30 seconds before the peer realizes it has been disconnnected from the other one.
Just to polish things off here, let's make ENet send a disconnect event to the other peer immediately when we are closing our application.
The lua-enet documentation lists a function we can invoke to do that, [`peer:disconnect_now`](http://leafo.net/lua-enet/#peerdisconnect_nowdata).
LÖVE has a [`love.quit`](https://love2d.org/wiki/love.quit) callback that is called when our application is closing.
We can write a `server.disconnect` function and call it from `love.quit`.

Server:

```lua
-- server/main.lua

...

love.quit = function()
  server.disconnect()
end
```

```lua
-- server/server.lua

...

server.disconnect = function()
  if peer then
    peer:disconnect_now()
    peer = nil
  end
  host = nil
  received_data = false
end
```

The `client.disconnect` code would be identical.

To see this full example or if you have any problems getting your code to run check out the code on GitHub:
https://github.com/RVAGameJams/learn2love/tree/master/code/networking-1

In the next part we will look at network architecture and add entities to the screen to work with.

## Exercises

- What happens if you try to connect multiple clients to the server? What about running multiple servers on the same IP address and port? Why does it behave like it does?
