# Making functions

Functions are the third data type we've seen.
We've accessed some variables where functions were defined for us and had a blast using them (I know I did).
Functions are the building blocks of software.
You can compose them then snap them together like Danish plastic blocks.
It takes time to understand how they work and much longer to master their inner power.
So without further ado, let's see what they actually look like:

```lua
function()
  return 4 + 4
end
```

Type it out in the text editor window and let us break this down line by line and word for word.
Whenever we type `function()` we are beginning a new function.
The 2nd line is the body of our function where things happen.
The body of the function can be many lines long.
The body of the function could also be empty (but that's not very useful).
On the last line of the function body we return data.
This return statement won't end our entire program though!
It will only tell the computer we're finishing up with our function.
Then on the third line, we're telling the computer we're done writing our function.
In order to use this example function, we should probably use a variable to give it a name:

```lua
add = function()
  return 4 + 4
end
```

The first bit should be understandable.
We *declared* a variable called `add`, then we assigned some data to it on the right of the equal sign.
In this case, our function.
Now it is ready to use.

```lua
add = function()
  return 4 + 4
end

result = add()
return result
```
```
=> 8
```

We've made our very own function with our very own name for it and even invoked it and got back data!
If you instead got an error message, double check what you typed that nothing is missing.
Error messages give you a *line number* of where to find the error that crashed the program.

Take a look for a minute at how we invoked our function:

```lua
add()
```

We typed out the variable name that our function is assigned to, followed by some parenthesis.
In those parenthesis is the data that we passed into our function... wait a minute the parenthesis are empty.
We didn't pass any data into our function.
Whenever we called those other functions we passed in data, like when we passed `"hello"` into `string.reverse("hello")`.
What if we modify our line where we invoke our function and give it some data?

```lua
add = function()
  return 4 + 4
end

result = add(16)
return result
```

It seems it always returns `=> 8` no matter what arguments we try to pass in.
We need to rewind to the first line of our function and take a close look at this bit:

```lua
add = function()
```

The `()` at the end of `function()` is where we tell our program how many arguments we are accepting.
If the parenthesis are empty, then our function is ignoring all arguments and will likely always return the same result.
Let's tweak the function slightly and give it one parameter with the name `a`.
Let's also tweak the second line while we're at it:

```lua
add = function(a)
  return a + 4
end

result = add(16)
return result
```
```
=> 20
```

Now when we pass in different numbers, we get different results:

```lua
add = function(a)
  return a + 4
end

print(add(16))
print(add(12))
```

To complete this function, let's give it a second parameter of `b` and modify the return statement in the function body:

```lua
add = function(a, b)
  return a + b
end

print(add(16))
print(add(12))
```

If we try and run the code now, we'll get another error:

```lua
[string "add = function(a, b)..."]:2: attempt to perform arithmetic on local 'b' (a nil value)
```

Let's read this error carefully.
It is saying inside the square brackets that an error occurred when using the function we defined (`add = function(a, b)...`).
To the right of the square brackets it is saying line 2 (`:2`) of our text is the particular location of the crash.
To the right of the line number is what happened that made it crash.
It tried to perform addition with `a + b` but the value of `b` was nil.
We stated that our function requires two parameters now, `a` and `b`, and our program will crash if we try and invoke the function with only one parameter.
Let's modify the lines where we invoke the function to give it two arguments each time we invoke it:

```lua
add = function(a, b)
  return a + b
end

print(add(16, 10))
print(add(12, 2))
```

Great, everything is working again!
With the experience of our first, fully-functional function, we can now start treading the waters of this great world.

## Exercises

- To get used to writing functions, try writing some complimentary functions named `subtract`, `multiply`, `divide`, or `modulate` (modulus).
- Make a `concatenate` function that accepts 2 strings and returns 1 combined string.
- Try making a function that takes 3 or more parameters.
