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
Let's [run the code in the REPL](https://repl.it/languages/Lua) and try it out:

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

print(table2.rabbit)
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

### Composite data types

In Lua there is no composite data such as in other language as C/C++. But the table in Lua is a powerful type that can act as composite data type.
Usually composite data type, is a type constructed in a program using the programming language's primitives data types and even other composite types.

Imagine, you need to have a new data type to refer in your program, like a Player data type. That type, will be a composed of multiples primitives types. In my game a player is composed
of:

**Player composite data**
   - name (string)
   - health (int)
   - strengh (int)
   - agility (int)
   - intellect (int)
   - isAlive (bool)


First you have to declare the composite type, the program needs to know you are creating a new data type.
Once you have created a new composite data, your life will be easier! Every times you want to create a new player, you can create a new variable and assign him Player type.
It's exactly the same way as declared a new `int` variable or `string` variable, but in that case it will be a `player` variable.
Your composite data type will work almost like a primitive, except you want to work on the primitives variables in your composite not the composite it self.

You can access all the primitives variables from your composite as:

```lua
local player = playerType

player.health = 50


print("Player's health :")
print(player.health)
```

Player's health:

```lua
50
```

It's awesome! Now you can create thousands of new players! But how can you know if two variables of playerType, are equals?

The operation:

```lua
local player1 = playerType
local player2 = playerType

player1.health = 50
player2.health = 50



print(player1 == player2)
```

will return

```
false
```

Why?

That is a main point of composite data type, the machine doesn't know how handle them for basic operations in contrary of primitives data types.
All the common operations needed have to be coded like:
    - addition
    - subtraction
    - print

I hope you understand now, that composite data type, are YOUR types. You have to tell everything in your program : how does it look like, how print it, etc...

But it's extremely powerful and less time consuming than if you work with only primitives.



### Referenced values


Back to our example in the introduction . `The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?`
Remember `There are eight basic types in Lua: nil, boolean, number, string, function, userdata, thread, and table.`
But Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them

We will try to understand how it works.


```lua
local string1 = "hello"

-- I declare two different table
local myTable = {}
local myTable2 ={}

-- I declare a new field myString in myTable, and it's equal to string1, BUT because string1 is a string, the value is copied in my new field
-- In any case if I modified myTable.myString, string1 will not be modified.
myTable.myString = string1

print("myTable.myString == "..myTable.myString)


-- Now I want myTable2 to be equal to myTable. If you remember, myTable2 will have the same reference as myTable, IT IS NOT a copy

myTable2 = myTable

-- Because tables working with references, myTable and myTable2 are equals. It means both reference to the same area in the memory.
-- May be for you memory area is something obscure, but all you have to know is you can have access to a specific space in the memory
-- with some "id". And when you try to print a table, it's exactly what it returns. So if two tables return the same memory id, it's means
-- they both point to the same memory area and so they are equals.
-- And now, if I test if these two tables are equals, it will be true.

if myTable == myTable2 then
print(tostring(myTable).." is the same as "..tostring(myTable2) )
end

-- So if I change something in myTable2 does myTable will be changed too?


myTable2.myString = "changed"



print("Final")
print("string1 == "..string1)
print("myTable.myString == "..myTable.myString)
print("myTable2.myString == "..myTable2.myString)
```

```
myTable.myString == hello
table: 0x22ed7e0 is the same as table: 0x22ed7e0
Final
string1 == hello
myTable.myString == changed
myTable2.myString == changed
```


### Conclusion

:warning: ***There are eight basic types in Lua: nil, boolean, number, string, function, userdata, thread, and table.***

:warning: ***Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them***
