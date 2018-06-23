# Strings

Numbers are one type of data that can be operated on.
Let's explore another data type within the REPL.
Take a set of quotes and put some text in it and hit ENTER:

```lua
"hello"
```

The REPL will print `hello` back to you.
This is a string.
A string is a set of characters (letters and symbols) *stringed* together as one single piece of data.
This string is made of 9 characters:

```lua
"H-E-L-L-O"
```

Like numbers, there are operators to make strings play with each other.
The *concatenate* operator (`..`) combines strings together:

```lua
"hello" .. "world"
```

What's the result?
Notice that the resulting string has no space between the two words.
If you wanted a space, you would have to put one in the quotes to be part of the operation:

```lua
"hello " .. "world"
```

You could even make a separate string with the space in it:

```lua
"hello" .. " " .. "world"
```

Strings can have any characters in them that you want.

```lua
"abc" .. "123"
```

```lua
"Япо́нский" .. "ロシア語!!"
```

## Exercises

- Try using an arithmetic operator on strings `"hello" / "world"`. What happens?
- Try using the concatenate operator (`..`) on numbers (`1 .. 1`).
