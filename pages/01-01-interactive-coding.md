# Interactive coding

## What's a REPL?

Programming doesn't take much effort beyond loading up a REPL and just typing.
What is a *REPL*?
It's an interactive window you can type code into and it spits out the results on screen when you hit enter.
It stands for **R**ead-**E**valuate-**P**rint-**L**oop.
These are the 4 things the REPL does:
1. Read the code that was just typed
2. Evaluate, or process the code down into a result
3. Print, or spit out the result
4. Loop... do everything again and again until the programmer is done

It's actually simpler than it sounds.
Let's go to a website with a REPL and try it out: https://repl.it/languages/Lua

You will see two window panes on the website: a light side on the left and dark side on the right.
The right-side is the REPL and is what we're interested in for now.
It has a lot of information that isn't necessarily useful to us at the moment.
Something similar to this:
```
Lua 5.1  Copyright (C) 1994-2006 Lua.org, PUC-Rio
[GCC 4.2.1 (LLVM, Emscripten 1.5)] on linux2
```

This is just telling you what programming language this REPL is loading, in this case, Lua.
If you click inside the window pane and start typing you will see your text appear.

Let's try typing some code for the REPL to **R**ead.
You already know some code if you know arithmetic.
Type:

```lua
2 + 2
```

Then hit ENTER and immediately the REPL will **P**rint out:

```
=> 4
```

A lot happened very quickly.
After hitting ENTER, the REPL, **R**ead the line `2 + 2`, it **E**valuated the value of that statement to be `4`, it **P**rinted 4 on the screen for you, then **L**ooped back to a new line to await your next command.
Try out some more arithmetic.
Multiplication:

```lua
2 * 3
```

Subtraction:

```lua
2 + 2 - 4
```

Division:

```lua
6 / 2
```

You can use parenthesis to tell it which order to do the operations:

```lua
(2 + 2) * (3 + 1)
```

Which gives different results than:

```lua
2 + 2 * 3 + 1
```

If you give the REPL a single number:

```lua
12
```

It will give you back `12`, because this can't be simplified down any further.

You can also do exponents using the `^` (caret) symbol:

```lua
2^4
```

Numbers are a type of data, and `+`, `-`, `/`, `*`, `^`, `%` are operators.
Statements such as `2 - 2` and `23 * 19` are all operations.


One last arithmetic operation we'll cover is modulo, which is done with the modulus operator.
The modulus operator is represented in most languages as a `%` (percent) symbol:

```lua
8 % 3
```

Modulus operations aren't seen in grade school classrooms as often as the rest, but are quite common in software and computer sciences.
The way it works is you take the 2nd number and subtract it from the bigger number as many times as possible until the 1st number is bigger than the 2nd.
The result is what's left of the 1st number.
With `8 % 3`, if you keep subtracting `3` from `8` then you end up with `2` left.

A real world example is time elapsing on an analog clock.
Imagine the face of a clock with the hour hand on noon.
If 25 hours pass then the hour hand goes all the way around and ends on 1.
That would be the same as saying:

```lua
25 % 12
=> 1
```

The hour hand resets every time is passes 12, so `13 % 12`, `25 % 12`, and `37 % 12` would all equal `1`.
Likewise, `10 % 4` results in `2` because 4 goes into 10 twice, and leaves a remainder of 2.

## Exercises

- Try typing different modulo operations in and guessing what the answer will be.
- Try using negative numbers (`-3 + -2`).
- Try using a set of parenthesis inside another set of parenthesis. Does it behave as you expect?
- After running through all the exercises press the 'up' key in the REPL. What happens and how can this speed up your work?

