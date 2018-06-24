# Mapping

Let's sidetrack from LÖVE for a minute to learn about a concept called maps.
Not to be confused with overhead maps a player would walk around on in a game, but data maps.
We actually did mapping back in chapter 1 when we [learned about tables](/pages/01-14-tables-2.md).

```lua
coins = {
  ["half"] = "50 cents",
  ["quarter"] = "25 cents",
  ["dime"] = "10 cents",
  ["nickel"] = "5 cents",
  ["penny"] = "1 cent"
}

print("Which coin do you have?")
response = io.read()

print("Your coin is worth " .. coins[response] .. ".")
```

Whenever the user typed in a coin, we mapped the coin name to a value by looking up the coin name in the table, or dictionary.
So what's the difference between tables, dictionaries, and maps?

- tables are just a data type in Lua that can be used to build data structures like lists and dictionaries
- dictionaries are key-value storages used to centralize similar-purpose data in one place and make it easier to look the data up
- maps are data structures used to map data from one place to another, and a dictionary is one type of map

Dictionaries are the only types of map we'll be concerned about here, but know that maps generally refer to instances of data structures that do mapping.
There are often discrepancies in terminology between mathematics and the various fields in computer science.
Don't be surprised if you see dictionaries and maps being used synonymously in other contexts later in life.

Let's do some mapping on our code we previously wrote to get a better feel for them.
Remember all those if/elseif statements in main.lua?

```lua
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
```

We can put all that functionality in a map like this:

```lua
local key_map = {
  b = function()
    current_color = {0, 0, 1, 1} -- Blue
  end,
  g = function()
    current_color = {0, 1, 0, 1} -- Green
  end,
  r = function()
    current_color = {1, 0, 0, 1} -- Red
  end,
  w = function()
    current_color = {1, 1, 1, 1} -- White
  end,
  -- Close the game
  escape = function()
    love.event.quit()
  end
}
```

This doesn't look any more concise that our previous code, but our goal is to keep the `love.keypressed` function clean in this case.
When a key is pressed it will be mapped to a key function we define in `key_map`.
Another important thing is these functions could be modular and moved anywhere we need them to be, and even re-used.
Let's not go too crazy right now though.
We'll keep the key map somewhere near the top.

```lua
local current_color = {1, 1, 1, 1}
local seconds = 0

local key_map = {
  b = function()
    current_color = {0, 0, 1, 1} -- Blue
  end,
  g = function()
    current_color = {0, 1, 0, 1} -- Green
  end,
  r = function()
    current_color = {1, 0, 0, 1} -- Red
  end,
  w = function()
    current_color = {1, 1, 1, 1} -- White
  end,
  escape = function()
    love.event.quit()
  end,
}

love.draw = function()
  local square = {100, 100, 100, 200, 200, 200, 200, 100}

  -- Print a counter clock
  local clock_display = 'Seconds: ' .. math.floor(seconds)
  love.graphics.print(clock_display, 0, 0, 0, 2, 2)

  -- Initialize the square with the default color (white)
  love.graphics.setColor(current_color)
  love.graphics.polygon('fill', square)
end


love.keypressed = function(pressed_key)
  -- Check in the key map if there is a function
  -- that matches this pressed key's name
  if key_map[pressed_key] then
    key_map[pressed_key]()
  end
end

love.update = function(dt)
  -- Add up all the delta time as we get it
  seconds = seconds + dt
end
```

If you press a key that isn't part of the map then the new if statement (`if key_map[pressed_key] ...`) will see that key doesn't exist in the map and not do anything.
`key_map[pressed_key]()` is the same as saying `key_map['b']()`, `key_map['escape']()` or whatever the value of `pressed_key` was at the time.
