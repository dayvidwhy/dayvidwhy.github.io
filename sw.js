---
layout: null
---
var SITE_NAME = 'davids-site'
var CACHE_NAME = SITE_NAME + '-6';
var urlsToCache = [
  '/css/main.css',
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
  {{ asset_urls | normalize_whitespace }}
  'https://fonts.googleapis.com/css?family=Open+Sans' // cache the redirect served
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
  var requestUrl = new URL(event.request.url);
  if (requestUrl.host === 'fonts.gstatic.com') {
    // cache font
    event.respondWith(
      caches.open(CACHE_NAME)
        .then(function(cache) {
          return cache.match(event.request).then(function(match) {
            if (match) {
              // serve the cached font
              return match;
            }
            return fetch(event.request).then(function(response) {
              cache.put(event.request, response.clone());
              // put the font they downloaded in the cache
              return response;
            });
          });
        })
      );
  } else {
    // it's something else they want
    try {
      event.respondWith(
      caches.match(event.request)
        .then(function(response) {
          if (response) {
            return response;
          }
          return fetch(event.request).catch(function(_) {
            // we didn't cache it, and they're offline and it failed
            // just send back a 404
            return new Response(null, {status: 404});
          });
        })
      );  
    } catch(_) {/* eat errors */}
  }
});