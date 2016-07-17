---
layout: post
title:  "Understanding ES2015 Imports and Tree Shaking"
date:   2016-07-17 01:28:00 +0100
categories: javascript
---
One of the main features of ES2015 was the re-worked module system and with that came the keyword import. This is *easily* one of the most used features in JavaScript, so I thought I’d clear some things up. In this post I will be explaining how to use imports effectively by outlining the differences between them and the older require syntax and take a look into tree shaking and why it matters.

## Imports
Imports are used to import other pieces of code that the working file depends on. They are generally used at the top of the working file, making it obvious to other developers what code is used throughout the file. This syntax is similar to Python and Java and works the same way.

{% highlight javascript %}

import router from ‘myRouter’;
import calc from ‘calc’;
etc...

{% endhighlight %}

Using this format we can componentize our application, a major benefit to any application that grows in size and the basis of the whole JavaScript open source ecosystem.

At first glance, the import statement just looks like syntactic sugar for the require statement used in AMD and CommonJS modules. However it goes a bit deeper than that, and that’s where tree shaking comes in. But first let’s tie up the module system by creating something to export. To be able to import a module, an export needs to be created first.

## Exports

{% highlight javascript %}

// myRouter.js
export function sum(x, y) {
	return x + y;
}

export default function product(x, y) {
	return x * y;
}

{% endhighlight %}

This is one way of writing it, the other way is my preferred way, and that is writing the export statements at the bottom of the file. This allows someone to scroll to the bottom and see exactly what has been exported out for use quickly.

{% highlight javascript %}

// myRouter.js
function sum(x, y) {
	return x + y;
}

function product(x, y) {
	return x * y;
}

export ( sum );
export default product;

{% endhighlight %}

Somethings to note here, and this is important as it trips people up a lot. There are two rules:

1. The syntax `import <module-name> from ‘module-location’;` is only relevant to the default export.
2. The syntax `import { <module-name> } from ‘module-location’;` applies to all other exported code.

So, using the example above, I could import those functions like so:

{% highlight javascript %}

import { sum } from ‘myRouter’;
import default from ‘myRouter’;

{% endhighlight %}

Note that the default export’s name doesn’t have to match: the transpiler knows it is the product export as it doesn’t have curly braces around it. You can also just do it in one line:

{% highlight javascript %}

import default, { sum } from ‘myRouter’;

{% endhighlight %}

## Tree Shaking
That’s all well and good, but I did mention this wasn’t just syntactic sugar for the require syntax, and does provide a real benefit. Tree shaking is that benefit.

Tree shaking refers to only importing specific pieces of code from a file. Previously, using the require syntax, this was not possible, When you required another file, you pulled in the whole file and had access to everything. This wasn’t good for a modular system as authors of packages had to be careful about where they asked users of their package to require things, as if they built it in a monolithic way, the user and therefore app would have a huge amount of code imported. This could slow down apps, not in a major way, but in a way that required a solution.

Imports and ES2015 solve this problem with the above syntax. Now, as an author of a package, I can write all my code in one file, and export the bits the user will need at the bottom of the file, or inline with the function declaration. As the name suggests, you are shaking the tree down, only grabbing what you actually need from that package.

Here’s to a more modular community.

Cheers, CR.
