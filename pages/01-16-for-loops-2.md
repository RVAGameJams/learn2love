# For loops (part 2)

We can create a different style of for loop using functions, but in order to do that, we need to understand another aspect of functions we haven't yet covered.
Functions can return multiple values.

```lua
sort_numbers = function(a, b)
  if a > b then
    return a, b
  end
  return b, a
end

bigger, smaller = sort_numbers(12, 18)

print(bigger)
print(smaller)
```

This function takes two numbers, checks to see which is bigger, then returns both the bigger number first then the smaller number second.
Notice we did this by putting a comma in the return statement then providing a second value after the comma.
Likewise, we were able to capture both values into variables by putting the first variable name, a comma, then the second variable (`bigger, smaller =`).
We don't need to capture everything returned from a function.
We could have just as easily called the function and only captured the bigger number if that's all we wanted from it.

```lua
bigger = sort_numbers(12, 18)
```

## Generic for loops

Let's take a look at the sibling to the numeric for loop called the generic for loop.
It's called generic for loop because it takes a function that makes it behave in different ways for different situations.
It doesn't do anything on its own.
It relies on the function to tell it how to behave.

### ipairs

Here's what generic for loops look like:

```lua
list = {'dog', 'cat', 'mouse'}
for index in ipairs(list) do
  print(index, list[index])
end
```

`ipairs` takes our for loop and makes it iterate over each item in the list and gives us an `index` variable to work with inside the loop.
But wait, there's more!
`ipairs` provides us with another variable that holds the value of the item at that index.
Try it out yourself:

```lua
list = {'dog', 'cat', 'mouse'}
for index, value in ipairs(list) do
  print(index, value)
end
```

Ah yes, so convenient!
There is one gotcha with doing this.
If you wanted to edit the table from inside the loop, you need to access the table directly:

```lua
list = {'dog', 'cat', 'mouse'}
for index, value in ipairs(list) do
  list[index] = string.upper(value)
end

print(list[1])
```

If you try to just edit the value:

```lua
list = {'dog', 'cat', 'mouse'}
for index, value in ipairs(list) do
  value = string.upper(value)
end

print(list[1])
```

the list won't be modified, because `value` is just a copy of the data that's actually in the list.
You're editing a temporary copy.

### pairs

Another function for programming for loops with special functionality is `pairs`.
This will iterate over every key in a table:

```lua
table = {
  cat = 'meow',
  dog = 'bark'
}

for key, value in pairs(table) do
  print(key, value)
end
```

Even indices:

```lua
table = {
  'a',
  'b',
  'c',
  cat = 'meow',
  dog = 'bark'
}

for key, value in pairs(table) do
  print(key, value)
end
```

No sneaking past `pairs` for any of these keys either:

```lua
table = {
  [1] = 'a',
  [2] = 'b',
  [3] = 'c',
  cat = 'meow',
  dog = 'bark',
  [true] = false,
  [{}] = 'what?'
}

for key, value in pairs(table) do
  print(key, value)
end
```

An easy way to remember the difference between `ipairs` and `pairs` is the "i" in `ipairs` stands for index.
Sure there's a difference when working with weird tables like the one above, but why can't we just use `pairs` for regular list-style tables?

```lua
table = {
  [2] = 'b',
  [3] = 'c',
  [1] = 'a'
}

for key, value in pairs(table) do
  print(key, value)
end
```
```
3   c
2   b
1   a
```

As you can see, the order of the items isn't guaranteed with `pairs`.
`ipairs` is also optimized to handle numeric keys and will generally perform faster, so it's good to know the difference.

### Under the generic-for-loop hood

`ipairs` and `pairs` are just regular functions that we invoke.
They return a function (yes, a function that returns a function!) and this returned function programs our loop to behave how we want.

```lua
for key, value in iterator, list, start_number do
  print(index)
end
```

So this is what a generic for loop really looks like without the help of `ipairs` or `pairs`.
It requires 3 parameters that `ipairs`/`pairs` provides data back to the key and value variables that we can use inside the loop.
`iterator`, `list`, `start_number` are all variables we would otherwise have to define without their help.

- `iterator` would be a function we provide to the loop
- `list` would be what we want to iterate over
- `start_number` would be the starting index in the list

```lua
list = {'a', 'b', 'c'}

iterator, list, start_number = ipairs(list)

for index, value in iterator, list, start_number do
  print(index)
end
```

`ipairs` gives us an iterator to pass to the for loop, as well as our list we already had, and a starting number.
We can print the results of ipairs and see the 3 things it gives us:

```lua
print(ipairs(list))
```
```
function: 0x156a3f0	table: 0x1572aa0	0
```

So to say it again, generic for loops require 3 things: an iterator function, our list, and a number.
In order to not have to write them ourselves, we generated those 3 things by invoking `ipairs` then passing them into the for loop parameters.
Don't fret too much if this seems confusing right now because we're not going to need to write custom for loops or custom iterators.

### Numeric versus generic: which to use?

Numeric for loops are good for simple counting but perform just as well or maybe even better than generic for loops.
Generic for loops are more adaptable.
If you have a situation where either would work, just use whichever you want.
It really won't make any difference.

## Exercises

- Make a list and then write both a numeric for loop and generic for loop that iterate over the list and print each item. Compare the two approaches.
- Make a table with animals for keys and the sounds they make for the key values. Make a for loop that uses `pairs` to iterate over each and change the noises to all capital letters.
