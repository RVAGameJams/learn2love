# Primitives and references

Take a look at this code:

```lua
    local string1 = "hello"
    local string2 = 'hello'

    print(string1 == string2)

    local number1 = 14
    local number2 = 14

    print(number1 == number2)

    local table1 = {}
    local table2 = {}

    print(table1 == table2)

    local function1 = function() end
    local function2 = function() end

    print(function1 == function2)
```

What would happen if you were to run this?

In chapter 1 we learned about comparing strings with the `==` operator when we talked about [booleans](01-08-booleans.md).
Let's run the code in [the REPL](https://repl.it/languages/Lua) and try it out:

```
true
true
false
false
```

The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?
Try printing the tables and functions and look what happens:

```lua
local table1 = {}
local table2 = {}

print(table1)
print(table2)

local function1 = function() end
local function2 = function() end

print(function1)
print(function2)
```

```
table: 0x16af270
table: 0x16af220
function: 0x16ae840
function: 0x16aeff0
```

Attempting to print each value you are given back a [hexadecimal number](https://en.wikipedia.org/wiki/Hexadecimal), the place in memory where those values are located.
Each table and function resides in a different place in memory.
So how is this relevant?

When checking data like strings and numbers, the `==` operator does indeed check that the data matches.
These data types are simple and take very little effort for a computer to check that they are equal.
Booleans, strings, numbers, and `nil` are all *primitive* types of data and behave this way.

When checking data like functions and tables, however, the `==` operator checks the memory location of the data on both sides of the operator and if the variables reference the same location then they are equal.
In other words, the `==` operator checks these data types to see if they have the same identity.
No matter how many empty tables or functions you have, each one is created with a unique identity.


```lua
local string1 = 'hello'
local string2 = "hello"
-- Another copy of "hello" is created in memory:
local string3 = string2
-- But these two copies are equal
print(string2 == string3)

local table1 = {}
local table2 = table1
print(table1 == table2)
```

What is the result of `print(table1 == table2)`?
Aha! Both these variables reference the same data.
Quick– a magician waves two wands in front of your face and asks you to count how many wands there are.
How do you know if there are really two wands or if this is just a trick with mirrors?
What do you do?
You take one of the wands and break it of course.
If the other wand breaks then they were the same wand the entire time.
Let's try that with the two objects:

```lua
local table1 = {}
local table2 = table1
table1.rabbit = 'white'

print(table2.rabbit) -- Equals 'white' too
```

As long as your variables reference the same table, updating the table from one variable you will see the result when checking the other variable.
This doesn't work with primitive data because you're always making a copy when assigning it to a new variable name:

```lua
local string1 = 'hello'
local string2 = string1
string1 = 'world'

return string2
```

```
=> hello
```

## Primitive versus non-primitive data types

Whenever we assign non-primitive data to a new variable, we're always referencing the original data:

```lua
local grocery_list = {
  'carrots',
  'celery',
  'pecans'
}

local same_list = grocery_list

grocery_list[1] = 'grapes'

return same_list[1]
```

But assigning primitive data to a variable, even primitive data inside tables, we're always making a unique copy:

```lua
local grocery_list = {
  'carrots',
  'celery',
  'pecans'
}

local item_copy = grocery_list[1]

print('item_copy is ' .. item_copy)

grocery_list[1] = 'grapes'

print('item_copy still is ' .. item_copy)
```

If you need to make each item in your table reference-able, you need to make each item a non-primitive data type:

```lua
local grocery_list = {
  { name = 'carrots', location = 'produce' },
  { name = 'celery', location = 'produce' },
  { name = 'pecans', location = 'baking' }
}

local item_reference = grocery_list[1]

print('item_reference is ' .. item_reference.name)

grocery_list[1].name = 'grapes'

print('item_reference is now ' .. item_reference.name)
```

So rather than replacing the first item in the list, the first item was retained and only modified:

```lua
item_reference is carrots
item_reference is now grapes
```

## Cloning non-primitive data types

As we are familiar with at this point, tables are a special data type that can contain other data types.
You can build structures containing strings, variables, and even other tables.
That makes the table a *composite* data type, in other words, a data type with distinguishable parts.
Not all languages have composite data types, but for Lua the table is one of its primary features.

One thing a programmer may want to do with a table is once constructed, create a copy of it.
If there was a table for a monster in a video game, you may want to have more than one table.
If you did this:

```lua
local enemy1 = { health = 10, strength = 12, type = 'orc' }
local enemy2 = enemy1
```

You would still only have one table.
You could use a loop to copy all the values out of a table and into a brand new table.
A function to do that may look like this, more or less:

```lua
local copy = function(orig_table)
  local new_table = {}
  for key, value in pairs(orig_table) do
    new_table[key] = value
  end
  return new_table
end

local enemy1 = { health = 10, strength = 12, type = 'orc' }
local enemy2 = copy(enemy1)
```

There is nothing terribly wrong with this method, but a more efficient way to do such a thing would be to construct each monster table inside a function instead of copying one from another.
This method will be familiar already if you read and followed through the [breakout game](02-11-breakout-part-1.md).

```lua
local create_orc = function(strength)
  return {
    health = 10,
    strength = strength,
    type = 'orc'
  }
end

local enemy1 = create_orc(12)
local enemy2 = create_orc(12)
```

Every time the function `create_orc` is ran, it constructs a new table from scratch.
You define an orc-style table only once and don't need to read values in from one table to another.
A function that constructs tables for you is a common paradigm in programming known as a *factory* function.
You made a factory that builds orcs!
Of course this factory function paradigm works with other non-primitive types of data as well:

```lua
local create_function = function()
  return function() return 1 + 1 end
end

local fn1 = create_function()
local fn2 = create_function()

print(fn1)
print(fn2)
```

A function that generates other functions?
This may seem like an odd thing to want to do, but method of programming can be quite useful as we'll see in [3.02 - Higher-order functions](03-02-higher-order-functions.md) and later follow-up sections.
One thing that should be mentioned though is that functions can also be considered a composite data type as it can return other data types, and even other functions.
Composite in that you can compose higher-order functionality in the way tables can be used to compose higher-order structures.

## Conclusion

When comparing or referencing data, always keep in mind whether you handling primitive or non-primitive data.
If you are modifying data in one place, think if this might be affecting you somewhere else in your program.
Even when writing out a `local some_module = require('some-module')` in your code `some_module` is just a table and like every other table, every reference to it can affect each other.
So modifying `some_module` in two different files can have either beneficial or disastrous consequences depending how much care and regard you give your code.
