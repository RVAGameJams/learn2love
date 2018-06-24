# Tables (part 2)

In the last section we saw how simple it was to make a list.
Working with the list was a little tricky at first but hopefully not too bad.
If we rewind back, we can remember that we created a table by assigning some keys values.

```lua
boxes = {
  [1] = "John Doe",
  [2] = "Amanda Parker",
  [3] = "Tyler Reese"
}
```

Think of it like post office boxes and we label each box with a unique number.
Whenever we reference a postal box, we do so by referencing the number within the array (list) of boxes: `boxes[2]`.
The label, or key, is ultimately arbitrary though.
For making a list, we label things in an incremental order to make them easier to loop over and to give us a sense of linear sequence.
Keys don't need to be numbers.
They could just as well be strings:

```lua
coins = {
  ["half"] = "50 cents",
  ["quarter"] = "25 cents",
  ["dime"] = "10 cents",
  ["nickel"] = "5 cents",
  ["penny"] = "1 cent"
}
```

Which would be accessed just the same way:
```lua
print(coins["nickel"])
```
```
5 cents
```

This can be really useful for doing a lookup if we instead use a variable for the key.
Try this one out:

```lua
coins = {
  ["half"] = "50 cents",
  ["quarter"] = "25 cents",
  ["dime"] = "10 cents",
  ["nickel"] = "5 cents",
  ["penny"] = "1 cent"
}

print("Which coin do you have?")
response = io.read()

print("Your coin is worth " .. coins[response] .. ".")
```

This isn't far off from how certain databases and digital services work.
Items are stored in a unique key that can be referenced for getting a definition out of later.
That's why this data structure is sometimes called a dictionary.
Remember, we can add items to a table after it is defined:

```lua
coins["silver dollar"] = "1 dollar"
```

Another shortcut Lua gives us is we don't need to use the square braces or quotes when adding keys that are strings.

```lua
coins.nickel = "5 cents"
```

The limitation with doing this is the keys defined this way can't have spaces or special characters.
They must be valid in the same way variable names are valid.

```lua
coins.silver dollar = "1 dollar"  -- INVALID
coins.silver_dollar = "1 dollar"  -- Valid
coins.100 = "1 dollar" -- INVALID
```

You can use variable names for keys when creating the table too:

```lua
color = "purple"
description = "the best color"
colors = {
  [color] = description
}

print(colors.purple)
print(colors[color]) -- prints the same thing
```

By convention, strings are typically used for dictionary-like tables while lists are numbers.
Don't make the mistake of thinking these are the same:

```lua
list = {
  1 = "some item",
  ["1"] = "a unique item"
}
```

You could use other data types as keys, but you might find your results to be very unexpected:

```lua
crazy_list = {
  [true] = "works",
  [false] = "works",
  ["true"] = "not the same",
  ["false"] = "not the same"
}

print(crazy_list[true])
print(crazy_list[false])
print(crazy_list["true"])
print(crazy_list["false"])
```

```lua
crazy_key = {}
crazy_list = {
  [crazy_key] = "works"
}
print(crazy_list[crazy_key])
```

```lua
crazy_list = {
  [nil] = "doesn't work!"
}
print(crazy_list[nil])
```

Throws an error:

```
[string "crazy_list = {..."]:2: table index is nil
```

Values in a table can be any type of data, including functions:

```lua
cat = {
  color = "gray",
  smelly = true,
  make_sound = function()
    print("meyuow!")
  end
}

cat.make_sound()
```

# Exercises

- Remember the early function we made that returned the animal sounds? Make a function with a table in it, where each key in the table is an animal name. Give each key a value equal to the sound the animal makes and return the animal sound. Try invoking the function and see if you get back the correct sound.
