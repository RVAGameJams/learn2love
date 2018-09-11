# First game

Let's learn about a few new functions and then we'll be able to write our first game!

## Reading input 

Not only can our program print out data, but using the function `io.read` it can take data too.
This function doesn't need any arguments because it will prompt us in the window on the right for us to type in data.

```lua
print("Enter your name:")
name = io.read()

print("Your name is " .. name .. ".")
```

After you click "Run", the program will pause when it runs `io.read()`.
Type your name and hit ENTER and look, the program prints back out the name you gave it.
Notice the last print statement. We combined the name with two other strings to form a sentence.
You can prompt the user multiple times if you need to get additional information:

```lua
print("Enter your name:")
name = io.read()

print("What's your favorite food?")
food = io.read()

print("Your name is " .. name .. " and your favorite food is " .. food .. ".")
```

One limitation with doing this is the data will always come in as a string:

```lua
print("What's your favorite number?")
data = io.read()

print(type(data))
```
```
string
```
In the last section we talked about converting data between different types.
If we wanted to find out whether your favorite number is odd or even, we would need to convert it to an actual number to perform operations on it.
Type this in your text editor and run it:

```lua
print("What's your favorite number?")
data = io.read()
number = tonumber(data)

-- If the user gave us an answer that isn't a
-- number, then the value of "number" is nil.
if number == nil then return "Invalid number." end
if number % 2 == 0 then return "Your number is even." end

return "Your number is odd."
```

## Random number

Many languages give us access to a random number generator.
Randomness is how we generate secure passwords and keys in the real world.
To generate a random number in lua, we use `math.random`:

```lua
math.random(100)
```
```
=> 63
```

This generates a random number between 1 and 100.
Except, if you run the program repeatedly you may notice that it spits out the same number.
That's because nothing in the computer world is random.
If we fed in random noises through a speaker or white noise from an old television set then our computer could use this to generate random numbers.
Since we don't easily have access to those things, we need to *seed* Lua with some *perceived* randomness.

If we run `os.time` we will get the computer's current time in integer form:

```lua
os.time()
```
```
=> 1.529098167e+09
```

This number is hard enough to guess that it will work as a seed for our program.
Let's take the system time and feed it in using `math.randomseed` then from there, Lua will be able to generate a "random" number in the range we want (1-100).

```lua
seed_number = os.time()
math.randomseed(seed_number)
return math.random(100)
```
```
=> 19
```

Success!
It is generated different numbers each time we run it, with no pattern.

## Putting it all together

I should probably explain what this game is.
It's quite simple.
We want the computer to make up a number and the user has to guess what the number is.
If they're wrong, then we should give them a hint and make them guess again.
We can take advantage of the while loop to make them continue guessing while their guess is incorrect.

```lua
-- The computer's secret number
math.randomseed(os.time())
number = math.random(100)

print("Guess what number I am think of. It is between 1 and 100.")

guess = tonumber(io.read())

-- While the user's guess is not equal to
-- the number, repeat the body of the loop.
while guess ~= number do
  -- Give them some hints
  if guess > number then
    print("Your guess is too high.")
  end
  if guess < number then
    print("Your guess is too low.")
  end

  -- Make them guess again and again until they get it
  print("Guess again:")
  guess = tonumber(io.read())
end

-- Winning message
print("You guessed correctly! The number was " .. number .. ".")
```

Let's re-factor one bit of this code to make it easier to read.
When we talked about if statements, remember the keyword `else`?

```lua
-- The computer's secret number
math.randomseed(os.time())
number = math.random(100)

print("Guess what number I am think of. It is between 1 and 100.")

guess = tonumber(io.read())

-- While the user's guess is not equal to
-- the number, repeat the body of the loop.
while guess ~= number do
  -- Give them some hints
  if guess > number then
    print("Your guess is too high.")
  else
    print("Your guess is too low.")
  end

  -- Make them guess again and again until they get it
  print("Guess again:")
  guess = tonumber(io.read())
end

-- Winning message
print("You guessed correctly! The number was " .. number .. ".")
```

Now that things are cleaner, let's add one feature to our program.
It would be more fun if the game kept track of how many guesses we made so we could give them a special message.
Let's create a variable called `guess_count` that will start at `1` and increment every time the user makes another guess.
We'll also go ahead and add some messages to the bottom to praise the user if they did it in a reasonable number of guesses.

```lua
-- The computer's secret number
math.randomseed(os.time())
number = math.random(100)
-- Our starting number of guesses
guess_counter = 1

print("Guess what number I am think of. It is between 1 and 100.")

guess = tonumber(io.read())

-- While the user's guess is not equal to
-- the number, repeat the body of the loop.
while guess ~= number do
  -- Increment the guess counter by 1
  guess_counter = guess_counter + 1

  -- Give them some hints
  if guess > number then
    print("Your guess is too high.")
  else
    print("Your guess is too low.")
  end

  -- Make them guess again and again until they get it
  print("Guess again:")
  guess = tonumber(io.read())
end

-- Winning messages
print("You guessed correctly! The number was " .. number .. ".")

if guess_counter <= 5 then
  print("Amazing! It only took you " .. guess_counter .. " tries.")
else
  print("It took you " .. guess_counter .. " tries. Not bad.")
end
```

## Exercises

- Try adding more messages to the `guess_counter` for different scores.
- Try adding a message to the if statement with the hints for when the user guesses an invalid number. How would you do that?
- Make the condition exit if `guess_counter` goes above 10 and tell the user they lost the game but should try again.
