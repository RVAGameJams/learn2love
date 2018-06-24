# Delta time

Here's what we've learned about the game loop so far:

1. Game is started. Load game files.
  - main.lua is loaded and the `love` table is updated with our modifications.
2. Begin loop.
3. Check for input from keyboard, joystick, or other peripherals.
  - If there was keyboard input and we defined `love.keypressed`, invoke it, passing it information about the pressed key.
4. Tick time in game.
  - ???
5. Redraw the screen.
  - Invoke `love.draw` if we defined it.
6. Go back to step 2.

Let's take a look at the function [`love.update`](https://love2d.org/wiki/love.update):

```lua
love.update = function(dt)
  print(dt)
end
```

**Note for Windows:** Unless you are running LÖVE from the console, you won't see anything printed out.
Put this file in the game folder next to main.lua under the name "conf.lua":

```lua
-- LÖVE configuration file

love.conf = function(t)
  t.console = true
end
```

This configuration file will let us set special parameters for our game.
Don't worry too much about what all the options are, but if you're curious then you can find the documentation [here](https://love2d.org/wiki/Config_Files).
Essentially this will open a console window on Windows to see printed values.

Now run the game and if you weren't seeing the `print(dt)` message display anything you should now see it being invoked many times a second, printing out a decimal number.
`dt` stands for *delta time* and it represents the amount of seconds that has passed since the last game loop.
If the game loops 4 times a second, that means `love.update` and `love.draw` get invoked 4 times each second as well.
The delta time in this case would be roughly `0.25` as roughly 1/4 a second has passed between each time `love.update` was called.
Some computers are faster than others so the number of game loops per second will be different.
You are likely seeing numbers around `0.01` or smaller, meaning the game is running roughly 100 frames a second.
Let's add a counter to the screen like before, but now using delta time.

```lua
local current_color = {1, 1, 1, 1}
local seconds = 0

love.draw = function()
  local square = {100, 100, 100, 200, 200, 200, 200, 100}

  -- Print a counter clock
  local clock_display = 'Seconds: ' .. seconds
  love.graphics.print(clock_display, 0, 0, 0, 2, 2)

  -- Initialize the square with the default color (white)
  love.graphics.setColor(current_color)
  love.graphics.polygon('fill', square)
end


love.keypressed = function(pressed_key)
  if pressed_key == 'b' then
    -- Blue
    current_color = {0, 0, 1, 1}
  elseif pressed_key == 'g' then
    -- Green
    current_color = {0, 1, 0, 1}
  elseif pressed_key == 'r' then
    -- Red
    current_color = {1, 0, 0, 1}
  elseif pressed_key == 'w' then
    -- White
    current_color = {1, 1, 1, 1}
  end
  if pressed_key == 'escape' then
    love.event.quit()
  end
end

love.update = function(dt)
  -- Add up all the delta time as we get it
  seconds = seconds + dt
end
```

Imagine if we wanted to move a character across the screen but we didn't use delta time.
The character would run faster on some computers and slower on others.
Computers would keep getting faster and the game would run so fast it would no longer be playable.
Delta time solves this issue and we'll be taking advantage of it for everything time-based in our game.

## Exercises

- Change the line `local clock_display = 'Seconds: ' .. seconds` so that `seconds` is formatted to display whole numbers. Hint: you will need to use Lua's built-in `math.floor` function.
- Change the x position of the left side of the square from `100` to `(seconds * 10)` and watch what the square does.
