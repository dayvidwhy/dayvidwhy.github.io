---
layout: post
title:  "Live HTMLCollection"
date:   2016-12-14 12:00:15 +1000
categories: blog html live
permalink: live-htmlcollection
---
For most of the time I've been writing JavaScript I've had jQuery there to hold me up, providing an assortment of helper functions and methods that I _think_ make life easier. I mean I'm fairly sure they're supposed to, that's what it says in their documentation. I realised I had never really tried to make a proper web application without it, so decided it was about [time to do so](https://dayvidwhy.github.io/local-to-do/).

# Where are you jQuery?
I decided that a to-do type application that made use of local storage to remember tasks would be a good starting point, it would let me play with a web API and do some UI state management that's incredibly easy to do in jQuery. 

A lot of what this blog post wants to address comes from me trying to be somewhat clever. I have become incredibly used to the typical jQuery style selectors like `$(".class")` and figured how hard could that be to reproduce in a simple function. Behold.

```javascript
function $(element) {
    if (element[0] === '#') {
        return document.querySelector(element);
    } else if (element[0] === '.') {
        return document.getElementsByClassName(element.slice(1, element.length));
    } else {
        return getElementsByTagName(element);
    }
}
```

Seems good right? If we want an ID based element we use `querySelector`, or for a class we make use of `getElementsByClassName` to return a collection of all elements with that class.

I figured I was set and continued upon my efforts, until I encountered something interesting. I had discovered that `DOM` elements contain a list of classes they currently have, a fancy new feature that has great support, and figured what an excellent way to toggle the visibility than to add and remove a `show` class from this set.

![Error from indexOf](images/htmlcollection/error.png "Error from indexOf")

But it's an array? Arrays have an `indexOf` function? This is when I started thinking I'd lost my touch a bit, but after a quick search around I discovered the culprit was that fact that this is _not_ an array, but a [DOMTokenList](https://developer.mozilla.org/en/docs/Web/API/DOMTokenList). 

There are some specific methods here for class management, which jQuery handles really well for us with their `.addClass` and `.removeClass` methods, that have fairly strict browser requirements. I started using `.add` and `.remove` and everything worked as expected avoiding `.replace` since chrome does not support it.

# A Live Collection
My efforts picked up again after this, having felt as if I learned something, so I pressed on. The next issue I encountered was an oddly shrinking array. Having become very used to how jQuery style selectors work, I selected the elements I wanted to hide, those being the ones currently shown, and use `.hide()` on them. Image the following scenario.

```html
<div class="show">
    <p>Content</p>
</div>
<div class="show">
    <p>Content</p>
</div>
<div class="hide">
    <p>Content</p>
</div>
```

I have a couple of div elements currently showing that I would like to hide, so I attempted the following.

```javascript
var shown = $(".show");
for (var i = 0; i < shown.length; i++) {
    shown[i].classList.remove('show');
    shown[i].classList.add('hide');
}
```

This is where things became interesting. I was looping over this array of 2 elements, removing their `show` class and then adding a `hide` class to their class lists, but only one element was ever toggling, the second one. 

The thing happening here is that `document.getElementsByClassName` returns an `HTMLCollection`. An [HTMLCollection](https://developer.mozilla.org/en/docs/Web/API/HTMLCollection) is a _live_ collection that is _updated_ when the DOM updates. 

So what was happening there was as I removed the `show` class from the first element, the `shown` set of elements suddenly lost a member and went down to a length of 1. Now `shown[i]`, or `shown[0]` was in fact the _second_ element I had selected since the first one had disappeared from under me. I then exit the array _early_.

This can be fairly easily remedied by swapping the order of operations, I just found it profoundly odd that a live updating collection of elements is something that people would want.

# Finally
This held me up a bit yesterday and I felt as if jQuery has slightly altered my understanding of how selectors work, but it was definitely a useful learning experience and I intend to keep attempting more features without jQuery.

# Update
I revised my original function to look something like this.

```javascript
function $(element) {
    if (element[0] === '#') {
        return document.getElementById(element.slice(1, element.length));
    }
    return document.querySelectorAll(element);
}
```

To leverage the better version of the query selector, `querySelectorAll`. This meant I was dealing with `NodeLists` instead of the collections and I was able to move along much more efficiently and continue the logic the way I was doing it the first time around.