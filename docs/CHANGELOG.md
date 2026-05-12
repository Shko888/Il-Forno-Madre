# CHANGELOG — Il Forno Madre B2B Platform

Formato: [versione] — data — descrizione

---

## [0.15.0] — 2026-05-12 — Ridimensionamento automatico foto (Canvas API, max 800x600 JPEG 85%)

### Aggiunto
- `dashboard_admin.html`: `resizeImage()` — Canvas API ridimensiona automaticamente prima dell'upload
- Ogni foto viene convertita in JPEG 85%, max 800×600px, ~100-300KB

---

## [0.14.0] — 2026-05-12 — Foto full bleed con padding controllato

### Modificato
- `menu_b2b.html`: `.pcard-img` height e padding aggiornati per proporzioni ottimali (50% altezza, 65% larghezza)
- `menu_b2b.html`: sfondo casella foto → gradiente caldo `linear-gradient(145deg, ...)`

---

## [0.13.0] — 2026-05-12 — Strip numeri brand, card fiducia, copy artigianale

### Aggiunto
- `menu_b2b.html`: strip numeri (20 anni · 24–48h · 100%) in font Cormorant
- `menu_b2b.html`: 3 card fiducia (Dal 2005 · Consegna gratuita · Un click)
- `menu_b2b.html`: frase posizionamento + titolo catalogo "Dal forno a te"
- `menu_b2b.html`: rimossa service card "Zona di consegna" ridondante

---

## [0.12.0] — 2026-05-12 — Promo visibili nel menu B2B

### Aggiunto
- `menu_b2b.html`: banner offerte attive caricate da tabella `offers` Supabase
- Filtro per data `valid_to` — mostrate solo le promo non scadute

---

## [0.11.0] — 2026-05-12 — IVA 4/10/22%, date gg/mm/aaaa, ordini per data arrivo

### Aggiunto
- `dashboard_admin.html`: campo IVA per prodotto (4%, 10%, 22%)
- `menu_b2b.html` + `dashboard_admin.html`: `formatDate()` per display sempre in gg/mm/aaaa
- `dashboard_admin.html`: ordini ordinati per `created_at.desc` (più recenti prima)

---

## [0.10.0] — 2026-05-12 — Sistema modifica completa prodotti con modal precompilato

### Aggiunto
- `dashboard_admin.html`: `openEditProductModal(index)` precompila tutti i campi dal prodotto esistente
- `dashboard_admin.html`: `saveProduct()` gestisce sia nuovo (POST) che modifica (PATCH Supabase)
- `dashboard_admin.html`: DELETE prodotto con conferma

---

## [0.9.0] — 2026-05-12 — Galleria 3 foto per prodotto + lightbox zoom

### Aggiunto
- `dashboard_admin.html`: 3 slot foto nel modal prodotto con preview locale
- `dashboard_admin.html`: upload parallelo fino a 3 foto, salvate in `images[]` + `image`
- `menu_b2b.html`: galleria con foto principale + miniature cliccabili (`switchPhoto()`)
- `menu_b2b.html`: lightbox zoom al click (`openLightbox()`) con chiusura Escape

---

## [0.8.0] — 2026-05-10 — Upload foto prodotti su Supabase Storage

### Aggiunto
- `dashboard_admin.html`: campo file upload foto nel modal "Nuovo prodotto" (JPG, PNG, WebP · max 5MB)
- `dashboard_admin.html`: `previewPhoto(input)` — anteprima locale con FileReader prima del POST
- `dashboard_admin.html`: `uploadPhoto(file)` async — POST binario a `/storage/v1/object/product-images/{fileName}`, restituisce URL pubblico
- `dashboard_admin.html`: `saveProduct()` ora async — upload foto se presente, poi salva prodotto con campo `image`
- `dashboard_admin.html`: `renderProducts()` — miniatura 40×40px se `p.image` disponibile, altrimenti emoji
- `dashboard_admin.html`: `openAddProductModal()` — reset campo foto e nasconde anteprima alla riapertura

---

## [0.7.0] — 2026-05-10 — Immagini prodotti, IVA visibile, impostazioni azienda

### Aggiunto
- `menu_b2b.html`: supporto campo `image` nelle card prodotto (`<img object-fit:cover>`)
- `menu_b2b.html`: nota "+ IVA 10%" sotto ogni prezzo prodotto (11px, colore muted)
- `menu_b2b.html`: descrizione prodotto con `line-clamp: 3` righe
- `menu_b2b.html`: carrello con etichette semplificate: "Subtotale" e "TOTALE"
- `dashboard_admin.html`: pagina Impostazioni (⚙️ in sidebar) con form dati azienda + parametri commerciali
- `dashboard_admin.html`: `DEFAULT_SETTINGS`, `loadSettings()`, `renderSettings()`, `saveSettings()`
- `dashboard_admin.html`: nome azienda nel footer sidebar aggiornabile via impostazioni

---

## [0.6.0] — 2026-05-10 — Responsive completo: mobile, tablet, desktop, iOS, Android

### Modificato
- Entrambi i file: `viewport-fit=cover` per iPhone notch e safe area
- `menu_b2b.html`: `cat-bar` con scroll orizzontale senza scrollbar visibile (flex-nowrap)
- `menu_b2b.html`: touch target 44px su `qty-btn`, `add-cart-btn`, `cat-btn`
- `menu_b2b.html`: iOS zoom fix — `font-size:16px` su input/select/textarea ≤767px
- `menu_b2b.html`: `env(safe-area-inset-bottom)` su cart-footer e toast
- `menu_b2b.html`: griglia prodotti — 1 col ≤479px, 2 col 480–767px, auto-fill tablet/desktop
- `menu_b2b.html`: carrello 100vw su mobile, 380px tablet, 420px desktop
- `menu_b2b.html`: modal come bottom-sheet su mobile (border-radius top, max-height 95vh)
- `dashboard_admin.html`: touch target 44px su btn, sb-item, form inputs
- `dashboard_admin.html`: KPI grid — 2 colonne ≤479px, 4 colonne fisso ≥768px
- `dashboard_admin.html`: modal bottom-sheet su mobile

---

## [0.5.0] — 2026-05-10 — Fix struttura HTML app-wrapper

### Risolto
- `dashboard_admin.html`: `app-wrapper` era auto-chiuso (`></div>`) — l'overview risultava bianca perché sidebar, topbar, main erano fuori dal wrapper
- `dashboard_admin.html`: `display:none` iniziale su `app-wrapper` (evita flash pre-auth)
- `dashboard_admin.html`: titolo sidebar e topbar aggiornati a "Il Forno Madre"
- `dashboard_admin.html`: footer aggiornato a "Il Forno Madre © 2025"

---

## [0.4.0] — 2026-05-10 — Fix definitivo visualizzazione items ordini

### Risolto
- `dashboard_admin.html`: `parseItems()` usa `Array.isArray` come check primario (jsonb Supabase arriva già come array JS)
- `dashboard_admin.html`: `renderOrders()` usa `join(', ')` invece di `join('<br>')`
- `dashboard_admin.html`: rimossi tutti i `console.log` di debug
- Funzioni corrette: `mapOrder()`, `orderTotal()`, `renderOrders()`, `showOrderDetail()`

---

## [0.3.0] — 2026-05-10 — Salvataggio dati cliente in localStorage

### Aggiunto
- `menu_b2b.html`: `openOrder()` pre-compila nome/tel/email/indirizzo da `localStorage['forno_cliente']`
- `menu_b2b.html`: `submitOrder()` salva dati cliente dopo invio ok
- `menu_b2b.html`: link "Non sei tu? Cambia dati" che cancella localStorage e pulisce i campi

---

## [0.2.0] — 2026-05-10 — Dashboard legge ordini da Supabase

### Aggiunto
- `dashboard_admin.html`: `loadOrders()` — GET `/rest/v1/orders?order=created_at.desc`
- `dashboard_admin.html`: `mapOrder()` — mapping campi Supabase → dashboard (client_name→client, delivery_date→deliveryDate, ecc.)
- `dashboard_admin.html`: `parseItems()` per gestire `items` jsonb come stringa o array
- `dashboard_admin.html`: `orders` inizializzato a `[]` invece di `DEFAULT_ORDERS`
- `dashboard_admin.html`: `loadOrders()` chiamata al boot (DOMContentLoaded) e dopo login PIN

---

## [0.1.1] — 2026-05-10 — Integrazione Supabase ordini menu B2B

### Modificato
- `menu_b2b.html`: `submitOrder()` convertita da `window.open(wa.me)` a `fetch POST /rest/v1/orders`
- Genera ID ordine: `ORD-YYYYMMDD-XXXX` (4 char random maiuscoli)
- Calcola totale: `subtotale × 1.10 + €20 se subtotale < €150`
- Headers: `apikey`, `Authorization Bearer`, `Content-Type`, `Prefer: return=representation`
- Campi inseriti: `id`, `client_name`, `tel`, `addr`, `agent_name`, `order_date`, `delivery_date`, `delivery_time`, `items` (array jsonb), `note`, `status='new'`, `total`
- Toast con numero ordine in caso di successo, toast errore in italiano in caso di fallimento

---

## [0.1.0] — 2026-05-10 — Setup iniziale

### Aggiunto
- Struttura cartelle progetto completa
- `skills/` — documentazione tecnica completa (ARCHITECTURE, DESIGN_SYSTEM, BUSINESS_LOGIC, DEPLOY, TROUBLESHOOTING)
- `supabase/schema.sql` — schema database con 5 tabelle, RLS, realtime, indici
- `vercel.json` — configurazione hosting con rewrites
- `docs/TODO.md` — roadmap sviluppo
- `src/menu/menu_b2b.html` — menu B2B con carrello, modal ordine, filtri categoria
- `src/dashboard/dashboard_admin.html` — dashboard con PIN login, ordini, prodotti, clienti, agenti, offerte
- `README.md` — documentazione progetto
- Deploy su Vercel: `il-forno-madre.vercel.app`
- GitHub: `github.com/Shko888/Il-Forno-Madre`
- Supabase: `klhuctufvfmrowysoqzg.supabase.co`
