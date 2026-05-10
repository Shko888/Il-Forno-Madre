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

## Contatti supporto tecnico

- Cursor AI (chat integrata): per modifiche codice
- Supabase Docs: docs.supabase.com
- Vercel Docs: vercel.com/docs
- Claude: claude.ai (per analisi e strategia)
