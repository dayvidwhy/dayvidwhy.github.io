---
layout: post
title:  "Caching Dynamic Resources With Service Workers"
date:   2021-09-06 12:00:00 +1000
categories: fonts service-workers
permalink: caching-dynamic-resources-with-service-workers
---
When using service workers you may know some of the routes you want to cache, but if you want to cache some more complex resources that are requested dynamically later, and the resultant URL of the resource you want to cache is not clear up front, there is a way to get those working offline.


# Google fonts as a dynamic resource
When caching Google fonts for example there are a couple of routes that you will want to cache, so the resultant behaviour while offline is the same while online. This involves a couple of parts, caching the request to the initial font page and the redirect then served to the actual font file.

Initially when you add google fonts to a webpage you include a link like the one below;
```
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans">
```

That URL is the first route we will need to catch, but this is an example of a route we know up front, and we _could_ include this resource in our list of cached assets.

```js
var urlsToCache = [
    'https://fonts.googleapis.com/css?family=Open+Sans'
];

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

This will store the initial requests response which is a redirect to the font file in the cache, but not the actual font file.

```
# we are caching this part
https://fonts.googleapis.com/css?family=Open+Sans

# but not this part which we are redirected to
https://fonts.gstatic.com/s/opensans/v23/mem8YaGs126MiZpBA-UFVZ0bf8pkAg.woff2
```

That second request will load the font Open Sans font file into the page and you can make use of it. We could add that route to our list of items to cache, but at this point we can consider some generalised logic to handle it for us.

# Custom service worker fetch cases
You can extend this to any resource you might want to download and cache after the install step, Google fonts are just an interesting example and a common workflow on webpages.

We can create a list of domains we would like to cache all requests to and then check what resource we are requesting in the `fetch` step each time.

If the request is one we want to cache, we can put a clone of the response in the cache as we go, so we have it ready in the service worker next time, and also pass the response back to the browser.

```js
var resourcesToCacheLater = [
    'fonts.googleapis.com',
    'fonts.gstatic.com'
];
self.addEventListener('fetch', function(event) {
    var requestUrl = new URL(event.request.url);

    // is this a route we want to cache?
    if (resourcesToCacheLater.indexOf(requestUrl.host) >= 0) {
        event.respondWith(
            caches.open(CACHE_NAME)
            .then(function(cache) {
                return cache.match(event.request).then(function(match) {
                    if (match) {
                        // serve the cached resource
                        return match;
                    }
                    return fetch(event.request).then(function(response) {
                        // put resource in the cache while we have it
                        cache.put(event.request, response.clone());
                        // pass the resource back to the browser
                        return response;
                    });
                });
            })
        );
    } else { // it's something else they want
        try {
            event.respondWith(
                caches.match(event.request)
                .then(function(response) {
                    if (response) {
                        return response;
                    }
                    return fetch(event.request).catch(function(_) {
                        // we didn't cache it, and they're offline and it failed
                        return new Response(null, {status: 404});
                    });
                })
            );  
        } catch(_) { /* errors */}
    }
});
```

The key part in that first conditional is checking for a cache hit on the resource, and then reaching out to the network if we need to go and grab it.

```js
return cache.match(event.request).then(function(match) {
    if (match) {
        // serve the cached resource
        return match;
    }
    return fetch(event.request).then(function(response) {
        // put resource in the cache while we have it
        cache.put(event.request, response.clone());
        // pass the resource back to the browser
        return response;
    });
});
```

If we have it, we serve the resource up from the cache, otherwise we go out and get the resource while also storing a copy of it in our cache.

Note that we need to create a `.clone()` of the response to put in the cache, we can't store the request in the cache and also send the same one back to the browser.

# Wrapping up
This is just one way service workers can provide custom functionality for your needs. They are impressive in that they essentially let you put custom logic in the middle of all of your fetch requests, and can be extended in a number of different ways to match your needs.