# Breakout (part 3): inputs

## Review

In the previous section we reconstructed our entities to make room for bricks and additional functionality.
We haven't completed any new items on our checklist:

- The objective of the game is to destroy all the bricks on the screen
- The player controls a "paddle" entity that hits a ball
- The ball destroys the bricks
- **✔** The ball needs to stay within the boundaries of the screen
- If the ball touches the bottom of the screen, the game ends

So let's come up with a system to handle user input and get the paddle moving.

## Input service

Inside **main.lua** there is some functionality for this that we are going to remove and rewrite starting with a new file that specifically handles all the user input.
This kind of file is typically called a service because it abstracts away tedious functionality into an easy-to-use service.
I encourage you to write out the service instead of copying and pasting.
Read through each function and try to understand what each one does.

```lua
-- input.lua

-- This table is the service and will contain some functions
-- that can be accessed from entities or the main.lua.
local input = {}
-- Map specific user inputs to game actions
local press_functions = {}
local release_functions = {}


-- For moving paddle left
input.left = false
-- For moving paddle right
input.right = false
-- Keep track of whether game is pause
input.paused = false
-- Look up in the map for actions that correspond to specific key presses
input.press = function(pressed_key)
  if press_functions[pressed_key] then
    press_functions[pressed_key]()
  end
end
-- Look up in the map for actions that correspond to specific key releases
input.release = function(released_key)
  if release_functions[released_key] then
    release_functions[released_key]()
  end
end
-- Handle window focusing/unfocusing
input.toggle_focus = function(focused)
  if not focused then
    input.paused = true
  end
end


press_functions.left = function()
  input.left = true
end
press_functions.right = function()
  input.right = true
end
press_functions.escape = function()
  love.event.quit()
end
press_functions.space = function()
  input.paused = not input.paused
end


release_functions.left = function()
  input.left = false
end
release_functions.right = function()
  input.right = false
end


return input
```

The input table is what gets returned, meaning when we `require('input')` in another file, we get back that table and its contents.
Inside the input there are three boolean properties that get toggled by user input: `input.left`, `input.right`, and `input.paused`.
Along with these three properties, there are three functions exposed to us to make use of: `input.press`, `input.release`, and `input.toggle_focus`, all of which we will invoke from our callbacks in **main.lua**:

```lua
-- main.lua

local entities = require('entities')
local input = require('input')
local world = require('world')

love.draw = function()
  for _, entity in ipairs(entities) do
    if entity.draw then entity:draw() end
  end
end

love.focus = function(focused)
  input.toggle_focus(focused)
end

love.keypressed = function(pressed_key)
  input.press(pressed_key)
end

love.keyreleased = function(released_key)
  input.release(released_key)
end

love.update = function(dt)
  if not input.paused then
    for _, entity in ipairs(entities) do
      if entity.update then entity:update(dt) end
    end
    world:update(dt)
  end
end
```

In `love.update` we skip updates if `input.paused` is `true`.
However if the game is **not** paused then it will loop through the entity list, calling `entity.update` if the entity has an update function.
With this added functionality, we can append an `entity.update` function into our existing paddle code:

```lua
-- entities/paddle.lua

entity.update = function(self)
  -- Don't move if both keys are pressed. Just return
  -- instead of going through the rest of the function.
  if input.left and input.right then
    return
  end
  local self_x, self_y = self.body:getPosition()
  if input.left then
    self.body:setPosition(self_x - 10, self_y)
  elseif input.right then
    self.body:setPosition(self_x + 10, self_y)
  end
end
```

The left and right arrows will now move the paddle!
There isn't much else to say here in the way of input.
A bit unrelated to the actual input, but more so the paddle functionality is it moves off screen and doesn't adhere to the boundaries?
Why is that?

If you remember when we created the paddle, it is a static entity.
It doesn't have the ability to move on its own or by the effect of other entities.
This will cause us some problems later (and we're learning the hard way)!
Rather than forcing the paddle with an invisible push, we force a new position for the paddle when we call `body:setPosition` inside the paddle's `entity.update` function.
It's like we're teleporting it on top of whatever space we want with a keystroke, ignoring all physics and collision.
This is simpler to code and gets around the fact the paddle's static body won't respond to force.
To fix this, we can artificially set the boundary on the paddle by checking if it is out of bounds before moving it.

```lua
-- entities/paddle.lua

entity.update = function(self)
  -- Don't move if both keys are pressed. Just return
  -- instead of going through the rest of the function.
  if input.left and input.right then
    return
  end
  local self_x, self_y = self.body:getPosition()
  if input.left then
    local new_x = math.max(self_x - 10, 108)
    self.body:setPosition(new_x, self_y)
  elseif input.right then
    local new_x = math.min(self_x + 10, 700)
    self.body:setPosition(new_x, self_y)
  end
end
```

Calling `math.max` means we will set the new x-position to either `self_x - 10` or `100`, whichever number is bigger.
This prevents us from getting a number so small it runs off too far to the left.
`math.min` does the opposite and takes care of the right side of the screen.

One issue you may or may not notice is movement isn't always a uniform speed, and depending on the speed of your computer the paddle may appear to go faster or slower.
Remember the article on [delta time](02-05-delta-time.md)?
We need to scale the distance travelled to match the amount of time that has passed.
Conveniently, we are getting the delta time from `love.update` already.
Take a closer look at it:

```lua
-- main.lua

love.update = function(dt)
  if not input.paused then
    for _, entity in ipairs(entities) do
      -- Delta time is being passed
      -- to the entity.update function here
      --                                  |
      --                                  |
      --                                  V
      if entity.update then entity:update(dt) end
    end
    world:update(dt)
  end
end
```

Which means we can do this:

```lua
-- entities/paddle.lua

entity.update = function(self, dt)
  -- Don't move if both keys are pressed. Just return
  -- instead of going through the rest of the function.
  if input.left and input.right then
    return
  end
  local self_x, self_y = self.body:getPosition()
  if input.left then
    local new_x = math.max(self_x - (400 * dt), 100)
    self.body:setPosition(new_x, self_y)
  elseif input.right then
    local new_x = math.min(self_x + (400 * dt), 700)
    self.body:setPosition(new_x, self_y)
  end
end
```

The number `400` is arbitrary and can be whatever speed you want the paddle to move at.
`dt` is a small number so it needs to be multiplied by a large number like 400 to match a speed similar to what we were seeing before when we simply were adding and subtracting `10`.

If you missed anything or are having issues, here's a copy of the completed source code for this section:
https://github.com/RVAGameJams/learn2love/tree/master/code/breakout-3

In the next section we will work on the physics more to give the ball movement a more realistic feel.
We will also implement the ability to destroy bricks using the world collision callbacks.

## Exercises

- Despite having a restitution of 1, the ball is losing momentum as it collides with other objects. This is due to friction. How can that be fixed?
- When the game is paused, make it display text on the screen so the player knows the game isn't just frozen. Hint: you'll need one of the draw functions from [love.graphics](https://love2d.org/wiki/love.graphics) to print the text.

The answers to these exercises will be in the next section's source code.
