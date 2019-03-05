# Reduce (fold)

In previous sections we discussed many methods for iterating over data and transforming it.
In this section we'll discuss another higher order function that is arguably one of the most powerful.
It is a concept recognized across enough programming languages to get its own [wikipedia article](https://en.wikipedia.org/wiki/Fold_(higher-order_function).
Most popular languages call it **reduce**, although some languages will call it *fold* or *inject*.
Here's the parameters it takes, and although the order of the parameters may be different in other languages the functionality and output will be the same.

```
reduce(list, fn, starting_value)
```

Like with `map()` and `filter()`, it takes a list you want to transform and a function (`fn`) to do the transformation.
The transformation function behaves like a recursive loop like seen in the last section.
Here's a function that takes a list of numbers and gives you the total sum of those numbers.

```lua
local list = {23, 63, 12, 48, 3}

local sum_fn = function(accumulator, current_number)
  return accumulator + current_number
end


local total_sum = reduce(list, sum_fn, 0)
```

We pass reduce a starting number of `0`.
What happens is `sum_fn` is invoked with the first parameter, the `accumulator` being the starting number 0 and `current_number` being the first number in the list.
Whatever value the function returns becomes the new value for `accumulator` next loop around.

Lua doesn't have a reduce function built in so we'll implement our own here with a detailed description of all the parameters.
Try not to get too hung up on the actual reduce function's implementation at the top, but rather focus below that on how it works.
There will be several more examples.
Once you understand how to use it, go back to the top and look at the actual `reduce` function's implementation.
Copy all this code into the text editor window on the REPL and run it:

```lua
-- Applies fn on two arguments cumulative to the items of the array t,
-- from left to right, so as to reduce the array to a single value. If
-- a first value is specified the accumulator is initialized to this,
-- otherwise the first value in the array is used.
-- @param {table} t - a table to reduce
-- @param {function} fn - the reducer for comparing the two values
--   @param {*} acc - The accumulator accumulates the callback's return
--     values; It is the accumulated value previously returned in the
--     last invocation of the callback, or `first_value`, if supplied.
--   @param {*} current_value - The current element being processed in the list.
--   @param {number} current_index - The index of the current element
--     being processed in the list, starting at 1.
-- @param {*} first_value - The initial value of the accumulation. If the array is
--   empty, the first_value will also be the returned value. If the array is empty
--   and no first value is specified an error is raised.
-- @example
--   -- returns 'zxy'
--   reduce(
--     { 'x', 'y' },
--     function(a, b) return a + b end,
--     'z'
--    )
local function reduce(t, fn, first)
  local acc = first
  local starting_value = first ~= nil
  for i, v in ipairs(t) do
    -- No starting value, start on
    -- the first element in the list
    if starting_value then
      acc = fn(acc, v, i, t)
    else
      acc = v
      starting_value = true
    end
  end
  assert(
    starting_value,
    'Attempted to reduce an empty table with no first value.'
  )
  return acc
end

local list = {23, 63, 12, 48, 3}
local sum_fn = function(accumulator, current_number)
  print(accumulator)
  return accumulator + current_number
end

local total_sum = reduce(list, sum_fn, 0)
print('The total sum is:', total_sum)
```

Following the `print` statement inside of `sum_fn`, we can see that the `accumulator` starts out with the 0 we pass in.
We add `current_number` to `accumulator` and it begins to *accumulate* all the values as it goes.

```
0
23
86
98
146
The total sum is:   149
```

If we don't pass in a starting number, the accumulator will begin right away with the first number in the list:

```lua
local sum_fn = function(accumulator, current_number)
  print(accumulator)
  return accumulator + current_number
end

local total_sum = reduce(list, sum_fn)
```

```
23
86
98
146
The total sum is:   149
```

If you've used javascript, you may be starting to see the uncanny resemblance it bears to [javascript's reduce function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce).
Both languages are very similar syntactically, and given the ubiquity of javascript this Lua implementation follows much of the same behavior.

Let's look at some more examples to better understand how to reduce and what situations doing so could prove useful.
The reduce function is omitted in the following examples, but you can copy and paste the function in the REPL alongside the examples to run the code yourself.

```lua
-- Concatenate a list of words
local list = {'this', 'is', 'a', 'sentence'}

local sentence = reduce(list, function(acc, word, index, list)
  -- Add a period if this is the last word
  if index == #list then
    word = word .. '.'
  end
  -- Otherwise add a space between the words
  return acc .. ' ' .. word
end)

print(sentence)
```

```
this is a sentence.
```

```lua
-- Only keep odd numbers
local list = {23, 63, 12, 48, 3}
local odd_numbers = reduce(list, function(acc, current_number)
  if current_number % 2 == 0 then
    return acc
  end
  acc[#acc + 1] = current_number
  return acc
end, {})

for key, value in ipairs(odd_numbers) do
  print(value)
end
```
```
23
63
3
```

This looks similar to what we might do with the `filter` function previously covered in [3.3 - Map and filter](03-03-map-and-filter.md).
In fact, we can compose `filter` and `map` from `reduce`.
Take a look at the same code refactored out:

```lua
local filter = function(list, predicate_fn)
  return reduce(list, function(acc, val, i, t)
    if predicate_fn(val, i, t) then
      acc[#acc + 1] = val
      return acc
    end
    return acc
  end, {})
end


-- Only keep odd numbers
local list = {23, 63, 12, 48, 3}
local odd_numbers = filter(list, function(current_number)
  return current_number % 2 ~= 0
end)

for key, value in ipairs(odd_numbers) do
  print(value)
end
```

An example of wrapping `reduce` with a new `map` function won't be explained here, but rather left up to the reader as an exercise at the end of this section.

Here's one more example that is a bit more complex, a function called `compose` that creates a pipeline for passing data through.
It accomplishes this by passing any functions you give it through to `reduce` as a list:

```lua
-- Function that allows you to compose other functions
-- together to form a pipeline. The resulting pipeline
-- is a function that you can pass your intended data through.
local compose = function(...)
  -- "..." and "arg" are special keywords in Lua.
  -- See: https://www.lua.org/pil/5.2.html
  local fns = arg
  return function(x)
    return reduce(fns, function(acc, v)
      return v(acc)
    end, x)
  end
end

-- Some example composable functions
local add = function(x)
  return function(y)
    return y + x
  end
end
local multiply = function(x)
  return function(y)
    return y * x
  end
end
local subtract = function(x)
  return function(y)
    return y - x
  end
end


local number_pipeline = compose(add(12), multiply(2), subtract(9))
print(number_pipeline(3))
print(number_pipeline(2))
```

## Alternative reduce implementations

### Iterating tables

Let's go back to the implementation of reduce for a moment.
Take a look at the implementation of it given above.
Notice the iteration inside is using `ipairs` which expects an array/list-type table.
If we wanted to reduce a non-list table we could modify `reduce` to first check if the table is an array and do appropriate iteration over the table whether or not it is.
Let's test that:


```lua
local function reduce(t, fn, first)
  local get_iterator = function(t)
    if type(t) == 'table' then
      -- If property of 1 is empty then
      -- iterate as a regular keyed table
      if t[1] == nil then
        return pairs(t)
      end
      return ipairs(t)
    end
    error('Expected table, got ' .. tostring(t))
  end
  local acc = first
  local starting_value = first ~= nil
  -- Whether we do ipairs or pairs is conditional
  for i, v in get_iterator(t) do
    -- No starting value, start on
    -- the first element in the list
    if starting_value then
      acc = fn(acc, v, i, t)
    else
      acc = v
      starting_value = true
    end
  end
  assert(
    starting_value,
    'Attempted to reduce an empty table with no first value.'
  )
  return acc
end


local list = {
  monday = 23,
  tuesday = 63,
  wednesday = 12,
  thursday = 48,
  friday = 3
}
local total_sum = reduce(list, function(acc, current_number, key)
  print(key .. ': ' .. current_number)
  return acc + current_number
end)

print('total sum: ' .. total_sum)
```

This should print something like this:

```
wednesday: 12
friday: 3
thursday: 48
monday: 23
total sum: 149
```

Note that the order the keys are iterated in are not guaranteed.
Also "tuesday" wasn't printed out because it was the starting number, but it was still included in the total.
Passing an extra argument of `0` to `reduce` would have caused all the days to be passed through our reducer function and printed out.

### Break early

Ok, here's another example that seems tricky at first glance;
Let's say you implemented some search functionality on top of reduce like this:

```lua
local list = {23, 63, 12, 48, 3}

local find = function(list, predicate_fn)
  return reduce(list, function(acc, v, i, t)
    if predicate_fn(v, a, t) then
      return v
    end
    return acc
  end)
end

print(find(list, function(val)
  return val > 50
end))
print(find(list, function(val)
  return val % 8 == 0
end))
```

Which prints out the expected results:

```
63
48
```

But do you see what's problematic about this?
If we find the results we want, the reduce function will keep running through the entire list unnecessarily.
Typically when doing a search you only want the first item you find anyway, but the above implementation will return the last item found if more than one match is made.
Do you remember how the reduce function passes in the table as the last argument to the reducer function?
We can take control of iterator via the table and kill the iteration prematurely.
This involved mutating the table:

```lua
local list = {23, 63, 12, 48, 3}

local find = function(list, predicate_fn)
  return reduce(list, function(acc, v, i, t)
    if predicate_fn(v, a, t) then
      -- If a result was found, destroy the next item in the list
      -- to prevent the iteration from going any further.
      t[i + 1] = nil
      return v
    end
    return acc
  end)
end

print(find(list, function(val)
  return val > 1
end))
```

This returns the correct result:

```
23
```

But if we loop over the table afterwards we can see we've messed with the original data which can lead to unexpected consequences in a real application.
If your data is coming from an immutable source, meaning something is generating a new copy each time you use it then this wouldn't be a problem:

```lua
local generate_list = function()
  return {23, 63, 12, 48, 3}
end

reduce(generate_list(), function()
  ...
  ...
```

However we could fix all of this if we are willing to add another parameter to our reduce implementation.

```lua
local function reduce(t, fn, first)
  local get_iterator = function(t)
    if type(t) == 'table' then
      -- If property of 1 is empty then
      -- iterate as a regular keyed table
      if t[1] == nil then
        return pairs(t)
      end
      return ipairs(t)
    end
    error('Expected table, got ' .. tostring(t))
  end
  local acc = first
  local starting_value = first ~= nil
  for i, v in get_iterator(t) do
    -- Exit the loop when true
    local should_break = false
    -- No starting value, start on
    -- the first element in the list
    if starting_value then
      acc, should_break = fn(acc, v, i, t)
      if should_break then
        break
      end
    else
      acc = v
      starting_value = true
    end
  end
  assert(
    starting_value,
    'Attempted to reduce an empty table with no first value.'
  )
  return acc
end
```

Now if we pass `true` as a second return parameter then we will get the first number we are looking for instead of the last.
Loop through and print out the list afterward to make sure we haven't mutated it unexpectedly.

```lua
local list = {23, 63, 12, 48, 3}

local find = function(list, predicate_fn)
  return reduce(list, function(acc, v, i, t)
    if predicate_fn(v, a, t) then
      return v, true
    end
    return acc
  end, false)
end

print(find(list, function(val)
  return val > 1
end))

for idx, val in ipairs(list) do
  print(idx, val)
end
```

### reduce_right

Another possible change you would want to make is to replace the iterator with a custom-made one to transform data in a specific order or pattern.
Taken from lua-users.org's [Iteration Tutorial](http://lua-users.org/wiki/IteratorsTutorial) is this reverse-ipairs (`ripairs`) implementation that allows you to iterate over a table from right to left.
This modified version of `reduce` is typically called `reduce_right`.

```lua
local function reduce_right(t, fn, first)
  local ripairs = function(t)
    local max = 1
    while t[max] ~= nil do
      max = max + 1
    end
    local function ripairs_it(t, i)
      i = i-1
      local v = t[i]
      if v ~= nil then
        return i,v
      else
        return nil
      end
    end
    return ripairs_it, t, max
  end
  local acc = first
  local starting_value = first ~= nil
  for i, v in ripairs(t) do
    -- Exit the loop when true
    local should_break = false
    -- No starting value, start on
    -- the first element in the list
    if starting_value then
      acc, should_break = fn(acc, v, i, t)
      if should_break then
        break
      end
    else
      acc = v
      starting_value = true
    end
  end
  assert(
    starting_value,
    'Attempted to reduce an empty table with no first value.'
  )
  return acc
end
```

Then swap out `reduce` for `reduce_right` in the places you want to use it:

```lua
local list = {23, 63, 12, 48, 3}

local find = function(list, predicate_fn)
  return reduce_right(list, function(acc, v, i, t)
    if predicate_fn(v, a, t) then
      return v, true
    end
    return acc
  end, false)
end

print(find(list, function(val)
  return val > 1
end))
```

### Recursive

Since we talked about recursion in the last section, let's try a recursive implementation of `reduce`.
Although with Lua there's no practical reason to choose a recursive implementation over a for-loop or while-loop implementation, doing recursion is fun.

```lua
local function reduce(t, fn, acc, key)
  -- Check for starting value
  if key == nil and acc == nil then
    key = next(t, key)
    acc = t[key]
  end
  -- Begin next iteration. Next is a Lua built-in function
  -- that fetches the next key in a table after the given key.
  -- See: https://www.lua.org/pil/7.3.html
  key = next(t, key)
  -- Return acc if we've iterated all keys
  if key == nil then
    return acc
  end
  local break_early = false
  -- Collect new accumulator from predicate function
  acc, break_early = fn(acc, t[key], key, t)
  -- Check to see if the predicate wants to end early
  if break_early then
    return acc
  end
  -- Recur
  return reduce(t, fn, acc, key, acc)
end


-- Test it by getting the total sum from a table like before
local list = {
  monday = 23,
  tuesday = 63,
  wednesday = 12,
  thursday = 48,
  friday = 3
}
local total_sum = reduce(list, function(acc, current_number, key)
  print(key .. ': ' .. current_number)
  return acc + current_number
end, 0)

print('total sum: ' .. total_sum)
```

This supports breaking early like the two previous implementations.

## Exercises

- Create a `count` function that counts up the number of items in a list that match the predicate and returns the total. It should work like this:

    ```lua
  local count = function(list, predicate_fn)
    ????
  end

  local list = {23, 63, 12, 48, 3}
  -- Print number of items evenly divisible by 3 (should return 4)
  print(count(list, function(v)
    return v % 3 == 0
  end))
    ```

- Go back to the [map section in 3.3](03-03-map-and-filter.md#map) and see if you can reimplement the `map` function on top of `reduce`.
