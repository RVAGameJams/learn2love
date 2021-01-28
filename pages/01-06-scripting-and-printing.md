# Scripting and printing

Looking back at the website, (you bookmarked it, right?) we have been using the REPL window pane on the right, but haven't talked about the pane on the left.
This window is just a text editor.
Instead of running the program with each line you type, it allows you to write multiple lines of code before executing it all.
Let's try typing something in it.
Once you are done typing all the code you can click the "Run" button.

```lua
number = 4
number = number + 1
```

But when you click run, nothing happens.
So let's provide another *statement* to our program.

```lua
number = 4
number = number + 1
print(number)
```

Now when you click Run, the text `5` appears in the right-hand pane.
When you told it to run, it read and evaluated each line of the code in sequence.

You can print any type of data, not just numbers:

```lua
print("hello")
```

Remember those other functions we used before?
You can write those inside of a print statement.

```lua
print(string.reverse("hello"))
```

We can even print functions themselves:

```lua
print(string.reverse)
```

And see a memory location of where that function exists:

```
function: 0x1795320
```

This can serve as a unique indentity for that function, which we'll see more of in a later page.

Lua provides this `print` function to allow us to poke around while our program is running.
We can print as many things as we want.

```lua
print("hello")
print("world")
```

## Exercises

- When we pass data into a function, it is called an argument. We passed 1 argument into `print` but it can pass in two, or three, or more. What does it look like when you print multiple arguments?
- When using a text editor along-side the REPL you can run the code without the mouse by pressing 'command + enter' on Mac and 'Ctrl + Enter' on Windows. Does this speed up your learning?
