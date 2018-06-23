# LÖVE structure

Open up "main.lua" and take a look at our first line.
We defined a function called `love.draw`, which implies there is a table called `love` and we created a key in it called `draw`.
Indeed this is the case, but somehow the function was invoked without using having to write `love.draw()` and invoke it ourselves.
This requires a high-level explanation of what the engine is doing with our file.

When LÖVE is run, before our main.lua file is ran, a table called `love` is defined as a global variable.
We can assign functions to this table (`love.draw`) and access functions already defined in it (`love.graphics.print`).
`love.graphics.print` has two dots in it, so that means the love table probably looks something like:

```lua
love = {
  draw = nil,
  graphics = {
    print = function() ... end
  }
}
```

The `love` table has a plenty of other tables nested in it, and it puts similar functions in tables together.
So all the functions relating to graphics are inside the `love.graphics` table.

Once "main.lua" is done running, we've accessed and modified the `love` table and added some new functionality to it, telling it how to draw to the screen by defining our `love.draw` function.
If we define a function with this name, the game engine will see it and invoke it.
In fact, it continuously invokes `love.draw` many times a second.
To prove my point, let's modify main.lua and make it print a number.

```lua
local number = 0

love.draw = function()
  number = number + 1
  love.graphics.print(number, 400, 300)
end
```

Each time we go to print the number, we increase it by 1.
Run this program and see how quickly the number climbs.
The faster your computer is, the faster the number will move.

The `love` table is a seemingly complex structure of tables inside tables and functions inside those, but we'll gradually learn the structure and purpose of each thing over the course of this chapter.
In the next section, let's take a look at the 2nd and 3rd parameters in `love.graphics.print` and see how they work.
