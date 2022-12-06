'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "4e54a0082c2ed68d45a237eee871a94e",
"index.html": "15607b12b29ffd7899c8906a4a2ccf14",
"/": "15607b12b29ffd7899c8906a4a2ccf14",
"main.dart.js": "2f1866cb5631b2d30bc2ca9b66df0a75",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"favicon.png": "b65731f1a32e881fcb00e13d1efa5961",
"icons/Icon-192.png": "e88f1a8f6d591e4dfb9b47a2b92ae3bf",
"icons/Icon-maskable-192.png": "e88f1a8f6d591e4dfb9b47a2b92ae3bf",
"icons/Icon-maskable-512.png": "689baf8f2a853c985d049606a04a6470",
"icons/Icon-512.png": "689baf8f2a853c985d049606a04a6470",
"manifest.json": "2bc3b8524cbeb5441b3d45f0c2cebe31",
"assets/AssetManifest.json": "1223555a0517608776f1c992b935e4a0",
"assets/NOTICES": "fbe825bd140e632dad9e613aae0a8f6e",
"assets/FontManifest.json": "690d12f2d87d9636f6df7630529a5568",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "4ecffbe291f17e99de179387ba330cd7",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/assets/images/ic-warning.png": "4cb684b1016af781014344188e36ee91",
"assets/assets/images/ic-light-theme.png": "85ea8cf4ecf6afafc8bf01ef810f0622",
"assets/assets/images/ic-avatar.png": "608c779b24f8dce4cfe388ce86aea724",
"assets/assets/images/ic-checked.png": "3ef4ba72e0e54234fd370bd87713795c",
"assets/assets/images/ic-system-theme.png": "a5e528b9adee075c1974069e0e827924",
"assets/assets/images/ic-user-unselect.png": "76fe326606586ceb4c222a35d2bee72c",
"assets/assets/images/ic-dashboard-unselect.png": "ed9337a26642e3317f9377dcd2726162",
"assets/assets/images/ic-qr-unselect.png": "83c2381d6f1791704bd525fdf9adb033",
"assets/assets/images/ic-dark-theme.png": "2489d2c1a9d0367403b962f5a9d1374f",
"assets/assets/images/ic-dashboard.png": "07bcad74b80d2881c7c73d40abc00b24",
"assets/assets/images/bg-bank-card.png": "a735b43d2849891671bd48cf1231d4fa",
"assets/assets/images/ic-pop.png": "aebd963f3c030c6bf4b43849a4aca956",
"assets/assets/images/logo.png": "e2764cb2c470a8114d1354ce69c657e8",
"assets/assets/images/ic-user.png": "96baf1f6ff0c95d638ee7847b27dd6d8",
"assets/assets/images/ic-uncheck.png": "5afe9d1df5cdfbce671ae8b28005d2d5",
"assets/assets/images/ic-card.png": "60f3cf2a1a5c03109d657ef43906d95e",
"assets/assets/images/ic-viet-qr.png": "ad4b764b5840265e82308b1a362d7348",
"assets/assets/images/bg-qr.png": "1feb906ab766cc066be47b331ed0237c",
"assets/assets/images/ic-viet-qr-small.png": "2dc41cc1d43e72ad55e4725ee7d9f23b",
"assets/assets/images/ic-qr.png": "f6f6d61bfdb5e00104820ce0edcc2bba",
"assets/assets/images/ic-dropdown.png": "94d7102385a1ad012b994b69eeb5aad6",
"assets/assets/fonts/font-times-new-roman.ttf": "e2f6bf4ef7c6443cbb0ae33f1c1a9ccc",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
