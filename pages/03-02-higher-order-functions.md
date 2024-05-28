# Higher-order functions

In [1.07 Making functions](01-07-making-functions.md) we learned about, well, making functions.
So what about higher-order functions?
What are they and how do we make them?
Simply put, higher-order functions are functions built on top of other functions.
Here's a basic example:

```lua
local run_twice = function(some_function, some_data)
  some_function(some_data)
  some_function(some_data)
end

run_twice(print, 'Hello World!')
```

It can take any function and run it twice for you, in this case the `print` function, but it could be any function you pass it.
Typically higher-order functions return data.
Here's a trickier example that does just that:

```lua
local twice = function(fn, val)
	return fn(fn(val))
end

local add_four = function(num)
	return num + 4
end

return twice(add_four, 12)
```

Take a look at the bottom line for a second.
We are calling the function `twice` with two arguments, the `add_four` function and the number `12`.
The purpose of the `twice` function is to take a value, `12` in this case, and run it through the given function (`add_four`) twice.
Now take a look inside the `twice` function.
Inside it returns `fn(fn(val))`.
Given what we know is being passed to this function, this can be read as saying `add_four(add_four(12))`.
The order of operation says to start from the inner-most parenthesis and work your way out:

```
add_four(add_four(12))
```

becomes

```
add_four(16)
```
which becomes

```
20
```
and that is what is returned when you run the code.
The power of these higher-order functions is that they are re-usable.
You can give the `twice` function anything that takes and returns a value:

```lua
local twice = function(fn, val)
	return fn(fn(val))
end

local double = function(number)
	return number * 2
end

return twice(double, 3)
```

...or similar to our original example:

```lua
local twice = function(fn, val)
	return fn(fn(val))
end

local shout = function(message)
  print(message .. '!!')
	return message
end

return twice(shout, 'hello')
```

There are all examples of higher-order functions that accept a function as an argument.
Another kind of higher-order function is one that *returns* another function:

```lua
local wrapper = function()
  return function()
    return 'You found the treasure!'
  end
end

local kinder_surprise = wrapper()
local secret = kinder_surprise()
return secret
```

When we ran `wrapper` it returned us *another function* that we had to invoke to get to the innermost value.
To avoid all the variable names, you can save some time and invoke such kinds of functions like so:

```lua
local wrapper = function()
  return function()
		return 'You found the treasure!'
	end
end

return wrapper()()
```

## Closures

Which number will print out by running the following code?

```lua
local number = 3

local closure = function()
  local number = 5
  return function()
    print(number)
  end
end


local print_number = closure()
print_number()
```

Strange?

Ok, so let's try this same function-returning-a-function thing but passing in some data:

```lua
local adder = function(a)
  return function(b)
    return a + b
  end
end

local add_three = adder(3)

return add_three(1)
```

The `add_three` variable is assigned a unique and special function.
It is assigned the inner function within the adder function, but with the data we passed in now assigned to the `a` variable.
Even though the function was returned outside of the [scope](01-17-scopes.md) it was defined in, the scope's data was enclosed inside the returned function until the function was discarded and the program exited.
These types of functions are common in situations where a function needs to be generated multiple times but with different data sets.

The data in the closure can also continue to be updated, giving you the ability to make storage containers for your data.
Try this out:

```lua
local make_counter = function()
  local number = 0
  return function()
    number = number + 1
    return number
  end
end

local count = make_counter()
print(count())
print(count())
print(count())
print(count())
```

In programs like LÖVE there are callback systems where a similar effect happens:

```lua
local entity = require('entity')

love.draw = function()
  entity:draw()
end
```

As seen in the previous chapter, the `love.draw` callback is defined in a **main.lua** file and later invoked somewhere within the game engine.
Since `love.draw` was defined in the scope where the entity variable is defined, the entity variable lives on and can be used inside `love.draw` long after the **main.lua** file is done being invoked.

## Conclusion

Closures take some practice to understand and appreciate, but once you see practical examples of where and how to use them they become an indispensable item on your programming toolbelt.
In the previous section we used the term *composite data* to compare primitive and non-primitive data types.
In this section we saw how to go about *composing* higher-order functions.
In the following pages we will cover some higher-order functions that are the building blocks for old and modern software alike.

## Exercises

- In the `make_counter` example above, try generating multiple counters:
```lua
-- Do the numbers in each counter stay in
-- sync or are they tracked independently?
local count_a = make_counter()
local count_b = make_counter()
```

- Using the same `make_counter` example, modify it to return a table instead of a function. Within this table, define an `increment` and `decrement` function so that you can make the counter number go up or down. How would you use such a function?
