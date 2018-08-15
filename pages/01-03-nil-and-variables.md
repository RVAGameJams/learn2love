# Nil and variables

## Data, or the lack thereof

Humans have different ways of representing a lack of data.
If there are no sheep to count then we have zero sheep.
If there are no words on a page then the page is blank.
In a computer we may represent the number of sheep as `0` or the missing words on a page as an empty `""`.
These are still data though... a number and a string.
In software when you want to represent a lack of data we have:
```lua
nil
```

Sometimes called `null` or `undefined` data in other languages.
It's seemingly useless.
You can't use operators on `nil`.

```lua
nil + nil
```

This will print an error like it did when you tried doing arithmetic on strings.
Let's take a look at variables and we'll discover the purpose of `nil`.

## Variables

Sometimes you want to write out data, but you want that data to be easy to change.
Variables let you give data a name to reference.
Here's an example to try:

```lua
name = "Mandy"
"hello my name is " .. name
```

Since you told it what `name` is, it knows what value to add to the string `"hello my name is "`.
If you type:

```lua
name
```

...and hit ENTER, it will print out the value that belongs to this variable to remind you.
The `=` (equal) sign tells Lua that you want to assign a value to the given name/variable.
You can change the value of a variable and get different results:

```lua
name = "Jeff"
"hello my name is " .. name
```

Assignment isn't the same as it is in Algebra.
You can change the value of a variable multiple times.
We can tell `name` that it equals itself with some additional information *concatenated* to it:

```lua
name = "abc"
name = name .. "def"
name
```

You can assign any type of data to a variable, including numbers:
```lua
name = "Jeff"
age = 16
"hello my name is " .. name .. " and I am " .. age .. "."
```

You can change numbers after assignment too:
```lua
age = 16
age = age * 2
"my age doubled is " .. age
```

So, what if you type in a made up variable name?

```lua
noname
```

You will see it has `nil`, or no data yet.
If you try to use `nil` in your string operation you will get an error:

```lua
"hello my name is " .. nil
```
```
[string "return "hello my name is " .. nil"]:1: attempt to concatenate a nil value
```
```lua
"hello my name is " .. noname
```
```
[string "return "hello my name is " .. noname"]:1: attempt to concatenate global 'noname' (a nil value)
```

Try assigning a value to a variable name:
```lua
best_color = "purple"
```

then assigning that variable data to another:
```lua
worst_color = best_color
worst_color
```

You'll see that both variables now have the value `"purple"`.


Variables can have names made up of letters, numbers and underscores (`_`).
Variable names cannot begin with a number though, otherwise it will think you're trying to type in number data.
Here's some examples of valid variables:

```lua
my_dog = "Poe"
myDog = "Zia"
DOG3 = "Ember"
```

## Exercises

- Try out different variable names. Try a few invalid variables names too just to see what the error message looks like. It's important to see error messages and understand them. They help you understand how a program breaks so you can fix it.
