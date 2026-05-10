# SKILL: DEPLOY E CONFIGURAZIONE
## Il Forno Madre B2B Platform

---

## Step 1 — Supabase (database live)

### Crea il progetto
1. Vai su **supabase.com** → Sign up con Google
2. "New project" → nome: `il-forno-madre`
3. Regione: **West EU (Ireland)** — più vicina all'Italia
4. Password database: genera e salva in luogo sicuro
5. Attendi 2 minuti che il progetto si crei

### Recupera le credenziali
1. Settings → API
2. Copia **Project URL** → es: `https://abcxyz.supabase.co`
3. Copia **anon public key** → stringa lunga che inizia con `eyJ...`
4. Incollale nei file HTML come costanti in cima al file:

```javascript
const SUPABASE_URL = 'https://tuoid.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR...';
```

### Esegui lo schema
1. SQL Editor (icona a sinistra)
2. Copia il contenuto di `supabase/schema.sql`
3. Incolla → clicca **Run**
4. Verifica: Table Editor → devono apparire 5 tabelle

### Abilita Realtime
1. Database → Replication
2. Attiva la tabella `orders`
3. Salva

---

## Step 2 — GitHub (repository live)

### Repository attuale
```
URL:    https://github.com/Shko888/Il-Forno-Madre.git
User:   Shko888
Branch: main
```

### Workflow aggiornamenti (Claude Code)
```bash
# Naviga nella cartella del progetto
cd ~/Desktop/Il\ Forno\ Madre

# Avvia Claude Code
claude

# Dai le istruzioni in italiano — Claude farà:
# 1. Legge i file necessari
# 2. Applica le modifiche
# 3. git add <file>
# 4. git commit -m "messaggio descrittivo"
# 5. git push origin main
# → Vercel si aggiorna automaticamente in ~30 secondi
```

### Workflow manuale (se necessario)
```bash
git add src/menu/menu_b2b.html src/dashboard/dashboard_admin.html
git commit -m "Descrizione modifica"
git push origin main
```

---

## Step 3 — Vercel (live)

### Progetto live attuale
```
URL menu B2B:  https://il-forno-madre.vercel.app
URL dashboard: https://il-forno-madre.vercel.app/src/dashboard/dashboard_admin.html
GitHub repo:   Shko888/Il-Forno-Madre (connesso a Vercel)
Branch deploy: main (auto-deploy ad ogni push)
```

### vercel.json attuale (nella radice del progetto)
```json
{
  "rewrites": [
    { "source": "/", "destination": "/src/menu/menu_b2b.html" },
    { "source": "/menu", "destination": "/src/menu/menu_b2b.html" },
    { "source": "/dashboard", "destination": "/src/dashboard/dashboard_admin.html" }
  ]
}
```

### Aggiornamenti automatici
Ogni `git push` su `main` → Vercel ribuilds → live in ~30 secondi. Zero azioni manuali.

---

## Step 4 — Dominio custom (opzionale, dopo lancio)

### Acquisto dominio
- **Namecheap.com** (consigliato): ~€10/anno per `.it`
- Suggerimento nome: `fornoartigianale.it` o `ordina.[tuonome].it`

### Collegamento a Vercel
1. Vercel → progetto → Settings → Domains
2. "Add domain" → inserisci il tuo dominio
3. Vercel mostra i record DNS da configurare
4. Vai su Namecheap → DNS → aggiungi i record
5. Propagazione: 5-60 minuti

### Risultato finale
- Menu B2B: `https://menu.fornoartigianale.it`
- Dashboard: `https://admin.fornoartigianale.it`

---

## Configurazione Vercel (vercel.json)

```json
{
  "version": 2,
  "builds": [
    { "src": "src/menu/menu_b2b.html", "use": "@vercel/static" },
    { "src": "src/dashboard/dashboard_admin.html", "use": "@vercel/static" }
  ],
  "routes": [
    { "src": "/menu", "dest": "/src/menu/menu_b2b.html" },
    { "src": "/admin", "dest": "/src/dashboard/dashboard_admin.html" },
    { "src": "/", "dest": "/src/menu/menu_b2b.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-XSS-Protection", "value": "1; mode=block" }
      ]
    }
  ]
}
```

---

## Variabili ambiente (sicurezza)

Per non esporre le credenziali Supabase nel codice pubblico, usa le variabili Vercel:

```bash
# Imposta variabili su Vercel
vercel env add SUPABASE_URL
vercel env add SUPABASE_ANON_KEY
```

Poi nel codice HTML usa un approccio di build o, più semplicemente per file statici, mantieni le credenziali pubbliche nel codice (la anon key di Supabase è progettata per essere pubblica — la sicurezza è gestita dalle RLS policies).

---

## Checklist pre go-live

### Supabase
- [ ] Progetto creato nella regione EU
- [ ] schema.sql eseguito senza errori
- [ ] 5 tabelle visibili nel Table Editor
- [ ] Prodotti inseriti (verifica su Table Editor → products)
- [ ] Realtime abilitato per tabella orders
- [ ] URL e anon key inseriti in entrambi i file HTML

### File HTML
- [ ] menu_b2b.html → test ordine completo in locale
- [ ] dashboard_admin.html → test login PIN + ricezione ordine
- [ ] Notifica realtime testata (ordine da menu → suono in dashboard)
- [ ] Test su iPhone (Safari) — nessun zoom su input
- [ ] Test su Android (Chrome) — layout corretto
- [ ] Test su iPad — grid prodotti corretto
- [ ] Numero WhatsApp ordini configurato

### Deploy
- [ ] GitHub repo creato e file caricati
- [ ] Menu B2B deployato su Vercel
- [ ] Dashboard deployata su Vercel (URL separato)
- [ ] Entrambi gli URL aperti su iPhone reale — tutto funziona
- [ ] PIN dashboard cambiato dal default 1234

### Business
- [ ] Ordine minimo €150 impostato
- [ ] Soglia consegna gratuita €150 impostata
- [ ] Numero WhatsApp ordini funzionante
- [ ] Test ordine completo: menu → WhatsApp → dashboard → stato aggiornato

---

## Manutenzione

### Aggiornare un prodotto
1. Apri dashboard → Prodotti
2. Modifica direttamente nella riga
3. Clicca "Sync" → si aggiorna su Supabase
4. Il menu B2B mostra il nuovo prezzo entro 30 minuti (cache sessionStorage)
5. Per aggiornamento immediato: gli utenti ricaricano la pagina

### Aggiungere un nuovo prodotto
1. Dashboard → Prodotti → "+ Nuovo prodotto"
2. Compila tutti i campi
3. Salva → appare immediatamente nel menu B2B

### Backup dati
1. Dashboard → Impostazioni → "Esporta tutti i dati"
2. Salva il file JSON in luogo sicuro
3. Oppure da Supabase: Database → Backups (automatici giornalieri nel piano free)
