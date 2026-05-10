# TODO — Il Forno Madre B2B Platform

## ✅ Completati

- [x] Integrazione Supabase menu B2B — ordini via POST `/rest/v1/orders`
- [x] Integrazione Supabase dashboard ordini — `loadOrders()` GET con mapping campi
- [x] Deploy Vercel — live su `il-forno-madre.vercel.app`
- [x] PIN login dashboard — sessione 8h, default 1234
- [x] Responsive mobile/tablet/desktop — iPhone SE → desktop 1920px
- [x] Fix struttura HTML app-wrapper — overview ora visibile
- [x] Fix parsing items jsonb — `parseItems()` con `Array.isArray`
- [x] Salvataggio dati cliente in localStorage — pre-compilazione form
- [x] Immagini prodotti — supporto campo `image` con `object-fit:cover`
- [x] IVA visibile — "+ IVA 10%" su ogni card e breakdown carrello
- [x] Pagina Impostazioni dashboard — dati azienda + parametri commerciali
- [x] Upload foto prodotti su Supabase Storage (bucket product-images)

## 🔴 Prossimi (priorità alta)

- [ ] Cambio stato ordine salva su Supabase (PATCH `/rest/v1/orders?id=eq.{id}`)
- [ ] Prodotti caricati da Supabase (GET `/rest/v1/products?active=eq.true`)
- [ ] Registrazione cliente con email (form + insert tabella clients)
- [ ] PWA installabile su telefono (manifest.json + service worker)

## 🟡 Priorità media

- [x] Immagini prodotti da Supabase Storage (bucket pubblico) ✅ done in 0.8.0
- [ ] Impostazioni azienda sincronizzate su Supabase (tabella settings)
- [ ] Email di conferma ordine al cliente (Supabase Edge Functions + Resend)
- [ ] Export ordini in CSV dalla dashboard
- [ ] Filtro ordini per data nella dashboard
- [ ] Report provvigioni agente (PDF mensile)

## 🟢 Priorità bassa

- [ ] Dominio custom (es. menu.ilforномадре.it)
- [ ] Notifiche WhatsApp automatiche cambio stato ordine
- [ ] Pagina "Traccia il tuo ordine" pubblica
- [ ] Dashboard analytics avanzate (grafico trend mensile)
- [ ] Catalogo PDF scaricabile

## 💡 Idee future

- [ ] App mobile React Native (fase 2)
- [ ] Integrazione con sistema contabilità (Fatture in Cloud API)
- [ ] Portale agenti dedicato (login separato, vista commissioni)
- [ ] Configuratore prodotto personalizzato (peso, condimenti)
- [ ] Sistema prenotazione slot consegna
