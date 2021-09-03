---
layout: post
title:  "Caching Google Fonts Service Worker"
date:   2021-09-06 12:00:00 +1000
categories: fonts serviceworker
permalink: caching-google-fonts-service-worker
---
When using service workers you may want to cache some more complex resources and if you are not entirely sure what the resultant URL of the resource you want to cahce is, that can be okay, for example when caching Google fonts. You might have specified a list of routes to cache and cached those during the `install` step of the service worker activating, but you can also cache resources you might want to cache where you do not know the route initially.

# Caching Google fonts
When you add google fonts to a webpage you include a link like the one below;
```
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans">
```

This will load the font Open Sans into the page and you can make use of it. The interesting thing to note here though is that there are two requests involved when getting the font, first hitting that URL, and then downloading the actual font from another URL.

```
https://fonts.googleapis.com/css?family=Open+Sans
# serves a redirect to
https://fonts.gstatic.com/s/opensans/v23/mem8YaGs126MiZpBA-UFVZ0bf8pkAg.woff2
```

Where that second link is the actual font resource we want loaded into the page.

# Custom service worker fetch cases
You can extend this to any resource you might want to download and cache after the install step there are features that enable this. We can check what resource we are requesting in the `fetch` step, and if it is one we want to cache, we can put a clone of the response in the cache so we have it ready in the service worker next time.

```js
var resourcesToCacheLater = [
    'fonts.googleapis.com',
    'fonts.gstatic.com'
]
self.addEventListener('fetch', function(event) {
    var requestUrl = new URL(event.request.url);
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
        } catch(_) { /* eat errors */}
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

If we have it we serve the resource up from the cache, otherwise we go out and get the resource, storing a copy of it in our cache. Note that we need to create a `.clone()` of the response to put in the cache, we can't store the request in the cache and also send it back to the browser.

This is just one way service workers can provide custom functionality for your needs. They are impressive in that they essentially let you put custom logic in the middle of all of your fetch requests.
