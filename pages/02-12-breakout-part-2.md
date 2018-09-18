# Breakout (part 2): entity management

## Review

In the previous section we made a checklist of requirements and accomplished one of them:

- The objective of the game is to destroy all the bricks on the screen
- The player controls a "paddle" entity that hits a ball
- The ball destroys the bricks
- **✔** The ball needs to stay within the boundaries of the screen
- If the ball touches the bottom of the screen, the game ends

In the previous exercise, the goal was to move the boundaries so they were just off screen.
This gives the effect that the ball is bouncing off the edges of the game window.

```lua
-- entities/boundary-bottom.lua
entity.body = love.physics.newBody(world, 400, 606, 'static')
```
```lua
-- entities/boundary-left.lua
entity.body = love.physics.newBody(world, -6, 300, 'static')
```
```lua
-- entities/boundary-right.lua
entity.body = love.physics.newBody(world, 806, 300, 'static')
```
```lua
-- entities/boundary-top.lua
entity.body = love.physics.newBody(world, 400, -6, 'static')
```

Here they have been moved 6 pixels off screen just to use even numbers and make calculation easier.
Previously we also raised the question of whether or not the boundaries would work if we still `require`'d them in **main.lua** but didn't draw them in `love.draw`.
The answer is they still work but we don't see them.
Since they are off screen, that doesn't matter anyway and we can save our program from doing extra work:

```lua
-- main.lua
love.draw = function()
  local ball_x, ball_y = ball.body:getWorldCenter()
  love.graphics.circle('fill', ball_x, ball_y, ball.shape:getRadius())
  love.graphics.polygon('line', paddle.body:getWorldPoints(paddle.shape:getPoints()))
end
```

## Entity list

Let's think about the problem of brick entities for a minute.
We could create an entity file for each brick, but they are more or less the same except that they spawn in different spots.
Imagine making 50 different entity files and then inside `love.draw` making 50 lines to draw each brick and so on.
What we can instead do is make an entity file for 1 brick then make a list with 50 copies of it (or however many brick copies we end up fitting on the screen).
We can then loop over this list to draw the bricks.

Let's first create the brick entity file:

```lua
-- entities/brick.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  return entity
end
```

Instead of returning an entity in this file, we returned a function that takes an x-position and y-position as parameters.
When the function gets invoked wherever it is required, it will generate a new entity with those coordinates for its spawn point.
Here's how we can use it:

```lua
-- main.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local brick = require('entities/brick')

local entities = {
  brick(100, 100),
  brick(200, 100),
  brick(300, 100)
}


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
  love.graphics.polygon('line', paddle.body:getWorldPoints(paddle.shape:getPoints()))

  for _, entity in ipairs(entities) do
    love.graphics.polygon('fill', entity.body:getWorldPoints(entity.shape:getPoints()))
  end
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

We made an entity table with a list of brick entities in it, then in `love.draw` we made a for loop to draw each entity in the list.
Before we change anything else try running the game and taking a look that the bricks appear and that everything works.

## Rule of single responsibility

Our goal for the rest of this section will be to simplify entity management.
One strategy we'll have for doing this is to think of each file in our game as having a single responsibility.
A good sign that we're doing this is **main.lua** is very small and easy to scan over with the eyes and digest.

So what is the responsibility of **main.lua**?

- Create the callback functions necessary to run the game.

Here's some things it is doing that don't fit that responsibility:

- Load and store all the entities
- Figure out how to draw each type of entity in `love.draw`
- Store a map of keypresses

Imagine our game is an organization and each file is a role in the company.
Our main file is like the secretary that knows how to handle requests from outsiders.
If somebody called asking the secretary about building-maintenance issues, the secretary wouldn't grab plumbing tools and take care of the problem but rather dispatch the person whose responsibility is that exact kind of problem.
As the owner of this organization we should know everyone's roles so it's easy to know where each responsibility lies.
It will make is easier for us to grow the company to the size we desire.

One easy improvement is to not write out all the instructions for drawing each entity within the main file, but rather let each entity file be responsible for every feature of that entity, including how to draw that entity.
We may want to get fancy later and draw bricks in different colors, for instance.
That could get complicated and we don't want the main file to retain a bunch of code about brick colors and such.

Modifying the entities is as easy as creating `draw` functions in the entity tables:

```lua
-- entities/brick.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
  end

  return entity
end
```

```lua
-- entities/paddle.lua

local world = require('world')

return function(pos_x, pos_y)
  local entity = {}
  entity.body = love.physics.newBody(world, pos_x, pos_y, 'static')
  entity.shape = love.physics.newRectangleShape(180, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end

  return entity
end
```

```lua
-- entities/ball.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'dynamic')
  entity.body:setMass(32)
  entity.body:setLinearVelocity(300, 300)
  entity.shape = love.physics.newCircleShape(0, 0, 10)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setRestitution(1)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    local self_x, self_y = self.body:getWorldCenter()
    love.graphics.circle('fill', self_x, self_y, self.shape:getRadius())
  end

  return entity
end
```

Go ahead and make *all* the entities return a function with `x_pos` and `y_pos` parameters and we'll just add everything to the entity list like the bricks.
Don't forget to change out the numbers in the `love.physics.newBody(world, 200, 200, 'dynamic')` with the arguments being passed in by the function: `love.physics.newBody(world, x_pos, y_pos, 'dynamic')`.
For the boundaries entity files there is no need for `entity.draw` functions, but still make them return functions with the two parameters.
Now update the `entities` list in **main.lua** to include all the entities:

```lua
-- main.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local brick = require('entities/brick')

local entities = {
  boundary_bottom(400, 606),
  boundary_left(-6, 300),
  boundary_right(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  ball(200, 200),
  brick(100, 100),
  brick(200, 100),
  brick(300, 100)
}


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
  for _, entity in ipairs(entities) do
    if entity.draw then entity:draw() end
  end
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

Take a look at our `love.draw` function.
It is much simpler now that it no longer needs to know how to draw each entity.
It just asks the entity if it knows how to draw itself and if it does it tells it to do so.
Remember that invoking `entity:draw()` is just shorthand for writing `entity.draw(entity)` because of the `:`.

Ok, but putting the entities in a list didn't clean up this file.
Now this file is responsible for knowing where to spawn the entities and having them in a list just makes this file bigger.
Well you see the reason we put them in a list is because we want to make a new game file called **entities.lua** that will be responsible for loading, spawning, and storing all the entities when the game starts up.
Create a new file then cut all the entity `require` statements and the entity list and paste it in the new file:

```lua
-- entities.lua

local boundary_bottom = require('entities/boundary-bottom')
local boundary_left = require('entities/boundary-left')
local boundary_right = require('entities/boundary-right')
local boundary_top = require('entities/boundary-top')
local paddle = require('entities/paddle')
local ball = require('entities/ball')
local brick = require('entities/brick')

return {
  boundary_bottom(400, 606),
  boundary_left(-6, 300),
  boundary_right(806, 300),
  boundary_top(400, -6),
  paddle(300, 500),
  ball(200, 200),
  brick(100, 100),
  brick(200, 100),
  brick(300, 100)
}
```

And now the top of our main file only needs to load the entities file and it will have the list to use in `love.draw` and elsewhere as needed:

```lua
-- main.lua

local entities = require('entities')
local world = require('world')
```

When you run the game, you should be seeing something similar to this:
![](https://raw.githubusercontent.com/RVAGameJams/learn2love/master/code/breakout-2/screenshot.png)

If you missed anything or are having issues, here's a copy of the completed source code for this section:
https://github.com/RVAGameJams/learn2love/tree/master/code/breakout-2

And that's about it for entity management.
We'll figure out how to handle keypresses for the paddle and everything else in the next section.
We'll finish the cleanup in our main file while we're at it.

## Exercises

- Now that our entities have passed off knowledge on where they spawn over to **entities.lua**, our left and right boundaries are identical files. Replace **boundary-left.lua** and **boundary-right.lua** with a single **boundary-vertical.lua** file and spawn two copies of that in **entities.lua**.
