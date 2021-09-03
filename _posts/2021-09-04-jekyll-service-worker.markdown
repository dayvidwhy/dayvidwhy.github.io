---
layout: post
title:  "Jekyll Service Worker"
date:   2021-09-04 12:00:00 +1000
categories: jekyll serviceworker liquid
permalink: jekyll-service-worker
---
Back in 2017 when I was originally putting this new blog together with Jekyll I made a point of integrating a service worker with the build process. Generating the required urls to cache using liquid tags and embedding these within the URL's to be cached on service worker activation can be included.

# Caching built pages from jekyll
In a [previous post](/simple-service-worker-setup) I show a simple service worker setup where some URL's are specified for caching. When building the site with Jekyll, it is good to not have to keep a list of every page up to date in the service workers set of routes to cache, so we can instead use liquid within our service workers file to generate the routes we need to cache at build time.

```js{% raw %}
{% capture asset_urls %}
{% for page in site.html_pages %}
'{{ page.url | remove: '.html' }}',
{% endfor %}

{% for post in site.posts %}
'{{ post.url }}',
{% endfor %}

{% for file in site.static_files %}
{% if file.path contains '/images' or file.path contains 'manifest' or file.path contains 'css' %}
'{{ file.path }}',
{% endif %}
{% endfor %}
{% endcapture %}

var SITE_NAME = '{{ site.url }}-site'
var CACHE_NAME = SITE_NAME + '-{{ site.time | date_to_xmlschema }}';
var urlsToCache = [
  '/manifest.json',
  '/js/validate.js',
  '/css/main.css',
  {{ asset_urls | normalize_whitespace }}
];{% endraw %}
```

The above script tracks pages which are our main routes like `/` and `/contact`. It also tracks each post like the one you are reading right now and adds it to the list. Finally it also adds static files, like images and other Jekyll pages without front matter that are not processed.

The setup also uses `{% raw %}{{ site.time | date_to_xmlschema }}{% endraw %}` to keep our cache name unique each time we rebuild the site.

```js
var CACHE_NAME = SITE_NAME + '-{% raw %}{{ site.time | date_to_xmlschema }}{% endraw %}';
```

Currently some static resources need to be added manually with the above setup, so a few resources are included in the list already.

```js
var urlsToCache = [
  '/manifest.json',     // manually added
  '/js/validate.js',    // manually added
  '/css/main.css',      // manually added
```

# Installing the generated routes
These routes are injected inside the declared variable `urlsToCache` and then when we go to cache these URL's with a service worker we pass these `urlsToCache` to the `install` step and they are added to our cache.

```js
// Perform install steps
self.addEventListener('install', function(event) {
    event.waitUntil(
        caches.open(CACHE_NAME)
        .then(function(cache) {
            return cache.addAll(urlsToCache)
            .then(self.skipWaiting());
        })
    );
});
```

The install step inserts these resources into the browsers cache and subsequent loads of these resources intercepted by the service worker will use the cached asset over reaching out to the network, so the site will start working offline.