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

| Layer | Tecnologia | Note |
|---|---|---|
| Frontend | HTML/CSS/JS vanilla | Zero dipendenze, deployabile ovunque |
| Database | Supabase (live) | `klhuctufvfmrowysoqzg.supabase.co` |
| Hosting | Vercel (live) | `il-forno-madre.vercel.app` |
| Font | Google Fonts | Cormorant Garamond + DM Sans |
| Auth | PIN 4 cifre (dashboard) | Sessione 8h in sessionStorage |
| AI dev tool | Claude Code (CLI) | Prompt → modifica → git push |

## URL live

| App | URL |
|---|---|
| Menu B2B (clienti) | `https://il-forno-madre.vercel.app` |
| Dashboard admin | `https://il-forno-madre.vercel.app/src/dashboard/dashboard_admin.html` |
| Repository GitHub | `https://github.com/Shko888/Il-Forno-Madre` |
| Supabase | `https://klhuctufvfmrowysoqzg.supabase.co` |

## Avvio rapido

### Sviluppo con Claude Code (workflow attuale)
```bash
# Naviga nella cartella del progetto
cd ~/Desktop/Il\ Forno\ Madre

# Avvia Claude Code
claude

# Descrivi la modifica in linguaggio naturale — Claude:
# 1. Legge i file coinvolti
# 2. Fa le modifiche
# 3. Esegue git add + commit + push
```

### Test in locale
```bash
# Nessun build step — basta aprire i file nel browser
open src/menu/menu_b2b.html
open src/dashboard/dashboard_admin.html
```

### Deploy
Il deploy è automatico: ogni `git push` su `main` aggiorna Vercel entro 30 secondi.

## Credenziali default
- Dashboard PIN: `1234` (cambia via console: `localStorage.setItem('forno_pin','NUOVOPIN')`)
- Ordine minimo: €150
- Consegna gratuita: sopra €150
- IVA applicata: 10%

## Contatti progetto
- Zona operativa: Racconigi (CN) · raggio 50km
- GitHub user: Shko888
- Supabase project ID: klhuctufvfmrowysoqzg
