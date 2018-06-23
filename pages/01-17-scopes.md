# Scopes

When defining functions, we define parameters for those functions which work like regular variables.
If we try to access a parameter outside a function we will see that it is `nil`.

```lua
addition = function(a, b)
  print(a, b)
  return a + b
end

addition(1, 2)

print(a, b)
```

The parameters `a` and `b` are *local variables*.
We've seen local variables with for loops, where the variable `counting_number` couldn't be accessed outside the for loop:

```lua
for counting_number = 1, 4 do
  print(counting_number)
end

print(counting_number)
```

Functions, for loops, and while loops create a *scope* each time they are ran.
Things created in the scope, including local variables, are destroyed when that loop or function invoke is done.
This is how the program tidies up after itself and keeps the computer from running out of memory.
The process of removing unused data from memory and releasing control of that memory is called garbage collection.
Lua does this for us so we don't have to think about it.
Variables we create normally don't follow the same rules.
They will continue to exist after the scope they were created in has been destroyed.

```lua
addition = function(a, b)
  text = "I'm not going away."
  return a + b
end

addition(1, 2)

print(text)
```

Eventually all these variables we make will fill up memory unnecessarily.
This can also be problematic if we accidentally make two variables but use the same name.

```lua
x = 2

addition = function(a, b)
  -- This modifies the x at the top!
  x = 9
  return a + b
end

print(x)
result = addition(x, y)
print(x)
```

When you write a large program, you'll inevitably make two variables with the same name, so this could be a huge issue.
The solution is to make our variables local variables by putting the keyword `local` before all our variables when we create them.

```lua
addition = function(a, b)
  local text = "I'm only accessible inside the function."
  return a + b
end

addition(1, 2)

print(text)
```

Now `text` is only in the scope of the function and not getting into other people's business.
If you don't write `local` before a variable, then what you are creating is a *global variable*.
It's a shame that variables are global unless we explicitly tell them not to be.
There is never a reason to create global variables if you have enough knowledge to know not to.
So as a best practice, all code examples going forward, only local variables will be created.
Let's see a few more examples:

```lua
local number = 12

-- This function has no parameters
local print_numbers = function()
  -- This works. You can see variables outside the function
  print('number:', number)
  -- This doesn't work. The variable didn't exist
  -- at the time "print_numbers" was created.
  print('number2:', number2)
end

local number2 = 18

print_numbers()

-- We already "declared" number. We don't write "local" again.
number = 13

print_numbers()
```

Notice when it printed that it knew `number` was updated to 13 but couldn't track `number2`.
As long as a variable was created before the scope (function's scope in this case) was created then it will always track the latest value.


As a reminder, we already saw with the for loop and while loop that you can modify variables in the outer, or parent, scope:

```lua
local number = 1

while number < 10 do
  number = number + 1
end
```

This also works with functions:

```lua
local number = 1

local mutate_number = function()
  number = 7
end

print(number)
mutate_number()
print(number)
```

What if you make two variables with the same name in two different scopes?
Try running this one:

```lua
local number = 18

local shadowing = function()
  local number = 6
  print(number)
end

print(number)
shadowing()
```

The inner `number` does not affect the outer `number` in any way.
The outer `number` is not accessible inside the function as long as the inner `number` exists.
When a variable has the same name as another variable in a parent scope as the parent scope variable becomes inaccessible, this is called *shadowing*.
Typically you would want to avoid shadowing if at least for the reason that using the same variable name twice in the same file can make the code harder to read and more prone to errors being introduced.


One more interesting things with scopes.
Normally a function cannot see itself:

```lua
local self_reference = function()
  print(self_reference) -- This will be nil!
end

self_reference()
```

It doesn't see itself because the variable is still being created when the function is being created.
But remember that if a variable exists before the function does, it can see the latest up-to-date content of that variable.
So here's the trick to make that work:

```lua
local self_reference = nil
self_reference = function()
  print(self_reference)
end

self_reference()
```

The variable is declared, even though we assigned `nil` to it.
Assigning nil to get a variable declared is pretty common, so Lua includes a shorthand way of declaring empty variables:

```lua
local self_reference
self_reference = function()
  print(self_reference)
end

self_reference()
```

This may seem silly that a function would need to access itself, but there are some very powerful applications for this that we will see later on.

## Exercises

- Declare a global variable inside a function, `x = 5` (no local keyword) then try to print the variable from outside the function. Can it be printed? How?
