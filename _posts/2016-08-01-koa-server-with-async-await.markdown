---
layout: post
title:  "Setting up a Koa Server with ES7 support"
comments: true
date:   2016-08-01 09:05:00 +0100
categories: javascript
---

## Intro
Last week, I was tasked with re-writing one of our APIs to use modern JavaScript features. I say modern, what I really mean is bleeding edge. You see, the app in question was using generator functions coupled with yields to produce async code. This is actually pretty modern as it is. Granted, there were more features that weren’t being implemented from the ES2015 spec such as import and such, but this was a simple task, right?

My plan to tackle this was simple: find all generator functions, yield keywords, imports, and various smaller things (such as let where const should be used, etc) and replace them with the appropriate es2015/2016 equivalent.

This should of been straightforward; if you have a single JavaScript generator function and simply replace the syntax with async/await instead, it works.

So I went ahead and started changing everything in the codebase, which wasn’t particularly large. It mainly consisted of lots of endpoints which called various other services across the Sky estate. I regularly ran the app and checked the endpoints to make sure they were working, and they seemed to be.

That is, until I started going higher up the stack, towards the server itself. The server was NodeJS with Koa and Koa Router powering it. As soon as I changed the functions in this file, which was one of the last to change, everything broke.

## To the debugging-mobile!
I scratched my head, played around a bit, like normal. But nothing worked. Ah! To Google! This is obviously a problem lots of other people have come across. All I found though, to my dismay, were a few GitHub issue threads. There were no direct solutions in these though, they were tailored to a particular problem, related to - but not exactly - mine.

Each endpoint in the app should have been returning a JSON object, and all I was getting was Not Found. As soon as I changed the server file back to using ES2015 generators, ta dah! It worked. Something was amiss.

The root of the problem, I soon found, was the this keyword. It gets passed around as context throughout the app, but wasn’t with aysnc/await. The server calls a file called connect.js which requests another file based on the route passed to it. It’s in this file the JSON is loaded, either as plain JSON or through a function call to another file. Logging out this with the generator setup got the router context (correct, now it can load the router information requested), but with async/await I was getting undefined.

## The Solution
By this point I was pulling my hair out. I didn’t know enough about generator functions, let alone async/await, to even have a  starting point. It didn’t help that I hadn’t written this app in the first place either.

In one of the GitHub threads mentioned earlier, I came across some syntax which wasn’t being picked up by my Koa implementation, and that was the ctx parameter passed in to async functions. So I checked out the Koa repo, and BAM! There it was. It turns out I had to update my Koa package to use the latest version of it: Koa2.

It didn’t stop there though, I also had to update Koa Router to version 7. With these in place, I went ahead and passed in the ctx parameter to the various function calls that were previously generator functions.

One thing was biting at me though, how would this change the this context? It surely wouldn’t. It was in another file to the server, after all. I loaded up the app and it was as I thought, I got the same ‘this is undefined’ error.

A bit more googling and I arrived at the final part of the solution. Ctx stands for context. **And in the case of Koa, that is used in place of this to populate context throughout asynchronous applications.**

So I did just that: a simple Find and Replace throughout the application and changed this to ctx. Loading up the app once more - every endpoint worked. I’ve never been so happy to get valid JSON. The fact I’d dedicated so much time to changing all the syntax (when I ran ESLint, I got 366 errors and fixed all of them) it was a real hit to get stuck at the end of the ticket with an obscure problem.

The final product is pretty cool to look through, and is far easier now to maintain, thanks to concurrency through the application. In places it is a lot easier to understand as well, due to refactoring of obfuscated code. Plus we have shiny new features!

Cheers, CR.
