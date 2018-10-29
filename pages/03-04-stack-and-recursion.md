# Stack and recursion

When running a program, the interpreter (Lua in this case) keeps track of variables defined in a scope and which function you are currently in.
It organizes this information into a list in memory called *the stack*.
The first item in the stack is the starting point - the root of your application.
Take the following example:

```lua
local two = function()
  print('two')
end

local one = function()
  print('one')
  two()
end

one()
```

When starting the program, the start of the stack is the top level of the module.
The Lua stack calls this the "main chunk".
When a function is invoked, another layer is added to the stack.
Every time a function is called from another function, the stack continues to build.
So with the example code above, The stack will follow the progression:

- Stack is `{ "main chunk" }`.
- Now start executing `one`. Stack is `{ "main chunk", "one" }`.
- Now start executing `two` while still in `one`. Stack is `{ "main chunk", "one", "two" }`.
- `two` is done executing. Stack is now `{ "main chunk", "one" }`.
- `one` is done executing. Stack is now `{ "main chunk" }`.
- Program exits.

This can be visualized by throwing an error at any point the program.
The interpreter will give you back a *stack trace* that details where it was when the problem occurred.
Lua provides a helpful `error` function for debugging that we can use here:

```lua
local three = function()
  error('This is an error.')
end

local two = function()
  print('two')
  three()
end

local one = function()
  print('one')
  two()
end

one()
```

Unfortunately the REPL doesn't provide us with stack traces, but if you have a Lua interpreter on your computer (`lua` command, `luajit`, or LÖVE) you will see the error message and a stack trace like this:

```
lua: test.lua:2: This is an error.
stack traceback:
        [C]: in function 'error'
        test.lua:2: in upvalue 'three'
        test.lua:7: in upvalue 'two'
        test.lua:12: in local 'one'
        test.lua:15: in main chunk
        [C]: in ?
```

From the "stack traceback" you can see the newest from the top of the stack to the oldest on the bottom.
In complex programs is can be very beneficial to see which function invoked another function to help trace down how an error came about.

Understanding the stack is beneficial for more than just reading errors.
Let's switch the conversation over to something seemingly unrelated for a bit.

## Recursion

When thinking of loops, many programmers first think of the `for` loop or the `while` loop.
Another common method is to make a function call itself.
Similar to the `while` loop, you can create infinite loops like this one

```lua
local loop
loop = function()
  print('hello!')
  loop()
end
```

When a function invokes itself, whether directly or indirectly, this is called *recursion*.
The same function will recur again and again until a condition changes.
Or in the case above, `loop()` will be called unconditionally.
Without a condition, any kind of loop will run infinitely (or crash trying).
Here's a loop that is a little safer to run:

```lua
local count_to_5
count_to_5 = function(current_number)
  print(current_number)
  if current_number < 5 then
    count_to_5(current_number + 1)
  end
end

count_to_5(1)
```

Which prints:

```
1
2
3
4
5
```

One quick little aside;
Notice how the function was defined in both these situations:

```lua
local loop
loop = function()
  ...
```

The variable was defined before the function was created.
Since the function needs to access the variable inside itself, the variable needs to exist at the time the function's scope is created.
Variables created after the function are unknown to the function.
This is discussed in [1.17 - Scopes](01-17-scopes.md) and is a limitation of Lua's design.
Fortunately there is shorthand syntax for writing recursive functions:

```lua
local function count_to_5(current_number)
  print(current_number)
  if current_number < 5 then
    count_to_5(current_number + 1)
  end
end

count_to_5(1)
```

is the same as writing:

```lua
local count_to_5
count_to_5 = function(current_number)
  ...
```

Let's try another recursive loop:

```lua
local grocery_list = {
  'pumpkin',
  'pecans',
  'butter',
  'flour',
  'sugar'
}

local function print_items(list, index)
  index = index or 1
  if index <= #list then
    print(list[index])
    print_items(list, index + 1)
  end
end

print_items(grocery_list)
```

Which prints the grocery list.
Don't forget the `local` at the beginning of `local function print_items`, otherwise you will accidentally generate global variables in your code when trying to define functions.

We can even re-implement our `map` function from earlier to use recursion instead of a `for` loop.

```lua
local grocery_list = {
  'pumpkin',
  'pecans',
  'butter',
  'flour',
  'sugar'
}

local function map(orig_list, transform_fn, new_list)
  new_list = new_list or {}
  if #new_list < #orig_list then
    local index = #new_list + 1
    new_list[index] = transform_fn(orig_list[index], index)
    return map(orig_list, transform_fn, new_list)
  end
  return new_list
end

local new_list = map(grocery_list, function(value, index)
  return index .. '. ' .. value
end)

map(new_list, function(value)
  print(value)
  return value
end)
```

Which prints:

```lua
1. pumpkin
2. pecans
3. butter
4. flour
5. sugar
```

## Stack overflow

So what does the stack look like during recursion when a function enters itself?
Here's a script to test:

```lua
local function recur(n)
  -- assert is like error, but takes an expression to test as its first parameter
  assert(n < 5, 'This is a conditional error')
  print(n)
  recur(n + 1)
end

recur(1)
```

```
lua: test2.lua:2: This is a conditional error
stack traceback:
        [C]: in function 'assert'
        test2.lua:2: in upvalue 'recur'
        test2.lua:4: in upvalue 'recur'
        test2.lua:4: in upvalue 'recur'
        test2.lua:4: in upvalue 'recur'
        test2.lua:4: in local 'recur'
        test2.lua:7: in main chunk
        [C]: in ?
```

Every time the function recurs we get another addition to the stack.
This can be a problem if you are looping over a large set of data because the stack will consume more and more memory as it stacks up.
This can be accomplished by creating a recursive loop that runs infinitely.
If you haven't tried so already, here's an easy example:

```lua
local function recur()
  recur()
end

recur()
```

When the stack reaches a critical size, you get a *stack overflow* error:

```lua
lua: test3.lua:2: stack overflow
stack traceback:
        test3.lua:2: in upvalue 'recur'
        test3.lua:2: in upvalue 'recur'
        ...
        test3.lua:2: in upvalue 'recur'
        test3.lua:2: in upvalue 'recur'
        test3.lua:2: in local 'recur'
        test3.lua:5: in main chunk
        [C]: in ?
```

With a specific `return` statement added to the loop, however, we no longer get a stack overflow:

```lua
local function recur()
  return recur()
end

recur()
```

This will run until you manually kill the application process.
Killing it returns a somewhat mysterious stack track:

```
lua: test4.lua:2: interrupted!
stack traceback:
        test4.lua:2: in function <test4.lua:1>
        (...tail calls...)
        test4.lua:2: in function <test4.lua:1>
        (...tail calls...)
        test4.lua:5: in main chunk
        [C]: in ?
```

So how did our modification save us from overflowing our stack?

## Tail call optimization

Inside a function when you return another function call, the interpreter has the ability to re-use the same layer of the stack instead of creating another layer.
This works with direct recursion (function calling itself) and indirect (mutual) recursion such as two functions calling each other:

```lua
local one
local two

one = function()
  return two()
end

two = function()
  return one()
end

one()
```

[Programming in Lua](https://www.lua.org/pil/6.3.html) goes into greater detail on when a recursion will or won't be optimized, but the simple thing to remember is that the function(s) must return the value of invoking a function for this to work.
The following will be tail-call optimized:

```lua
local one
local two

one = function(n)
  print(n)
  return two(n + 1)
end

two = function(n)
  print(n)
  return one(n + 1)
end

-- Count until we run out of numbers
one(1)
```

But the following won't, since it returns an operation including the function call instead of just the function call itself:

```lua
local one
local two

one = function(n)
  print(n)
  return 1 + two(n)
end

two = function(n)
  print(n)
  return 1 + one(n)
end

-- This won't work!
one(1)
```

## The case for recursive loops

So why would we want to do recursion?
It seems trickier than a `for` loop and perhaps just as easy to mess up as a `while` loop.

It's not necessarily a replacement for the `for` loop, but allows you to do certain things you can't easily do without recursion.
Take this example from [Rosetta Code](http://rosettacode.org/wiki/Flatten_a_list#Lua) which will flatten a list of lists into a single, flat list.
It uses a `for` loop and a recursive loop in conjunction with each other:

```lua
local function flatten(list)
  if type(list) ~= "table" then return {list} end
  local flat_list = {}
  for _, elem in ipairs(list) do
    for _, val in ipairs(flatten(elem)) do
      flat_list[#flat_list + 1] = val
    end
  end
  return flat_list
end

local test_list = {
  {1},
  2,
  {{3,4}, 5},
  {{{}}},
  {{{6}}},
  7,
  8,
  {}
}

print(table.concat(flatten(test_list), ","))
```

Which prints:

```
1,2,3,4,5,6,7,8
```

This function isn't tail-call optimized, but it probably won't be passed a nested list deep enough to cause a stack overflow.

Here's just a few of the many situations where recursion is usually the best tool for the job:
- Sorting data
- Searching trees (nested data) in a database or nested folders in a filesystem.
- Finding the shortest path between two points
- Loops that increment or decrement in irregular patterns
- Evaluating a finite set of moves in a game like chess


The point isn't to replace the `for` loop, although you can.
Take the following example, which returns the [factorial](https://en.wikipedia.org/wiki/Factorial) of the given number (5):

```lua
local fact = function(n)
  local acc = 1
  for iteration = n, 1, -1 do
    acc = acc * iteration
  end
  return acc
end

print(fact(5))
```

The same functionality written with a recursive loop would look very different:

```lua
local function fact(n, acc)
  acc = acc or 1
  if n == 0 then
    return acc
  end
  return fact(n-1, n*acc)
end
```

...but one method wouldn't offer an advantage over the other here.
Depending on the language you are working in, one method may be easier to read than the other.
Maybe the language supports one type of loop and not the other.
These are the factors that will often do the deciding for you.
