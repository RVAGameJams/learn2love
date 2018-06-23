# Tables (part 1)

Tables are the last data type we'll discuss in this chapter.
Other languages have different names for this data type like "object", "hash", "map" and "dictionary", and the features may vary from one programming language to another.
Tables are used to build *composite data types* like lists, trees, or a big green orc running across the screen.
Composite data types are higher order data structures created from more primitive data types like numbers and strings.
The number of data structures you can create are endless.
We need to learn about a few to not only understand how tables work, but to be able to build any modern software.

The basic syntax for tables is to make a curly brace `{` (same key as the square brace on most keyboards) to start the table, write some data in the table, then put a closing curly brace `}` to end the table.
So an empty table would look like this:

```lua
my_cool_table = {}
```

## Lists

Lists are usually started by writing the first item, then the second, and so on.
If we wanted to make a grocery list in software, it may look like this:

```lua
groceries = {
  [1] = "beans",
  [2] = "bananas",
  [3] = "buns"
}
```

Ok maybe your typical grocery list looks different.
What do we do with this data now that we got it?
We can access and modify the data as if they were stored in their own variables.

```lua
return groceries[1]
```
```
=> beans
```

First we specify the variable name of the table, then in square brackets we put the number we want.
You can access them in any order and modify them as needed:

```lua
print(groceries[3])
groceries[1] = "coffee beans"
print(groceries[1])
```
```
buns
coffee beans
```

The order you define them in doesn't matter:

```lua
groceries = {
  [3] = "beans",
  [1] = "bananas",
  [2] = "buns"
}
```

The number in square brackets is the *key*.
A key that is part of a numeric sequence of keys such as this list is often called an *index*.
So `"bananas"` has an index of `1`.
The plural of index is *indices*.


Don't forget the commas between each item in your list or you will get quite the error message:

```
[string "groceries = {..."]:3: '}' expected (to close '{' at line 1) near '['
```

When you are missing a comma between items, it thinks it has reached the end of the table but then errors out when it goes to close the table but sees another item instead of the close curly bracket `}`.

Another issue you may run into is if you try to access a key that has no data.
There is no 4th item in our table so if we try to access it:

```lua
print(groceries[4])
```

We get back `nil`, the same way we would if we tried to access a variable name that has no data assigned to it.

Writing out large lists can become a headache when we have to manually number each item in a list:

```lua
groceries = {
  [1] = "beans",
  [2] = "bananas",
  [3] = "buns",
  [4] = "blueberries",
  [5] = "butter",
  [6] = "broccoli",
  [7] = "basil"
}
```

What if we remove an item or we want to move something to a different position in the list?
What a pain to have to re-index everything.
Thankfully there is shorthand way of writing lists:

```lua
groceries = {
  "beans",
  "bananas",
  "buns",
  "blueberries",
  "butter",
  "broccoli",
  "basil"
}
```

This is identical to the code written above, except now the indices are auto-generated for me.
`"basil"` has an index of `7` since it is the 7th item in the list, but if I cut and pasted it to the top of my list, it's index would be `1` and everything below it would be renumbered accordingly.

## Looping over lists

If we wanted to print our grocery list, we could say something like:

```lua
print(groceries[1])
print(groceries[2])
print(groceries[3])
print(groceries[4])
-- and so on...
```

But that is quite repetitious and requires updating if the size of our list changes.
Luckily we already know about *while loops*.

```lua
index = 1

while groceries[index] ~= nil do
  print(index, groceries[index])
  -- Go to the next index in the list
  index = index + 1
end
```

See how instead of accessing each item as `groceries[1]`, `groceries[2]`... we can just use a variable in the square brackets instead of a number.
Then inside the loop we bump the number up and access the next item in the list.
The loop stops when the index goes beyond the last item in the list and there is nothing there.
So when index 8 is read, `groceries[8]` is nil and the while condition is no longer true.
While conditions don't even need a boolean expression.
It can know whether or not to continue simply if the given item has data or is nil.
It can be simplified to read:

```lua
index = 1

while groceries[index] do
  print(index, groceries[index])
  -- Go to the next index in the list
  index = index + 1
end
```

Again, it knows to exit when it sees `false` or `nil`.
The caveat to this would be if you a special list with `false` in it:

```lua
groceries = {
  "beans",
  "bananas",
  false,
  "blueberries",
  "butter",
  "broccoli",
  "basil"
}
```

When the while loop gets to the third item in the list and sees `false`, it would stop looping before it reads the rest.
It's not typically a good idea to mix and match different data types in a list because of issues like this, however, we could work around this if we needed to.
There is a special operator for tables to get the size of the list.

```lua
print(#groceries)
```
```
7
```

An easy way to remember the `#` operator is to remember that it returns the # of items in a list.
Using this operator we could write our while loop in a different way.

```lua
index = 1

while index <= #groceries do
  print(index, groceries[index])
  -- Go to the next index in the list
  index = index + 1
end
```

You could even tweak this slightly to read the list backwards if you wanted to:

```lua
index = #groceries

while index > 0 do
  print(index, groceries[index])
  -- Go to the next index in the list
  index = index - 1
end
```

Notice we are subtracting from the index with each loop in order to accomplish this.

## Exercises

- Try to modify the while loop to only print every other item in the grocery list. (Hint: instead of incrementing by 1 on each read, you want to increment more.)
- Write a while loop that counts to 10 and populates an empty table with the same item 10 times. (Hint: you assign to indices just like variables, `list[index] = "hi"`.)
