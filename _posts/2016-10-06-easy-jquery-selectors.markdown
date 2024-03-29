---
layout: post
title:  "Easy jQuery Selectors"
date:   2016-10-06 15:26:00 +1000
categories: blog jQuery
permalink: easy-jquery-selectors
---
The popular web plugin [jQuery](https://jquery.com/) is currently in its third version and is still going strong on the internet. Lately it has become less popular as the web platform catches up and DOM altering methods become more standard across browsers, but some parts of it are still very useful to the novice web developer.

# jQuery
Probably the biggest point I have seen from people that have done some website development before is that jQuery is not helpful, [and it does have its problems](https://github.com/jquery/jquery.com/issues/88#issuecomment-72400007) with performance. Many of its functions have big performance hits to do simple things, but it is still a very convenient library to use.

jQuery is well known for being old and clunky with its a large library weighing in at 28kB for the second flavour, and it takes a phones browser about 500ms on average to parse all of the code. Not the greatest.

What you might not have realised is that jQuery actually offer a [section on their website](https://learn.jquery.com/performance/) about getting the most out of the library. The biggest one is probably actually reading the jQuery source and not treating it like a magical box. I watched a [video](https://www.youtube.com/watch?v=i_qE1iAmjFg) by Paul Irish where he actually goes through the code seeing what can be learned. It is about an older version, but the idea is still relevant.

# Plain JavaScript
JavaScript has a range of selectors that facilitate grabbing elements on the page and then doing things to them, as follows.

```js
var x = document.getElementsByClassName("class");
var x = document.getElementsByID("id");
var x = document.querySelector("id");
var x = document.querySelectorAll("div input"); // all inputs inside a div
```

Now while `querySelector` is very easy to use and it's brother, `querySelectorAll` covers a range of bases with complex selectors, jQuery style selectors are still substantially easier to understand.

We can use fully fledged CSS selectors to grab elements even using pseudo selectors like `:first-child` and `:not`

```js
var x = $(".cool-class");
var x = $("#that-id");
var x = $("image");
var x = $(".sections .headings:not(:first-child)");
```

Probably the most interesting part is how we use the same selection statement, `$('thing')` and we can clearly see whether we are selecting an `#id` or a `.class` thanks to the inclusion of a `.` or `#`. Of note as well is how easy it is to then iterate over these elements using `$.each()` by simply providing a callback function.

# Iterating Over Class Selections
One thing that bothers me about `getElementByClassName` is how it returns an array and I need to loop over this to do something to each element.

For instance if we grabbed a bunch of navigation elements.

```js
var x = document.getElementsByClassName("nav-links");
```

To change them all to red we need to do something like this.

```js
for (var i = 0; i < x.length; i++) {
   x[i].style.color = "red";
}
```

So we have a few concepts here that need to be understood well before that line in the middle makes sense. We need to understand array indexes, and that DOM objects, surprisingly, actually are objects. Accessing the style element of a DOM object seems obvious when you're more experienced but I suggest that early on he similar jQuery version is much clearer.

```js
$(".nav-links").css("color", "red");
```

I can see that for all things with the class `.nav-links` I am changing their color to red.

# Making API Requests
Making use of API's in plain JavaScript just isn't fun as well, and trying to diagnose an issue in the depths of this code.

```js
var xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        //do stuff with this.response
    }
};
xhttp.open("GET", "link_to_amaze.json", true);
xhttp.send();
```

This isn't making anyone happy. The new [fetch](https://developer.mozilla.org/en/docs/Web/API/Fetch_API) API does start making this easier however the old jQuery;

```js
$.getJSON("link_to_amaze.json", function(data) {
    console.log(data); //print the data
});
```

This is a lot easier to get our heads around and start making meaningful web applications that plug in external information sources.

Also specifying the `&callback=?` in the URL we pass to `$.getJSON` seamlessly deals with `JSONP` requests and we don't have to spend time figuring out how to load JSON as the source of a script tag.

# Finally
jQuery has its weak points and has become less popular, but its [developer API](http://api.jquery.com/) is very available if you want to read further. I would highly recommend learning jQuery as an extension of their general JavaScript knowledge.