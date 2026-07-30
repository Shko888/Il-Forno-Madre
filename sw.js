const CACHE_NAME = 'forno-madre-v2';
const APP_SHELL = [
  '/',
  '/src/menu/menu_b2b.html',
  '/manifest.json',
  '/assets/img/products/teg_b.webp',
  '/assets/img/products/teg_b-800.webp',
  '/assets/img/products/teg_b_dettaglio.webp',
  '/assets/img/products/teg_b_dettaglio-800.webp',
  '/assets/img/products/focc_b.webp',
  '/assets/img/products/focc_b-800.webp',
  '/assets/img/products/hamburger.webp',
  '/assets/img/products/hamburger-800.webp',
  '/assets/img/products/piz_rot.webp',
  '/assets/img/products/piz_rot-800.webp',
  '/assets/img/products/pinsa.webp',
  '/assets/img/products/pinsa-800.webp',
];

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(APP_SHELL)));
  self.skipWaiting();
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))
    ))
  );
  self.clients.claim();
});

self.addEventListener('fetch', (e) => {
  // network-first per API Supabase (dati sempre freschi)
  if (e.request.url.includes('supabase.co')) {
    e.respondWith(fetch(e.request).catch(() => caches.match(e.request)));
    return;
  }
  // cache-first per asset statici
  e.respondWith(caches.match(e.request).then(r => r || fetch(e.request)));
});
