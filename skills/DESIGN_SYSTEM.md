# SKILL: DESIGN SYSTEM
## Il Forno Madre B2B Platform

---

## Filosofia design

**Luxury artigianale italiano.** Il design comunica qualità, tradizione e cura artigianale. Non è minimalista asettico né massimalista caotico — è caldo, raffinato, diretto. Ogni elemento ha uno scopo. Il cliente B2B deve sentire che sta trattando con un produttore serio.

**Parole chiave:** Crema · Oro · Inchiostro · Caldo · Sereno · Professionale · Artigianale

---

## Palette colori completa

```css
:root {
  /* Neutri base */
  --ink:      #1A1208;  /* Testo principale, header, sidebar */
  --cream:    #FAF6EF;  /* Sfondo principale */
  --warm:     #F2E9DC;  /* Sfondo secondario, hover light */
  --sand:     #E8D8C4;  /* Bordi card, separatori */
  --white:    #FFFFFF;  /* Sfondo card */

  /* Brand */
  --brown:    #5C3D1E;  /* Titoli secondari, label */
  --brown-l:  #8B6340;  /* Testo label */
  --gold:     #C4973A;  /* Accent primario, CTA principale */
  --gold-l:   #F5E6C8;  /* Sfondo badge gold, alert info */
  --gold-d:   #A07820;  /* Gold hover, gold dark */

  /* Stato: successo */
  --green:    #2A4A2E;
  --green-l:  #EAF0EA;
  --green-m:  #1D9E75;  /* Badge successo, barre */

  /* Stato: errore */
  --red:      #8B2020;
  --red-l:    #F5EAEA;

  /* Stato: warning */
  --orange:   #B85C00;
  --orange-l: #FEF0E0;

  /* Stato: info */
  --blue:     #1A3A5C;
  --blue-l:   #E8F0F8;

  /* Utility */
  --border:   #DDD0BC;  /* Bordi standard */
  --muted:    #8A7560;  /* Testo secondario, placeholder */
}
```

---

## Tipografia

### Font families
```css
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400;1,600&family=DM+Sans:wght@300;400;500&display=swap');

--font-display: 'Cormorant Garamond', Georgia, serif;
--font-body:    'DM Sans', system-ui, sans-serif;
```

### Scale tipografica
```
Display (hero, logo):     Cormorant Garamond 400  clamp(28px,5vw,44px)
H1 (titolo pagina):       Cormorant Garamond 600  clamp(22px,4vw,32px)
H2 (titolo sezione):      Cormorant Garamond 600  18-22px
H3 (titolo card):         Cormorant Garamond 600  16-18px
KPI numero grande:        Cormorant Garamond 400  28-40px
Body large:               DM Sans 400             15-16px  line-height 1.6
Body:                     DM Sans 400             13-14px  line-height 1.5
Body small:               DM Sans 300             12px     line-height 1.4
Label/Tag:                DM Sans 500             10-11px  uppercase letter-spacing .05-.08em
Price display:            Cormorant Garamond 600  20-24px
```

---

## Spaziatura (sistema 4px)

```
2px  = micro (gap icon-testo)
4px  = xs
8px  = sm
12px = md
16px = lg
20px = xl-sm
24px = xl
32px = 2xl
40px = 3xl
48px = 4xl
64px = 5xl
```

---

## Border radius

```
4px  = micro (badge inline)
6px  = sm (input, button sm)
8px  = md (button, select)
10px = lg (card)
12px = xl (card principale, modal)
20px = pill (badge, tag, filtro)
50%  = circle (avatar, dot)
```

---

## Ombre

```css
--shadow-sm:   0 1px 4px rgba(26,18,8,.06);
--shadow-md:   0 2px 16px rgba(26,18,8,.08);
--shadow-lg:   0 4px 24px rgba(26,18,8,.12);
--shadow-xl:   0 8px 40px rgba(26,18,8,.18);
--shadow-modal: 0 8px 40px rgba(26,18,8,.22);
```

---

## Componenti standard

### Button variants
```css
/* Primary (CTA principale) */
.btn-primary {
  background: var(--ink);
  color: var(--cream);
  padding: 11px 22px;
  border-radius: 8px;
  font: 500 14px var(--font-body);
  border: none;
  cursor: pointer;
  transition: background .18s;
}
.btn-primary:hover { background: var(--brown); }

/* Gold (azione secondaria importante) */
.btn-gold {
  background: var(--gold);
  color: var(--ink);
}
.btn-gold:hover { background: var(--gold-d); }

/* Ghost (azione neutra) */
.btn-ghost {
  background: transparent;
  color: var(--muted);
  border: 1px solid var(--border);
}
.btn-ghost:hover { background: var(--warm); }

/* Danger (elimina, annulla) */
.btn-danger {
  background: transparent;
  color: var(--red);
  border: 1px solid #F7C1C1;
}
.btn-danger:hover { background: var(--red-l); }

/* Sizes */
.btn-lg  { padding: 13px 28px; font-size: 15px; }
.btn-sm  { padding: 7px 14px;  font-size: 12px; }
.btn-xs  { padding: 4px 9px;   font-size: 11px; }
```

### Card
```css
.card {
  background: var(--white);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 16px;
  box-shadow: var(--shadow-md);
}
.card:hover {
  box-shadow: var(--shadow-lg);
  transform: translateY(-1px);
  transition: all .2s ease;
}
```

### Input / Select / Textarea
```css
input, select, textarea {
  width: 100%;
  padding: 10px 13px;
  border: 1.5px solid var(--border);
  border-radius: 8px;
  font: 400 14px var(--font-body);
  color: var(--ink);
  background: var(--cream);
  -webkit-appearance: none;
  appearance: none;
  transition: border-color .2s;
}
input:focus, select:focus, textarea:focus {
  outline: none;
  border-color: var(--gold);
  background: var(--white);
  box-shadow: 0 0 0 3px rgba(196,151,58,.12);
}
/* iOS zoom fix */
input[type=text],
input[type=number],
input[type=email],
input[type=tel] { font-size: 16px; }
```

### Badge / Status
```css
.badge {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 20px;
  font: 500 11px var(--font-body);
}
.badge-new       { background: var(--green-l);  color: var(--green); }
.badge-promo     { background: var(--gold-l);   color: var(--brown); }
.badge-active    { background: var(--green-l);  color: var(--green); }
.badge-inactive  { background: var(--warm);     color: var(--muted); }
.badge-new-order { background: var(--blue-l);   color: var(--blue);  }
.badge-confirmed { background: var(--gold-l);   color: var(--orange);}
.badge-delivered { background: var(--green-l);  color: var(--green); }
.badge-cancelled { background: var(--red-l);    color: var(--red);   }
```

### Skeleton loader
```css
.skeleton {
  background: linear-gradient(90deg, var(--warm) 25%, var(--sand) 50%, var(--warm) 75%);
  background-size: 200% 100%;
  animation: skeleton-wave 1.4s ease infinite;
  border-radius: 6px;
}
@keyframes skeleton-wave {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### Toggle switch
```css
.toggle { position: relative; width: 38px; height: 22px; }
.toggle input { opacity: 0; width: 0; height: 0; position: absolute; }
.toggle-track {
  position: absolute; inset: 0;
  background: var(--sand); border-radius: 11px;
  cursor: pointer; transition: background .2s;
}
.toggle input:checked + .toggle-track { background: var(--green); }
.toggle-track::after {
  content: '';
  position: absolute;
  width: 16px; height: 16px;
  left: 3px; top: 3px;
  background: white; border-radius: 50%;
  transition: transform .2s;
}
.toggle input:checked + .toggle-track::after { transform: translateX(16px); }
```

### Toast notification
```css
.toast {
  position: fixed;
  bottom: 24px; right: 24px;
  background: var(--ink); color: var(--cream);
  padding: 12px 20px;
  border-radius: 8px;
  font: 500 13px var(--font-body);
  box-shadow: var(--shadow-lg);
  opacity: 0;
  transform: translateY(10px);
  transition: opacity .3s, transform .3s;
  z-index: 999;
  pointer-events: none;
  max-width: 320px;
}
.toast.success { background: var(--green); }
.toast.error   { background: var(--red); }
.toast.show    { opacity: 1; transform: translateY(0); }
```

### Modal
```css
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(26,18,8,.5);
  z-index: 600;
  display: none;
  align-items: center; justify-content: center;
  padding: 16px;
  backdrop-filter: blur(2px);
}
.modal-overlay.open { display: flex; }
.modal {
  background: var(--cream);
  border-radius: 12px;
  max-width: 560px; width: 100%;
  max-height: 92vh; overflow-y: auto;
  box-shadow: var(--shadow-modal);
  animation: modal-in .25s cubic-bezier(.25,.46,.45,.94);
}
@keyframes modal-in {
  from { opacity: 0; transform: scale(.96) translateY(8px); }
  to   { opacity: 1; transform: scale(1) translateY(0); }
}
```

---

## Layout responsive

### Breakpoints
```
Mobile:  <480px   (iPhone SE, iPhone mini)
Mobile+: 480-680px (iPhone standard, piccoli Android)
Tablet:  680-1024px (iPad, tablet Android)
Desktop: >1024px   (laptop, desktop)
```

### Grid prodotti
```css
/* Mobile: 1 colonna */
.prod-grid { grid-template-columns: 1fr; }

/* Mobile+: 2 colonne */
@media(min-width:480px) {
  .prod-grid { grid-template-columns: 1fr 1fr; }
}

/* Tablet: 2-3 colonne */
@media(min-width:680px) {
  .prod-grid { grid-template-columns: repeat(auto-fill, minmax(240px,1fr)); }
}

/* Desktop: 3-4 colonne */
@media(min-width:1024px) {
  .prod-grid { grid-template-columns: repeat(auto-fill, minmax(260px,1fr)); }
}
```

---

## Animazioni standard

```css
/* Entrata lista (staggered) */
@keyframes fade-up {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}
.list-item {
  animation: fade-up .3s ease forwards;
  opacity: 0;
}
.list-item:nth-child(1) { animation-delay: .05s; }
.list-item:nth-child(2) { animation-delay: .10s; }
.list-item:nth-child(3) { animation-delay: .15s; }
/* etc. */

/* Rispetta preferenza utente */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation: none !important; transition: none !important; }
}
```

---

## Accessibilità minima (WCAG AA)

- Contrasto testo/sfondo: minimo 4.5:1
- Touch target: minimo 44×44px
- Focus visibile: `outline: 2px solid var(--gold); outline-offset: 2px`
- Tutti i bottoni icon-only hanno `aria-label`
- Tutti i form field hanno `<label>` associata
- Loading state: `aria-busy="true"` sul contenitore
- Errori: `aria-live="polite"` sul container errori
