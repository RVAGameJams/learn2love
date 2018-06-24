# Game loop

Another aspect common with game engines is that there is a loop (like a while loop) that continuously runs and keeps the game going.
The order that things happen in varies, but the contents more of less look like:

1. Game is started. Load game files.
2. Begin loop.
3. Check for input from keyboard, joystick, or other peripherals.
4. Tick time in game.
5. Redraw the screen.
6. Go back to step 2.

During steps in the game loop, LÖVE invokes certain functions inside the `love` table.
For instance, every time the screen needs to be re-drawn, the game loop invokes `love.draw()` if you defined it.
In the step where LÖVE checks for user input, if there is user input, it invokes `love.keypressed(PRESSED_KEY)` if we defined it.
The `PRESSED_KEY` that is passes in of course depends on what key the user pressed.
When defining `love.keypressed`, it may look something like this:

```lua
love.keypressed = function(pressed_key)
  print('key was pressed:', pressed_key)
end
```

Let's modify main.lua to have a contrived example:

```lua
local current_color = {1, 1, 1, 1}

love.draw = function()
  local square = {100, 100, 200, 200, 100, 200, 100, 200}

  -- Initialize the square with the default color (white)
  love.graphics.setColor(current_color)
  -- Draw the square
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
end
```

When you press any of the keys, "b", "g", "r", or "w", our function `love.keypressed` will be invoked and the variable `pressed_key` will be a string matching one of our letters.
This changes `current_color`, which is changing the color being drawn in `love.draw`.

In the next section, let's see how LÖVE handles the "4. Tick time in game." step of the game loop.

## Exercises

- Try adding a few more colors to the program. To understand how `love.graphics.setColor` works, see [the documentation](https://love2d.org/wiki/love.graphics.setColor).
- Make is so that if the escape key is pressed, the function `love.event.quit` is invoked and the game exits. Spoilers: the solution can be seen in the next section.
