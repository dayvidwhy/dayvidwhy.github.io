---
layout: post
title:  "Easy jQuery Selectors"
date:   2016-10-06 15:26:00 +1000
categories: blog
---
The popular web plugin [jQuery](http://jquery.com) is currently in it's third version and it's still going strong on the internet. Lately it has become less popular as the platform catches up, but some parts of it are still very useful to the novice web developer.

## jQuery Is Just Bad
Probably the biggest point you get from a few students that have done some stuff with web development before is that jQuery is bad, [and it sort of is](https://github.com/jquery/jquery.com/issues/88#issuecomment-72400007). Many of it's functions have big performance hits that people have come to live with but it is still a very convenient library to use.

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

The similar jQuery can be sumarised down to;

```js
$(".nav-links").css("color", "red");
```

So I can see that for each thing I am changing it's colour to red.

## Making Requests - Just One More Thing
Making use of API's in plain JavaScript just isn't fun as well, and trying to diagnose an issue in the depths of;

```js
var xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        document.getElementById("output").innerHTML = this.responseText;
    }
};
xhttp.open("GET", "link_to_amaze.json", true);
xhttp.send();
```

..isn't making anyone happy. The new [fetch](https://developer.mozilla.org/en/docs/Web/API/Fetch_API) API does start making this easier however the old jQuery;

```js
$.getJSON("link_to_amaze.json", function(data) {
    //data 
});
```

This is just too easy for first year students to get their heads around and start making meaningful web applications that plug in external information sources.

Specifying the `&callback=?` in the URL we pass to `$.getJSON` also seemlessly deals with `JSONP` requests and student's don't have to spend time figuring out how to load JSON as the source of a script tag.

## Finally
jQuery has it's weak points and get's a bad name lately, but it's [developer API](http://api.jquery.com/) is the easiest thing to read and introduce student's to. I've found myself more than a few times sitting with them while we explore it together and would recommend learning jQuery as an extension of their general JavaScript knowledge.