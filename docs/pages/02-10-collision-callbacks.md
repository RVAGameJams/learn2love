# Collision callbacks

When writing a game such a platformer you may want something special to happen when two objects collide.
If it's a powerup, for instance, you may want the powerup to *despawn* (be removed from the world) if a player touches it and then give the player a special ability.
If a player and an enemy bump into each other, you may want the player's health to decrement.
The *world* table has a method that allows you to program in functionality like this for when two entities collide.
It does this by allowing you to create callbacks as we learned before, but these callbacks are triggered before, during, or after collision.
Take a look at [World:setCallbacks](https://love2d.org/wiki/World:setCallbacks).

If you look at the parameters for `World:setCallbacks`, you see it can take four functions.
The description of these parameters helps explain when the functions will be called.
`beginContact` and `endContact` should be self explanatory, but `preSolve` and `postSolve` may not be as obvious.
Nonetheless, let's edit the previously-created **world.lua** file and write some collision callbacks to test this functionality.

```lua
-- world.lua

local beginContactCounter = 0
local endContactCounter = 0
local preSolveCounter = 0
local postSolveCounter = 0

local beginContactCallback = function()
  beginContactCounter = beginContactCounter + 1
  print('beginContact called ' .. beginContactCounter .. ' times')
end

local endContactCallback = function()
  endContactCounter = endContactCounter + 1
  print('endContact called ' .. endContactCounter .. ' times')
end

local preSolveCallback = function()
  preSolveCounter = preSolveCounter + 1
  print('preSolve called ' .. preSolveCounter .. ' times')
end

local postSolveCallback = function()
  postSolveCounter = postSolveCounter + 1
  print('postSolve called ' .. postSolveCounter .. ' times')
end

local world = love.physics.newWorld(0, 9.81 * 128)

world:setCallbacks(
  beginContactCallback,
  endContactCallback,
  preSolveCallback,
  postSolveCallback
)

return world
```

Try it out.
Every time one of the callbacks is invoked, it will increment its own number by 1 then print a message to the console telling you how many times it has been invoked.
It's clear right away that `preSolveCallback` and `postSolveCallback` get invoked many more times that `beginContactCallback` and `endContactCallback` in this situation.

Unless you've edited the behavior of the triangle entity, it will bounce a bit (because of the restitution).
Once it bounces and neither corner or side is touching the floor underneath, the contact ends.
Once it settles down it will slide a bit, maybe even a lot... like an air hockey puck.
This is because our triangle and bar have no friction between them to prevent that.
Anyways, this is good because it allows us to see that while the triangle is sliding it is still making contact.
While the triangle is sliding and still making contact, the `preSolveCallback` and `postSolveCallback` will continue to get called with every frame of movement.

Pretend our triangle was a futuristic race car moving across a neon strip of road that restored health.
You could start increasing the character health inside `beginContactCallback` as the car makes contact with that section of road and then stop increasing health when `endContactCallback` is invoked.
This could work pretty well, but then the player may try parking for a moment on the power up and continue to gain healh as long as they want.
So another approach could be to only increase the health as the player continues to make contact with the road, increasing health by 1 point every time the `postSolveCallback` function is invoked.
You don't necessarily need to use all of these callbacks, so you could just pass in an empty function or `nil` to `World:setCallbacks` for the arguments you don't need.

Without knowing what entities are colliding, the collision callbacks aren't very useful.
Luckily, our callbacks have parameters of their own that we can access.
Let's modify the code again and check out those parameters:

```lua

```
