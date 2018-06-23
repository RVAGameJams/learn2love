# Using functions

Most programming languages come with some variables already defined for us.
Lua has many, so let's type one in and hit ENTER to see what the value is:

```lua
string.reverse
```
```
=> function: 0x2381b60
```
Oh my.
So "function" is another data type, but what is `0x2381b60`?
It's just telling you where in the computer's memory that function exists, just in case you wanted to know.
Functions work very differently than numbers in strings.
Essentially functions are pre-defined instructions that tell the program how to do different things.
They take data and *return* back different data.
Let's see how to give this function data:

```lua
string.reverse("hello")
```
```
=> olleh
```

At the end of the function's variable name, `string.reverse`, we type a set of parenthesis, `string.reverse()`, and put inside the parenthesis some data we want changed (`string.reverse("hello")`).
Making the function run is often called *invoking* the function.
Having a function that reverses text in a string for us can be useful, and we can capture the return value (the results) of the function using a variable.
Try it out:

```lua
greeting = "hello, how are you?"
backwards_greeting = string.reverse(greeting)
backwards_greeting
```
```
=> ?uoy era woh ,olleh
```

It should be obvious from the name what that function's purpose is.
How about this one?

```lua
string.upper("hello, how are you?")
```

Now try capturing that value by assigning it to a variable:

```lua
greeting = "hello, how are you?"
shouting_greeting = string.upper(greeting)
crazy_greeting = string.reverse(shouting_greeting)
```

We can get crazier.
How about invoking a function when invoking another function??

```lua
string.reverse(string.upper("hey"))
```

What's happening here is the string is being uppercased by `string.upper` but then the value from `string.upper` is being reversed by `string.reverse` as soon as it is done.
It's just like in arithmetic when you have nested parenthesis.
The inner-most parenthesis are resolved before doing the outer-most parenthesis.


Let's try one more function.
This function has two parameters, meaning it accepts two pieces of data which it requires to work properly.

```lua
math.max(7, 10)
```

When giving more than one piece of data to a function, you need to put a comma (`,`) between the parameters

These are great functions, but wouldn't it be great if we could make our own?
We'll give it a shot in just a few pages.

## Exercises

- See if you can figure out what `math.max` does. Give it different numbers and examine the result.
- There is another function called `math.min` that also takes two numbers. What does it return?
