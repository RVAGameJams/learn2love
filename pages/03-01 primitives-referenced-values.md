# Primitives, composite data types  and referenced values


## Introduction

```
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

    What would happen if you were to run this?
    In chapter 1 we learned about comparing string with the == operator when we talked about booleans.
    Let's run the code in the repl and try it out:

    true
    true
    false
    false

    The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?
```
	First, let's see variables types. 
	
	
### Primitves data types
In Lua, though we don't have variable data types, but we have types for the values. The list of data types for values are given below.




| Value Type | Description |
| ------------- |:-------------:|
|nil| Used to differentiate the value from having some data or no(nil) data.|
|boolean|Includes true and false as values. Generally used for condition checking.|
|number|Represents real(double precision floating point) numbers.|
|string|Represents array of characters.|
|function|Represents a method that is written in C or Lua.|
|userdata|Represents arbitrary C data.|
|thread|Represents independent threads of execution and it is used to implement coroutines.|
|table|Represent ordinary arrays, symbol tables, sets, records, graphs, trees, etc., and implements associative arrays. It can hold any value (except nil).|


In Lua, there is a function called ‘type’ that enables us to know the type of the variable. Some examples are given in the following code.

```
print(type("What is my type"))   --> string
t = 10

print(type(5.8*t))               --> number
print(type(true))                --> boolean
print(type(print))               --> function
print(type(nil))                 --> nil
print(type(type(ABC)))           --> string
```
When you build and execute the above program, it produces the following result on Linux −
```
string
number
boolean
function
function
nil
string
```

### Composite data types

In lua there is no composite data such as in other language as C/C++. But table in lua is powerful type that can act as composite data type.
Usually composite data type, is a type constructed in a program using the programming language's primitives data types and even other composite types.

Let's see how to declare that in lua
```
-- I declare the variable myTable to be an empty table
local myTable = {}


-- I want two named field in my table, his named and his id
myTable["name"] = "myTable" -- a string
myTable["id"] = 1 -- an int
```

Now we have myTable, a table type variable, compose of two others data types, a name (string) and an id (int).
```
print(type(myTable))
print(type(myTable["name"]))
print(type(myTable["id"]))
```
It will display
```
table
string
number
```
As you can see I can acces my fields, with the use of `[ ]`, but you can access it with `.` too.
```
print(type(myTable.name))
print(type(myTable.id))
```
will produce
```
myTable
1
```

Now you can create table variable that can include other primitive data type.
That's what looks most to composite data in other languages.

Let's take another example

```
-- I want to create a new player, kind of warrior, for my video game

-- Declare the table
local player= {}
-- Filling it with all the attributes I want for my player
player.name = "player1"
player.health = 50
player.strength = 5
player.agility =4
player.intellect =3

```
That's cool, but a bit messy. We can improve that by grouping some of the stats.

```
-- I want to create a new player, kind of warrior, for my video game

-- Declare the table
local player= {}

-- And I declare another table to group all my attributes
local attributesTable = {}

-- Now I'm filling both player and attributes variables

-- Player
player.name = "player1"

-- Attributes
attributesTable.health = 50
attributesTable.strength = 5
attributesTable.agility =4
attributesTable.intellect =3


-- And finaly, I declare a field attributes for my player.

player.attributes = attributesTable

```

Let's see the result

```

print("A new player is created named ".. player.name)
print("Attributes")
print("health "..player.attributes.health)
print("strength "..player.attributes.strength)
print("agility "..player.attributes.agility)
print("intellect "..player.attributes.intellect)
```
```
A new player is created named player1
Attributes
health 50
strength 5
agility 4
intellect 3

```

Here we go ! Now we have a player table with two fields : name (string) and attributes (table). 



### Referenced values
	Back to our example in the introduction . `The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?`
	Remember `There are eight basic types in Lua: nil, boolean, number, string, function, userdata, thread, and table. ....`
	
	But `Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them`
	
```
local string1 = "hello"
	
-- I declare two differentes table
local myTable = {}
local myTable2 ={}

-- I declare a new field `myString` in myTable, and it's equal to string1, BUT because string1 is a string, the value is copied in my new field
myTable.myString = string1

print("myTable.myString == "..myTable.myString)


-- Now I want myTable2 to be equal to myTable. If you remember, myTable2 will have the same reference as myTable, IT IS NOT a copy

myTable2 = myTable

-- Because table working with reference actually myTable and myTable2 are equal. It means both reference to the area in the memory

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
:warning: `There are eight basic types in Lua: nil, boolean, number, string, function, userdata, thread, and table. ....`

:warning: `Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them`


```

