# SKILL: BUSINESS LOGIC
## Il Forno Madre B2B Platform

---

## Identità brand

- **Nome:** Il Forno Madre
- **Fondato:** 2005 (20 anni di attività)
- **Sede:** Via Augusto Levis n. 10, Racconigi 12030 (CN)
- **Lievitazione:** 24–48h naturale
- **Ingredienti:** farine di eccellenza, selezione rigorosa
- **Claim principale:** "Quello che esce dal nostro forno entra diretto nel tuo servizio"
- **Tono comunicazione:** caldo, diretto, artigianale — mai formale né pubblicitario

### Aliquote IVA applicate
| Aliquota | Applicazione |
|---|---|
| 4% | Prodotti di prima necessità (pane semplice) |
| 10% | Prodotti alimentari standard (focacce, pizze) — **DEFAULT** |
| 22% | Altri prodotti |

---

## Azienda

- **Nome:** Il Forno Madre (nome commerciale da definire)
- **Sede:** Racconigi (CN), Piemonte, Italia
- **Forma giuridica:** Ditta individuale / Partita IVA
- **Attività:** Produzione e vendita B2B di focacce e pizze artigianali surgelate
- **Raggio operativo:** 50km da Racconigi (Cuneo, Torino Sud, Savona Nord)
- **Stagionalità:** operativa tutto l'anno

---

## Catalogo prodotti

| ID | Prodotto | Prezzo B2B | Unità | Min. ord. | Canale |
|---|---|---|---|---|---|
| teg_b | Focaccia Bianca (teglia) | €10,00 | teglia | 1 | B2B |
| teg_r | Pizza Rossa (teglia) | €13,00 | teglia | 1 | B2B |
| focc_b | Focaccina Bianca | €0,28 | pz | 50 | B2B |
| focc_r | Focaccina Rossa | €0,60 | pz | 50 | B2B |
| hamburger | Panino Hamburger | €1,10 | pz | 9 (3 buste SV) | B2B |
| piz_rot | Pizza Rotonda Bianca | €3,20 | pz | 5 | B2B/B2C |

### Food cost per prodotto (riferimento interno)
| Prodotto | Costo pieno/unità | Margine % |
|---|---|---|
| Focaccia Bianca teglia | €1,96 | ~80% |
| Pizza Rossa teglia | €3,73 | ~71% |
| Focaccina Bianca | €0,15 | ~46% |
| Focaccina Rossa | €0,14 | ~77% |
| Panino Hamburger | €0,54 | ~51% |
| Pizza Rotonda | €0,94 | ~71% |

---

## Regole ordine B2B

### Soglie
```javascript
const ORDER_RULES = {
  minOrderValue: 150,        // €150 ordine minimo
  freeDeliveryThreshold: 150, // sopra €150 → consegna gratuita
  deliveryFee: 20,            // sotto €150 → €20 contributo
  maxDeliveryRadius: 50,      // km da Racconigi
  iva: 0.10,                  // 10% IVA alimentari
};
```

### Calcolo totale ordine
```javascript
function calculateOrderTotal(items) {
  const subtotal = items.reduce((sum, item) => sum + item.qty * item.price, 0);
  const iva = subtotal * ORDER_RULES.iva;
  const delivery = subtotal >= ORDER_RULES.freeDeliveryThreshold ? 0 : ORDER_RULES.deliveryFee;
  const total = subtotal + iva + delivery;
  return {
    subtotal:      parseFloat(subtotal.toFixed(2)),
    iva:           parseFloat(iva.toFixed(2)),
    delivery,
    total:         parseFloat(total.toFixed(2)),
    freeDelivery:  subtotal >= ORDER_RULES.freeDeliveryThreshold,
    missingForFree: Math.max(0, ORDER_RULES.freeDeliveryThreshold - subtotal),
  };
}
```

---

## Listini prezzi B2B

| Listino | Condizione | Sconto |
|---|---|---|
| A | Nuovi clienti / primo ordine | Nessuno — prezzo pieno |
| B | Clienti ricorrenti (4+ settimane consecutive) | −5% su tutto |
| C | Contratto annuale (min €2.000/mese) | −10% su tutto |

### Applicazione sconto
```javascript
function applyListino(price, listino) {
  const discounts = { A: 0, B: 0.05, C: 0.10 };
  const discount = discounts[listino] || 0;
  return parseFloat((price * (1 - discount)).toFixed(2));
}
```

### Sconto massimo assoluto: −15%
Non scendere mai oltre il 15% anche su grandi volumi o trattative straordinarie. Il floor assoluto è il costo pieno.

---

## Sistema agenti commerciali

### Struttura provvigione (ibrida)
```javascript
const AGENT_COMMISSION = {
  baseRate: 0.06,         // 6% flat su fatturato (imponibile, senza IVA)
  bonusNewClient: 50,     // €50 per nuovo cliente (primo ordine ≥ €150)
  bonusFidelity: 30,      // €30/mese per ogni cliente attivo 3+ mesi
  volumeThreshold: 3000,  // €3.000/mese → rate sale all'8%
  volumeRate: 0.08,       // 8% sopra soglia volume
};

function calculateCommission(agent, monthlyRevenue, newClients, loyalClients) {
  const rate = monthlyRevenue >= AGENT_COMMISSION.volumeThreshold
    ? AGENT_COMMISSION.volumeRate
    : AGENT_COMMISSION.baseRate;
  const base = monthlyRevenue * rate;
  const bonusNew = newClients * AGENT_COMMISSION.bonusNewClient;
  const bonusFid = loyalClients * AGENT_COMMISSION.bonusFidelity;
  return {
    base:     parseFloat(base.toFixed(2)),
    bonusNew: parseFloat(bonusNew.toFixed(2)),
    bonusFid: parseFloat(bonusFid.toFixed(2)),
    total:    parseFloat((base + bonusNew + bonusFid).toFixed(2)),
    rate:     rate * 100,
  };
}
```

### Forma contrattuale consigliata
- Agente plurimandatario con P.IVA (art. 1742 c.c.)
- Nessun fisso — solo provvigione
- Pagamento entro il 15 del mese successivo a fattura ricevuta

---

## Logistica consegne

### Fasce orarie disponibili
- 07:00 – 10:00 (prima apertura — preferita da bar/hotel)
- 10:00 – 13:00
- 14:00 – 17:00
- Da concordare

### Politica consegna per fase
```
Fase lancio (mesi 1-3): gratuita su tutto
Fase crescita (mesi 4-6): gratuita sopra €250, €15 sotto
Fase regime (mesi 7+): gratuita sopra €300, €20 sotto
```

### Costo operativo consegna stimato
- Furgone (€0,45/km) × 80km andata/ritorno = €36
- Manodopera 2-3h = €24-36
- **Totale per uscita: €55-70**
- Soglia convenienza: ordine ≥ €250 per uscita

---

## Stati ordine e workflow

```
new         → Ordine ricevuto, da confermare
confirmed   → Confermato, in attesa produzione
production  → In lavorazione nel laboratorio
delivered   → Consegnato e completato
cancelled   → Annullato (con motivazione in nota)
```

### Transizioni valide
```
new → confirmed → production → delivered
new → cancelled
confirmed → cancelled
production → delivered
```

---

## Costi fissi mensili (riferimento P&L)

| Voce | Importo |
|---|---|
| Personale (2 dipendenti) | €4.000 |
| Affitto laboratorio | €500 |
| Ammortamento attrezzature | €333 |
| Energia elettrica | €294 |
| Acqua + gas | €130 |
| Commercialista | €150 |
| Assicurazioni + varie | €180 |
| **TOTALE** | **€5.587** |

### Break-even mensile
- Fatturato break-even: **€10.086** (con MC medio 55%)
- Fatturato obiettivo utile 15%: **€11.889**
- Teglie bianche necessarie per BE: ~30/giorno

---

## Obiettivi commerciali

### Fase 1 — Lancio (mesi 1-3)
- 5 clienti B2B fissi
- 3 ordini/settimana per cliente
- Fatturato target: €2.800/mese
- Prezzi: −20% rispetto listino A

### Fase 2 — Crescita (mesi 4-6)
- 10 clienti B2B fissi
- Fatturato target: €6.500/mese
- Prezzi: −10% rispetto listino A

### Fase 3 — Regime (mesi 7-12)
- 15+ clienti B2B fissi
- Fatturato target: €10.500/mese
- Prezzi: listino A pieno
- Utile mensile stimato: +€600-900
