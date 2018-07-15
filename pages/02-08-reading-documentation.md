# Reading documentation

You typically run into two types of documentation for software: guides and API documentation.
Guides would be information on getting started, tutorials, and books.
An API (application programming interface) is a portion of software that a programmer writes for his/her program to allow fellow programmers to interact with their application.
As for LÖVE's programming interface, most of your interactions with the framework are done through the `love` global variable that the framework purposely exposes.
API documentation is the most fundamental form of software documentation because without it, you would not know what all the functions in the program do unless you were resourceful enough to go in and study all the source code and figure each function out on your own.

[The documentation for LÖVE](https://love2d.org/wiki/love) (bookmark this!) is written in a wiki style where each table and function has an article that describes how to use it.
From here you should see many *modules* listed.
Click on [`love.physics`](https://love2d.org/wiki/love.physics).
Again, `love.physics` is just a table with functions in it.
So within the article we see each of the functions stored in it including the functions [`love.physics.newBody`](https://love2d.org/wiki/love.physics.newBody) which we used to create our entities' bodies, [`love.physics.newPolygonShape`](https://love2d.org/wiki/love.physics.newPolygonShape) which we used to create their shapes, and  [`love.physics.newFixture`](https://love2d.org/wiki/love.physics.newFixture) which we used to create their fixtures.
We also see [`love.physics.newWorld`](https://love2d.org/wiki/love.physics.newWorld) which created our world table.
Let's look at the first function's article.

Clicking on the article for `love.physics.newBody` we get a synopsis showing how the function might be used, along with a description of its parameters and what the function returns.
Over the course of different versions of the framework, functions may be modified so in the case of this function you can see examples of how to use it differently in different versions of LÖVE.
Since the function lists that it returns a body, click the link to go over to the article on the [body](https://love2d.org/wiki/Body) table's documentation.

There's a lot of functions here that set properties on the body and get properties from the body.
One of them is the [`body:setMass`](https://love2d.org/wiki/Body:setMass) function we used to give our entity weight.
We can see that it takes one parameter and that the parameter is meant to simulate how many kilograms of mass the body has.
We originally told it that our triangle in the last section weighed 32 kilograms, which if you think the object fell too fast or too slow then you may need to adjust your world's gravity to match your expectation.

Now let's go back to [`love.physics`](https://love2d.org/wiki/love.physics) for a moment and take a look at one of the other components we added to our previous code, the [fixture](https://love2d.org/wiki/Fixture).
We previously created a fixture table by calling [`triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)`](https://love2d.org/wiki/love.physics.newFixture).
However, we haven't seen any of these functions in the fixture table that could come in handy.
For instance, we could give our triangle bounciness by invoking [`fixture:setRestitution`](https://love2d.org/wiki/Fixture:setRestitution).
Our triangle fixture is named `triangle.fixture` though, not `fixture`.
If 0 is no bounciness (default) and 1 is 100%, try modifying the game code and adding a restitution of 75%:

```lua
triangle.fixture:setRestitution(0.75)
```

Try running the game and see how that works.
If you set the restitution to `1` or higher then the triangle won't stop bouncing and will bounce itself right off the screen.

## Callbacks

Let's backtrack now to the main article about the [love table](https://love2d.org/wiki/love).
If you scroll down a little on the page, you'll see a section titled "Callbacks" that contains some functions we've become familiar with such as `love.draw` and `love.update`.
This is a list of all the functions in the game loop that we have and haven't talked about yet.
A "callback" is a function you create and give to an API (the `love` table in this case) that will later get invoked as needed.
Creating functions with these names allow you to tap into specific portions of the game loop and trigger your own events.

Let's take a look at the `love.keypressed` callback for instance.
In the synopsis you see that it has 3 parameters (the documentation mistakenly calls parameters "arguments").
We used the first parameter `key` to see what key was pressed.
If you ever need to know what keys are available, you can click on the link provided next to the parameter name, `KeyConstant` to see a well-defined list of all the available key strings passed in to this parameter.
The second parameter `scancode` we didn't talk about, but it has a well-defined `Scancode` article explaining what it is.
If you are not familiar with scancodes, take a minute to read it and perhaps you'll learn about a feature you may want to use in your game.

One more callback we'll look at while we're here is `love.focus`.
Take a moment to stop here and read what it does and what parameters it takes before continuing.
Now it would be really cool if we were making a game and when the user switched to another application window, the game automatically paused for the user.
So first let's start by implementing a pause feature in our earlier game code:

```lua
local world = love.physics.newWorld(0, 9.81 * 128)

-- Triangle is the name of our first entity
local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
-- Give the triangle some weight
triangle.body.setMass(triangle.body, 32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)
triangle.fixture:setRestitution(0.75)

-- Another entity
local bar = {}
bar.body = love.physics.newBody(world, 200, 450, 'static')
bar.shape = love.physics.newPolygonShape(0, 0, 0, 20, 400, 20, 400, 0)
bar.fixture = love.physics.newFixture(bar.body, bar.shape)

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
  if not paused then
    world:update(dt)
  end
end
```

Notice the 3 changes:
- We added a boolean called `paused` and set it to false
- We added a new function to `key_map` so that when `"space"` is pressed, the value of `paused` is set to `not paused`. `not` is an operator for booleans we previously didn't discuss. It simply says "the opposite of this boolean". So if `paused` is `true`, then setting `paused` to `not paused` will set it to `false`.
- Lastly, inside `love.update` to told the world to update only if we are `not paused`. So the passage of time in the game world will cease when pressing the space key.

## Exercises

- Now with the documentation in hand, define `love.focus` and make it so the game pauses when the user clicks away from the game window.
- Bonus: make the game print a text saying that the game is paused when `paused` is `true`. Go find the documentation for `love.graphics.print` to see an example on displaying text.

