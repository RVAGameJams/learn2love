# Primitives, composite data types  and referenced values


## Introduction

```Lua
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
In chapter 1 we learned about comparing string with the == operator when we talked about booleans.
Let's run the code in the repl and try it out:  

```
    true
    true
    false
    false
```  

The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?

First let's see the two most common data types in programming .
	
	
### Primitves data types
Primitives data types are built in the language.
Remember from the first chapter, the types ares 

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


These types are the primitives. They are uncheangeable and any language give specific built in functions that handle operations on it (exception in Lua : Tables, functions, threads, and userdata). For example 
all the common mathematic operations : '+', '-', '==' ... Or function like `print()` . These are the basic tools to build all your program and even
complexe composite data type.



### Composite data types


In Lua there is no composite data such as in other language as C/C++. But table in Lua is a powerful type that can act as composite data type.
Usually composite data type, is a type constructed in a program using the programming language's primitives data types and even other composite types.

Imagine, you need to have a new data type to refer in your program, like a Player data type. That type, will be a composed of multiples primtives types. In my game a player is composed
of :  

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

You can access all the primitives variables from your composite as :
```Lua

local player = playerType

player.health = 50


print("Player's health :")
print(player.health)


```
```Lua
Player's health :
50
```

It's awesome! Now you can create thousands of new players! But how can you know if two variables of playerType, are equals?

The operation :

```
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
   - substraction
   - print
   .
   .
   .
   
   
I hope you understand now, that composite data type, are YOUR types. You have to tell everything in your program : how does it look like, how print it , etc ...

But it's extremely powerfull and less time consuming than if you work with only primitives.



### Referenced values


Back to our example in the introduction . `The strings equal and the numbers equal, but why aren't the tables and functions equal since they are both empty?`
Remember `There are eight basic types in Lua: nil, boolean, number, string, function, userdata, thread, and table.`
But Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them

We will try to understand how it works.

	
```Lua
local string1 = "hello"
	
-- I declare two differentes table
local myTable = {}
local myTable2 ={}

-- I declare a new field myString in myTable, and it's equal to string1, BUT because string1 is a string, the value is copied in my new field
-- In any case if I modified myTable.myString, string1 will not be modified.
myTable.myString = string1

print("myTable.myString == "..myTable.myString)


-- Now I want myTable2 to be equal to myTable. If you remember, myTable2 will have the same reference as myTable, IT IS NOT a copy

myTable2 = myTable

-- Because tables working with references, myTable and myTable2 are equals. It means both reference to the same area in the memory.
-- May be for you memory area is something obscur, but all you have to know is you can have access to a specific space in the memory
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

