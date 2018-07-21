# Modules and organization

Eventually when you start writing real programs, you realize if you keep all the code in one file that things can get a bit messy.
Putting your code in separate files helps you not only keep your different pieces of code separated from each other, but it helps you visualize the structure of your program.

Let's start with a single *main.lua* file and we'll then split it into different files:


```lua
local my_cool_functon = function()
  love.graphics.print('This function came from function-module.lua', 100, 100, 0, 2)
end

local my_cool_table = {}
my_cool_table.print_stuff = function()
  love.graphics.print('This function came from table-module.lua', 100, 200, 0, 2)
end

print('my_cool_function is', my_cool_function)
print('my_cool_table is', my_cool_table)
```

When we go to run the code, we get a blank window because we're not drawing anything.
We do see our print statements output our function and table to the console though:

```
my_cool_function is     function: 0x41f2abc0
my_cool_table is        table: 0x41f2aa08
```

## Modules and `require`

Think of your Lua files as giant functions that get invoked whenever you load the file.
Just like a function, you can *return* values from your files.
If you load one Lua file from another, you will get whatever value is returned.
Let's modify our previous code.
First define these two new files in the game folder:

**function-module.lua**

```lua
return function()
  love.graphics.print('This function came from function-module.lua', 100, 100, 0, 2)
end
```

**table-module.lua**

```lua
local my_cool_table = {}
my_cool_table.print_stuff = function()
  love.graphics.print('This function came from table-module.lua', 100, 200, 0, 2)
end

return my_cool_table
```

Then update **main.lua**:

```lua
local function_module = require('function-module')
local table_module = require('table-module')

print('function_module is', function_module)
print('table_module is', table_module)
```

Let's start from the top.
In *function-module.lua* we write a return statement that returns a function with no name.
We don't invoke the function, we just return it as a value the same way a function may return a number or string.
Likewise in *table-module.lua* we defined a table (with a function in it) and returned the table on the last line of the file.
The function name and local variable name `my_cool_table` is inconsequential and can't be seen outside the *table-module.lua* file as modules have their own [scope](/pages/01-17-scopes.html).

In *main.lua* we are *requiring* function-module using a built-in Lua function, `require`.
`require` takes one argument, a string that equals the name of your file and it then invokes that file and returns back a function which we assign to a new variable `function_module`.
We then do the same thing for *table-module.lua*. We require it, which invokes it and returns back whatever that file returns.
In this case is a table.
Notice that when we pass in the filenames as arguments we just give the first part of the filename without the extension ".lua" at the end.
This function expects that any file it is requiring is a Lua file.

After we required the files, we printed the values of those variables, so you should see the results of the print statements appear in the console like before:

```
function_module is      function: 0x40479548
table_module is table: 0x40479bc8
```

We pulled in the return values from the other two files into our *main.lua* file and printed the values, but since we didn't invoke the functions from those two files then we got a blank game window when running the program.
Let's define a `love.draw` in *main.lua* like before and invoke the functions we got back from both modules:

```lua
local function_module = require('function-module')
local table_module = require('table-module')

print('function_module is', function_module)
print('table_module is', table_module)

love.draw = function()
  function_module()
  table_module.print_stuff()
end
```

We were able to invoke the functions and use the returned data as if it were all in the same file.

## Organizing modules

It may help to see a real example of using modules in a game, so let's take our previous game code from [2.8 - Reading documentation](pages/02-08-reading-documentation.md) and see how we can separate out functionality.
The first thing we did in our game was define a world, so let's start by putting our world-related code in a dedicated file named **world.lua**:

```lua
-- world.lua

local world = love.physics.newWorld(0, 9.81 * 128)

return world
```

Remember that you need the return statement at the end of your files or else the code will return `nil` when you go to require it and this could cause all kinds of unexepcted errors when you run it.
Next let's create a folder named **entities** that we can keep all our game entities in.
We plan on creating more entities so it will help to keep them all together.
In the entities folder, create a file and name it **triangle.lua**.
We'll cut all the code from the original main.lua that related to our triangle entity and put it here:

```lua
-- entities/triangle.lua

local world = require('world')

local triangle = {}
triangle.body = love.physics.newBody(world, 200, 200, 'dynamic')
triangle.body.setMass(triangle.body, 32)
triangle.shape = love.physics.newPolygonShape(100, 100, 200, 100, 200, 200)
triangle.fixture = love.physics.newFixture(triangle.body, triangle.shape)
triangle.fixture:setRestitution(0.75)

return triangle
```

Notice how we are requiring the `world` table from world.lua, because we need to access that table in this entity's file so we can add the entity to the world.
We also need to do the same thing as above with the **bar** entity:

```lua
-- entities/bar.lua

local world = require('world')

local bar = {}
bar.body = love.physics.newBody(world, 200, 450, 'static')
bar.shape = love.physics.newPolygonShape(0, 0, 0, 20, 400, 20, 400, 0)
bar.fixture = love.physics.newFixture(bar.body, bar.shape)

return bar
```

Now our **main.lua** should only contain our key map and `love` functions:

```lua
-- main.lua

local bar = require('entities/bar')
local triangle = require('entities/triangle')
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
  love.graphics.polygon('line', triangle.body:getWorldPoints(triangle.shape:getPoints()))
  love.graphics.polygon('line', bar.body:getWorldPoints(bar.shape:getPoints()))
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
  world:update(dt)
end
```

Our two entities and world get pulled into main.lua and everything should run exactly as before.
One thing to note is that even though we require world.lua 3 times in our code, it is the same world and not 3 copies.
This is because Lua knows to only run a module the first time you require it and not invoke it again.
Once it runs the first time, the returned results are stored in memory for the next time you try to require it.
We can prove this by adding a print statement to **world.lua**:

```lua
-- world.lua

print("This is the world")

local world = love.physics.newWorld(0, 9.81 * 128)

return world
```

How many times does `"This is the world"` get printed to the console?

## Exercises

- Try creating two new modules; One that returns a string and one that returns a number.
