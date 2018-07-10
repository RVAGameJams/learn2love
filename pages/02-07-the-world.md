# The world

A world is a physical space where objects can be created (spawned) and interact.
Shapes and other things drawn on the screen are not implicitly part of a world and won't interact with each other unless they are.
Multiple worlds can co-exist, but the objects in each world won't interact.
Going forward I will refer to these objects as *entities*.

## Entities

Entities are made up of different components that allow them to interact.
These are the 3 fundamental physical components:

- **shape** - some sort of polygon to give our entity a physical shape that determines the boundaries of the entity
- **body** - holds physical properties such as mass
- **fixture** - attaches a shape to a body

Let's write a new main.lua from scratch and see how these are all wired up.
First, a world needs to be defined:

```lua
local world = love.physics.newWorld(0, 100)
```

`love.physics.newWorld` returns a table, an instance of a world.
The table holds functions that allow us to apply attributes to the world.
It also holds all the entities in our world, which is currently none on initialization.
According to the documentation on [`love.physics.newWorld`](https://love2d.org/wiki/love.physics.newWorld), our 1st and 2nd parameters set the X and Y gravity on our world.
We don't want any sideways gravity, but we'll go ahead and set an arbitrary number for the vertical gravity.


While focusing on the world, we should allow the world to know whenever we get an update to the delta time.
A world without time would be frozen;
By letting the world know about the passage of time, it can know whether it needs to make an entity fall another meter or two meters…

```lua
love.update = function(dt)
  world.update(world, dt)
end
```

Actually, let's do one trick here.
When calling a function in Lua and the first parameter of the function is the table the function is stored in, you can use a shortcut notation:

```lua
love.update = function(dt)
  world:update(dt)
end
```

Aside from being easier to write, you'll see this way of invoking functions used all over the place in the LÖVE documentation.


Finally, we'll add an entity to the game in 4 steps:
1. Create a table to store all the pieces of our entity together. Not entirely necessary but we'll learn later why this step makes things easier.
2. Create a body. This will be added to the entity table and the world.
3. Create the shape we want the entity to have.
4. Create a fixture to attach the body and shape together.

```lua
-- Triangle is the name of our first entity
local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
-- Give the triangle some weight
triangle.body:setMass(32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)

love.draw = function()
  love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
end
```

After creating the `body` table inside `triangle`, we called `triangle.body.setMass` to set a weight property on our triangle so it can fall.
Notice we wrote `triangle.body:setMass(32)`, which is the same as saying `triangle.body.setMass(triangle.body, 32)` but shorter and more conventional to the way the LÖVE documentation writes.

What's going on inside `love.draw` looks pretty crazy so let's break the long line up.

```lua
  love.graphics.polygon(
    'line',
    triangle.body:getWorldPoints(triangle.shape:getPoints())
  )
```

We've used `love.graphics.polygon` previously so its purpose should already be familiar.
The first parameter `'line'` is telling it that we want an outline of a shape drawn.
The second parameter is a table containing the points that need to be outlined.
To get the triangle's points we call `triangle.shape:getPoints()`, but this only returns the shape of the triangle and the relative position of the points.
By then calling `triangle.body:getWorldPoints(triangle.shape:getPoints())` we convert those relative points to their absolute position as that's what the polygon drawing function needs to know so it can draw the triangle exactly where it is supposed to be on the screen.


Let's put it all together and add one more entity into the mix so the two can interact:

```lua
local world = love.physics.newWorld(0, 100)

-- Triangle is the name of our first entity
local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
-- Give the triangle some weight
triangle.body.setMass(triangle.body, 32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)

-- Another entity
local bar = {}
bar.body = love.physics.newBody(world, 200, 450, 'static')
bar.shape = love.physics.newPolygonShape(0, 0, 0, 20, 400, 20, 400, 0)
bar.fixture = love.physics.newFixture(bar.body, bar.shape)


local key_map = {
  escape = function()
    love.event.quit()
  end
}

love.draw = function()
  love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
  love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
end


love.keypressed = function(pressed_key)
  -- Check in the key map if there is a function
  -- that matches this pressed key's name
  if key_map[pressed_key] then
    key_map[pressed_key]()
  end
end

love.update = function(dt)
  world:update(dt)
end
```

## Exercises

- Try changing the mass and gravity and see what happens.
