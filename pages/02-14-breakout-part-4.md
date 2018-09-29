# Breakout (part 4): physics

## Review

In the previous exercises we discussed issues with the ball slowing down due to friction.
With a bit of browsing through the `love.physics` documentation you might have seen that friction is a property of the fixture and can be set to 0 in [`fixture:setFriction`](https://love2d.org/wiki/Fixture:setFriction).

How about creating the pause screen text?
Were you able to do it without touching **main.lua**?
Take a look at this entity that was created just for the single responsibility of displaying pause text:

```lua
-- entities/pause-text.lua

local input = require('input')

return function()
  local window_width, window_height = love.window.getMode()

  local entity = {}

  entity.draw = function(self)
    if input.paused then
      love.graphics.print(
        {{ 0.2, 1, 0.2, 1 }, 'PAUSED'},
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

That's right.
Even the pause screen is an entity.
The first natural place to think to put it would be the main file but entity files are perfect because we can create as many as we need for each task and add it to **entities.lua** where it will be handled by the game loop.
For centering the text the [`love.window.getMode`](https://love2d.org/wiki/love.window.getMode) function is used to get the full window dimensions then those numbers are divided in half.
This saves us from manually coding in numbers that would need to be readjusted if the window size changed.
Additionally, `math.floor` was used for good measure to make sure we are returning a whole number.
It is recommended to round decimals off from numbers when passing coordinates to the drawing functions.
Otherwise it may attempt to draw that object between pixels on the screen and cause some blurriness.

## Physics updates

An issue we had with the game physics since we got the paddle moving is that the ball doesn't always ricochet off the paddle as you would expect.
This is because we made the paddle static so the ball doesn't push it around, but this has the effect of the paddle not interacting with the ball correctly.
This is where `kinematic` bodies come in.
Kinematic bodies, like static bodies aren't affected by dynamic bodies.
Kinematic bodies, unlike static bodies, can affect dynamic bodies.

We're going to make 3 changes to **paddle.lua**:
- Move the boundary dimensions, paddle dimensions, and paddle speed to easily-referenced variables at the top of the file.
- Change the body type to kinematic
- Overhaul the update code to move the body with linear velocity rather than manually setting a new location on the screen with every update

```lua
-- entities/paddle.lua

local input = require('input')
local world = require('world')

return function(pos_x, pos_y)
  local window_width = love.window.getMode()
  -- Variables to make these easier to adjust
  local entity_width = 120
  local entity_height = 20
  local entity_speed = 600
    -- The limit of how far left/right the entity can move towards
    -- the edges (with a little bit of padding thrown on).
  local left_boundary = (entity_width / 2) + 2
  local right_boundary = window_width - (entity_width / 2) - 2

  local entity = {}
  entity.body = love.physics.newBody(world, pos_x, pos_y, 'kinematic')
  entity.shape = love.physics.newRectangleShape(entity_width, entity_height)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end

  entity.update = function(self)
    -- Don't move if both keys are pressed. Just return
    -- instead of going through the rest of the function.
    if input.left and input.right then
      return
    end
    local self_x = self.body:getX()
    if input.left and self_x > left_boundary then
      self.body:setLinearVelocity(-entity_speed, 0)
    elseif input.right and self_x < right_boundary then
      self.body:setLinearVelocity(entity_speed, 0)
    else
      self.body:setLinearVelocity(0, 0)
    end
  end

  return entity
end
```

I took the liberty of adjusting the paddle size, but with our nice boundary-size calculations in place the paddle dimensions can easily be adjusted and the boundary size will take those changes into account.
Let's drill into the `entity.update` function.

Once the inputs are checked to be true or false the current x-position of the paddle is checked to see if it goes out of the boundaries (calculated near the top).
Notice that the calculations for the boundary locations are done at the top instead of in `entity.update`.
This means those calculations aren't done on every update since they don't need to be.

A bit more complex than the paddle are the calculations for the ball:

```lua
-- entities/ball.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity_max_speed = 880

  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'dynamic')
  entity.body:setLinearVelocity(300, 300)
  entity.shape = love.physics.newCircleShape(0, 0, 10)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setFriction(0)
  entity.fixture:setRestitution(1)
  entity.fixture:setUserData(entity)

  entity.draw = function(self)
    local self_x, self_y = self.body:getWorldCenter()
    love.graphics.circle('fill', self_x, self_y, self.shape:getRadius())
  end

  entity.update = function(self)
    local vel_x, vel_y = self.body:getLinearVelocity()
    local speed = math.abs(vel_x) + math.abs(vel_y)

    local vel_x_is_critical = math.abs(vel_x) > entity_max_speed * 2
    local vel_y_is_critical = math.abs(vel_y) > entity_max_speed * 2
    -- Ball is bouncing too fast to reasonably hit.
    -- Cut down its speed by 75% if so.
    if vel_x_is_critical or vel_y_is_critical then
      self.body:setLinearVelocity(vel_x * .75, vel_y * .75)
    end
    if speed > entity_max_speed then
      self.body:setLinearDamping(0.1)
    else
      self.body:setLinearDamping(0)
    end
  end

  return entity
end
```

In the first chunk we get the current x and y velocity, which tells us the x and y direction of the ball:
```lua
    local vel_x, vel_y = self.body:getLinearVelocity()
    local speed = math.abs(vel_x) + math.abs(vel_y)
```

An example `vel_x`/`vel_y` may be `212`/`-300`, which means the ball is moving up and towards the right.
The speed is calculated by turning both these numbers into absolute numbers and adding them together (so `512` in the example).

In the next chunk there is a safety check to make sure the ball didn't ricochet with so much force that it's going too fast to possibly hit.
If either boolean variable is true then the linear velocity is multiplied by a fraction of itself to quickly slow it down:

```lua
    local vel_x_is_critical = math.abs(vel_x) > entity_max_speed * 2
    local vel_y_is_critical = math.abs(vel_y) > entity_max_speed * 2
    -- Ball is bouncing too fast to reasonably hit.
    -- Cut down its speed by 75% if so.
    if vel_x_is_critical or vel_y_is_critical then
      self.body:setLinearVelocity(vel_x * .75, vel_y * .75)
    end
```

Now there is just a check to ease the ball back down to a comfortable maximum speed.
If the ball's speed is greater than `entity_max_speed` a damping is applied which will reduce the balls speed below 880.
Once the target speed is reached then the damping switches back to 0:

```lua
    if speed > entity_max_speed then
      self.body:setLinearDamping(0.1)
    else
      self.body:setLinearDamping(0)
    end
```

Try out the changes to feel it in action compared to the previous physics and hopefully you will find that it's an improvement.
It's not a perfect replica of the arcade game, but playing around with these tricks and features you can get it pretty darn close to something satisfactory.
Another thing to try out if within the ball's `entity.update`, add a line under the speed variable that reads `print(speed)` and watch the number increase and decrease again as the damping kicks in.
Pretty neat that most of the heavy calculations are handled by the physics engine for us.

## Collision

There are 4 changes involved to make the bricks destructible:

- Update **world.lua** to check for collision functionality for the entities when they collide
- Update **brick.lua** to include a collision callback
- Add a new attribute on the brick entity to let us know its current condition and if it needs to be destroyed. We'll just call it `entity.health`.
- Update **main.lua** to remove/destroy any entities that have no more health

First the world:

```lua
-- world.lua

-- Called at the end of any contact in the world. Parameters:
-- {fixture} fixture_a - first fixture object in the collision.
-- {fixture} fixture_b - second fixture object in the collision.
-- {contact} contact - world object created on and at the point of contact
--   See further: https://love2d.org/wiki/Contact
local end_contact_callback = function(fixture_a, fixture_b, contact)
  local entity_a = fixture_a:getUserData()
  local entity_b = fixture_b:getUserData()
  if entity_a.end_contact then entity_a:end_contact() end
  if entity_b.end_contact then entity_b:end_contact() end
end

local world = love.physics.newWorld(0, 0)

world:setCallbacks(nil, end_contact_callback, nil, nil)

return world
```

The only callback we'll be using for this tutorial is the end-contact callback, so for `world:setCallbacks` we are going to returning `nil` for the rest to keep our code fast and clean.
Take a look at what is happening inside `end_contact_callback`.
Remember inside each entity when we invoked `entity.fixture:setUserData(entity)`?
With the entity attached to each fixture, we can get access to those entities by invoking `fixture:getUserData` in the callback above.
Once we have access to each entity, we check to see if the entity has any `end_contact` functions, code specific to that entity that needs to run when ending the collision.

Now we can go to **brick.lua** and define that functionality:

```lua
-- entities/brick.lua

local world = require('world')

return function(x_pos, y_pos)
  local entity = {}
  entity.body = love.physics.newBody(world, x_pos, y_pos, 'static')
  entity.shape = love.physics.newRectangleShape(50, 20)
  entity.fixture = love.physics.newFixture(entity.body, entity.shape)
  entity.fixture:setUserData(entity)

  -- How many times the brick can be hit before it is destroyed
  entity.health = 2

  entity.draw = function(self)
    love.graphics.polygon('fill', self.body:getWorldPoints(self.shape:getPoints()))
  end

  entity.end_contact = function(self)
    self.health = self.health - 1
  end

  return entity
end
```

Notice the two new values in the table, `entity.health` and `entity.end_contact`.
Inside `end_contact` we are subtracting 1 health when the collision ends.
Health could start at any number and that means the ball will need to collide with the brick that many times before the health reaches 0.
Lastly, we need to go into **main.lua** and adjust `love.update` so it does something when it sees an entity with 0 health:

```lua
-- main.lua
love.update = function(dt)
  if not input.paused then
    local index = 1
    while index <= #entities do
      local entity = entities[index]
      if entity.update then entity:update(dt) end
      -- When an entity has no health (brick has been hit enough times
      -- then we remove it from the list of entities. Don't increment
      -- the index number if doing that though because we have shrunk
      -- the table and made all the items shift down by 1 in the index.
      if entity.health == 0 then
        table.remove(entities, index)
        entity.fixture:destroy()
      else
        index = index + 1
      end
    end
    world:update(dt)
  end
end
```

The entity is removed from `entities` as well as having its fixture destroyed from the world.
This will only happen to bricks with 0 health.
It won't happen to entities where we didn't define health because `nil` is not the same thing as `0`.
Notice that a `while` loop was used here.
This is because we may remove entities from the list we are looping over and this would throw off the index count for a regular `for` loop.

If you missed anything or are having issues, here's a copy of the completed source code for this section:
https://github.com/RVAGameJams/learn2love/tree/master/code/breakout-4

In the next section we'll review the checklist and see what is left to cover.

## Exercises

- It would be great if the colors of the bricks changed depending how much health the brick has. Update the brick's `entity.draw` function with some colors. Hint: we covered colors in [2.4 - Game loop](02-04-game-loop.md).
- Add more bricks to the screen. What's the easiest way to do that?
