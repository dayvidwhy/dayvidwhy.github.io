---
layout: post
title:  "Useful Web Skills"
date:   2016-11-11 14:20:00 +1000
categories: blog web semantics
permalink: useful-web-skills
---
A few people have asked me recently how I've managed to make heads or tails of the current state of the web, and how do you get to a point where this weird online world of development doesn't freak you out too much. Well quite a lot of it still confuses me, but it's definitely become easier. 

I also feel like I can weigh in on this topic after tutoring this past semester and can suggest a few things that would increase anyone's ability to make effective websites.

Disclaimer: Some of these things are very obvious to the experienced web developer.

# Build a Page from Scratch
If there's one thing that really accelerated my understanding of, and ability to write for the web, was doing everything from scratch at least a few times. I reached a point where I became frustrated with how many different frameworks there were and the number of CSS templates out there were immense.

I had noticed a lot of students would suggest the use of [bootstrap](https://getbootstrap.com/) right away for building pages, only to come to a halt later when some of the classes they used were not working the way they hoped. Often I would ask why they thought this class behaved this way and what CSS rules does it actually apply and they mostly weren't sure. 

I still use frameworks from time to time but I always investigate the behaviour of pre-defined classes myself before using them and I even built my [own grid](http://daygrid.dwy.io) to ensure I understood the concepts. Don't always just assume you know how some piece of CSS works, try out its various attributes or value ranges.

# Learning Semantics
The [semantic web](https://www.w3.org/standards/semanticweb/) is a standard that allows the web to start making a lot more 'sense'. A lot of the data we put into pages has meaning beyond just the text we show. We can give our data more meaning quite easily with the proper syntax. 

The latest thing I've become a fan of is the `itemscope` syntax. You can make links to blog posts much more meaningful like so. Here's a blog link from my [portfolio](https://davidyoung.tech) site.

```html
<div class="row" itemscope="" itemtype="http://schema.org/Blog" id="blog">
    <article role="article" itemtype="http://schema.org/BlogPosting" itemscope="itemscope">
        <h3 itemprop="name">
            <a href="http://blog.davidyoung.tech/software-process" itemprop="url">
                Software Process
            </a>
        </h3>
        <p itemprop="description">
            Something I’ve been struggling to understand is why some students dislike courses that attempt to teach the so...
        </p>
        <a itemprop="url" href="http://blog.davidyoung.tech/software-process" class="blog-link">
            Read more..
        </a>
    </article>
</div>
```

This rich semantic mark-up shows that this piece of code actually represents a blog post, and can actually communicate what parts reflect the name, or the description of it. We can specify the `itemscope` and tell the web _what_ this thing is, and then say what each part represents. So the web knows that this is a blog post, and that it has a name, a description and a link to it for reading.

# Accessibility with Semantics
I recently jumped on the band wagon for making sure my site is readable to everyone. In my opinion every site needs to be a place that doesn't restrict who can view the content. Semantic tags with implied aria roles help here and the following mark-up demonstrates a common structure you should be adopting for your pages.

```html
<!-- Great semantics! -->
<html>
<head>
    <title>A title</title>
</head>
<body>
    <header>
        Header stuff, like your nav-bar, or top banner.
    </header>
    <main>
        Main content that you want readers to look at.
    </main>
    <footer>
        The thing at the bottom of the page.
    </footer>
</body>
</html>
```

This is much better for screen readers given the good use of semantic tags breaking up the page into three clear body parts, the header, main and the footer. This is vastly better than the following.

```html
<!-- Not so great semantics -->
<html>
<head>
    <title>A Title</title>
</head>
<body>
    <div class="cool-top-banner">
        Header stuff, like your nav-bar, or top banner.
    </div>
    <div class="main-stuff">
        Main content that you want readers to look at.
    </div>
    <div class="footer-bit">
        The thing at the bottom of the page.
    </div>
</body>
</html>
```

Mostly because the first one is more readable, but also because of the implied aria labels. The `<header>` tag has an implicit `role=banner` associated with it. It's possible to give this back with aria labels but why not just use the proper mark-up in the first place? 

If you have not done much with aria labels before I highly recommend reading [the spec](https://www.w3.org/TR/wai-aria/) or [looking at Mozilla's guide](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-label_attribute) on the matter.

# Inspect Everything
One of the best things you can do while learning is to inspect almost every page you come across. Look inside the head tag, look at the properties they gave their `<p>` tags and look at what classes they used and why. Look at how they lay out their content. 

Things that usually interest me are:

* Did they use a grid or are they using flexbox?
* How did they set the background colour of this element, does it cascade down from a higher class for some reason?
* What's in the `<head>` tag? Which usually leads onto the next point.
* What framework, if any, are they using?
* How are they loading their CSS, in a blob or throughout the HTML? Sharding CSS has become the cool new thing lately.
* Are they using a web-font and how are they loading it? Are they using [modernizr](https://modernizr.com/) or lazy loading it?

Because it's pretty interesting to see how some people make their pages, and sometimes they leave small comment messages for you to see.

# Development Tools
Learning to use the dev tools provided in Chrome and Firefox will increase your productivity ten-fold. Lately I've become a fan of just jamming around in the elements tab manually adjusting some HTML and CSS making the page look the way I want live instead of going back to my editor. 

You can try out new ideas fairly rapidly without making huge changes to your code this way. Sure you can make a commit, make some changes and refresh the page to see what it looks like, I just find it very cool that I can change CSS instantly in the browser on the fly.

This is really helpful early on as well for understand what each CSS rule does since you can flick them on and off easily with the checkboxes. Lately I've become a bit obsessed with the chrome dev tools, mainly because of the timeline feature. 

# Finally
These are just some of the things I wish my teachers had pushed on me a bit more when I was first learning the hypertext mark-up language and I can assure anyone that if you want to get better at making stuff on the web awesome, you need to understand these things.