# Breakout (part 1): more entity practice

Let's bring all these concepts together by making another game, a [breakout clone](https://en.wikipedia.org/wiki/Breakout_clone).
The requirements are pretty simple:

- The objective of the game is to destroy all the bricks on the screen
- The player controls a "paddle" entity that hits a ball
- The ball destroys the bricks
- The ball needs to stay within the boundaries of the screen
- If the ball touches the bottom of the screen (below the paddle), the game ends

If you still have the code from the previous sections, feel free to copy the folder naming the new one "breakout" or whatever you want your breakout clone to be called.
At the end of this section there will be a link to all the source code to use as a reference in case you get stuck.
The first modification we'll make is to set a specific window size so no matter which version of LÖVE you're on we're working with the same window proportions and entity dimensions.
To do this, open of **conf.lua** or create it if you don't have it and put in the following code:
```lua
-- LÖVE configuration file

love.conf = function(t)
  t.console = true        -- Enable the debug console for Windows.
  t.window.width = 800    -- Game's screen width (number of pixels)
  t.window.height = 600   -- Game's screen height (number of pixels)
end
```

The *conf*, or *configuration* file lets you define a callback in the `love` table that modifies the game engine's configuration on load.
You can read more about all the interesting things you can do with it [here](https://love2d.org/wiki/Config_Files) but most of its features won't be necessary for our simple game.

The next modification we'll make is deleting the entities from the last section. Let's create new entities to represent the ball and paddle:

```lua
-- entities/ball.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 200, 200, 'dynamic')
entity.body:setMass(32)
entity.body:setLinearVelocity(300, 300)
entity.shape = love.physics.newCircleShape(0, 0, 10)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setRestitution(1)
entity.fixture:setUserData(entity)

return entity
```

```lua
-- entities/paddle.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 200, 560, 'static')
entity.shape = love.physics.newRectangleShape(180, 20)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
```

Before we try and run anything, take a look at a few things we've done differently in defining these entities than we've previously done.
- In **ball.lua** we are defining a circle shape instead of a polygon. This means we have no sides or corner points we can reference when spawning or tracking the position of this object. Circles have to be tracked from their center point and their boundaries by their radius.
- In this file we're using [`Body:setLinearVelocity`](https://love2d.org/wiki/Body:setLinearVelocity) to apply movement on the ball in a specific direction when the entity spawns.
- In **paddle.lua** we are defining a polygon shape, but instead of specifying each point we are using the [`love.physics.newRectangleShape`](https://love2d.org/wiki/love.physics.newRectangleShape) function to define the shape. This will still generate a polygon as before, but instead of specifying each point in the shape we are giving a height and width and allowing it to figure out the shape we want based on those two parameters. Think of it as a shortcut version of the [`love.physics.newPolygonShape`](https://love2d.org/wiki/love.physics.newPolygonShape) function.
- The paddle has a static body while the ball is dynamic. What this entails is the ball will be affected by the paddle but the paddle won't be affected by the ball. Even though the paddle is static, it can be manually repositioned as we'll do later with buttons.
- In both entity files, we are passing the full entity table as the fixture user data instead of just a string name like before. This will allow us to easily access the entire entity inside the collision callback as we'll see later. You'll want to go back and compare that code from the [Collision Callbacks](02-10-collision-callbacks.md) section to these entities, but don't worry if it doesn't make complete sense yet.


Now we need to modify **main.lua** to load up our new entities:

```lua
-- main.lua

local paddle = require('entities/paddle')
local ball = require('entities/ball')
local world = require('world')

-- Boolean to keep track of whether our game is paused or not
local paused = false

local key_map = {
  escape = function()
    love.event.quit()
  end,
  space = function()
    paused = not paused
  end
}

love.draw = function()
  local ball_x, ball_y = ball.body:getWorldCenter()
  love.graphics.circle('fill', ball_x, ball_y, ball.shape:getRadius())
  love.graphics.polygon(
    'line',
    paddle.body:getWorldPoints(paddle.shape:getPoints())
  )
end

love.focus = function(focused)
  if not focused then
    paused = true
  end
end

love.keypressed = function(pressed_key)
  -- Check in the key map if there is a function
  -- that matches this pressed key's name
  if key_map[pressed_key] then
    key_map[pressed_key]()
  end
end

love.update = function(dt)
  if not paused then
    world:update(dt)
  end
end
```

Take note of a few things we're doing here:
- For drawing the circle, we need to invoke [`love.graphics.circle`](https://love2d.org/wiki/love.graphics.circle).
- For drawing the paddle, we still invoke [`love.graphics.polygon`](https://love2d.org/wiki/love.graphics.polygon) as the rectangle is still a polygon shape.

Now let's remove any print statements in **world.lua** just to clean things up.
We'll leave the callbacks there since we may use them later but we'll leave them empty for now.
We'll also set the gravity to `0` because we want the ball to bounce freely like in the real Breakout game and not lose any momentum.

```lua
-- world.lua

-- Called at the beginning of any contact in the world. Parameters:
-- {fixture} fixture_a - first fixture object in the collision.
-- {fixture} fixture_b - second fixture object in the collision.
-- {contact} contact - world object created on and at the point of
--   contact. When sliding along an object, there may be several.
--   See further: https://love2d.org/wiki/Contact
local begin_contact_callback = function(fixture_a, fixture_b, contact)
end

local end_contact_callback = function(fixture_a, fixture_b, contact)
end

local pre_solve_callback = function(fixture_a, fixture_b, contact)
end

local post_solve_callback = function(fixture_a, fixture_b, contact)
end

local world = love.physics.newWorld(0, 0)

world:setCallbacks(
  begin_contact_callback,
  end_contact_callback,
  pre_solve_callback,
  post_solve_callback
)

return world
```

What happens if you run the game now?
The ball flies right off the screen without consequence.
There are a couple different ways of preventing the ball from moving off screen.
Possibly the most simple approach is to put up some walls.
Can you guess what the code to those walls may look like?
Yup, they will be entities similar to the paddle except that they just sit at the edges of the screen.
Let's create some entities for that purpose:

```lua
-- entities/boundary-top.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 400, 5, 'static')
entity.shape = love.physics.newRectangleShape(800, 10)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
```

Take a look at these numbers for a minute.
For the location of the body we specified 400 pixels.
So starting from the top left corner and moving right along the x-axis we've specified the very center of an 800-pixel-wide window.
The reason we've done this is because we want the top and bottom wall boundaries to stretch 800 pixels wide, the entire length of the window, and when calling `newBody` and spawning an entity's body it will spawn the center point of the entity shape at that location.
Not all entity shapes are square, or even polygonal, so it is simplest for the game engine to center the shape on the body's spawn point rather than using another point of reference on the shape, like the top left corner of the shape (not all shapes have corners).
In fact, the ball and paddle spawned centered on the location we gave for their bodies.

So we made the walls 800 pixels wide and just to give it a little visibility we made them 10 pixels tall.
You would think we'd spawn the wall at the very top of the screen (0 pixels on the y-axis,) but since our walls will be centered to the spawn points we should move down half the height of the wall if we want it all to appear on screen.

Now the boundary on the bottom will have the same dimensions, but it will be spawned at the bottom of the screen (600 pixels) minus half the height of the wall (5 pixels):

```lua
-- entities/boundary-bottom.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 400, 595, 'static')
entity.shape = love.physics.newRectangleShape(800, 10)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
```

The left and right boundaries will follow the same pattern except they will be the height of the screen instead of the width of the screen:

```lua
-- entities/boundary-left.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 5, 300, 'static')
entity.shape = love.physics.newRectangleShape(10, 600)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
```

```lua
-- entities/boundary-right.lua

local world = require('world')

local entity = {}
entity.body = love.physics.newBody(world, 795, 300, 'static')
entity.shape = love.physics.newRectangleShape(10, 600)
entity.fixture = love.physics.newFixture(entity.body, entity.shape)
entity.fixture:setUserData(entity)

return entity
```

We won't see these entities until we *require* them and draw them on the screen.
So modify **main.lua** to require and draw them the same way we do the ball and paddle:

```lua
-- main.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local world = require('world')

-- Boolean to keep track of whether our game is paused or not
local paused = false

local key_map = {
  escape = function()
    love.event.quit()
  end,
  space = function()
    paused = not paused
  end
}

love.draw = function()
  love.graphics.polygon('line', boundary_bottom.body:getWorldPoints(boundary_bottom.shape:getPoints()))
  love.graphics.polygon('line', boundary_left.body:getWorldPoints(boundary_left.shape:getPoints()))
  love.graphics.polygon('line', boundary_right.body:getWorldPoints(boundary_right.shape:getPoints()))
  love.graphics.polygon('line', boundary_top.body:getWorldPoints(boundary_top.shape:getPoints()))
  local ball_x, ball_y = ball.body:getWorldCenter()
  love.graphics.circle('fill', ball_x, ball_y, ball.shape:getRadius())
  love.graphics.polygon('line', paddle.body:getWorldPoints(paddle.shape:getPoints()))
end

love.focus = function(focused)
  if not focused then
    paused = true
  end
end

love.keypressed = function(pressed_key)
  -- Check in the key map if there is a function
  -- that matches this pressed key's name
  if key_map[pressed_key] then
    key_map[pressed_key]()
  end
end

love.update = function(dt)
  if not paused then
    world:update(dt)
  end
end
```

When you run the game, you should see pretty much the same thing as this:
![](code/breakout-1/screenshot.png)


If you missed anything or are having issues, here's a copy of the completed source code for this section:
https://github.com/RVAGameJams/learn2love/tree/master/code/breakout-1

Looking back at our list of minimal requirements we've already completed one thing on our list:

> The ball needs to stay within the boundaries of the screen

There's still quite a bit more work to complete this list so let's continue in the next section.

## Exercises

- Maybe it would be better if the boundary lines were even with the screen so we couldn't see them. Modify the boundary positions so it looks like the ball is bouncing off the edge of the screen.
- What happens if we require the boundaries but don't draw them in `love.draw`? Does the game still work?
