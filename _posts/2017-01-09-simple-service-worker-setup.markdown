---
layout: post
title:  "Simple Service Worker Setup"
date:   2017-01-09 10:20:00 +1000
categories: ['blog', 'service worker', 'progressive', 'easy']
permalink: simple-service-worker-setup
---
If you've been paying attention to new technologies on the web one thing you have not missed is [Service Workers](https://developer.mozilla.org/en/docs/Web/API/Service_Worker_API). They're a new take on the idea of _progressive enhancement_ and I think they're going to stick around for a while yet.

# Workers on the page
The idea of a [web worker](http://www.w3schools.com/html/html5_webworkers.asp) is not new, and is currently used to help move large amounts of computation off the main thread. People tend to use them when they want to do large calculations in the background without affecting render performance. 

Web workers are just JavaScript as well which makes them very easy to understand and start using. If you have not looked into the idea of a promise in the browser I would suggest [this](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) resource from Mozilla.

# Simple service worker
Here's a really simple service worker that will work on any page if you add the basic assets in the array that gets cached. You also need to add the install script to the webpage that gets served to your users on their initial visit.

```javascript
// index.html - install the service worker
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js').then(function(registration) {
            console.log('ServiceWorker registration successful with scope: ', registration.scope);
        }).catch(function(err) {
            console.log('ServiceWorker registration failed: ', err);
        });
    });
}
```

This checks to see if the browser supports the API and then installs the service worker from `/sw.js`. It also removes the old cache if you bump up the version number ensuring your users download new assets if you want to make an update.

```javascript
// sw.js
var SITE_NAME = 'your-site'
var CACHE_NAME = SITE_NAME + '-1';
var urlsToCache = [
  '/',
  '/index.html',
  '/css/style.css',
  '/js/main.js'
];

self.addEventListener('install', function(event) {
  // Perform install steps
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        console.log('Opened cache');
        return cache.addAll(urlsToCache)
          .then(self.skipWaiting());
      })
  );
});

self.addEventListener('activate', function(event) {
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (CACHE_NAME !== cacheName 
                && cacheName.startsWith(SITE_NAME)) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request)
      .then(function(response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      }
    )
  );
});
```

This will install a service worker that serves up your `index.html` and main CSS and JavaScript assets. Next time you load the page it will appear offline. The key events are installing the cache, an activate event that clears the old cache, and a fetch event that interrupts network requests.

# Updating the worker
You will find yourself wanting to update assets at some point and might be frustrated when your service worker refuses to download the new version of things. It is possible to do a background fetch for new resources and replace that item in the cache, but there is a simpler way.

You can just bump up the version of the `sw.js` at the top such as:

```javascript
var SITE_NAME = 'your-site'
var CACHE_NAME = SITE_NAME + '-1';
```

Becomes;

```javascript
var SITE_NAME = 'your-site'
var CACHE_NAME = SITE_NAME + '-2';
```

This works because when the browser checks the `sw.js` file and whether it should install the new version, it checks to see if they are byte equivalent. Changing a number will prompt a reinstall.

# Finally
This technology is really new, and there's a [bunch of tools](https://github.com/GoogleChrome/sw-toolbox) made by google that substantially extend the functionality by adding offline support for messaging and even google analytics. You can also add support for caching fonts based on the response from google and even CDN based resources.

The point of this post is to show that it's _very_ easy to add a simple service worker to your site. Hopefully in the future all sites will have some sort of offline ability, and with phones having more and more storage space, it wouldn't be unreasonable for you to cache your most visited sites to have an uninterrupted experience on the web.