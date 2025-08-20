'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "7bd4652c7c272b88ab89b01dc89b5c2c",
"assets/AssetManifest.bin.json": "280ab13ba67c7a6b008e4d5d196b7840",
"assets/AssetManifest.json": "ec4cb9635ff191060f6f9ba3355605da",
"assets/assets/audio/correct.wav": "c347c53135a77fd2dd2e3f075566a8e2",
"assets/assets/audio/game_win.mp3": "de7c0cf36488e8bae779a91a49d5d0cd",
"assets/assets/audio/level_win.mp3": "604373c9fe8af4fa0ca994d7dd00e159",
"assets/assets/audio/wrong.mp3": "91f2951dec5307c557ab13761ddbf37e",
"assets/assets/fonts/Involve-Bold.ttf": "1f33d25795c8202989e48f359c941ec9",
"assets/assets/fonts/Involve-Medium.ttf": "9e4c17f76d8f5063bc036dd02cdd46a1",
"assets/assets/fonts/Involve-Regular.ttf": "48a394e7bfdd510ff37d980eaa08df70",
"assets/assets/fonts/Involve-SemiBold.ttf": "072972f22520ab8fb52824ff1c0fcf34",
"assets/assets/images/2177-min.png": "b733df326275ca1aafff93086c377843",
"assets/assets/images/2179-min.png": "db2726f11335498eed30dbbfa567aeca",
"assets/assets/images/2182-min.png": "cb5433feee7eb61fc9770e3220748a1e",
"assets/assets/images/2183-min.png": "0d7b59617f8eb7b255f428d25a1d9785",
"assets/assets/images/2184-min.png": "c999d179755a99cd9533257afa174ac0",
"assets/assets/images/2185-min.png": "6c46707189103ac6cac695454f546fbf",
"assets/assets/images/2186-min.png": "06ce6b26636415178af8be6f72fa0309",
"assets/assets/images/2187-min.png": "34b489e80d787299f04259fa49a89615",
"assets/assets/images/2188-min.png": "91624b5da0be8dfd79b8a11c4c435632",
"assets/assets/images/2189-min.png": "1313e7e270eb0901602ac5dc6883e202",
"assets/assets/images/2190-min.png": "d6816e7ae3b3ec01b60f856cb01a6f8c",
"assets/assets/images/2191-min.png": "b09d38aa05828672f62e9f9ef9d3440b",
"assets/assets/images/2192-min.png": "85d34b85b033903c7afd82acc54997c5",
"assets/assets/images/2194-min.png": "3cdf7d664444f5586b74c9752cc8d0d5",
"assets/assets/images/3user.svg": "ac2f53045034e169b54d70e37ce45e06",
"assets/assets/images/all_kids.png": "c7ebecbe2e18eeb3c14a654718d07cc5",
"assets/assets/images/android12splash.png": "0fbabf721c5c26eec52d29a04616a4cf",
"assets/assets/images/bell.svg": "570173de29e582f054b6484a661180e6",
"assets/assets/images/bell_fill.svg": "5e0e12e62ca13cbb81b3d40b24b1a7b9",
"assets/assets/images/bonus.svg": "888bc5965a3e3fa4abac394fb7b1ac4d",
"assets/assets/images/bonus_filled_tab.svg": "58e4337bc4fbd2faa8b643d2c321c9ae",
"assets/assets/images/bonus_tab.svg": "3ac8dfc3fe4d4db2a020a593ab18ec4b",
"assets/assets/images/bubble.svg": "4341a8aeb59c3fec15541ecd6d9ad9c7",
"assets/assets/images/calendar.svg": "5d247456a10dc60ad59de3982c1020b4",
"assets/assets/images/cancel.svg": "a7523268aedf30bb4f6e4d9e8772fcbd",
"assets/assets/images/chat_filled_tab.svg": "e48635531f40e36d23c629d06f9f9f5c",
"assets/assets/images/chat_tab.svg": "dfa9265177a8cdf28a47b390b3dcd76a",
"assets/assets/images/checkmark.svg": "45dc8a02043d221f982cfdeeee907da8",
"assets/assets/images/coin.svg": "ba18e4af44dc148ae6560b5c679dc00e",
"assets/assets/images/coins.svg": "90fd0744565f10e079cefb2a8e24c8d4",
"assets/assets/images/crown.svg": "0672bb6844499e3c71930824d4dbaa1c",
"assets/assets/images/delete.svg": "63c6ba6ebd74deaab6f2aef0eaacaaa5",
"assets/assets/images/diary.svg": "4f44a20226cb2d38a5f30e4786a5596d",
"assets/assets/images/done_fill.svg": "337dc1042aebcc672a4886eeab975c0e",
"assets/assets/images/edit.svg": "df0b8e12918731d6f95a047205d724c3",
"assets/assets/images/edit_blue_fill.svg": "e1edacdfd41c3768532a9edb9a95ecbf",
"assets/assets/images/em_bad.svg": "41bea0c015b90b4a261c615d93c58ec4",
"assets/assets/images/em_bad_filled.svg": "390e123ef477ac7e4792e1a0af9f8130",
"assets/assets/images/em_good.svg": "0c68b6f5e9811071090314c5f066c019",
"assets/assets/images/em_good_filled.svg": "c1980ceeb4e26b7ccc8d9d2902a1a827",
"assets/assets/images/em_joyful.svg": "c55e0e01f77840e2ecd521c79e240e08",
"assets/assets/images/em_joyful_filled.svg": "1cc098231da0858fd5ff0b6758651363",
"assets/assets/images/em_normal.svg": "2277f22dea62c280055667f0fefce7dc",
"assets/assets/images/em_normal_filled.svg": "a5fa8bef134424059d7612ab94982e71",
"assets/assets/images/em_sad.svg": "4093a2c3d36be5cad5fc2683024cc221",
"assets/assets/images/em_sad_filled.svg": "efa0fbc3b247ae6d957780507d3c61fa",
"assets/assets/images/game.svg": "625e29242146135ba13cda0b69b2076a",
"assets/assets/images/game_filled_tab.svg": "4ce5a9c806e65453605971a69c8098fe",
"assets/assets/images/game_tab.svg": "5bd2a036b786c4e48a0cc4b4baef7b92",
"assets/assets/images/hearts_bg.svg": "6cc2c3b95156d7bf16be0e460f22f2aa",
"assets/assets/images/info_square.svg": "2702723000d765ad6110f1ccdfc94196",
"assets/assets/images/info_square_filled.svg": "9058aac0e99e242cde254f551aeb69f9",
"assets/assets/images/lang.svg": "1a2af508da34f35c28ade9c2b0d0500d",
"assets/assets/images/level_chevron.svg": "59bd5e869ef42cfe429f56c023003d5d",
"assets/assets/images/link.svg": "c7a503ad3b21173072fe8e775917a85a",
"assets/assets/images/lock_fill.svg": "f5811bd26b45a388715bab201923462f",
"assets/assets/images/logo.svg": "983f3cc138869bcc2904a3ecaa21ea33",
"assets/assets/images/logout.svg": "ef91c0a9421bb503977480a6aab81b72",
"assets/assets/images/logo_min.svg": "a1b05e74500dbd271a4481007e32ac1e",
"assets/assets/images/members.svg": "985366c19fa5134754d55b2378a14f6b",
"assets/assets/images/mentors.png": "7ef2423334cba1a76e53bafdbcc3aca7",
"assets/assets/images/moon_star_bg.svg": "09178f02c6bfc5747eea98a9c7005a83",
"assets/assets/images/no_image.png": "de955ba3110e9ce82b99837994871998",
"assets/assets/images/picker_camera.svg": "8b91c7ebeee1a4291b76f025edd0814d",
"assets/assets/images/picker_gallery.svg": "9d5c3e84392b2ede236aa8d2f34be460",
"assets/assets/images/place_flag.svg": "c700ae97d45f9baff719d299f549b74f",
"assets/assets/images/play_fill.svg": "cf86fee81348a62ce76683fdb672dcd8",
"assets/assets/images/points.svg": "748834c58964b91577ffa3f8fd468f02",
"assets/assets/images/profile_filled_tab.svg": "80efe336f49ecede57624c0c17e4a3b8",
"assets/assets/images/profile_tab.svg": "595d093bdad6d17783176d5352158166",
"assets/assets/images/progress.svg": "e09a90f3d28f7c8c6b85037c518ddb98",
"assets/assets/images/progress_red.svg": "22704c6875d8482ba09592854902031b",
"assets/assets/images/qr.svg": "8c529c815e9af5efcfc80642119a9939",
"assets/assets/images/rain_bg.svg": "9200121be23b93c48c10de1794ba0e19",
"assets/assets/images/red_flag.svg": "7d30d9ee9896ae49c5cb6c2ea5c8859a",
"assets/assets/images/scan_q.svg": "c68369e522ab9b989ca2e90e1fbc28ef",
"assets/assets/images/select_kid.svg": "27e9f7a95193000112bbfed976d2d4f8",
"assets/assets/images/select_mentor.svg": "e0cfc9be1dd189575995321d0f67e008",
"assets/assets/images/send.svg": "db210836cfc0325d3d3ff2ea9be63c53",
"assets/assets/images/setting.svg": "961718f326277af860e2f6e6e59af231",
"assets/assets/images/share.svg": "10d71b96c8a94610d444559584c37d50",
"assets/assets/images/star.svg": "4eda386624ef8d5c4915667fd96ed1fb",
"assets/assets/images/task_of_day.svg": "c569f8fc664c7c05f1852507de272c85",
"assets/assets/images/task_without_point.svg": "cf48e6d560cffb88acbf4e93245c5234",
"assets/assets/images/task_with_point.svg": "b8e1e9d0d07bb49470c9d6fd8ae29e91",
"assets/assets/images/time_circle.svg": "7e77dd9610dc6e3cad56eb1a9a798991",
"assets/assets/images/tracker_filled_tab.svg": "c1cb9ca585839ff9d16ec15b29150303",
"assets/assets/images/tracker_tab.svg": "8af6acb450c81a9515e5731bda356b63",
"assets/assets/translations/en.json": "bc53c32195aed7f2cc7574f229933858",
"assets/assets/translations/ru.json": "e54b44dd480dc822ccacf9699abdfdcb",
"assets/FontManifest.json": "80658558740059e1fb18b1c55403668c",
"assets/fonts/MaterialIcons-Regular.otf": "c646bca65d62c526977d77bdef003ccd",
"assets/NOTICES": "b223f076e8f0f220539ac7ece76c825c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "218c37dd7fd0ed2a9218ed283e17d80b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"firebase-messaging-sw.js": "3be52d15587c795ee0a2f3e0109cf33e",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"flutter_bootstrap.js": "16cc551a1de6cab7da0583dfa993e966",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "222d040a7331f9671ef9e5434614f7c0",
"/": "222d040a7331f9671ef9e5434614f7c0",
"main.dart.js": "00b6e6bf7fed429fbc44feb84db61bc2",
"manifest.json": "329568535a4ec4b923a161d1fe22a272",
"splash/img/dark-1x.png": "8aec2533dd2e40b833c01b94736deb4e",
"splash/img/dark-2x.png": "5cd46649f7e37ead0a43ce7ac201da2d",
"splash/img/dark-3x.png": "7519ea5d86f7d1bb0ebf192cdf3b65e0",
"splash/img/dark-4x.png": "86d3754d824a83906e0f537f70455b2d",
"splash/img/light-1x.png": "8aec2533dd2e40b833c01b94736deb4e",
"splash/img/light-2x.png": "5cd46649f7e37ead0a43ce7ac201da2d",
"splash/img/light-3x.png": "7519ea5d86f7d1bb0ebf192cdf3b65e0",
"splash/img/light-4x.png": "86d3754d824a83906e0f537f70455b2d",
"version.json": "73654a5b9f12be1d6edaa7535a054f6b"};
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
