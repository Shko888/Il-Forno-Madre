# SKILL: ARCHITETTURA TECNICA
## Il Forno Madre B2B Platform

---

## Panoramica architettura

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENTE B2B                          │
│         (Ristorante, Bar, Hotel, iPhone/Desktop)        │
└─────────────────────┬───────────────────────────────────┘
                      │ HTTPS
                      ▼
┌─────────────────────────────────────────────────────────┐
│                 VERCEL CDN                              │
│              menu_b2b.html                              │
│         (HTML statico, JS client-side)                  │
└─────────────────────┬───────────────────────────────────┘
                      │ REST API + Realtime WebSocket
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  SUPABASE                               │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │ products │ │  orders  │ │ clients  │ │  agents  │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘  │
│                    + offers                             │
│              Realtime: orders INSERT                    │
└─────────────────────┬───────────────────────────────────┘
                      │ Realtime WebSocket
                      ▼
┌─────────────────────────────────────────────────────────┐
│                 VERCEL CDN                              │
│           dashboard_admin.html                          │
│    (Admin interno, PIN protetto, notifiche live)        │
└─────────────────────────────────────────────────────────┘
```

---

## Endpoint live

| Servizio | URL |
|---|---|
| Menu B2B | `https://il-forno-madre.vercel.app` |
| Dashboard admin | `https://il-forno-madre.vercel.app/src/dashboard/dashboard_admin.html` |
| Supabase REST | `https://klhuctufvfmrowysoqzg.supabase.co/rest/v1/` |
| GitHub repo | `https://github.com/Shko888/Il-Forno-Madre` |

---

## Flusso ordine completo (implementato)

```
1. Cliente apre menu_b2b.html su Vercel
   ↓
2. App carica prodotti da localStorage (DEFAULT_PRODS)
   → I prodotti sono hard-coded nell'HTML (Supabase products: TODO)
   ↓
3. Cliente sfoglia catalogo, aggiunge prodotti al carrello
   → Stato carrello in memoria (JS object: {pid: {name,qty,price,unit,emoji}})
   → Dati cliente pre-compilati da localStorage['forno_cliente'] se presenti
   ↓
4. Cliente compila form ordine (nome, tel, email, indirizzo, data, fascia oraria, note)
   ↓
5. submitOrder() genera ID e invia a Supabase
   → ID ordine: ORD-YYYYMMDD-XXXX (4 char random maiuscoli)
   → Totale: subtotale × 1.10 + (€20 se subtotale < €150)
   → POST https://klhuctufvfmrowysoqzg.supabase.co/rest/v1/orders
   → Headers: apikey, Authorization Bearer, Content-Type, Prefer: return=representation
   → Campi: id, client_name, tel, addr, agent_name, order_date, delivery_date,
             delivery_time, items (jsonb), note, status='new', total
   ↓
6. Se POST ok: chiude modal, svuota carrello, mostra toast con numero ordine
   → Salva dati cliente in localStorage['forno_cliente']
   Se POST ko: mostra toast errore in italiano
   ↓
7. Dashboard admin carica ordini con loadOrders()
   → GET https://klhuctufvfmrowysoqzg.supabase.co/rest/v1/orders?order=created_at.desc
   → mapOrder() traduce campi Supabase → formato dashboard
     (client_name→client, delivery_date→deliveryDate, ecc.)
   → parseItems() gestisce items jsonb (Array.isArray check robusto)
   ↓
8. Admin vede ordini in tabella, può cambiare stato via select
   → updateOrderStatus() aggiorna solo in memoria + localStorage (PATCH Supabase: TODO)
```

## PIN login dashboard

```
Costanti: PIN_KEY='forno_pin', SESSION_KEY='forno_session', SESSION_HOURS=8, DEFAULT_PIN='1234'

Boot (DOMContentLoaded):
  loadSettings() → aggiorna nome azienda nel footer sidebar
  checkSession() → legge sessionStorage['forno_session']
    Se sessione valida (< 8h): showApp() + loadOrders()
    Se no: showLogin() → mostra schermata PIN

PIN corretto:
  saveSession() → sessionStorage['forno_session'] = {ts: Date.now()}
  showApp() → nasconde login, mostra app-wrapper
  loadOrders() → carica ordini da Supabase

Cambio PIN: localStorage.setItem('forno_pin', 'NUOVOPIN')
Reset PIN:  localStorage.removeItem('forno_pin')  → torna a '1234'
```

---

## Struttura dati Supabase

### Tabella: products
```
id          text PK         Es: "teg_b", "focc_r"
emoji       text            Es: "🟨"
name        text NOT NULL   Es: "Focaccia Bianca"
cat         text            Es: "Teglie"
description text            Descrizione breve
weight      text            Es: "1.315 kg"
price       numeric(10,2)   Es: 10.00
unit        text            Es: "teglia", "pz"
min_ord     integer         Es: 1, 50, 9
tags        text[]          Es: ["vegano","surgelato"]
badge       text            "", "new", "promo"
active      boolean         true/false
created_at  timestamptz
updated_at  timestamptz
```

### Tabella: orders
```
id              text PK         Es: "ORD-20250510-001"
client_name     text NOT NULL
client_id       text FK→clients
tel             text
addr            text
agent_name      text
order_date      date
delivery_date   date
delivery_time   text            Es: "07:00–10:00"
items           jsonb           [{pid,name,qty,price,unit}]
note            text
status          text            new/confirmed/production/delivered/cancelled
total           numeric(10,2)   Totale IVA inclusa
created_at      timestamptz
updated_at      timestamptz
```

### Tabella: clients
```
id          text PK         Es: "CLI-001"
name        text NOT NULL
type        text            Ristorante/Bar/Hotel/Pizzeria/...
contact     text            Nome referente
tel         text
email       text
addr        text
piva        text
agent_id    text FK→agents
listino     text            A/B/C
note        text
active      boolean
created_at  timestamptz
```

### Tabella: agents
```
id          text PK         Es: "AG-001"
name        text NOT NULL
tel         text
email       text
piva        text
zona        text            Es: "Cuneo e provincia"
contract    text
provv       numeric(5,2)    Es: 6.00 (percentuale)
bonus_new   numeric(8,2)    Es: 50.00 (€ per nuovo cliente)
bonus_fid   numeric(8,2)    Es: 30.00 (€/mese fidelizzazione)
note        text
active      boolean
client_ids  text[]          Array ID clienti gestiti
created_at  timestamptz
```

### Tabella: offers
```
id              text PK
emoji           text
name            text NOT NULL
type            text        pct/fixed/bundle/free_delivery
value           numeric     Valore sconto
description     text
prod_id         text        "all" o ID prodotto specifico
valid_from      date
valid_to        date
clients_target  text        "all"/"new"/"agent"
active          boolean
created_at      timestamptz
```

---

## Chiamate API Supabase (pattern standard)

### Headers standard (da includere sempre)
```javascript
const HEADERS = {
  'apikey': SUPABASE_ANON_KEY,
  'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
  'Content-Type': 'application/json',
  'Prefer': 'return=representation'
};
```

### GET con filtro
```javascript
const res = await fetch(
  `${SUPABASE_URL}/rest/v1/products?active=eq.true&order=cat.asc,name.asc`,
  { headers: HEADERS }
);
const products = await res.json();
```

### POST (insert)
```javascript
const res = await fetch(`${SUPABASE_URL}/rest/v1/orders`, {
  method: 'POST',
  headers: HEADERS,
  body: JSON.stringify(orderObject)
});
```

### PATCH (update)
```javascript
const res = await fetch(`${SUPABASE_URL}/rest/v1/orders?id=eq.${orderId}`, {
  method: 'PATCH',
  headers: HEADERS,
  body: JSON.stringify({ status: 'confirmed', updated_at: new Date().toISOString() })
});
```

### DELETE
```javascript
const res = await fetch(`${SUPABASE_URL}/rest/v1/orders?id=eq.${orderId}`, {
  method: 'DELETE',
  headers: HEADERS
});
```

### Realtime (ordini)
```javascript
const { createClient } = supabase;
const client = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

client
  .channel('orders-channel')
  .on('postgres_changes',
    { event: 'INSERT', schema: 'public', table: 'orders' },
    (payload) => handleNewOrder(payload.new)
  )
  .subscribe();
```

---

## Pattern gestione errori (usare sempre)

```javascript
async function fetchWithRetry(url, options, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const res = await fetch(url, options);
      if (!res.ok) {
        const err = await res.json();
        throw new Error(err.message || `Errore HTTP ${res.status}`);
      }
      return await res.json();
    } catch (e) {
      if (attempt === maxRetries) {
        showError(`Errore di connessione. Riprova tra qualche secondo. (${e.message})`);
        throw e;
      }
      await new Promise(r => setTimeout(r, attempt * 1000));
    }
  }
}
```

---

## Cache prodotti (pattern standard)

```javascript
const CACHE_KEY = 'forno_products_cache';
const CACHE_TTL = 30 * 60 * 1000; // 30 minuti

async function getProducts() {
  const cached = sessionStorage.getItem(CACHE_KEY);
  if (cached) {
    const { data, timestamp } = JSON.parse(cached);
    if (Date.now() - timestamp < CACHE_TTL) return data;
  }
  const data = await fetchWithRetry(`${SUPABASE_URL}/rest/v1/products?active=eq.true`, { headers: HEADERS });
  sessionStorage.setItem(CACHE_KEY, JSON.stringify({ data, timestamp: Date.now() }));
  return data;
}
```

---

## Gestione foto prodotti

### Flusso upload
```
1. Admin seleziona file → previewPhoto() mostra anteprima locale
2. saveProduct() chiama resizeImage() → Canvas API ridimensiona a max 800×600 JPEG 85%
3. uploadPhoto() fa POST binario a /storage/v1/object/product-images/{timestamp}.jpg
4. URL pubblico salvato nel campo image (e images[] per galleria multi-foto)
5. Menu B2B carica URL da Supabase e mostra con object-fit:cover
```

**Bucket Supabase Storage:** `product-images` (pubblico)

**Policy necessarie:**
```sql
-- Lettura pubblica
create policy "allow public select" on storage.objects
  for select to anon using (bucket_id = 'product-images');

-- Upload pubblico
create policy "allow public upload" on storage.objects
  for insert to anon with check (bucket_id = 'product-images');
```

### Cache prodotti menu B2B
```
sessionStorage key : forno_products_cache
TTL               : 30 minuti (5 minuti dopo l'ultima modifica prodotto)
Reset manuale     : sessionStorage.removeItem('forno_products_cache')
Fallback          : DEFAULT_PRODS se Supabase non risponde
```

---

## Generazione ID ordine

```javascript
function generateOrderId() {
  const date = new Date().toISOString().slice(0,10).replace(/-/g,'');
  const rand = Math.random().toString(36).substr(2,4).toUpperCase();
  return `ORD-${date}-${rand}`;
}
// Es: ORD-20250510-A3F2
```
