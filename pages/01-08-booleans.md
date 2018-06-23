# Booleans

Data types are like elements on the periodic table.
The more elements you have the more chemicals can create.
Luckily there aren't as many data types as there are elements.
In fact we've learned almost all of them.
There are only two possible booleans:

```lua
true
```

and

```lua
false
```

That's right.
And you can assign them to variables just like numbers, strings, nil, and functions:

```lua
myboolean = true
print(myboolean)
```

The cool thing with numbers and strings is you can use them to create statements that can be evaluated as `true` or `false`.
Let me give an example by introducing some new operators.
Try these out in the REPL:

```lua
5 > 3
```
```
=> true
```
```lua
5 < 3
```
```
=> false
```

"5 *is greater than* 3" is a true statement so it returns a `true` boolean.
Naturally, "5 *is less than* 3" is a false statement and returns `false`.
We can check to see if two numbers are equal in value:

```lua
number = 5
number == 5
```
```
=> true
```
By using a double equal (`==`) we can compare the *equality* of two numbers.
This also works for strings:
```lua
"hello" == "hello"
```
```
=> true
```
```lua
"hello" == "HELLO"
```
```
=> false
```

For strings, often time you will see single quotes `' '` (apostrophe) used instead of regular quotes (sometimes called double quotes) wrapper around the text.
Lua doesn't care as long as the text inside both strings are identical.
We can prove that with an equality check:

```lua
'hello' == "hello"
```
```
=> true
```


Anyways, you can also do the inverse of an equality check and check for inequality (if two things are *not* equal):

```lua
5 ~= 3
```
```
=> true
```
```lua
"HELLO" ~= string.upper("hello")
```
```
=> false
```

Now let's dig in a little deeper with two more operators.
First is the `and` operator:

```lua
3 < 4 and 4 < 5
```
```
=> true
```

This reads out almost as plain English. 3 *is less than* 4 **and** 4 *is less than* 5.
This is a logically sound statement so it evaluates to true.
Just to be clear on what's actually going on here though, let's break it down.
What we said is being grouped into 3 separate operations:

```lua
(3 < 4) and (4 < 5)
```

The two sets of parenthesis are evaluated first and internally the computer breaks these two operations down to:

```lua
(true) and (true)
```

True and true are both true.
This sounds silly, but it is indeed logically sound.
Let's try one more just to get the hang of it:

```lua
"hello" == "hello" and 6 > 10
```

Finally, let's try one more operator to put a bow on things.
Sometimes we don't care that both operations are correct.
We only care if one `or` the other is correct.

```lua
4 == 10 or 4 ~= 10
```
```
=> true
```

```lua
1 > 100 or 12 == 12 or "hello" == "bananas"
```
```
=> true
```

As long as one of the operations is correct, the entire statement is logically true.
With the introduction of `true` and `false` we've brought in a lot of new operators: "greater than" (`>`), "less than" (`<`), "equal" (`==`), "not equal" (`~=`), "and" (`and`), and "or" (`or`).

## Trivia

Booleans get their name from [George Boole](https://en.wikipedia.org/wiki/George_Boole) who invented [boolean algebra](https://en.wikipedia.org/wiki/Boolean_algebra), which we've just seen a little bit of.

## Exercises

- Try writing different statements with all the new operators.
- Try using two `and` operators in the same statement and see if you can make it evaluate to `true`.
- Try out these two bonus operators with some numbers: "greater than or equal to" (`>=`), and "less than or equal to" (`<=`).
