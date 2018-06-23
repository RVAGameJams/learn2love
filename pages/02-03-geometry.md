# Geometry

If you modified the numbers `400` and `300` in main.lua you will have seen that they move the text.
Realizing that they're some kind of coordinates, let's talk about graphs.

When learning about graphs in geometry class, we learned about an x-axis and y-axis and labeled plotted points along the graph.
If you wanted to mark (-2, -4) then you would find where -2 on the x-axis intersects with -4 on the y-axis.
Knowing that X is horizontal and Y is vertical, if we had (-2, -4) and (1, 2) we could draw it out like this:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [-2, -4],
        [1, 2]
      ]
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "label": "x-axis",
    "domain": [-5, 5]
  },
  "yAxis": {
    "label": "y-axis",
    "domain": [-5, 5]
  }
}
{% endgraph %}

These two points could even be connected to form a 2-dimensional line:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [-2, -4],
        [1, 2]
      ]
    },
    {
      "attr": {
        "opacity": 1,
        "stroke": "blue",
        "stroke-width": 4
      },
      "fn": "2x"
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "label": "x-axis",
    "domain": [-5, 5]
  },
  "yAxis": {
    "label": "y-axis",
    "domain": [-5, 5]
  }
}
{% endgraph %}

Before we get too far on drawing points and lines, let's look back at our function:

```lua
  love.graphics.print("Hello World!", 400, 300)
```

The `400` is the X position and **increasing** it will move the text further to the **right**.
**Decreasing** the X position will move the text further to the **left**.
The `300` is the Y position, one difference between computers and geometry class is data is calculated from top to bottom, so **increasing** the Y position moves the **down** and **decreasing** it moves the data **up**.
Let's take a look at what our game's graph looks like with the point (5, 3) highlighted:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [5, 3]
      ]
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "domain": [0, 8]
  },
  "yAxis": {
    "domain": [0, 8],
    "invert": true
  }
}
{% endgraph %}

Notice that the top-left corner of our screen is (0, 0), so if you tried to draw any points with negative numbers they would be drawn off screen where we can't see them.
Another thing to note is in the game, the coordinates represent how many **pixels** down and to the right we want to draw.
Since computer screens are made of so many pixels, you need to use large numbers to make a noticeable difference.

If we wanted to draw a *polygon* (shape) such as a triangle on this graph, we would have to give three points:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [4, 1],
        [1, 7],
        [7, 7]
      ]
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "domain": [0, 8]
  },
  "yAxis": {
    "domain": [0, 8],
    "invert": true
  }
}
{% endgraph %}

In the same way, we can plot out points in our code and tell it to draw a line to connect the dots.
Let's use larger numbers though.
Rewrite main.lua to look like this:

```lua
love.draw = function()
  love.graphics.polygon('line', 50, 0, 0, 100, 100, 100)
end
```

The numbers in this code can be read off in pairs to identify the coordinates: (50, 0), (0, 100), (100, 100)
LÖVE's physics engine takes the coordinates, starting at the first point and connects them with a line sequentially.
Once it reaches the last point, it draws a line from the last point back to the first to close the shape.

Let's try a rectangle to get some more practice in:

```lua
love.draw = function()
  local rectangle = {100, 100, 100, 200, 200, 200, 200, 100}
  love.graphics.polygon('line', rectangle)
end
```

Notice this time instead of passing the numbers directly into `love.graphics.polygon`, we put them into a list and passed the list in.
Passing in coordinates both ways has the same effect.

Another important thing to think about is if you draw a polygon with 4 or more sides, you need to make sure the points are listed in the correct order.
Consider the following example:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [1, 1],
        [1, 6],
        [6, 6],
        [6, 1]
      ]
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "domain": [0, 8]
  },
  "yAxis": {
    "domain": [0, 8],
    "invert": true
  }
}
{% endgraph %}

If we fed the points into the function in a clockwise or counter-clockwise/anti-clockwise order, the rectangle would be drawn the same either way.
If we fed the points in from cross directions, we may accidentally draw a bow tie:

{% graph %}
{
  "data": [
    {
      "attr": {
        "fill": "red",
        "opacity": 1,
        "r": 2,
        "stroke": "red",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "scatter",
      "points": [
        [1, 1],
        [1, 6],
        [6, 6],
        [6, 1]
      ]
    },
    {
      "attr": {
        "fill": "none",
        "opacity": 1,
        "r": 2,
        "stroke": "blue",
        "stroke-width": 6
      },
      "fnType": "points",
      "graphType": "polyline",
      "points": [
        [1, 1],
        [6, 6],
        [6, 1],
        [1, 6],
        [1, 1]
      ]
    }
  ],
  "disableZoom": true,
  "grid": true,
  "xAxis": {
    "domain": [0, 8]
  },
  "yAxis": {
    "domain": [0, 8],
    "invert": true
  }
}
{% endgraph %}

Creating shapes with unclosed sides don't play well with LÖVE's physics engine as such shapes are not physically possible.
If you try to do this, you may not see the shape you expect, and perhaps nothing will be drawn.

## Exercises

- Take a look at the documentation for the function [love.graphics.polygon](https://love2d.org/wiki/love.graphics.polygon). The example shows the string `'line'` can be swapped for a different parameter. What is it? Try it out and see how it works!
- Try making a polygon with 5 sides.
