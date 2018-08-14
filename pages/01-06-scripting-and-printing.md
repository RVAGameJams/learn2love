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
Ok well now that you are writing a program, you need to *return* data.
So let's provide another *statement* to our program.

```lua
number = 4
number = number + 1
return number
```

Now when you click Run, the text `=> 5` appears in the console.
When you told it to run, it read and evaluated each line of the code, then when it got to the line with `return` on it, the program stopped and returned the value you asked it to return (in this case `5`).
If you write any code after the return statement, it will cause an error when we try to run the program, so the return statement should be the last thing in our file.

```lua
number = 4
number = number + 1
return number
-- This line will cause an error:
number = 10
```

You can return any type of data, not just numbers:

```lua
return "hello"
```

Remember those other functions we used before?
You can write those as part of the return statement.

```lua
return string.reverse("hello")
```

Sometimes when writing programs, we want to poke around and see values while the program is running and not wait until it is done.
This is so common that there is a function that provides this for us.

```lua
print("hello")
return "world"
```

The `print` function takes any data and *prints* the value in the window pane on the right.
```
>  
"hello"
=> "world"
```
So `"hello"` is being printed and `=> "world"` is being returned.
You can invoke functions on the same line when printing if you really want to get crazy:

```lua
print(string.reverse("hello"))
return "world"
```

The `print` function and `return` statement will both come in handy when testing the functions we're going to write.


## Exercises

- When we pass data into a function, it is called an argument. We passed 1 argument into `print` but it can pass in two, or three, or more. What does it look like when you print multiple arguments?
- Fun tip, when using a text editor along-side the REPL you can run the code without the mouse by pressing 'command + enter' on Mac and 'Alt + enter' on Windows. Does this speed up your learning? 
