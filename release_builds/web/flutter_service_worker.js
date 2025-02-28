'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "deab2b9d7fd1bc12d36dd04b20fefb15",
"assets/AssetManifest.bin.json": "fddee4073f8cb33961b9f46f2a29c9a9",
"assets/AssetManifest.json": "d3ecfcddc40513d03323e4c853388e4c",
"assets/assets/data/dummy_data/auth/sign_in_response.json": "dc5a0bd12a50eb9ae8d26d98b027190b",
"assets/assets/data/dummy_data/auth/sign_out_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/auth/sign_up_response.json": "dc5a0bd12a50eb9ae8d26d98b027190b",
"assets/assets/data/dummy_data/category/get_all_categories_response.json": "4744ece09ad569bda46111ffb160e1a6",
"assets/assets/data/dummy_data/category/get_categories_response.json": "dd78a79b2268874f0d3e01424c89e4cc",
"assets/assets/data/dummy_data/category/get_sub_categories_response.json": "3f2ee880a0967f9fb80ff15aeb63dd0a",
"assets/assets/data/dummy_data/message_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/product/create_product_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/product/get_products_response.json": "16e029245fc373d75f595d22b47bde6b",
"assets/assets/data/dummy_data/product/get_product_response.json": "2c0ec0a2469acb4ccd0fc21bd5aba092",
"assets/assets/data/dummy_data/product/update_product_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/system_message/create_system_message_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/system_message/get_system_messages_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/system_message/get_system_messages_shown_response.json": "46589a2c1ee7bd54f44921bb1ee30f13",
"assets/assets/data/dummy_data/system_message/get_system_message_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/system_message/update_system_message_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/dummy_data/user/get_user_response.json": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/data/local_data/local_db_alfia.db": "b1540ea7be0a9ce8ef2f2beb6d51d526",
"assets/assets/files/lottie/bad-routing.json": "7ea3b835084aa881c693a1a2e2a316dd",
"assets/assets/files/lottie/book-loading.json": "0bc0d892a7d9c87d4e239400b44a1d34",
"assets/assets/files/lottie/maintenance.json": "a65193e1909eb26e184ce0f092e03452",
"assets/assets/files/lottie/success.json": "129b6f4cdda5a34d842c1b4af1957df6",
"assets/assets/files/lottie/warning.json": "fe7efcef8fbf06f60127bcfff3a5a82a",
"assets/assets/fonts/analogue_reduced/analogue-reduced-black.otf": "130589dc374a403a4515874218b9ac9c",
"assets/assets/fonts/analogue_reduced/analogue-reduced-blackoblique.otf": "65b9f54a1d67655594e7ddebacea54f1",
"assets/assets/fonts/analogue_reduced/analogue-reduced-bold.otf": "66beace27747426f0671d304df574259",
"assets/assets/fonts/analogue_reduced/analogue-reduced-boldoblique.otf": "c9b65d748ea21d90f11478e3b1d686fe",
"assets/assets/fonts/analogue_reduced/analogue-reduced-light.otf": "8dec1bbd8ecae692000d3baca936a9b4",
"assets/assets/fonts/analogue_reduced/analogue-reduced-lightoblique.otf": "078be9db09ca21e33c3b9b43e7539369",
"assets/assets/fonts/analogue_reduced/analogue-reduced-medium.otf": "d41295cb40842ff0f8d9058609282fde",
"assets/assets/fonts/analogue_reduced/analogue-reduced-mediumoblique.otf": "21d14d6e45d86dd318a24ba5831014ba",
"assets/assets/fonts/analogue_reduced/analogue-reduced-oblique.otf": "d0cab3b50f08c2b72ebec618aa2e7129",
"assets/assets/fonts/analogue_reduced/analogue-reduced-regular.otf": "31a9a3760c6a8268f71c4ea92f3c0acb",
"assets/assets/fonts/analogue_reduced/analogue-reduced-thin.otf": "1358aa89a465908fec9fc37e100f1492",
"assets/assets/fonts/analogue_reduced/analogue-reduced-thinoblique.otf": "2549641fb94dab0b6cef8edf0d3f2d24",
"assets/assets/fonts/barlow_condensed/barlow-condensed-black.ttf": "f93cd47b7590ae82bc2a73394bd4bf74",
"assets/assets/fonts/barlow_condensed/barlow-condensed-blackitalic.ttf": "0bc0443292f2691bdfe9a3bb093c622e",
"assets/assets/fonts/barlow_condensed/barlow-condensed-bold.ttf": "0abc11955dc269acff39ccd5921d6daa",
"assets/assets/fonts/barlow_condensed/barlow-condensed-bolditalic.ttf": "c22305d117f3bc8b841e226437350554",
"assets/assets/fonts/barlow_condensed/barlow-condensed-extrabold.ttf": "c4c21b40e657120ff6bd264de5155962",
"assets/assets/fonts/barlow_condensed/barlow-condensed-extrabolditalic.ttf": "789b77fd7ccff4079bc230485b366a0d",
"assets/assets/fonts/barlow_condensed/barlow-condensed-extralight.ttf": "853a05f22fce224269fb150bc6f81e5d",
"assets/assets/fonts/barlow_condensed/barlow-condensed-extralightitalic.ttf": "1728b33cbf16ce4cec8fa43195eb530f",
"assets/assets/fonts/barlow_condensed/barlow-condensed-light.ttf": "95636c7b77d97cbad2cb75a3bcc45b9f",
"assets/assets/fonts/barlow_condensed/barlow-condensed-lightitalic.ttf": "22a338d62c9ec9fb92389e13cd0703b7",
"assets/assets/fonts/barlow_condensed/barlow-condensed-medium.ttf": "43b6c7b5a36d8a01302e1f75efe8b948",
"assets/assets/fonts/barlow_condensed/barlow-condensed-mediumitalic.ttf": "bad0fc8bf2eb5c657f9808ce0b9daf85",
"assets/assets/fonts/barlow_condensed/barlow-condensed-regular.ttf": "b9aa6092c4b6375d58005ce949fc1202",
"assets/assets/fonts/barlow_condensed/barlow-condensed-regularitalic.ttf": "4314c1433101a7eb1bc3358f5f8fb77e",
"assets/assets/fonts/barlow_condensed/barlow-condensed-semibold.ttf": "6917d6f7470c1aedebcfa8c66b5c2a37",
"assets/assets/fonts/barlow_condensed/barlow-condensed-semibolditalic.ttf": "b84f7ddec88394938a954ee4e2ac06c8",
"assets/assets/fonts/barlow_condensed/barlow-condensed-thin.ttf": "c8c38f416f0696568e49c47a62608721",
"assets/assets/fonts/barlow_condensed/barlow-condensed-thinitalic.ttf": "c3b06585aaea620b3327f5c24a15f492",
"assets/assets/fonts/cairo/cairo-black.ttf": "d5cfdef0ee5e1b9765295e3b58f43233",
"assets/assets/fonts/cairo/cairo-bold.ttf": "ad486798eb3ea4fda12b90464dd0cfcd",
"assets/assets/fonts/cairo/cairo-extrabold.ttf": "92ae313db90f497a9b8fec09433a70de",
"assets/assets/fonts/cairo/cairo-extralight.ttf": "a699568a2cf9e5794c5eccf7909b39c5",
"assets/assets/fonts/cairo/cairo-light.ttf": "c4a2ada0dd57e03f921b8f7d45820268",
"assets/assets/fonts/cairo/cairo-medium.ttf": "2b76c14c6934874d64ab85d92c4949e1",
"assets/assets/fonts/cairo/cairo-regular.ttf": "5ccd08939f634db387c40d6b4b0979c3",
"assets/assets/fonts/cairo/cairo-semibold.ttf": "e11b6bc7a07669209243fce5de153be4",
"assets/assets/fonts/calibri/calibri-bold.otf": "a34160144567cbc0b7b87d132596ee89",
"assets/assets/fonts/calibri/calibri-bolditalic.otf": "8d4812ce0703aa59d094178011b5271d",
"assets/assets/fonts/calibri/calibri-light.otf": "3328a1bbd2663820a89b656c9fd4d5e1",
"assets/assets/fonts/calibri/calibri-lightitalic.otf": "ebf8c98c232a3918a060f0d68b7e9b76",
"assets/assets/fonts/calibri/calibri-regular.otf": "eaf15ead307ebe815fde815e5114f526",
"assets/assets/fonts/calibri/calibri-regularitalic.otf": "5024aaedba9f7af3ff8b56d7987f24ba",
"assets/assets/fonts/roboto_mono/roboto-mono-bold.ttf": "90190d91283189e340b2a44fe560f2cd",
"assets/assets/fonts/roboto_mono/roboto-mono-bolditalic.ttf": "ff657358db1650242d3896f4e6a17cb1",
"assets/assets/fonts/roboto_mono/roboto-mono-extralight.ttf": "642c61c3093f360ebfe8c96dce691e21",
"assets/assets/fonts/roboto_mono/roboto-mono-extralightitalic.ttf": "6fe6edf7704d61127966047e0ee05e7e",
"assets/assets/fonts/roboto_mono/roboto-mono-light.ttf": "c9166464b1db95fc3cdf9b50fc7f98e2",
"assets/assets/fonts/roboto_mono/roboto-mono-lightitalic.ttf": "029bc3c3cc4278d2e0830f4240c9903d",
"assets/assets/fonts/roboto_mono/roboto-mono-medium.ttf": "0eaa3f458fb2611ca44b021db3db09a8",
"assets/assets/fonts/roboto_mono/roboto-mono-mediumitalic.ttf": "6bea71cb28b47720d7d1298dc6e30842",
"assets/assets/fonts/roboto_mono/roboto-mono-regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/assets/fonts/roboto_mono/roboto-mono-semibold.ttf": "eabbacb68fea19c24a80eaed6715ca4a",
"assets/assets/fonts/roboto_mono/roboto-mono-semibolditalic.ttf": "d6cd56b24c1859f3e01ec50684338882",
"assets/assets/fonts/roboto_mono/roboto-mono-thin.ttf": "564755b4222c6321216f1e764c9204f9",
"assets/assets/fonts/roboto_mono/roboto-mono-thinitalic.ttf": "a114a11bf7df312c7c0ca28a8ed848a6",
"assets/assets/icons/icon-dark.png": "aa8c4866f52307b5736c154e09763606",
"assets/assets/icons/icon-foreground.png": "5443ed1aeecfabe2e91535dfea72d6e2",
"assets/assets/icons/icon.png": "45c045af4a0e599289abb1705bbea82e",
"assets/assets/images/2.0x/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/images/3.0x/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/images/author1-example.jpg": "1a791e7a8a7b338cea333399c5e371cd",
"assets/assets/images/author2-example.jpg": "4858fbe0a7c15b96448f19945900ccaa",
"assets/assets/images/cnl-reference-logo.png": "07adbf1e0f191acb1f6d30c8a3fd87ed",
"assets/assets/images/cover-example.png": "d529f471899223347abb75147108beae",
"assets/assets/images/cover2-example.png": "14e5271c6969edbea345d0e35ccb6632",
"assets/assets/images/cover3-example.png": "7f8b2ed573139484b47df62ee9555ec6",
"assets/assets/images/mjcc-logo.png": "456410acf082d2eff9ea33ddd1af6418",
"assets/assets/images/payment-methods.png": "9cf8b42649abcf8237f4d1f765c7f5b1",
"assets/assets/images/post1-example.png": "ae02a05cd52cad174d23e9ea12b881da",
"assets/assets/images/post2-example.png": "6b83208bf383c12a63a97b242ee0d073",
"assets/assets/images/post3-example.png": "e5a55e58fadc4c32050d1e6dfe4534de",
"assets/assets/images/splash.png": "002b1c6b00dc6d73aab556359b50ca67",
"assets/assets/translations/ar.json": "af888f2361f8bd34011cb4c5368646d2",
"assets/assets/translations/de.json": "e041be79f4e60dd5203f45b9cdcb7570",
"assets/assets/translations/en.json": "e2bc39384c64fa0c62bca8bc96a589ff",
"assets/assets/translations/fr.json": "59e2a1ca0ee15eadc39e82428396f750",
"assets/assets/vectors/arrow-bottom-icon.svg": "4e2fbefc45ff04b2532875cee691db29",
"assets/assets/vectors/arrow-left-icon.svg": "448928e3f311c3f18a6bac9d4211abcd",
"assets/assets/vectors/arrow-right-icon.svg": "90c5e2234afa99cf240b86b51ab95246",
"assets/assets/vectors/arrow-top-icon.svg": "7b60f979ccddaca0ede1b6860a65440f",
"assets/assets/vectors/assistance-icon.svg": "6aa8ff55a4dda224fda5686b56d1203e",
"assets/assets/vectors/badge.svg": "77b484d7f533a2756e7fb2a199545739",
"assets/assets/vectors/book-icon.svg": "007eca10f75cfcbc0c667cd0aa82ae4f",
"assets/assets/vectors/book-store-icon.svg": "5f8f582ad3908ec3625661a6ced92eb2",
"assets/assets/vectors/calendar-date-icon.svg": "55cf3076f9c8c9845cad4e6edc33807f",
"assets/assets/vectors/cart-fill-icon.svg": "e8dbd7e81102a0cba6a7cdc4763d3c41",
"assets/assets/vectors/cart-icon.svg": "5dfab13ef50797828d148ec6c89d9156",
"assets/assets/vectors/change-view1-icon.svg": "45c467e01af3bc0595edcb053946f8c0",
"assets/assets/vectors/change-view2-icon.svg": "d62208639edb3f52f57d7e8d116af7de",
"assets/assets/vectors/change-view3-icon.svg": "ffb089b6935387a4daa446de380b9a44",
"assets/assets/vectors/change-view4-icon.svg": "bb23fba86a87a6b2c88387b85efc985f",
"assets/assets/vectors/change-view5-icon.svg": "de01c62c103ba53871a8460edaa0b78d",
"assets/assets/vectors/check-filled-icon.svg": "1ad7f67c2111983603f3573870991b2b",
"assets/assets/vectors/clock-icon.svg": "b73b1238d2a49f5955b92976203f52ba",
"assets/assets/vectors/close-icon.svg": "a820f426a2b52d57a2e666100a19eb08",
"assets/assets/vectors/credit-card-filled-icon.svg": "f370e971cf4d354063edcf8885b7efe0",
"assets/assets/vectors/de-icon.svg": "2fe907316d7128b868f1be2c9bd0eb00",
"assets/assets/vectors/delivery-icon.svg": "e6f8b489832a807a6e5c07db5131dc6b",
"assets/assets/vectors/description-icon.svg": "99db6d202a96ff3162d491a8c0db9af9",
"assets/assets/vectors/eclipse-icon.svg": "5d45581e760c188882275ebbdbedcff2",
"assets/assets/vectors/edit-icon.svg": "4f01183f6448703da97e467fc04556ce",
"assets/assets/vectors/error-icon.svg": "38a37b885a808abed3959c290ae703d0",
"assets/assets/vectors/eye-fill-icon.svg": "1ddb5a614b4c86cdb282d79e6ea51a74",
"assets/assets/vectors/facebook-icon.svg": "fa0db6ef018c2eec3f3877b188c2ca28",
"assets/assets/vectors/fast-delivery-icon.svg": "94443f6e215418f172bdd296989e1ae7",
"assets/assets/vectors/filter-funnel-icon.svg": "448d4112cd96f94cc0ec13adc34e2cd2",
"assets/assets/vectors/fr-icon.svg": "8ff409e8c6c9c047a9391e513cda0f6d",
"assets/assets/vectors/heart-icon.svg": "e309911c39908ff9a092e43245fa544c",
"assets/assets/vectors/home-fill-icon.svg": "2ded62ecb3106f8cfc32008faef5fc80",
"assets/assets/vectors/information-icon.svg": "9564e04a9c01d248db961c89b12b5e0d",
"assets/assets/vectors/instagram-icon.svg": "4252885bd16186b430bf13a107b7c04d",
"assets/assets/vectors/location-icon.svg": "1c8e3e1a7c0bdd99d5c5c0fa81ca8446",
"assets/assets/vectors/logo-dark.svg": "204bec8eb8d7f044a3526412f29c125b",
"assets/assets/vectors/logo.svg": "a917ce774d8ad530e70b159040a07d56",
"assets/assets/vectors/logout-icon.svg": "2c0e6e7a8dd6f032efeaaa0758cb02c6",
"assets/assets/vectors/ma-icon.svg": "9ee4c2ee0d0a09e4112af7b247afb11f",
"assets/assets/vectors/minus-icon.svg": "cc0e263f1bc93d05b0ff9a25f8451f67",
"assets/assets/vectors/navigation-icon.svg": "b1e1e93948f27e1991544ff665a785d8",
"assets/assets/vectors/next-icon.svg": "67979db2bdb2923dab520ba442fcf45f",
"assets/assets/vectors/next-skip-icon.svg": "c0da53d1f211204b6c8d2b9853447c15",
"assets/assets/vectors/no-cover.svg": "3856a7027af16301e362cd3fea2c9bf2",
"assets/assets/vectors/no-result-found.svg": "e59a8a6d6c5cf3f008fd4814145dcd6e",
"assets/assets/vectors/no-search-result-found.svg": "24606a380a73a9461d95ebc97c6487e9",
"assets/assets/vectors/pay-money-filled-icon.svg": "c949d07ba6c91214eb95294e6f5c4372",
"assets/assets/vectors/pen-icon.svg": "b39df6e464c9c391916f01ff34e256ec",
"assets/assets/vectors/plus-icon.svg": "12e1157890538a4194e091fdc8e34ce1",
"assets/assets/vectors/previous-icon.svg": "af1296d9ae8ebbf64d24c4a212fdeaeb",
"assets/assets/vectors/previous-skip-icon.svg": "cf205b80592b78cdd46e291e2193634d",
"assets/assets/vectors/profile-icon.svg": "362c59bb0f546c9e6ea79d90360fca87",
"assets/assets/vectors/purchase-fill-icon.svg": "c4a3b1be2e608599c4d8bf98a190e60d",
"assets/assets/vectors/rating-half-star-icon.svg": "6f0835f3f586cf558a2285002d405a39",
"assets/assets/vectors/rating-star-icon.svg": "059a752836f4090ac4d38a392bb9227e",
"assets/assets/vectors/search-icon.svg": "2f41757b910382467a3782ed2578365b",
"assets/assets/vectors/secured-payment-icon.svg": "9af473a7a142a363707f2d01f7b718aa",
"assets/assets/vectors/showcase-icon.svg": "0d8aa616f643ad3601ce254202aabef0",
"assets/assets/vectors/success-icon.svg": "b86681dd229a994cb80ed864513dd66f",
"assets/assets/vectors/sun-icon.svg": "89128310f99f4d4f864f9f5a90882303",
"assets/assets/vectors/trash-icon.svg": "ccacd7b146dc07ec9667235c01006605",
"assets/assets/vectors/triangle-bottom-icon.svg": "9e045d1fb7ad66618229cd8955e27ca3",
"assets/assets/vectors/triangle-left-icon.svg": "e014b7e33f1d6204533620e3a1ffc82f",
"assets/assets/vectors/triangle-right-icon.svg": "d547332f752bcd2ae32fa262b2a20374",
"assets/assets/vectors/triangle-top-icon.svg": "8eac89e15925269833db3583101cbb56",
"assets/assets/vectors/twitter-icon.svg": "a718f98b67b5b6d3e99e62d099f0f359",
"assets/assets/vectors/us-icon.svg": "381a400f1948c11e4aec40bc4347cd68",
"assets/assets/vectors/user-edit-icon.svg": "3ec610e89bfea3f8ad05df656d30761e",
"assets/assets/vectors/users-icon.svg": "76eca8113e15cf0f338231af23c28ea0",
"assets/assets/vectors/warning-icon.svg": "c1ea6fcd667b74f1bb41e6a8472aab25",
"assets/assets/vectors/x-filled-icon.svg": "7fa7e4892fece5f6cb6d62b00aad5383",
"assets/assets/vectors/youtube-icon.svg": "ca2c58d1a15661bc9e1b67dcc69bbff0",
"assets/FontManifest.json": "979d9dae3fe3df2e2718080fd4c3ae69",
"assets/fonts/MaterialIcons-Regular.otf": "7dd144d387ee4961f93d30cf9d04472c",
"assets/NOTICES": "0b1c1c87be92dc99b03a0d1ed8b47eb8",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "7dde4655beaf9f2dbae76e4e54d16f34",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "f77bf6d11f2bef48ae8b3e8513297556",
"icons/Icon-192.png": "45f238fe0b4c982e94459791023e19b1",
"icons/Icon-512.png": "7f1a9e13b243e4d008b2ac6bcabd1f34",
"icons/Icon-maskable-192.png": "45f238fe0b4c982e94459791023e19b1",
"icons/Icon-maskable-512.png": "7f1a9e13b243e4d008b2ac6bcabd1f34",
"index.html": "06f0bf7fcf93055f81dc39222f978a42",
"/": "06f0bf7fcf93055f81dc39222f978a42",
"main.dart.js": "5d0cee7f2a18d8413eff94232c3d3d27",
"manifest.json": "fbefeff7d063415af31d5398e3ec3e45",
"sqflite_sw.js": "4e90ada89670da328d6c72679eb3f9a7",
"sqlite3.wasm": "fa7637a49a0e434f2a98f9981856d118",
"version.json": "e8390ac3049c442288ca51f4929f5174"};
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
