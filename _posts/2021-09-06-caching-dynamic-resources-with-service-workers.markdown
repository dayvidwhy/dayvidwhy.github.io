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

That URL is the first route we will need to cache, but it doesn't actually return the font file itself, it serves a redirect to the actual font resource. We could store this route initially since we know it ahead of time but then the redirect would not work while offline.

```
# initial request to the font family endpoint serves redirect
https://fonts.googleapis.com/css?family=Open+Sans

# actual font resource we get redirected to
https://fonts.gstatic.com/s/opensans/v23/mem8YaGs126MiZpBA-UFVZ0bf8pkAg.woff2
```

That second request will load the font Open Sans font file into the page and you can make use of it. We could add that route to our list of items to cache, but at this point we can consider some generalised logic to handle it for us.

# Custom service worker fetch cases
Given that we know the two origins that requests for font files go out to, we can create a more generic piece of functionality to cache these resources on the fly. We can extend this to any resource you might want to download and cache after the install step, Google fonts are just an interesting example and a common workflow on webpages.

We can create a list of domains we would like to cache all requests to and then check what resource we are requesting in the `fetch` step each time.

```js
var resourcesToCacheLater = [
    'fonts.googleapis.com',
    'fonts.gstatic.com'
];
```

If the request is one we want to cache, we can put a clone of the response in the cache as we go, so we have it ready in the service worker next time, and also pass the response back to the browser.

```js
self.addEventListener('fetch', function(event) {
    var requestUrl = new URL(event.request.url);
    event.respondWith(
        caches.open(CACHE_NAME).then(function (cache) {
            return cache.match(event.request).then(function (match) {
                if (match) {
                    return match;
                }

                return fetch(event.request)
                    .then(function (response) {
                        // is this a route we want to cache?
                        if (resourcesToCacheLater.indexOf(requestUrl.host) >= 0) {
                            // put resource in the cache while we have it
                            cache.put(event.request, response.clone());
                        }
                        // pass the resource back to the browser
                        return response;
                    }).catch(function () {
                        // we didn't cache it, they're offline and it failed
                        return new Response(null, {status: 404});
                    });
            });
        })
    );
});
```

When we find that the resource we want does not have a match in the cache, and we go to fetch it from the network, we check to see if it is a resource we want to add to our cache dynamically. If we have it, we serve the resource up from the cache, otherwise we go out and get the resource while also storing a copy of it in our cache.

```js
// is this a route we want to cache?
if (resourcesToCacheLater.indexOf(requestUrl.host) >= 0) {
    // put resource in the cache while we have it
    cache.put(event.request, response.clone());
}
```

Note that we need to create a `.clone()` of the response to put in the cache, we can't store the request in the cache and also send the same one back to the browser.

# Wrapping up
This is just one way service workers can provide custom functionality for your needs. They are impressive in that they essentially let you put custom logic in the middle of all of your fetch requests, and can be extended in a number of different ways to match your needs.