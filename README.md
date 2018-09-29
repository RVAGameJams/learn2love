# [learn2love](https://rvagamejams.com/learn2love/)

**Current progress:**
- [Chapter 1](https://rvagamejams.com/learn2love/pages/01-00-programming-basics.html) - Programming basics ✔
- [Chapter 2](https://rvagamejams.com/learn2love/pages/02-00-introducing-love.html) - Introducing LÖVE (in progress)
- Chapter 3 - In-depth programming (in progress)
- Chapter 4 - In-depth LÖVE (to do)

## What is this book?

This book teaches programming from the ground up in the context of Lua and LÖVE.
It teaches basic computer science and software building skills along the way, but more importantly, teaches you how to teach yourself and find out how to go about solving a problem or building a solution.
Tools come and go, so the goal is to teach things of value with less focus on the programming language and other tools used to build the software.
I have been programming since 2007, focusing on teaching myself best practices. Along the way I have found a lot of good and bad tutorials on the right and wrong way to build things and I want to help others avoid getting stuck like I did.

## Who is this for?

- **Any age group.** Kids too, with a bit of demonstration, help and encouragement!
- **Anybody that wants to learn basic computer science.** This book will touch on several computer science subjects in order to build programs.
- **Anybody that wants to learn to program.** No prior skills or knowledge required.
- **Anybody that wants to learn to make a game.** Making games are fun and require learning many things along the way. We'll build a few through this book.
- **Anybody that wants to learn Lua.** Although we won't dive into the advanced features of the language, we will gain a large understanding on how the language works in order to actually build some things. There are already online guides and references covering some of the more advanced topics. For experienced programmers wanting to learn Lua, the [Programming in Lua](https://www.lua.org/pil/contents.html) book may be sufficient.

## Author and contributors

- [jaythomas](https://github.com/jaythomas): Original author
- [JimmyStevens](https://github.com/JimmyStevens): Edits and suggestions in chapter 1 & 2

## Contributing

- Issues, comments, and suggestions can be made using the [GitHub issues](https://github.com/RVAGameJams/learn2love/issues) page.
- To download, build, and run the book or any code examples use the "Clone or download" button on the [main repository page](https://github.com/RVAGameJams/learn2love).

### For developers and the curious

Feel free to submit a pull request.
The documentation is built using [NodeJS](https://nodejs.org/en/).
If you wish to run the documentation for local development purposes, install nodejs then run these commands from within the `learn2love` directory you downloaded:

```sh
npm install # Downloads build tools to the a "node_modules" folder inside the directory
npm start   # Creates a local web server to where you can visit the link http://localhost:4000
```

Once the local web server is running, any edits you make to the pages will rebuild the book and reload the page you're viewing.
