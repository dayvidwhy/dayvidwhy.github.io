---
layout: post
title:  "Loops, Closures and Ajax"
date:   2016-12-30 15:21:00 +1000
categories: blog closure ajax
permalink: loops-closures-and-ajax
---
Scope in JavaScript is one of its more peculiar features that tends to trip up developers as they get started with the language. One issue that came up again and again while I was tutoring last semester was the issue of performing asynchronous callbacks in loops, and why things were acting funny.

# Strange syntax
To be fair, this syntax does come across as strange, and even when I first saw it, I wasn't quite sure how it was solving the problem.

Let's consider the contrived example below where we have an array of elements, and for some reason we are going to make a get request to the index page a number of times asynchronously, and within each loop print the `i`th member of the array from within the callback function. That looks like the following.

```javascript
var items = ['cat', 'dog', 'cow', 'rabbit'];
for (let i = 0; i < 4; i++) {
    $.get('index.html', function(data) {
        console.log(items[i]); // What is i?
    });
}
```

Would you believe that the above example prints out `undefined` four times? Why does it not print out each element of the array as we go through the loop?

# How JavaScript is asynchronous
The issue lies with the fact that we are performing an `XHR` request, which we've abstracted away from ourselves by using jQuery's `$.get`. These requests, if they return, won't execute their function callbacks until the callstack is empty, after our loop is well and truly _over_.

One thing that needs to be understood is that an `XHR` or `$.get` request is asychronous, and most people get that. But what can be confusing is the way the [event loop](https://developer.mozilla.org/en/docs/Web/JavaScript/EventLoop) works and how javascript somehow magically managed to do something asychronously, when it's supposedly a single threaded language.

Essentially once the callstack has cleared, that being our loop has ended and fired off all of the requests, our value of `i` is actually 4. We go through the loop performing 4 asychronous requests, and then once `i` becomes 4 we exit the loop. 

Once the stack is cleared, finished requests are given a chance to execute their callback functions. Since our loop is long finished, `i` is happily holding the value `4` meaning we are trying to look up `items[4]`, which is obviously undefined.

# Solving the problem
There is a well-defined solution to the problem, although performing it can be utterly confusing and to be honest, I have to write out my closures carefully. As we make each `$.get` request in the loop, we need to _rescope_ `i`, so that when our request returns, `i` is what we expect it to be. We sort of make a copy of it, making sure it remains at the correct value for each request.

Closures are an interesting way of forcing variables to take on new scope and ensuring that in the context of your callback function, they are what you expect them to be. The example below correctly prints out each element of the array.

```javascript
var items = ['cat', 'dog', 'cow', 'rabbit'];
for (var i = 0; i < 4; i++) {
    $.get('index.html', (function(i) {
        return function(data) {
            console.log(items[i]);
        }
    })(i));
}
```

This prints out each animal, in an undefined order, because the requests could come back in any order, but alas it prints them all. The key different is how we wrote our callback function. Here's the original `$.get` request again.

```javascript
$.get('index.html', function(data) {
    console.log(items[i]);
});
```

The humble `$.get` function provided by jQuery takes two parameters, the url to request, and the callback function. So we need to pass in something as the second parameter that returns the type of function it expects, and also copies in our index `i`.

We can't simply do something like pass in the index, such as `function(data, i)`. That doesn't work so we need to look at our solution that uses the closure to rescope the variable. Here's the request making use of the closure again, but I'm going to remove the outer request and focus on the closure.

```javascript
(function(i) {
    return function(data) { // what $.get wants
        console.log(items[i]);
    }
})(i)
```

The first thing that looks strange is probably that fact that we start with a `(` and appear to be wrapping our function in another closing bracket. We then immediately have `(i)` at the end and this supposedly returns the inner function we want.

This is a self-calling function, that after defined, since we have the `(i)` at the end, calls itself with those parameters. This creates new scope for the variable `i` and we are able to use it as we expect. We can even call the inner value something else for clarity such as.

```javascript
(function(otherI) {
    return function(data) {
        console.log(items[otherI]); // use the scoped index
    }
})(i) // pass in the current value of i in the loop
```

By passing in our value `i`, the insides of the braces, our _closure_ has new scope on the variable and the array is accessed as you expect.

# Is there another way
This can take time to understand and at first can be very frustrating. This is different to how other languages behave and led to the proposal for a type of variable with block scope. If we change the index to use the `let` identifier, we can use our original logic.

```javascript
var items = ['cat', 'dog', 'cow', 'rabbit'];
for (let i = 0; i < 4; i++) { // using let
    $.get('index.html', function(data) {
        console.log(items[i]); // works
    });
}
```

The above code prints out each element of the array, like our closure solution did. You can check out the [current support](http://caniuse.com/#search=let) and it's all quite green, but still in production you need to accept that some people are on older versions of IE or on Opera Mini.

# Finally
Closures are a complicated part of the language, but if you come to understand their function you can make powerful use of them to ensure pieces of code do not interfere with each other.

Hopefully this brief look into their function makes it easier to understand why your piece of code did not work the way you hoped at first. Maybe you'll use a closure, or start using `let`. Either way you've tapped into a cool part of the language that I'll probably write more about in the future.