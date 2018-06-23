# Flow control

Typically the computer starts at the top of our script and reads each line down in a sequence.
We make the programs jump around with functions in the mix
Try this out in the text editor:

```lua
print("I'm called 1st")

add = function(a, b)
  print("I'm called 5th")
  return a + b
end

subtract = function(a, b)
  print("I'm called 3rd")
  return a - b
end

print("I'm called 2nd")

subtract(16, 10)

print("I'm called 4th")

add(12, 2)
```

We have a function that is saved to the variable `add` but it isn't invoked until further down in the code.
So in a sense our program has worked its way down the page then jumped back up to the function and worked its way through the body of the function then picked back up where it was before.
In a similar fashion, we can make our program take one path or another depending if the data is `true` or `false`.

```lua
noise = function(animal)
  if (animal == "dog") then return "woof" end
  return ""
end

print(noise("dog"))
print(noise("rabbit"))
```

Let's analyze this function line by line.
The function is called noise and takes an animal name (string) as a parameter.
On the next line it says if "animal is dog" is true then return something special.
We put an `end` at the end of our statement to make it obvious to the computer.
If the statement was false, then `"woof"` does not get returned.
Instead an empty string (`""`) gets returned.
When we invoke the function with the argument "dog" then we get back "woof!".
With "rabbit" we get back silence.
Maybe the rabbit doesn't want the dog to hear where she is.
Let's make our function more versatile by adding more animals:

```lua
noise = function(animal)
  if animal == "dog" or animal == "wolf" then return "woof" end
  if animal == "cat" then return "meow" end
  return ""
end

print(noise("dog"))
print(noise("cat"))
print(noise("rabbit"))
print(noise("wolf"))
```

We have branching paths happening within our function.
If we were to map out these branches it may look something like:
```
 |
 +--> "woof"
 +--> "meow"
 |
 +--> ""
```

There's no requirement that a statement has to be all written out on one line.
Sometimes when doing multiple things inside an *if statement* we may want to put it on multiple lines:

```lua
if my_age > 17 then
  print("You're an adult!")
  print("Get a job!")
end
```

Similar to functions having bodies, everything between `then` and `end` is considered the body of the if statement.
Sometimes it is necessary for our branches to have forks within them.
Let's say our function takes a language as a second, optional parameter:

```lua
noise = function(animal, language)
  if animal == "dog" or animal == "wolf" then return "woof" end
  if animal == "cat" then return "meow" end
  if animal == "bird" then
    if language == "spanish" then return "pío" end
    return "tweet"
  end
  return ""
end

print(noise("dog"))
print(noise("rabbit"))
print(noise("bird"))
print(noise("bird", "spanish"))
```

The if statement for checking if the animal is a bird is 4 lines long.
Once we find out that the animal is a bird, while still in the body of the if statement, we stop to check and see if the language is set to Spanish.
If it is, we end up inside an if statement within an if statement!
Otherwise we'll return `"tweet"` if the language isn't Spanish.
Maybe mapping out the paths will clear things up:

```
 |
 +--> "woof"
 +--> "meow"
 +-----> "pío"
 |   |
 |   +--> "tweet"
 |
 +--> ""
```

Our code can get unreadable very quickly if we start nesting if statements inside each other.
Fortunately doing so isn't usually necessary.


Let's talk about another aspect of if statements.
Suppose I have two branches of code that are opposite of each other:

```lua
if daytime == true then
  thermostat = 71
end
if daytime == false then
  thermostat = 68
end
```

Rather than writing this out as two if statements and checking the value of daytime twice, I can take advantage of the keyword `else`:

```lua
if daytime == true then
  thermostat = 71
else
  thermostat = 68
end
```

That way if `daytime` is not `true`, it will default to the second branch.
You could read this off almost like a sentence:
"If daytime is true then set the thermostat to 71, otherwise set the thermostat to 68."
Not having to check things twice when doing computations saves us time and makes our program run more efficiently.
Since `daytime` is a boolean in this case, we don't need to check if it is true or false.
We can just pass it to the if statement to be checked for true and false and make our operation even simpler.


```lua
if daytime then
  thermostat = 71
else
  thermostat = 68
end
```

Even simpler now.
"If daytime then set thermostat to 71, otherwise set thermostat to 68."
There's one more feature of if statements we should discuss.
If there is another condition you need to check, maybe several more, you can also use the `elseif` keyword that will get checked.
It's basically like an `if` that skip when the first if passes, or gets checked when the first if fails.
It looks something like this:

```lua
color = "green"

if color == "blue" then
  print("That's my favorite color!")
elseif color == "green" then
  print("Very subtle choice. I like it.")
elseif color == "pink" then
  print("Nice, bold choice.")
else
  print("I don't think that color would match your shoes.")
end
```

Try it out!


## Exercises

- Write out a function that takes 1 parameter named "sides". Make the function return the name of the shape depending on the number of sides (for instance, "triangle"). Try to make the if statement include an `else` at the end to account for everything else that the if doesn't.
