importScripts("/portal/client/v1/precache-manifest.208d6bbd0f8066dd2ce4e4fdae59af92.js", "/portal/client/v1/workbox-v4.3.1/workbox-sw.js");
workbox.setConfig({modulePathPrefix: "/portal/client/v1/workbox-v4.3.1"});
self.__precacheManifest = [].concat(self.__precacheManifest || [])
workbox.precaching.suppressWarnings()
workbox.precaching.precacheAndRoute(self.__precacheManifest, {})

workbox.routing.registerRoute(
  /\.(?:png|gif|jpg|jpeg|svg)$/,
  workbox.strategies.staleWhileRevalidate(0),
)

workbox.routing.registerRoute(
  new RegExp('https://reqres.in'),
  workbox.strategies.networkFirst(),
)

