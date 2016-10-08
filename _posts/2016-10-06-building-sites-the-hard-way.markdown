---
layout: post
title:  "Adventures in Teaching"
date:   2016-10-06 15:26:00 +1000
categories: blog
---
Something they don't seem to teach particularly well at university is how your _meant_ to build a site these days. After spending the last few months teaching this to first years at university I feel like I can reflect a bit on how students at UQ get started with web dev and how jQuery is useful.

## jQuery is bad etc.
Probably the biggest point you get from a few students that have done some stuff with web development before is that jQuery is bad, [and it sort of is](https://github.com/jquery/jquery.com/issues/88#issuecomment-72400007). Many of it's functions have big performance hits that people have come to live with but it is still a very convenient library to use.

## Just Teach Plain JavaScript
This is fine to a degree, but students quickly become confused with the various selectors JS has on offer. See;

```js
var x = document.getElementsByClassName("CLASS");
var x = document.getElementsByID("ID");
var x = document.querySelector("ID");
```

Now while `querySelector` is a huge improvement and easy to use, jQuery style selectors are still substantially easier to use;

```js
var x = $(".CLASS");
var x = $("#ID");
var x = $("whatever");
```
 Of note as well is how easy it is to then iterate over these elements using `$.each()`.


## Making Requests
Making use of API's in plain JavaScript just isn't fun as well, and trying to diagnose an issue in the depths of;

```js
var xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        document.getElementById("output").innerHTML = this.responseText;
    }
};
xhttp.open("GET", "link_to_amaze.txt", true);
xhttp.send();
```

..isn't making anyone happy. The new [fetch](https://developer.mozilla.org/en/docs/Web/API/Fetch_API) API does start making this easier however the old jQuery;

```js
$.getJSON("url", function(data) {
    //data 
});
```

..is just too easy for first year students to get their heads around.

## r.e. jQuery is bad
It has it's weak points but it's [developer API](http://api.jquery.com/) is the easiest thing to read and introduce student's to. I've found myself more than a few times sitting with them while we explore it together.