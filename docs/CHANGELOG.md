# CHANGELOG — Il Forno Madre B2B Platform

Formato: [versione] — data — descrizione

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
