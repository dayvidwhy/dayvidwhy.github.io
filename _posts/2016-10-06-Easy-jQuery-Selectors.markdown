---
layout: post
title:  "Easy jQuery Selectors"
date:   2016-10-06 15:26:00 +1000
categories: blog
permalink: easy-jquery-selectors
---
The popular web plugin jQuery is currently in it's third version and it's still going strong on the internet. Lately it has become less popular as the platform catches up, but some parts of it are still very useful to the novice web developer.

## jQuery Is Just Bad
Probably the biggest point you get from a few students that have done some stuff with web development before is that jQuery is bad, [and it sort of is](https://github.com/jquery/jquery.com/issues/88#issuecomment-72400007). Many of it's functions have big performance hits, but it is still a very convenient library to use.

## Just Teach Plain JavaScript
JavaScript has a range of selectors that fascilitate grabbing elements on the page and then doing things to them, see;

```js
var x = document.getElementsByClassName("CLASS");
var x = document.getElementsByID("ID");
var x = document.querySelector("ID");
```

Now while `querySelector` is very easy to use, jQuery style selectors are still substantially easier to understand;

```js
var x = $(".CLASS");
var x = $("#ID");
var x = $("tag");
```

Probably the most interesting part is how we use the same selection statement, `$('thing')` and we can clearly see whether we are selecting an `#id` or a `.class`. 

Of note as well is how easy it is to then iterate over these elements using `$.each()`. 

## Iterating Over Class Selections
One thing that bothers me about `getElementByClassName` is how it returns an array and I need to loop over this to do something to each element.

For instance if we grabbed a bunch of navigation elements;

```js
var x = document.getElementsByClassName("nav-links");
```

To change them all to red we need to do something like;

```js
for (var i = 0; i < x.length; i++) {
   x[i].style.color = "red";
}
```

So we a few concepts here that need to be understood well before that line in the middle makes sense. First students need to understand array indexes, and that DOM objects actually are objects. Accessing the style element of a DOM object seems obvious when you're more experienced but I suggest that early on he similar jQuery version..

```js
$(".nav-links").css("color", "red");
```

.. is much clearer. I can see that for all things with the class `.nav-links` I am changing their 'color' to red.

## Making Requests - Just One More Thing
Making use of API's in plain JavaScript just isn't fun as well, and trying to diagnose an issue in the depths of;

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

..isn't making anyone happy. The new [fetch](https://developer.mozilla.org/en/docs/Web/API/Fetch_API) API does start making this easier however the old jQuery;

```js
$.getJSON("link_to_amaze.json", function(data) {
    //do stuff with data 
});
```

This is just too easy for first year students to get their heads around and start making meaningful web applications that plug in external information sources.

Specifying the `&callback=?` in the URL we pass to `$.getJSON` also seemlessly deals with `JSONP` requests and student's don't have to spend time figuring out how to load JSON as the source of a script tag.

## Finally
jQuery has it's weak points and get's a bad name lately, but it's [developer API](http://api.jquery.com/) is the easiest thing to read and introduce student's to. I have found myself, more than a few times, sitting with students while we explore it together. In conclusion, I would highly recommend learning jQuery as an extension of their general JavaScript knowledge.