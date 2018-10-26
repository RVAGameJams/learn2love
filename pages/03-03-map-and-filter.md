# Map and filter

In the previous section we practiced creating some higher order functions.
In this sections we'll compose two higher-order functions commonly used in internet applications for transforming lists.

We'll start by taking a look at our grocery list to see what items we need to pick up:

```lua
local grocery_list = {
  {
    name = 'grapes',
    price = '7.20',
    location = 'produce'
  },
  {
    name = 'celery',
    price = '5.50',
    location = 'produce'
  },
  {
    name = 'walnuts',
    price = '6.20',
    location = 'baking'
  },
  {
    name = 'sugar',
    price = '8.00',
    location = 'baking'
  },
  {
    name = 'mayonnaise',
    price = '3.50',
    location = 'dressings'
  },
  {
    name = 'cream',
    price = '3.00',
    location = 'dairy'
  }
}
```

This list has more information than we want to see at a quick glance.
If we wanted to only display a numbered list of item names, we could do so by writing a for-loop that generates a new list for us:

```lua
local new_grocery_list = {}
for key, value in ipairs(grocery_list) do
  new_grocery_list[key] = key .. '. ' .. value.name
end

for _, value in ipairs(new_grocery_list) do
  print(value)
end
```

Here we generated a list with a loop then looped over the list again to print our results:

```
1. grapes
2. celery
3. walnuts
4. sugar
5. mayonnaise
6. cream
```

This works great for simple code like this example, but it can get messy if you are working with many lists or if you want to transform lists to different formats.

## Map

Here's our higher order function, `map`.
It takes a list and a function as arguments then returns a new list.

```lua
local map = function(list, transform_fn)
  local new_list = {}
  for key, value in ipairs(list) do
    new_list[key] = transform_fn(value, key)
  end
  return new_list
end
```

A new list is created by looping over each item in the original list, applying your function to the item, then assigning the transformed data to the new list.
Our code can be re-written to use the map function:

```lua
local map = function(list, transform_fn)
  local new_list = {}
  for key, value in ipairs(list) do
    new_list[key] = transform_fn(value, key)
  end
  return new_list
end

local grocery_list = {
  {
    name = 'grapes',
    price = '7.20',
    location = 'produce'
  },
  {
    name = 'celery',
    price = '5.50',
    location = 'produce'
  },
  {
    name = 'walnuts',
    price = '6.20',
    location = 'baking'
  },
  {
    name = 'sugar',
    price = '8.00',
    location = 'baking'
  },
  {
    name = 'mayonnaise',
    price = '3.50',
    location = 'dressings'
  },
  {
    name = 'cream',
    price = '3.00',
    location = 'dairy'
  }
}

local new_grocery_list = map(grocery_list, function(item, index)
  return index .. '. ' .. item.name
end)

for _, value in ipairs(new_grocery_list) do
  print(value)
end
```

Calling `map(...)` we get back the new list then we loop over it again just to print our results out.
Notice how the second argument we passed into map is just a function with no name.
Functions with no names are sometimes called anonymous functions.
In some languages they're called lambdas, especially when used inside a higher-order function in a situation like this.
The transform function takes in the item and its index and must return back a new result for `map` to put inside the new function.

Maybe a few more examples will help out, so what if we want to return another list with just the prices so we can add up how much we need to spend?

```lua
local price_list = map(grocery_list, function(item)
  print(item.price)
  return item.price
end)
```

Here the map function is passed in a transform function with a print statement inside it.
That way it will print the item prices as it builds the list so you can see what each value will be.

If you had other lists for which you wanted to print prices, it could be done quite easily with `map`:

```lua
local transform_fn = function(item) return item.price end

map(grocery_list, transform_fn)
map(car_parts, transform_fn)
map(card_transactions, transform_fn)
```

## Filter

Let's say we wanted to only see the things on our grocery list that are in the baking aisle.
We could write a loop to do that:

```lua
local filtered_list = {}
for _, value in ipairs(grocery_list) do
  if value.location == 'baking' then
    filtered_list[#filtered_list + 1] = value
  end
end

for _, value in ipairs(filtered_list) do
  print(value.name)
end
```

Try running that and once it makes sense, let's think about how to turn this into a re-usable higher-order function like `map`.
We'll make a function called `filter` that, like `map`, takes a list and a function.
The function will return `true` if it wants to put an item in the new list or `false` if it doesn't.
We'll call it the *predicate function*.

```lua
local filter = function(list, predicate_fn)
  local new_list = {}
  for key, value in ipairs(list) do
    -- The predicate_fn that was passed in should return
    -- a value that evaluates to either true or false.
    if predicate_fn(value, key) then
      new_list[#new_list + 1] = value
    end
  end
  return new_list
end
```

And we can use this function to filter down to just our baking items like this:

```lua
local filter = function(list, predicate_fn)
  local new_list = {}
  for key, value in ipairs(list) do
    if predicate_fn(value, key) then
      new_list[#new_list + 1] = value
    end
  end
  return new_list
end

local grocery_list = {
  {
    name = 'grapes',
    price = '7.20',
    location = 'produce'
  },
  {
    name = 'celery',
    price = '5.50',
    location = 'produce'
  },
  {
    name = 'walnuts',
    price = '6.20',
    location = 'baking'
  },
  {
    name = 'sugar',
    price = '8.00',
    location = 'baking'
  },
  {
    name = 'mayonnaise',
    price = '3.50',
    location = 'dressings'
  },
  {
    name = 'cream',
    price = '3.00',
    location = 'dairy'
  }
}

local filtered_list = filter(grocery_list, function(item)
  return item.location == 'baking'
end)

for _, value in ipairs(filtered_list) do
  print(value.name)
end
```

Notice our predicate function we wrote:

```lua
function(item)
  return item.location == 'baking'
end
```

The operation after the `return` always returns a boolean `true` or `false`, so `filter` knows exactly what to do with the item based on those results.

You can imagine the `filter` function could be useful for processing a search query.
For instance, if we wanted to see only medium-sized shirts that fit a specific price range:

```lua
filter(products, function(item)
  if item.type == 'shirt' then
    if item.size == 'M' then
      return item.price < 40
    end
  end
  return false
end)
```

## Caveats

The filter function returns a new list, but the items in the list still reference the old list if they aren't primitives.
For instance if we modified the grocery list, the filtered copy would be updated.

```lua
local filtered_list = filter(grocery_list, function(item)
  return item.location == 'baking'
end)

grocery_list[3].name = 'peanuts'
print(filtered_list[1].name)
```

This behavior can be advantageous if it's expected, but it's something that should be understood about how Lua and similar programming languages work.
This is explained more in [3.1 - Primitives and references](03-01-primitives-and-references.md).

Another thing to consider is whether or not to write the functions yourself or to use a pre-written library you can `require` into your project.
Not all implementations are the same and some may perform better than others, or behave differently.
Some languages have built-in versions of these functions to standardize things.
Unfortunately Lua doesn't provide these functions built in or as a standard library.

At least you now know how to write them yourself if the need arises.

## Exercises

- Try filtering the grocery list to only "produce" items, then mapping those results down to just the names.
- Using `filter`, now can you return the number of items in the grocery list with a price of more than 5? Hint: you will need to use [tonumber()](https://www.lua.org/manual/5.1/manual.html#pdf-tonumber) to convert the item prices to numbers for comparing.
