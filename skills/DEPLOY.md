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

## Step 2 — GitHub (repository)

### Crea il repo
1. Vai su **github.com** → Sign up o Login
2. "New repository" → nome: `il-forno-madre`
3. Visibility: **Private** (dati sensibili)
4. Inizializza con README: No (ne abbiamo già uno)

### Carica i file (da Cursor)
```bash
# Nel terminale di Cursor (View → Terminal)

# Prima volta:
git init
git add .
git commit -m "Initial commit — Il Forno Madre B2B Platform"
git branch -M main
git remote add origin https://github.com/TUOUSERNAME/il-forno-madre.git
git push -u origin main

# Aggiornamenti futuri:
git add .
git commit -m "Descrizione modifica"
git push
```

---

## Step 3 — Vercel (hosting live)

### Deploy menu B2B (pubblico)
```bash
# Installa Vercel CLI (una sola volta)
npm install -g vercel

# Login
vercel login

# Deploy dalla cartella del progetto
cd ~/Desktop/il-forno-madre
vercel --prod

# Rispondi alle domande:
# Set up and deploy? → Y
# Scope → il tuo account
# Link to existing project? → N
# Project name → forno-menu-b2b
# Directory → ./src/menu
# Override settings? → N
```

### Deploy dashboard admin (separato)
```bash
vercel --prod

# Project name → forno-dashboard
# Directory → ./src/dashboard
```

### Risultato
- Menu B2B: `https://forno-menu-b2b.vercel.app`
- Dashboard: `https://forno-dashboard.vercel.app`

### Aggiornamenti automatici
Dopo il primo deploy, ogni `git push` aggiorna automaticamente entrambi gli URL. Zero azioni manuali.

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
