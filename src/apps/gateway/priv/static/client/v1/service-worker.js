importScripts("/portal/client/v1/precache-manifest.bf417a5f7ca5c891a093baacd6fda9f5.js", "/portal/client/v1/workbox-v4.3.1/workbox-sw.js");
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

