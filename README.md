# Il Forno Madre — B2B Platform

Piattaforma digitale per la gestione vendite B2B di un produttore artigianale di focacce e pizze surgelate. Racconigi (CN), Italia.

## Struttura progetto

```
il-forno-madre/
├── .cursor/
│   └── rules                    # Regole permanenti per Cursor AI
├── src/
│   ├── menu/
│   │   └── menu_b2b.html        # App cliente B2B (pubblica)
│   ├── dashboard/
│   │   └── dashboard_admin.html # Dashboard admin (protetta PIN)
│   └── shared/
│       └── design-system.css    # Variabili CSS condivise
├── supabase/
│   ├── schema.sql               # Schema database completo
│   └── seed.sql                 # Dati iniziali prodotti
├── deploy/
│   └── vercel.json              # Configurazione Vercel
├── skills/
│   ├── ARCHITECTURE.md          # Architettura tecnica completa
│   ├── DESIGN_SYSTEM.md         # Design system e componenti
│   ├── SUPABASE.md              # Guida database e API
│   ├── DEPLOY.md                # Guida deploy e CI/CD
│   ├── BUSINESS_LOGIC.md        # Regole di business
│   ├── PRODUCTS.md              # Catalogo prodotti e food cost
│   ├── AGENTS.md                # Sistema agenti e provvigioni
│   └── TROUBLESHOOTING.md       # Debug e problemi comuni
└── docs/
    ├── CHANGELOG.md             # Storico modifiche
    └── TODO.md                  # Prossimi sviluppi
```

## Stack tecnologico

| Layer | Tecnologia | Motivo |
|---|---|---|
| Frontend | HTML/CSS/JS vanilla | Zero dipendenze, deployabile ovunque |
| Database | Supabase | Realtime, REST API pronta, free tier |
| Hosting | Vercel | Deploy in 60 secondi, CDN globale |
| Font | Google Fonts | Cormorant Garamond + DM Sans |
| Auth | PIN 4 cifre (dashboard) | Semplice, sufficiente per uso interno |

## Avvio rapido

### 1. Supabase
```bash
# Vai su supabase.com → nuovo progetto
# SQL Editor → incolla supabase/schema.sql → Run
# Copia URL e anon key → aggiornali in entrambi i file HTML
```

### 2. Sviluppo locale
```bash
# Apri la cartella in Cursor
# Apri src/menu/menu_b2b.html nel browser
# Modifica e ricarica — nessun build step
```

### 3. Deploy
```bash
npm install -g vercel
vercel login
vercel --prod
```

## Credenziali default
- Dashboard PIN: `1234` (cambiare subito in produzione)
- Ordine minimo: €150
- Consegna gratuita: sopra €150

## Contatti progetto
- Zona operativa: Racconigi (CN) · raggio 50km
- WhatsApp ordini: da configurare in dashboard → Impostazioni
