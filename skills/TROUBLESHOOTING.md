# SKILL: TROUBLESHOOTING
## Il Forno Madre B2B Platform

---

## Problemi Supabase

### Errore: "Failed to fetch" o "NetworkError"
**Causa:** URL Supabase errato o credenziali mancanti.
**Soluzione:**
1. Verifica che `SUPABASE_URL` inizi con `https://` e finisca senza slash
2. Verifica che `SUPABASE_ANON_KEY` sia la chiave `anon public` (non la `service_role`)
3. Controlla la console browser per il dettaglio dell'errore

### Errore: "permission denied for table"
**Causa:** Row Level Security attiva ma policy mancante.
**Soluzione:** Esegui nel SQL Editor di Supabase:
```sql
create policy "allow all" on products for all using (true);
-- Ripeti per ogni tabella con errore
```

### I prodotti non si aggiornano nel menu
**Causa:** Cache sessionStorage ancora attiva (30 min).
**Soluzione rapida:** Il cliente ricarica la pagina (F5 o pull-to-refresh).
**Soluzione permanente:** Svuota la cache manuale:
```javascript
sessionStorage.removeItem('forno_products_cache');
```

### Realtime non funziona (ordini non arrivano in dashboard)
**Causa 1:** Realtime non abilitato per la tabella orders.
→ Supabase → Database → Replication → attiva `orders`

**Causa 2:** WebSocket bloccato dal firewall/proxy.
→ Testa aprendo la dashboard su rete mobile invece che WiFi aziendale

**Causa 3:** Troppe connessioni realtime (piano free: max 500).
→ Verifica su Supabase → Reports → Realtime

---

## Problemi Mobile (iOS Safari)

### Il form fa lo zoom automatico quando tocco un input
**Causa:** font-size dell'input è inferiore a 16px su iOS.
**Soluzione:**
```css
input, select, textarea { font-size: 16px !important; }
```

### Il carrello va fuori schermo / scroll bloccato
**Causa:** `overflow: hidden` sul body quando il carrello è aperto non gestisce correttamente iOS.
**Soluzione:**
```javascript
function openCart() {
  document.body.style.overflow = 'hidden';
  document.body.style.position = 'fixed';
  document.body.style.width = '100%';
}
function closeCart() {
  document.body.style.overflow = '';
  document.body.style.position = '';
  document.body.style.width = '';
}
```

### La barra home iPhone copre i bottoni in fondo
**Causa:** mancano le safe area inset.
**Soluzione:**
```css
.bottom-bar {
  padding-bottom: calc(12px + env(safe-area-inset-bottom));
}
```
E nel `<head>`:
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
```

### Touch tap non risponde bene (ritardo 300ms)
**Soluzione:**
```css
* { touch-action: manipulation; }
```

---

## Problemi Dashboard

### Il PIN non viene accettato
**Causa 1:** Sessione scaduta (8 ore).
→ Reinserire il PIN

**Causa 2:** PIN cambiato e dimenticato.
→ Aprire la console browser → `localStorage.removeItem('forno_pin')` → il PIN torna al default 1234

### La notifica suono non funziona
**Causa:** Browser blocca audio senza interazione utente.
**Soluzione:** La prima volta, il suono funziona solo dopo che l'utente ha cliccato qualcosa nella pagina. È una limitazione di sicurezza dei browser — non risolvibile. Aggiungere un banner "Clicca qui per attivare le notifiche audio" all'apertura della dashboard.

### Gli ordini non appaiono in tempo reale
**Causa 1:** Connessione Realtime caduta.
→ Aggiungere riconnessione automatica:
```javascript
channel.subscribe((status) => {
  if (status === 'CLOSED') {
    setTimeout(() => channel.subscribe(), 2000);
  }
});
```

**Causa 2:** Filtro ordini attivo che nasconde i nuovi.
→ Verifica che il filtro sia su "Tutti"

### La tabella prodotti non si salva
**Causa:** Modifica inline non triggera il salvataggio su Supabase.
→ Verificare che ogni input abbia `onchange="saveProdToSupabase(index)"` e non solo `oninput`

---

## Problemi Vercel

### Deploy fallisce
**Causa comune:** Il file HTML ha errori di sintassi JS.
**Soluzione:** Apri il file nel browser locale — se dà errori in console, correggili prima del deploy.

### L'URL non si aggiorna dopo git push
**Causa:** Il repo non è collegato a Vercel.
**Verifica:** Dashboard Vercel → progetto → Deployments → deve apparire l'ultimo commit

### "404 Not Found" sull'URL
**Causa:** Il file non è nella root del deploy.
**Soluzione nel vercel.json:**
```json
{
  "routes": [
    { "src": "/", "dest": "/src/menu/menu_b2b.html" }
  ]
}
```

---

## Problemi comuni JavaScript

### "Cannot read properties of null" su getElementById
**Causa:** Il codice JS esegue prima che il DOM sia pronto.
**Soluzione:** Metti tutto il codice JS dentro:
```javascript
document.addEventListener('DOMContentLoaded', () => {
  // tutto il codice qui
});
```
O meglio ancora, metti il tag `<script>` prima di `</body>`.

### Il totale carrello non si aggiorna
**Causa:** La funzione `calcTotal()` non viene chiamata dopo ogni modifica quantità.
**Verifica:** Ogni bottone +/- deve chiamare sia `updateQty()` che `calcTotal()`.

### Le chiamate Supabase partono in loop
**Causa:** Una funzione che carica dati è dentro un `setInterval` o viene chiamata dentro `renderProducts()` che a sua volta viene chiamata dal risultato della fetch.
**Soluzione:** Separare sempre fetch e render. La fetch carica i dati, il render li mostra. Mai mescolare.

---

## Debug rapido (comandi console browser)

```javascript
// Vedi tutti i prodotti in cache
JSON.parse(sessionStorage.getItem('forno_products_cache'))

// Svuota cache prodotti
sessionStorage.removeItem('forno_products_cache')

// Vedi tutti gli ordini salvati (se localStorage)
JSON.parse(localStorage.getItem('dash_orders'))

// Reset PIN dashboard
localStorage.removeItem('forno_pin')

// Test chiamata Supabase manuale
fetch('TUO_SUPABASE_URL/rest/v1/products', {
  headers: { apikey: 'TUA_ANON_KEY', Authorization: 'Bearer TUA_ANON_KEY' }
}).then(r => r.json()).then(console.log)
```

---

---

## Problemi risolti in produzione

### Overview dashboard completamente bianca (nessun contenuto visibile)
**Causa:** `<div id="app-wrapper">` si chiudeva sulla stessa riga con `></div>` — l'elemento era vuoto. Sidebar, topbar, main e tutti i modal erano fuori dal wrapper. `showApp()` rendeva visibile un div vuoto.
**Soluzione:** Aprire `app-wrapper` senza auto-chiusura e assicurarsi che tutto il contenuto (sidebar, topbar, `.main`, modal) sia fisicamente dentro il div prima del suo `</div><!-- /app-wrapper -->`.
```html
<!-- SBAGLIATO -->
<div id="app-wrapper" style="display:none;"></div>
<nav class="sidebar">...</nav>   ← fuori dal wrapper!

<!-- CORRETTO -->
<div id="app-wrapper" style="display:none;">
  <nav class="sidebar">...</nav>
  <div class="main">...</div>
</div><!-- /app-wrapper -->
```

### Items ordini non visibili in tabella e nel dettaglio
**Causa:** Il campo `items` in Supabase è di tipo `jsonb`. Arriva già parsato come array JS nativo — `typeof items === "object"`, non `"string"`. Il codice che chiamava `JSON.parse(items)` su un array causava errore silenzioso.
**Soluzione:** Usare `parseItems()` con check `Array.isArray` come primo test:
```javascript
function parseItems(v){
  return Array.isArray(v) ? v : (typeof v === 'string' ? JSON.parse(v) : []);
}
```
Usare questa funzione in `mapOrder()`, `orderTotal()`, `renderOrders()`, `showOrderDetail()`.

### Vercel 404 su tutti gli URL
**Causa:** Il file `index.html` non era nella radice del progetto e mancava il `vercel.json` con i rewrites corretti.
**Soluzione:** Creare `vercel.json` nella radice con:
```json
{
  "rewrites": [
    { "source": "/", "destination": "/src/menu/menu_b2b.html" }
  ]
}
```
L'`index.html` nella radice non è necessario se i rewrites sono configurati.

### Terminale macOS senza permessi sulla cartella Desktop
**Causa:** macOS Privacy e Sicurezza blocca l'accesso al Desktop per le app terminale non autorizzate.
**Soluzione:**
1. Vai in **Impostazioni di Sistema → Privacy e Sicurezza → Accesso completo al disco**
2. Aggiungi **Terminale** (o iTerm2) all'elenco
3. Riavvia il terminale
4. Alternativa: sposta la cartella del progetto fuori dal Desktop (es. `~/Progetti/`)

---

### Problemi foto prodotti
- Foto occupa tutta la card → verificare height e padding su `.pcard-img`
- Foto distorta → assicurarsi che `object-fit:cover` sia presente su `.pcard-img img`
- Foto non si aggiorna dopo modifica → svuotare sessionStorage: `sessionStorage.removeItem('forno_products_cache')`
- Upload foto fallisce → verificare policy Supabase Storage: `create policy "allow public upload" on storage.objects for insert to anon with check (bucket_id = 'product-images')`
- Foto vecchie non ridimensionate → ricaricarle dalla dashboard, il nuovo sistema resize è automatico

### Problemi ordini dashboard
- Ordini non appaiono → verificare RLS Supabase: `create policy "allow read" on orders for select using (true)`
- Items ordine vuoti → `parseItems()` deve gestire sia string che array: `typeof o.items === 'string' ? JSON.parse(o.items) : (o.items || [])`
- Date in formato errato → usare sempre `formatDate()` per display, MAI modificare i valori degli input `type=date`

### Problemi prodotti
- Prodotti non si aggiornano nel menu → sessionStorage cache 30 min, forzare con `sessionStorage.removeItem('forno_products_cache')`
- IVA non salvata → verificare che `saveProduct()` includa campo iva: `parseInt(document.getElementById('np-iva').value) || 10`
- Modifica prodotto non salva → PATCH richiede headers: `Prefer: return=representation`

### Problemi generali
- Pagina bianca dopo login PIN → `app-wrapper` deve contenere tutto il contenuto (sidebar, topbar, main, modali)
- Vercel 404 → verificare `index.html` in radice e `vercel.json` con rewrites corretti
- GitHub push bloccato → verificare `git config user.email = segreteria.preka@gmail.com`

---

## Contatti supporto tecnico

- Claude Code CLI: tool principale di sviluppo (avvia con `claude` nella cartella del progetto)
- Supabase Docs: docs.supabase.com
- Vercel Docs: vercel.com/docs
- GitHub repo: github.com/Shko888/Il-Forno-Madre
