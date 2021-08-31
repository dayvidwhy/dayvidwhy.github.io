---
layout: post
title:  "Detecting Page Scroll Distance"
date:   2021-08-31 12:00:00 +1000
categories: javascript scroll page
permalink: detecting-page-scroll-distance
---
Checking when a user has scrolled to the end of a page can be useful for a number of different features. You may want to load more information once a user has scrolled to the end to create infinite scrolling, or find out that a user has read your whole article.

# Listening for the scroll event
We can listen for the user scrolling the page by attaching a `scroll` listener to the `document` object.

```js
document.addEventListener("scroll", function (event) {
    // perform logic when a user scrolls
});
```

This event will trigger each time the user scrolls the page, and the frequency that it reports information is quite high. It is common to debounce this triggered function which will be explained further on.

# Detecting the bottom of the page
There are some properties on the `window` and `document` objects that help us know whether the user has scrolled to the end of the page. First useful property is the height of the page in total which you can get from the `document`.

```js
console.log(document.body.scrollHeight); // height in px
```

Then we can work out how far down the page a user has scrolled so far using some properties on the `window` object.

```js
console.log(window.innerHeight); // how tall is the current window?
console.log(window.pageYOffset); // how far from the top of the page, is our current view?
```

Combining these properties we can create a test for checking if we have reached the end.

```js
// have we scrolled to the end of the page?
function testHeight() {
    return window.pageYOffset + window.innerHeight >= document.body.scrollHeight;
}
```

# Example including debounce
In the following codepen I have produced an example and the `scroller` object is a module that could be included in any webpage. When the bottom of the page has been reached, an event is triggered.

<iframe height="400" style="width: 100%;" scrolling="no" title="Scroll to page end detection with debounce" src="https://codepen.io/dayvidwhy/embed/oNWPYMM?default-tab=result" frameborder="no" loading="lazy" allowtransparency="true" allowfullscreen="true">
  See the Pen <a href="https://codepen.io/dayvidwhy/pen/oNWPYMM">
  Scroll to page end detection with debounce</a> by David Young (<a href="https://codepen.io/dayvidwhy">@dayvidwhy</a>)
  on <a href="https://codepen.io">CodePen</a>.
</iframe>