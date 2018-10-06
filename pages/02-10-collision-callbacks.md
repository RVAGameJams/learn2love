# Collision callbacks

When writing a game such as a platformer you may want something special to happen when two objects collide.
If it's a powerup, for instance, you may want the powerup to *despawn* (be removed from the world) if a player touches it and then give the player a special ability (think Mario and mushrooms).
If a player and an enemy bump into each other, you may want the player's health to decrement.
The *world* table has a method that allows you to program in functionality like this for when two entities collide.
It does this by allowing you to create callbacks as we learned before, but these callbacks are triggered before, during, or after collision.
Take a look at [World:setCallbacks](https://love2d.org/wiki/World:setCallbacks).

If you look at the parameters for `World:setCallbacks`, you see it can take four functions.
The description of these parameters helps explain when the functions will be called.
`beginContact` and `endContact` should be self explanatory; They happen at the point where contact begins and ends in a collision, but `preSolve` and `postSolve` may not be as obvious.
Nonetheless, let's edit the previously-created **world.lua** file and write some collision callbacks to test this functionality.

```lua
-- world.lua

local begin_contact_counter = 0
local end_contact_counter = 0
local pre_solve_counter = 0
local post_solve_counter = 0

local begin_contact_callback = function()
  begin_contact_counter = begin_contact_counter + 1
  print('beginContact called ' .. begin_contact_counter .. ' times')
end

local end_contact_callback = function()
  end_contact_counter = end_contact_counter + 1
  print('endContact called ' .. end_contact_counter .. ' times')
end

local pre_solve_callback = function()
  pre_solve_counter = pre_solve_counter + 1
  print('preSolve called ' .. pre_solve_counter .. ' times')
end

local post_solve_callback = function()
  post_solve_counter = post_solve_counter + 1
  print('postSolve called ' .. post_solve_counter .. ' times')
end

local world = love.physics.newWorld(0, 9.81 * 128)

world:setCallbacks(
  begin_contact_callback,
  end_contact_callback,
  pre_solve_callback,
  post_solve_callback
)

return world
```

Try it out.
Every time one of the callbacks is invoked, it will increment its own number by 1 then print a message to the console telling you how many times it has been invoked.
It's clear right away that `pre_solve_callback` and `post_solve_callback` get invoked many more times than `begin_contact_callback` and `end_contact_callback` in this situation.

Unless you've edited the behavior of the triangle entity, it will bounce a bit (because of the triangle's restitution).
Once it bounces and neither corner or side is touching the floor underneath, the contact ends.
This process is repeated every time it bounces.
Once the triangle settles down it will slide a bit, maybe even a lot... like an air hockey puck.
This is because our triangle and bar have no friction between them to prevent that.
Anyways, this is good because it allows us to see that while the triangle is sliding it is still making contact.
While the triangle is sliding and still making contact, the `pre_solve_callback` and `post_solve_callback` will continue to get called with every frame of movement.

Pretend our triangle was a futuristic race car moving across a neon strip of road that recharged the vehicle.
You could start increasing the race car's power meter inside `begin_contact_callback` as the car makes contact with that section of road and then stop increasing power when `end_contact_callback` is invoked.
This could work pretty well, but then the player may try parking for a moment on the power strip and continue to gain health as long as they want.
So another approach could be to only increase the power meter as the player continues to move *and* make contact with the road, increasing health by 1 point every time the `post_solve_callback` function is invoked.

You don't necessarily need to use all of these callbacks, so you could just pass in an empty function or `nil` to `World:setCallbacks` for the arguments you don't need.

Without knowing what entities are colliding, the collision callbacks aren't very useful.
Luckily, our callbacks have parameters of their own that we can access.
Let's modify the code again and check out those parameters:

```lua
-- world.lua

-- Called at the beginning of any contact in the world. Parameters:
-- {fixture} fixture_a - first fixture object in the collision.
-- {fixture} fixture_b - second fixture object in the collision.
-- {contact} contact - world object created on and at the point of
--   contact. When sliding along an object, there may be several.
--   See further: https://love2d.org/wiki/Contact
local begin_contact_callback = function(fixture_a, fixture_b, contact)
  print(fixture_a, fixture_b, contact, 'beginning contact')
end

local end_contact_callback = function(fixture_a, fixture_b, contact)
  print(fixture_a, fixture_b, contact, 'ending contact')
end

local pre_solve_callback = function(fixture_a, fixture_b, contact)
  print(fixture_a, fixture_b, contact, 'about to resolve a contact')
end

local post_solve_callback = function(fixture_a, fixture_b, contact)
  print(fixture_a, fixture_b, contact, 'just resolved a contact')
end

local world = love.physics.newWorld(0, 9.81 * 128)

world:setCallbacks(
  begin_contact_callback,
  end_contact_callback,
  pre_solve_callback,
  post_solve_callback
)

return world
```

This should print out some information in the console similar to:

```
Fixture: 0x561020bf8570 Fixture: 0x561020bf7350 Contact: 0x561020bf7480 beginning collision
Fixture: 0x561020bf8570 Fixture: 0x561020bf7350 Contact: 0x561020bf7480 about to resolve a contact
Fixture: 0x561020bf8570 Fixture: 0x561020bf7350 Contact: 0x561020bf7480 just resolved a contact
Fixture: 0x561020bf8570 Fixture: 0x561020bf7350 Contact: 0x561020bf7480 ending collision
```

`Fixture: 0x561020bf8570` is a text representation of our first entity's fixture.
The `0x56...` is the memory address of the fixture to help identify it, although this information still doesn't tell us which entity this fixture belongs to.
We also printed out a [contact table](https://love2d.org/wiki/Contact), which contains a set of functions just like the entities.
This instance of a contact provides information such as where the contact happened and how much velocity was involved.

Let's work on modifying the print statements so we can collect more useful information on these collisions.
There is a pair of functions on every fixture that let's you set any arbitrary data you want on that fixture and another function to get that data back out the fixture.
These functions are called [`Fixture:setUserData`](https://love2d.org/wiki/Fixture:setUserData) and [`Fixture:getUserData`](https://love2d.org/wiki/Fixture:getUserData).
These functions can be used to set a name or ID on the fixture to help us identify what entity it belongs to.
We can accomplish this by first modifying our entity files and passing some strings to `Fixture:setUserData`:

```lua
-- entities/bar.lua

local world = require('world')

local bar = {}
bar.body = love.physics.newBody(world, 200, 450, 'static')
bar.shape = love.physics.newPolygonShape(0, 0, 0, 20, 400, 20, 400, 0)
bar.fixture = love.physics.newFixture(bar.body, bar.shape)
bar.fixture:setUserData('bar')

return bar
```

```lua
-- entities/triangle.lua

local world = require('world')

local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
triangle.body.setMass(triangle.body, 32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)
triangle.fixture:setRestitution(0.75)
triangle.fixture:setUserData('triangle')

return triangle
```

Now go back to the world's collision callbacks and you can easily extract this information back out of the fixtures:

```lua
-- world.lua

-- Called at the beginning of any contact in the world. Parameters:
-- {fixture} fixture_a - first fixture object in the collision.
-- {fixture} fixture_b - second fixture object in the collision.
-- {contact} contact - world object created on and at the point of
--   contact. When sliding along an object, there may be several.
--   See further: https://love2d.org/wiki/Contact
local begin_contact_callback = function(fixture_a, fixture_b, contact)
  local name_a = fixture_a:getUserData()
  local name_b = fixture_b:getUserData()

  print(name_a, name_b, contact, 'beginning contact')
end

local end_contact_callback = function(fixture_a, fixture_b, contact)
  local name_a = fixture_a:getUserData()
  local name_b = fixture_b:getUserData()

  print(name_a, name_b, contact, 'ending contact')
end

local pre_solve_callback = function(fixture_a, fixture_b, contact)
  local name_a = fixture_a:getUserData()
  local name_b = fixture_b:getUserData()

  print(name_a, name_b, contact, 'about to resolve a contact')
end

local post_solve_callback = function(fixture_a, fixture_b, contact)
  local name_a = fixture_a:getUserData()
  local name_b = fixture_b:getUserData()

  print(name_a, name_b, contact, 'just resolved a contact')
end

local world = love.physics.newWorld(0, 9.81 * 128)

world:setCallbacks(
  begin_contact_callback,
  end_contact_callback,
  pre_solve_callback,
  post_solve_callback
)

return world
```

Ah, now we can see which fixture is colliding which!

```
bar     triangle        Contact: 0x55bf29c07590 beginning contact
bar     triangle        Contact: 0x55bf29c07590 about to resolve a contact
bar     triangle        Contact: 0x55bf29c07590 just resolved a contact
bar     triangle        Contact: 0x55bf29c07590 ending contact
```

## Exercises

- Modify the print statements in each collision callback to print out the coordinates where the entities' fixtures are making contact. You can find the information you need to do this in the documentation for the contact table mentioned above.
