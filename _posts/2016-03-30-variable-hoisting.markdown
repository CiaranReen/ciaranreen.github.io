---
layout: post
title:  "Variable Hoisting"
date:   2016-03-30 23:02:00 +0000
categories: jekyll update
---
In most languages, mainstream or obscure, variables are run in the order of program execution. This is a standard way for a programmer to think about
his or her code and one of the reasons experienced programmers who are new to JavaScript struggle with variable hoisting.

To put it simply, VH means the compiler takes all the variable declarations and 'hoists' them to to the top of their local scope, be that a function or the global space.

To give an example let's look at this simple function:

{% highlight javascript %}

var alertMessage = 'Hey!';

function alertMe() {
  alert(alertMessage);
  var alertMessage = 'Spanner in the works.';
}
{% endhighlight %}

Looking at the above code, one would surmise that the function `alertMe` would return an alert saying `Hey!`. However, what is actually returned is
`undefined`. Yup, this a highly annoying and difficult to find bug in your code, especially if this is a more complicated function call.

So, what's going on? Well, as said before the declaration of the variable is hoisted to the top, so when the code gets compiled, it actually looks like this.

{% highlight javascript %}

var alertMessage = 'Hey!';

function alertMe() {
  var alertMessage; // undefined
  alert(alertMessage); // undefined :(
  alertMessage = 'Spanner in the works.';
}
{% endhighlight %}

That clearer? Now when the function gets called we can see the variable `alertMessage` has been *declared* but not *initialized*.

For this reason, it is considered good practice to declare all variables at the top of its surrounding scope to avoid hard-to-find bugs.

Take care, JavaScripters.

[jekyll-docs]: http://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
