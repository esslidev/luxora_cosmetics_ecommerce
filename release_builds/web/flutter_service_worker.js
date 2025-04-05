'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "ede001af58a4dec2380e4ae4ee57de8c",
"assets/AssetManifest.bin.json": "5c0387b789475d0839d3b2ead4c472ff",
"assets/AssetManifest.json": "4e3e955b53b48cadd45a24239c107f26",
"assets/assets/animated_images/promo-videos-short-video.webp": "efc7a53a1c0a56f3acaed35c0826c78d",
"assets/assets/files/lottie/bad-routing.json": "7ea3b835084aa881c693a1a2e2a316dd",
"assets/assets/files/lottie/book-loading.json": "0bc0d892a7d9c87d4e239400b44a1d34",
"assets/assets/files/lottie/maintenance.json": "a65193e1909eb26e184ce0f092e03452",
"assets/assets/files/lottie/success.json": "129b6f4cdda5a34d842c1b4af1957df6",
"assets/assets/files/lottie/warning.json": "fe7efcef8fbf06f60127bcfff3a5a82a",
"assets/assets/fonts/inter/inter-black.ttf": "2392341284c30f5fffb9fe0ab0cd983e",
"assets/assets/fonts/inter/inter-blackitalic.ttf": "1fa0b44e2ca8a6ce911e0fc8cc3b7255",
"assets/assets/fonts/inter/inter-bold.ttf": "8b04b3bd9435341377d7f4b4d68b6ecc",
"assets/assets/fonts/inter/inter-bolditalic.ttf": "a1757dcadd00b07cd874af79e2904c92",
"assets/assets/fonts/inter/inter-extrabold.ttf": "995fb5ac38b90303c0cc1a0b21e2c9fe",
"assets/assets/fonts/inter/inter-extrabolditalic.ttf": "054fe10e7073eb84bf31447dfd79e522",
"assets/assets/fonts/inter/inter-extralight.ttf": "8da347e947a38e1262841f21fe7c893e",
"assets/assets/fonts/inter/inter-extralightitalic.ttf": "c37c2ef7e42dc86b284a5cbaf8a8efae",
"assets/assets/fonts/inter/inter-light.ttf": "65ec965bd90e1a297cdb3be407420abc",
"assets/assets/fonts/inter/inter-lightitalic.ttf": "a401ba0ab41163ff9ec6247c023b1c68",
"assets/assets/fonts/inter/inter-medium.ttf": "4591e900425d177e6ba268d165bf12e8",
"assets/assets/fonts/inter/inter-mediumitalic.ttf": "5ed286000cb7a0e7b015ec71e190a767",
"assets/assets/fonts/inter/inter-regular.ttf": "e48c1217adab2a0e44f8df400d33c325",
"assets/assets/fonts/inter/inter-semibold.ttf": "c77560a8441d664af3e65dd57026dff9",
"assets/assets/fonts/inter/inter-semibolditalic.ttf": "9685a9dcf0c26640b3828dd34b953bcd",
"assets/assets/fonts/inter/inter-thin.ttf": "1e9e30c74648950a240427636b6c1992",
"assets/assets/fonts/inter/inter-thinitalic.ttf": "27a3a82e0df426a69c7a7562a2293bda",
"assets/assets/fonts/recoleta/recoleta-black.otf": "8e7e039e2778a312a5516fc7095d5cfb",
"assets/assets/fonts/recoleta/recoleta-bold.otf": "d7bcae5a319888d4698ef6bdc0c887ab",
"assets/assets/fonts/recoleta/recoleta-light.otf": "698b4dc0fdc0696a2cc7851e4d7065c8",
"assets/assets/fonts/recoleta/recoleta-medium.otf": "caf114b62df037fce983de9566514364",
"assets/assets/fonts/recoleta/recoleta-regular.otf": "ac8f3b34c9acc2fa8039d496d28781e5",
"assets/assets/fonts/recoleta/recoleta-semibold.otf": "0c238933965b54ebef3c310502aae089",
"assets/assets/fonts/recoleta/recoleta-thin.otf": "0fe271b9758de9eac4523dbba1e997e1",
"assets/assets/fonts/recoleta_alt/recoleta-alt-black.otf": "cd6e6a8207ce010ed63f7b6b2a354f0b",
"assets/assets/fonts/recoleta_alt/recoleta-alt-bold.otf": "3bc04479f2c5be50f2de265d793fa256",
"assets/assets/fonts/recoleta_alt/recoleta-alt-light.otf": "42a3ab32472a60dd2286c13f4c6d3c37",
"assets/assets/fonts/recoleta_alt/recoleta-alt-medium.otf": "9f2e8446130a1c352d77c8af80359c5a",
"assets/assets/fonts/recoleta_alt/recoleta-alt-regular.otf": "7a1d7931042b371c63e33a6b3d6e264c",
"assets/assets/fonts/recoleta_alt/recoleta-alt-semibold.otf": "b91460f2fc0ff54d251da63968553914",
"assets/assets/fonts/recoleta_alt/recoleta-alt-thin.otf": "f330670e8f2c5b08956bac8281eae08a",
"assets/assets/icons/icon-dark.png": "aa8c4866f52307b5736c154e09763606",
"assets/assets/icons/icon-foreground.png": "5443ed1aeecfabe2e91535dfea72d6e2",
"assets/assets/icons/icon.png": "45c045af4a0e599289abb1705bbea82e",
"assets/assets/images/2.0x/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/images/3.0x/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/images/aloe-vera-brand-image.png": "757918377bc894b0625e0a925ddea2ab",
"assets/assets/images/barione-brand-image.png": "90a906653c481d3010838eba64693f2b",
"assets/assets/images/calvin-klein-brand-image.png": "dbe29e474a23f4eea3837f1476949372",
"assets/assets/images/farmesi-brand-image.png": "58d7e2fb0f6f4efeaf562d81ecbe38e3",
"assets/assets/images/join-us-image1.webp": "a966aceed917e8f519271e6e6382bf2a",
"assets/assets/images/join-us-image2.webp": "8a812a2d98685a3db5be33e9631d151a",
"assets/assets/images/join-us-image3.jpg": "1bb618d002568dacf32302a95d2d9ce5",
"assets/assets/images/logo-dark.png": "64c054a65a725661595a5b2e38443803",
"assets/assets/images/logo.png": "c7482ce4975720fee0dbba2323e44308",
"assets/assets/images/milestones-image.png": "70e21b40a79a50fb179edc742910db38",
"assets/assets/images/mission-vision-banner-image.png": "0eabe2033d25a4fa37a3969f52845048",
"assets/assets/images/payment-methods.png": "9cf8b42649abcf8237f4d1f765c7f5b1",
"assets/assets/images/product1-image.png": "89502d7d641085f420c578e9caa7efe2",
"assets/assets/images/product2-image.png": "2c5b325f56a6abdef48067d803235cdd",
"assets/assets/images/product3-image.png": "523cdd8bb9f86f02a26e1e72dabdebd8",
"assets/assets/images/product4-image.webp": "35d262e80e8a6343b7e99e82d575e16a",
"assets/assets/images/product5-image.webp": "cc88f984a978823463ca01caabfae9c8",
"assets/assets/images/rediscover-banner-image.png": "690948ea40a731ef7efe23aae843fd14",
"assets/assets/images/rediscover-banner-title-image.png": "230fe910372baffd5469a12b67e552e5",
"assets/assets/images/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/images/testimonial-customer-image.png": "3fa0bbc2ec0091a95756ca442796160e",
"assets/assets/images/vaooda-brand-image.png": "4980ae10327a23fe79b315999324b82e",
"assets/assets/translations/fr.json": "af89c65b5c0902f07efcf99c4b7df282",
"assets/assets/vectors/arrow-to-bottom-icon-style2.svg": "f8f866c7847bd1f9d7fc08cfd400a173",
"assets/assets/vectors/arrow-to-right-icon.svg": "d32e54c23d0af874d5172495c8db97a2",
"assets/assets/vectors/branch-decoration1.svg": "9b1627c56f6d074942e476a908991c79",
"assets/assets/vectors/branch-decoration2.svg": "ad46927790636af1ed416db1f8298d16",
"assets/assets/vectors/cart-icon.svg": "ab3a7968df5df86480fef67d75512ecb",
"assets/assets/vectors/close-icon.svg": "a820f426a2b52d57a2e666100a19eb08",
"assets/assets/vectors/facebook-icon.svg": "3fdd62cbf45397109cc380bb3a7fe97a",
"assets/assets/vectors/information-icon.svg": "9564e04a9c01d248db961c89b12b5e0d",
"assets/assets/vectors/instagram-icon.svg": "6200ad3698860fc3e36d4430e067a104",
"assets/assets/vectors/linkdin-icon.svg": "b0a78973587be0b94ede1128a24aad99",
"assets/assets/vectors/logo.svg": "f55f70aea95f630d8b253f4d3362a5b1",
"assets/assets/vectors/mission-vision-banner-rounded-text.svg": "b42ff5bb5f31130ed895bdd0c518dfd0",
"assets/assets/vectors/profile-icon.svg": "012b46fc22733782daecfa1becd2abb1",
"assets/assets/vectors/promo-videos-play-button-icon.svg": "69dad96df8bb5164f77cbc3646935118",
"assets/assets/vectors/quote-icon.svg": "773b6c8764efb3964f7094b53f54abb6",
"assets/assets/vectors/sidebar-icon.svg": "b1e1e93948f27e1991544ff665a785d8",
"assets/assets/vectors/twitter-icon.svg": "ec9c64efb712ef8fd6e928ef487df835",
"assets/assets/vectors/wishlist-icon.svg": "632322625f7dc9a7f06e07c91411f9b4",
"assets/FontManifest.json": "55a4835faf4296318ece31e5e482cfaa",
"assets/fonts/MaterialIcons-Regular.otf": "2902b56e4b535e6da56a69a50316702d",
"assets/NOTICES": "29677116669f663b503ce407033b344d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "a5e75938296a6aadb4d1dbbfaf1a2268",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "ef7d65ab76f7858f043288e9688c1c89",
"/": "ef7d65ab76f7858f043288e9688c1c89",
"main.dart.js": "4ba338ff533605427a3169fd8b31de15",
"manifest.json": "c9b30ba3a08474e29e64d63e69863869",
"version.json": "44fb1b51a0cad25caacba78807fbff15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
