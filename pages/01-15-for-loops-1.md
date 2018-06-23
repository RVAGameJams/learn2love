# For loops (part 1)

We saw previously that we could use while loops for many things, but we also saw how easy it was to make a while loop that didn't run properly.
The programmer has to make a variable to pass to the condition, make sure the condition is written out correctly, and then make sure the condition can be changed so the loop can eventually end.
This many steps each time we want to write a simple loop leaves us prone to errors and wasting our time.
With *for loops*, we can tell a loop exactly how many times we want it to run and skip all these steps.

## Numeric for loops

```lua
for number = 1, 10 do
  print(number)
end
```

On the first line we are saying "For [starting number] through [ending number] do the following".
The `number = ` is a variable you are assigning the starting number to.
The variable name can be whatever you want.
The second line is the body of the loop and the third line ends the loop.
If you run this program, it will print the numbers `1`, `2`, `3`... through `10` as `number` is being incremented by 1 with each loop.
This variable is a bit peculiar though, not only because we defined it in the middle of a statement but because it disappears after we are done with the loop.

```lua
for number = 1, 10 do
  print(number)
end

return number
```
```
=> nil
```

This is called a *local variable*, because it only exists locally within the for loop.


For loops actually have 3 parameters:
- start number - we assign the variable to it and the variable will increment with each loop
- stop number- the last number to increment to before stopping the loop
- step - how much to increment by with each loop. If we don't specify a step size it will default to 1.

Let's say we wanted to print out only even numbers.
We could change the starting number to 2 and set the size of the step (3rd parameter) to 2:

```lua
for number = 2, 10, 2 do
  print(number)
end
```

If we wanted to *iterate*, or loop over and read each item in a list, it would look similar to a while loop.
Let's look at the while loop example again just for comparison:

```lua
items = {'a', 'b', 'c', 'd'}
index = 1

while index <= #items do
  print(items[index])
  index = index + 1
end
```

```lua
items = {'a', 'b', 'c', 'd'}

for index = 1, #items do
  print(items[index])
end
```

We could also count down by changing the parameters around and setting the step to a negative 1.

```lua
items = {'a', 'b', 'c', 'd'}

for index = #items, 1, -1 do
  print(items[index])
end
```

In this case the index starts at the position of the last item and stops when it gets to the stop number, 1.

## Exercises

- Modify the previous loop so that it only prints every other item in the list.
