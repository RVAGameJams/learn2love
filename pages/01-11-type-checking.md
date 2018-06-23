# Type checking

Lua doesn't care what type of data a variable has.

```lua
data = 12
data = "hello"
data = true
```

To this end, we can use the `type` function to check what kind of data a variable is holding.

```lua
type(data)
```
```
=> boolean
```

We can check the type of function:

```lua
type(string.reverse)
type(type)
```

We can also use it to check what type of data a function is returning back to us:

```lua
type(string.reverse("hello"))
```
```
=> string
```
```lua
type(type(12))
```
```
=> string
```

## Converting data types

We've already seen data type conversion previously when we took numbers in and operation and transformed that into a true or false statement.

```lua
type(12 > 3)
```
```
=> boolean
```

There are also ways to convert between numbers and strings using `tonumber` and `tostring`.

```lua
number = tonumber("24")
print(type(number))
string = tostring(number)
print(type(string))
```
```
number
string
```

Interesting but maybe less useful, you can convert other data types to string:

```lua
print(tostring("already a string"))
print(tostring(true))
print(tostring(nil))
print(tostring(tostring))
```

## Exercises

- Which of these strings can be converted to a number successfully? `"001"`, `"7.12000"`, `"  5  "`, `"1,943"`
