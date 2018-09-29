# Breakout (part 5): game state

## Review

We've gotten a bit done so let's look at the basic requirements again:

- The objective of the game is to destroy all the bricks on the screen
- **✔** The player controls a "paddle" entity that hits a ball
- **✔** The ball destroys the bricks
- **✔** The ball needs to stay within the boundaries of the screen
- If the ball touches the bottom of the screen, the game ends

In the previous exercise the question was brought up what would be the easiest way to draw a bunch of bricks across the screen.
A simple, but *very tedious* answer to that would be to position the bricks one at a time in **entities.lua** like so:

```lua
  brick(40, 80),
  brick(100, 140)
  -- and so on...
```

If you want to make your bricks into a shape or sculpture then that might be the best approach.
If you just want to arrange your bricks into a grid, then the easiest way would be to write a [numeric for-loop](01-15-for-loops-1.md).

```lua
-- entities.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_vertical = require('entities/boundary-vertical')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local pause_text = require('entities/pause-text')
local ball = require('entities/ball')
local brick = require('entities/brick')

local entities = {
  boundary_bottom(400, 606),
  boundary_vertical(-6, 300),
  boundary_vertical(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  pause_text(),
  ball(200, 200)
}

local row_width = love.window.getMode() - 20
for number = 0, 38 do
  local brick_x = ((number * 60) % row_width) + 40
  local brick_y = (math.floor((number * 60) / row_width) * 40) + 80
  entities[#entities + 1] = brick(brick_x, brick_y)
end

return entities
```

Ok this admittedly looks more complicated at first, but if you remember the arithmetic and orders of operation covered in [1.1 - Interactive coding](01-01-interactive-coding.md) statements are processed from the inner parenthesis and worked outwards.
So why the long calculation?
Let's start off with a simpler calculation:

```lua
  local brick_x = number * 60
```

Starting with the `number` 0 up to 38, there will be 39 loops and therefore 39 bricks drawn.
On the first loop, `number` is 0.
Since the bricks are 50 pixels wide this would draw the bricks with a 10 pixel space between each.
First brick at 60, then 120, then 180...
Ok, but then after only a dozen bricks we would start running off the screen.
This is where the modulus comes in handy:

```lua
  local brick_x = (number * 60) % row_width
```

`row_width` is how wide we want a row of bricks to be be.
In this case `row_width` is the screen width, 800 pixels, subtract 20 pixels for padding.
So draw the bricks every 60 pixels, but then when you get to 780 pixels, start back at 0 pixels and begin drawing a new row.
Thanks modulus!
Now just to give the bricks some spacing on the left side away from the wall, we can go ahead and add 40 pixels to the final result for the x-position:

```lua
  local brick_x = ((number * 60) % row_width) + 40
```

The brick's y-position is calculated a little bit differently.
What we need to find out is which row we're on so we know where on the y-axis to draw.
If we take the `number` and multiply it by 60 then do a modulus we know that gives us the x-position.
So let's take that chunk of code from above and make that the basis of our y-position calculation:

```lua
  local brick_y = (number * 60) % row_width
```

Rather than using modulus, if we use regular division we get a small remainder every time `(number * 60)` exceeds the row width:

```lua
  local brick_y = (number * 60) / row_width
```

This will give us a number with decimals so to keep things rounded we can use `math.floor` to snap the y-position  down to the nearest whole number:

```lua
  local brick_y = math.floor((number * 60) / row_width)
```

Great!
Now every time the x-position exceeds the row width, we get back the number of the row we're on... 0 for the first, 1 for the second, 2 and so on.
With this number we can now space out each row by 40 pixels:

```lua
  local brick_y = math.floor((number * 60) / row_width) * 40
```

Then finally just to shift the bricks a little further down the screen we give it a padding that looks right, say 80:

```lua
  local brick_y = (math.floor((number * 60) / row_width) * 40) + 80
```

And there you go.
The entity can just be added to the end of the entities list so it doesn't get lost:

```lua
  entities[#entities + 1] = brick(brick_x, brick_y)
```

In the previous exercises we also talked about drawing the bricks different colors to indicate their integrity/health left before they will be destroyed.
Rather than review that now, let's dive into state management and we'll wrap coloring up along the way.

## State management

Your average, every-day program has a lot of information it needs to story in memory.
For our game to function with just the basic features, we need to store information about each entity, whether or not the game is currently paused, or if the game is won or lost.
This information is called the *state*.
The state is data that may change during the lifetime of the application.
Think of the state of your lights in your room.
Are they currently in an "on" or "off" state?
The state can cause different effects on the application, like if the "pause" state of the game is "true" then the world will no longer receive updates.

One thing we must think of is how to organize the state of our application.
This is something we take for granted often in the real world;
We don't have to figure out where to store the state of our lights.
It's a piece of information intrinsic to the lamp's design.

So why do we have to care so much about our game's state?
To be fair, our game is small so we probably don't need to.
However, it is crucial to reconcile such things while applications are small because it will be very difficult to go back and fix a bunch of code once the application is big.
The way you should organize the state of your application should accomplish a few things:

- **It should be easy to find and access the necessary data that makes up the state.** For instance, how easy is it for our main file to access the entities and loop over them in the `love.update` function?
- **There should only be one copy of the state.** If we want to access the "paused" state of our game in multiple places that is fine, but we shouldn't have multiple "paused" variables floating around our game. If we had a "paused" variable inside an entity file and another inside the input service updating independently then they could get out of sync and our game would get confused on when it should be paused.
- **The state should only be accessed where it is needed.** If you were accessing or storing the "paused" state inside the ball entity, then if that ball was destroyed then something bad will happen the next time the game checks to see if it is paused.

What files contain the state of our game?
- **entities.lua** - Each entity table is responsible for its own state. For instance, each brick stores the state of its own health. All the entities tables are generated and stored here. The entities are **not** stored in the entities folder. Those are just functions used to generate the entities. The blueprints.
- **input.lua** - This file is responsible for capturing user input, but also storing the state of what keys are currently being pressed.
- **world.lua** - This file is not only the blueprints for the game world, but it also stores the world instance that is generated when the game starts. We made the world instance easily accessible to the rest of the application by writing `return world` at the end. There would be no game if this wasn't easily accessible.

A few pieces of game state we need to add are a boolean of whether the game is over, another for if the stage is cleared, and also a list of colors to use in our game which we'll refer to as our *palette*.
This information wouldn't really fit in any of the places we listed above, and we don't want to add it to **main.lua** because of our first rule that the game state should be easy to access where it is needed.
Besides, that's not the main file's responsibility.
We'll go ahead and just make a new file called **state.lua** and store the overall game state in this file.
This is also a little matter of opinion but the "paused" and button states we'll also move in here since they affect the overall game's state.
This will also make it so that **input.lua**'s only responsibility is to capture and translate the user input, **not** to handle any state whatsoever.

```lua
-- state.lua

-- The state of the game. This way our data is separate from our functionality.

return {
  button_left = false,
  button_right = false,
  game_over = false,
  palette = {
    {1.0, 0.0, 0.0, 1.0},  -- red
    {0.0, 1.0, 0.0, 1.0},  -- green
    {0.4, 0.4, 1.0, 1.0},  -- blue
    {0.9, 1.0, 0.2, 1.0},  -- yellow
    {1.0, 1.0, 1.0, 1.0}   -- white
  },
  paused = false,
  stage_cleared = false
}
```

It's kind of a nice feeling to keep all the state together.
We could even move the entities list into **state.lua** and get rid of **entities.lua**, but this doesn't seem necessary.
Now with this shift in data we need to update **input.lua** and **main.lua** to reference the new file:

```lua
-- input.lua

local state = require('state')

-- Map specific user inputs to game states
local press_functions = {
  left = function()
    state.button_left = true
  end,
  right = function()
    state.button_right = true
  end,
  escape = function()
    love.event.quit()
  end,
  space = function()
    if state.game_over or state.stage_cleared then
      return
    end
    state.paused = not state.paused
  end
}

local release_functions = {
  left = function()
    state.button_left = false
  end,
  right = function()
    state.button_right = false
  end
}


-- This table is the service and will contain some functions
-- that can be accessed from entities or the main.lua.
return {
  -- Look up in the map for actions that correspond to specific key presses
  press = function(pressed_key)
    if press_functions[pressed_key] then
      press_functions[pressed_key]()
    end
  end,
  -- Look up in the map for actions that correspond to specific key releases
  release = function(released_key)
    if release_functions[released_key] then
      release_functions[released_key]()
    end
  end,
  -- Handle window focusing/unfocusing
  toggle_focus = function(focused)
    if not focused then
      state.paused = true
    end
  end
}
```

```lua
-- main.lua

local entities = require('entities')
local input = require('input')
local state = require('state')
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
  if state.game_over or state.paused or state.stage_cleared then
    return
  end

  local index = 1
  while index <= #entities do
    local entity = entities[index]
    if entity.update then entity:update(dt) end
    -- When an entity has no health (brick has been hit enough times
    -- then we remove it from the list of entities. Don't increment
    -- the index number if doing that though because we have shrunk
    -- the table and made all the items shift down by 1 in the index.
    if entity.health and entity.health < 1 then
      table.remove(entities, index)
      entity.fixture:destroy()
    else
      index = index + 1
    end
  end

  world:update(dt)
end
```

Notice the change to `love.update`.
We check if `state.game_over`, `state.paused` or `state.stage_cleared` is true and if so, we return from `love.update` without doing any of the updates as these kind of game states merit freezing the screen.

Next up, update **paddle.lua** to require `state` instead of `input`.
The `entity.update` function now needs to reference `state.button_left` and `state.button_right` to tell if the player has pressed any buttons.
Try updating it on your own.
If you do get stuck, the source code will be in the link at the bottom waiting for you.

Ok, now that we have a state where we stored the colors it is probably a good time to try and update **brick.lua**.
First let's look at those colors stored in **state.lua**:

```lua
  palette = {
    {1.0, 0.0, 0.0, 1.0},  -- red
    {0.0, 1.0, 0.0, 1.0},  -- green
    {0.4, 0.4, 1.0, 1.0},  -- blue
    {0.9, 1.0, 0.2, 1.0},  -- yellow
    {1.0, 1.0, 1.0, 1.0}   -- white
  },
```

The `palette` table is a list of more tables.
Each table in the list represents colors where the first number is the amount of red, 2nd the amount of green, 3rd the amount of blue, and 4th number the amount of opacity.
Setting the last number to `0` means the color is 100% transparent and `1` means it is completely opaque.
All of these values mix together to form a single color.
In the case of the first color, we have the red value set to maximum opaque red with no other colors mixed in.
I would encourage you to go back and edit the colors in this palette after everything is working.
Now, inside **brick.lua** let's update `entity.draw`:

```lua
-- entities/brick.lua

local state = require('state')
local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  -- How many times the brick can be hit before it is destroyed
  entity.health = 2
  -- Used to check during update if this entity is a brick
  -- If no bricks are found then the level was cleared
  entity.type = 'brick'

  entity.draw = function(self)
    -- Draw the brick in a different color depending on health
    love.graphics.setColor(state.palette[self.health] or state.palette[5])
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
    -- Reset graphics drawer back to the default color (white)
    love.graphics.setColor(state.palette[5])
  end

  entity.end_contact = function(self)
    self.health = self.health - 1
  end

  return entity
end
```

Before drawing the brick's polygon, we set the graphics renderer to use one of the colors from `state.palette`.
The color to use depends on what the brick's health is.
So if the brick has 2 health then `state.palette[self.health]` will become `state.palette[2]` which will grab the 2nd color in the list... green.
If the brick's health was 1, then the first color from the palette would be selected... red.
After the colored polygon is drawn, `entity.draw` finishes up by setting the renderer color back to white.
If we didn't do this step, the ball and paddle would get drawn the same color as the bricks.

One last thing we need to do to get the game working is update **pause-text.lua** as it is incorrectly looking for the "pause" state in **input.lua** instead of the new **state.lua** location:

```lua
-- entities/pause-text.lua

local state = require('state')

return function()
  local window_width, window_height = love.window.getMode()

  local entity = {}

  entity.draw = function(self)
    if state.paused then
      love.graphics.print(
        {state.palette[3], 'PAUSED'},
        math.floor(window_width / 2) - 54,
        math.floor(window_height / 2),
        0,
        2,
        2
      )
    end
  end

  return entity
end
```

## Final touches

We need the game to end when the player destroys all the bricks or loses the ball.
Just like the pause-text entity, display some messages based on the game state.

```lua
-- entities/game-over-text.lua

local state = require('state')

return function()
  local window_width, window_height = love.window.getMode()

  local entity = {}

  entity.draw = function(self)
    if state.game_over then
      love.graphics.print(
        {state.palette[5], 'GAME OVER'},
        math.floor(window_width / 2) - 100,
        math.floor(window_height / 2),
        0,
        2,
        2
      )
    end
  end

  return entity
end
```

```lua
-- entities/stage-clear-text.lua

local state = require('state')

return function()
  local window_width, window_height = love.window.getMode()

  local entity = {}

  entity.draw = function(self)
    if state.stage_cleared then
      love.graphics.print(
        {state.palette[4], 'STAGE CLEARED'},
        math.floor(window_width / 2) - 110,
        math.floor(window_height / 2),
        0,
        2,
        2
      )
    end
  end

  return entity
end
```

To trigger the "GAME OVER" text is easy enough.
We need to add a collision callback to **boundary-bottom.lua** to set the game's `state.game_over` to true on any collision:

```lua
-- entities/boundary-bottom.lua

local state = require('state')
local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(800, 10)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.end_contact = function(self)
    state.game_over = true
  end

  return entity
end
```

Don't forget we need to update **entities.lua** to add our two new entities:

```lua
-- entities.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_vertical = require('entities/boundary-vertical')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local game_over_text = require('entities/game-over-text')
local pause_text = require('entities/pause-text')
local stage_clear_text = require('entities/stage-clear-text')
local ball = require('entities/ball')
local brick = require('entities/brick')

local entities = {
  boundary_bottom(400, 606),
  boundary_vertical(-6, 300),
  boundary_vertical(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  game_over_text(),
  pause_text(),
  stage_clear_text(),
  ball(200, 200)
}

local row_width = love.window.getMode() - 20
for number = 0, 38 do
  local brick_x = ((number * 60) % row_width) + 40
  local brick_y = (math.floor((number * 60) / row_width) * 40) + 80
  entities[#entities + 1] = brick(brick_x, brick_y)
end

return entities
```

Ok, test that out and check that the "GAME OVER" text works.
If it does, then let's continue on and add the conditions for how to win the game.
This involves checking through all the entities in `love.update` to make sure we still have bricks.
If we don't have any bricks left, then the player destroyed them all and the stage is cleared.

```lua
-- main.lua
love.update = function(dt)
  if state.game_over or state.paused or state.stage_cleared then
    return
  end

  -- Switch to true if we have bricks left
  local have_bricks = false

  local index = 1
  while index <= #entities do
    local entity = entities[index]
    if entity.type == 'brick' then have_bricks = true end
    if entity.update then entity:update(dt) end
    -- When an entity has no health (brick has been hit enough times
    -- then we remove it from the list of entities. Don't increment
    -- the index number if doing that though because we have shrunk
    -- the table and made all the items shift down by 1 in the index.
    if entity.health and entity.health < 1 then
      table.remove(entities, index)
      entity.fixture:destroy()
    else
      index = index + 1
    end
  end

  -- Flag the stage cleared if there are no more bricks
  state.stage_cleared = not have_bricks
  world:update(dt)
end
```

Every time `love.update` is ran, we set a variable `have_bricks` to false.
If this boolean stays `false` all the way to the bottom of the function then `state.stage_cleared` gets switched to true and the game is won.
Inside the `while` loop, however, we check every entity to see if we find an `entity.type` of `'bricks'` and if so, `have_bricks` gets flipped to `true` to stop the game from being won yet.

So that about does it for completing our checklist.
The game may not be as feature-complete as a true breakout game, but that room for improvement leaves opportunity for you to modify the game to work how you want it to.
It's really up to your imagination.
Try out a few exercises if you can't think up any new features.
If you are having trouble running the game, be sure to check out the source code:

https://github.com/RVAGameJams/learn2love/tree/master/code/breakout-5

## Exercises

- Instead of getting a game over as soon as the ball touches the ground once, add a new property in **state.lua** named `lives` and set it to as many lives as you want the player to have. Make is so the `state.lives` decreases when the ball hits the ground and make the `game_over` not trigger unless `state.lives < 1`.
- Try setting the paddle to different shape to make the game play differently
- Come up with new features to make the game play better and feel more polished
  - Change the ball and paddle colors
  - Add a background color
  - Figure out how to play a sound effect when the ball collides with things
  - Create some kind of power-up entity
