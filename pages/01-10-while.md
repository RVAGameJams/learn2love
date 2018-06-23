# While

Another way to check conditions is with the `while` keyword.

```lua
while 1 + 1 == 2 do
  print("My math is correct!")
end
```

While a condition is true, the body (everything between the `do` and `end`) will be run repeatedly and not stop.
So if you tried to run that bit of code, your screen probably went crazy printing over and over in a never-ending loop.
We need to make sure the condition can get changed so we're not stuck in a never-ending loop.
Let's write a loop we can escape out of.

```lua
boolean = true

-- This condition will get checked twice. The first time it
-- is checked it will be true and the body of the while-loop
-- will be run. The second time the condition is checked,
-- our boolean will be false and the while-loop won't be run again!
while boolean do
  print("Switching boolean to false.")
  boolean = false
  print("Boolean has been set to false.")
end

print("We made it out of the loop!"
```

Understanding that we can change the *while* condition from inside the body of the loop, we have the power to write programs that end exactly when we want them to.
Can you guess what this will do when we run it?

```lua
countdown = 10

while countdown > 1 do
  print(countdown .. "...")
  -- This line is critical to make our number shrink.
  countdown = countdown - 1
end

print("Blast off!")
```

...And remember to use a `>` and not a `<`, or your loop may never run.

## Exercise

- Come up with your own idea for a while loop.
