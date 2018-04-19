---
layout: post
title:  "Stuck In A Bind"
date:   2017-06-12 11:53:28 +1000
categories: javascript bind this
permalink: stuck-in-a-bind
---
In JavaScript it can be advantageous to override the default `this` context when dealing with function callbacks where you want to abstract these out into their own named functions. Using a plain `.bind` on the end of your function can be one way of dealing with this. 

Let us consider the following event handler which prints a message and adds a class. We're going to alter this code a few times to illustrate how else we could write it, and the pros and cons of each.

```javascript
function startListening() {
    var message = 'Print out this message!';
    var button = document.querySelector('button');
    button.addEventListener('click', function(event) {
        console.log(message);
        this.className += ' clicked-style';
    });
}

startListening();
```

Here we are calling a simple function `startListening` that will listen for a click on our button, print out our message and add some class that indicates to the user they clicked our button. In the callback function for a click event listener, `this` is the button itself, so we can directly alter it's `className` attribute.

# Named Functions
As your code grows in size it can be useful to abstract out anonymous functions and give them names to better separate your logic. The above could be rewritten as.

```javascript
function startListening() {
    var message = 'Print out this message!';
    var button = document.querySelector('button');
    button.addEventListener('click', buttonClicked);
}

function buttonClicked(event) {
    console.log(message); // undefined error
    this.className += 'clicked-style';
}

startListening();
```

Here we pass the function `buttonClicked` by name which will get called later when we click on the button.  Note that we dont put `( )` brackets on the end of the event listeners second argument, as we don't want to invoke the function, only pass reference to it. The issue that then arises is when the button is clicked, you will get an error saying `message` is undefined.

This is because of [lexical scope](https://developer.mozilla.org/en/docs/Web/JavaScript/Closures#Lexical_scoping) in JavaScript and the fact that variables are function scoped. This means that any given function only has access to variables within the function or outside of it's own closure.

# Global Variable
We could solve this problem by making that variable more 'global' and lift it out of that functions scope

```javascript
// global variable
var message = 'Print out this message!';

function startListening() {
    var button = document.querySelector('button');
    button.addEventListener('click', buttonClicked);
}

function buttonClicked(event) {
    console.log(message); // no problem
    this.className += 'clicked-style';
}

startListening();
```

But now we are leaking variables and the entire document would have access to this variable which we might not want.

# Wrapping the Function
To get this `message` variable into out extra function we could wrap an anonymous function around it and make our button clicked function take an extra argument.

```javascript
function startListening() {
    var message = 'Print out this message!';
    var button = document.querySelector('button');
    button.addEventListener('click', function(event) {
        // take a couple of extra argument here
        buttonClicked(event, this, message);
    });
}

function buttonClicked(event, button, message) {
    console.log(message); // works!
    button.className += 'clicked-style';
}

startListening();
```

But now we've reintroduced our anonymous function which is what we were hoping to avoid and you'll also notice I needed to pass the button itself down by passing `this`.

# Bring in Bind
`.bind` is a javascript directive that lets you manipulate the `this` context within a callback function. It's a method on functions that return a new function that acts a bit differently.

```javascript
function startListening() {
    var message = 'Print out this message!';
    var button = document.querySelector('button');
    button.addEventListener('click', buttonClicked.bind({
        innerMessage: message
    }));
}

function buttonClicked(event) {
    // this is an object now, not the button itself
    console.log(this.innerMessage); // works!
    this.className += 'clicked-style'; // doesn't work :(
}

startListening();
```

The issue here is we lose context of the button itself so our class change no longer works. This is fine if you didn't really want to access the button directly, it really just depends on your use case.

# Wrapping up
You've seen 4 ways of getting our message into the callback function, and which one you use really depends on your use case. 

If you don't need direct access to the button itself in the callback, then binding `this` into something else can be entirely reasonable.