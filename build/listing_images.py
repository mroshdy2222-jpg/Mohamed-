"""Compose Etsy listing images (2000x1500) from real workbook screenshots in build/shots/."""
import os
import sys

from PIL import Image
from playwright.sync_api import sync_playwright

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
SHOTS = os.path.join(ROOT, "build", "shots")
HTML_DIR = os.path.join(ROOT, "build", "listing_html")
OUT = os.path.join(ROOT, "product", "images")
CHROME = "/opt/pw-browsers/chromium-1194/chrome-linux/chrome"


def img(name):
    return f"file://{SHOTS}/{name}.png"


CSS = """
* { box-sizing: border-box; margin: 0; padding: 0; }
body { width: 2000px; height: 1500px; overflow: hidden; font-family: 'Inter', 'Liberation Sans', sans-serif;
       color: #0B1F3A; -webkit-font-smoothing: antialiased; }
.navy { background: radial-gradient(1400px 900px at 85% 20%, #1d3f73 0%, #0B1F3A 60%); color: #fff; }
.light { background: linear-gradient(160deg, #F0FDFA 0%, #E6FFFB 45%, #F8FAFC 100%); }
.abs { position: absolute; }
.brand { font-size: 30px; font-weight: 800; letter-spacing: 6px; color: #14B8A6; }
.brand small { color: #94A3B8; letter-spacing: 3px; font-weight: 600; margin-left: 14px; }
h1 { font-size: 104px; line-height: 1.02; font-weight: 800; letter-spacing: -2px; }
h1 .t, h2 .t { color: #14B8A6; }
h2 { font-size: 78px; line-height: 1.05; font-weight: 800; letter-spacing: -1.5px; }
.sub { font-size: 38px; line-height: 1.3; font-weight: 500; color: #C7D2FE; }
.light .sub { color: #475569; }
.es { font-style: italic; color: #94A3B8; font-weight: 500; }
.light .es { color: #64748B; }
.checks { list-style: none; font-size: 36px; font-weight: 600; line-height: 1.25; }
.checks li { position: relative; padding-left: 76px; margin-bottom: 26px; min-height: 52px; }
.checks li::before { content: '✓'; position: absolute; left: 0; top: -4px; width: 52px; height: 52px; border-radius: 50%; background: #14B8A6; color: #0B1F3A;
                     font-weight: 900; font-size: 32px; display: flex; align-items: center; justify-content: center; }
.pills { display: flex; gap: 16px; flex-wrap: wrap; }
.pill { font-size: 28px; font-weight: 700; padding: 14px 28px; border-radius: 999px; border: 3px solid #14B8A6;
        color: #fff; background: rgba(20,184,166,.14); }
.light .pill { color: #0F766E; background: #fff; }
.pill.solid { background: #14B8A6; color: #0B1F3A; }
.laptop .screen { border: 22px solid #0f172a; border-bottom-width: 26px; border-radius: 30px 30px 0 0; background: #fff;
                  overflow: hidden; box-shadow: 0 40px 80px rgba(0,0,0,.45); }
.laptop .screen img { display: block; width: 100%; }
.laptop .base { height: 30px; margin: 0 -7%; border-radius: 0 0 36px 36px;
                background: linear-gradient(#e2e8f0, #94a3b8); box-shadow: 0 18px 40px rgba(0,0,0,.35); }
.phone { border: 18px solid #0f172a; border-radius: 64px; overflow: hidden; background: #fff;
         box-shadow: 0 40px 80px rgba(0,0,0,.5); }
.phone .bar { height: 92px; background: #107C41; color: #fff; display: flex; align-items: flex-end; justify-content: center;
              padding-bottom: 16px; font-size: 24px; font-weight: 700; }
.phone .scr { width: 100%; object-fit: cover; object-position: left top; display: block; }
.card { background: #fff; border-radius: 22px; padding: 8px; box-shadow: 0 30px 70px rgba(11,31,58,.18); overflow: hidden; }
.card img { display: block; width: 100%; }
.callout b, .callout span { overflow-wrap: anywhere; }
.callout { background: #0B1F3A; color: #fff; border-radius: 26px; padding: 34px 38px; box-shadow: 0 24px 50px rgba(11,31,58,.25); }
.callout b { display: block; font-size: 38px; margin-bottom: 8px; }
.callout span { font-size: 27px; color: #C7D2FE; line-height: 1.3; display: block; }
.callout .n { float: left; width: 64px; height: 64px; border-radius: 50%; background: #14B8A6; color: #0B1F3A; font-weight: 900;
              font-size: 34px; display: flex; align-items: center; justify-content: center; margin: 0 24px 10px 0; }
.foot { position: absolute; left: 0; right: 0; bottom: 0; height: 92px; background: #14B8A6; color: #0B1F3A;
        display: flex; align-items: center; justify-content: center; gap: 46px; font-size: 30px; font-weight: 800; letter-spacing: 1px; }
.foot i { font-style: normal; opacity: .55; }
.tag { display: inline-block; background: #14B8A6; color: #0B1F3A; font-weight: 800; font-size: 28px; letter-spacing: 3px;
       padding: 10px 24px; border-radius: 12px; }
"""

FOOT = ('<div class="foot">INSTANT DOWNLOAD <i>•</i> EXCEL &amp; GOOGLE SHEETS <i>•</i> '
        'iPHONE • ANDROID • PC / MAC <i>•</i> ENGLISH + ESPAÑOL</div>')


def page(body, theme="navy"):
    return f'<!doctype html><html><head><meta charset="utf-8"><style>{CSS}</style></head><body class="{theme}">{body}</body></html>'


def laptop(shot, x, y, w):
    return (f'<div class="abs laptop" style="left:{x}px;top:{y}px;width:{w}px">'
            f'<div class="screen"><img src="{img(shot)}"></div><div class="base"></div></div>')


FIT_PHONE = {"hp_phone"}   # screenshots that must be shown whole (numbers on the right)


def phone(shot, x, y, w, h, label="Excel"):
    fit = "object-fit:contain;object-position:center top;" if shot in FIT_PHONE else ""
    return (f'<div class="abs phone" style="left:{x}px;top:{y}px;width:{w}px;height:{h}px">'
            f'<div class="bar">{label}</div><img class="scr" style="height:{h - 92 - 36}px;{fit}" src="{img(shot)}"></div>')


# ---------------------------------------------------------------- templates
def hero(brand, line1, line2, sub, checks, dash, phone_shot, extra_pills=()):
    items = "".join(f"<li>{c}</li>" for c in checks)
    pills = "".join(f'<span class="pill">{p}</span>' for p in ("Excel", "Google Sheets", "EN + ES", *extra_pills))
    return page(f"""
<div class="abs" style="left:90px;top:86px;width:840px">
  <div class="brand">PROFITTRACK<small>{brand}</small></div>
  <h1 style="margin-top:34px;font-size:88px">{line1}<br><span class="t">{line2}</span></h1>
  <p class="sub" style="margin-top:30px">{sub}</p>
  <ul class="checks" style="margin-top:46px">{items}</ul>
  <div class="pills" style="margin-top:20px">{pills}</div>
</div>
{laptop(dash, 960, 190, 960)}
{phone(phone_shot, 1580, 640, 360, 720)}
{FOOT}""")


def feature(kicker, title, title_es, shot, callouts, shot_w=1240, shot_top=330):
    cs = "".join(f'<div class="callout" style="margin-bottom:30px"><div class="n">{i}</div><b>{t}</b><span>{s}</span></div>'
                 for i, (t, s) in enumerate(callouts, start=1))
    return page(f"""
<div class="abs" style="left:90px;top:80px;width:1820px">
  <span class="tag">{kicker}</span>
  <h2 style="margin-top:26px">{title}</h2>
  <p class="sub es" style="margin-top:10px">{title_es}</p>
</div>
<div class="abs" style="left:90px;top:330px;bottom:130px;width:1820px;display:flex;gap:50px;align-items:center">
  <div class="card" style="flex:0 0 {shot_w}px"><img src="{img(shot)}"></div>
  <div style="flex:1">{cs}</div>
</div>
{FOOT}""", "light")


def feature_wide(kicker, title, title_es, shot, callouts, shot_top=330, stacked=False):
    if isinstance(shot, tuple) and stacked:
        a, b = shot
        shot_html = (f'<div style="display:flex;flex-direction:column;align-items:center;gap:14px">'
                     f'<div style="display:flex;align-items:center;gap:26px"><div class="tag">YOU TYPE • ESCRIBES</div>'
                     f'<div class="card" style="height:270px"><img src="{img(a)}" style="height:100%;width:auto"></div></div>'
                     f'<div style="font-size:64px;color:#14B8A6;font-weight:900;line-height:1">↓</div>'
                     f'<div style="display:flex;align-items:center;gap:26px"><div class="tag">YOU GET • OBTIENES</div>'
                     f'<div class="card" style="height:270px"><img src="{img(b)}" style="height:100%;width:auto"></div></div></div>')
    elif isinstance(shot, tuple):   # (input shot, output shot) side by side with an arrow
        a, b = shot
        wa, ha = Image.open(f"{SHOTS}/{a}.png").size
        wb_, hb = Image.open(f"{SHOTS}/{b}.png").size
        ratio = (wa / ha) / (wb_ / hb)
        shot_html = (f'<div style="display:flex;align-items:center;gap:30px">'
                     f'<div style="flex:{ratio:.3f}"><div class="tag" style="margin-bottom:16px">YOU TYPE • ESCRIBES</div>'
                     f'<div class="card"><img src="{img(a)}"></div></div>'
                     f'<div style="font-size:80px;color:#14B8A6;font-weight:900;padding-top:60px">→</div>'
                     f'<div style="flex:1"><div class="tag" style="margin-bottom:16px">YOU GET • OBTIENES</div>'
                     f'<div class="card"><img src="{img(b)}"></div></div></div>')
    else:
        shot_html = f'<div class="card"><img src="{img(shot)}"></div>'
    cs = "".join(f'<div class="callout" style="flex:1"><div class="n">{i}</div><b>{t}</b><span>{s}</span></div>'
                 for i, (t, s) in enumerate(callouts, start=1))
    return page(f"""
<div class="abs" style="left:90px;top:80px;width:1820px">
  <span class="tag">{kicker}</span>
  <h2 style="margin-top:26px">{title}</h2>
  <p class="sub es" style="margin-top:10px">{title_es}</p>
</div>
<div class="abs" style="left:90px;top:330px;bottom:130px;width:1820px;display:flex;flex-direction:column;justify-content:center;gap:56px">
  {shot_html}
  <div style="display:flex;gap:34px">{cs}</div>
</div>
{FOOT}""", "light")


def inside(title, title_es, tiles):
    n = len(tiles)
    w = (1820 - (n - 1) * 34) // n
    cards = "".join(f"""
<div style="width:{w}px">
  <div class="card" style="height:600px"><img src="{img(s)}" style="height:100%;object-fit:cover;object-position:left top"></div>
  <div style="margin-top:26px;font-size:36px;font-weight:800">{name}</div>
  <div style="font-size:27px;color:#475569;margin-top:8px;line-height:1.3">{desc}</div>
</div>""" for s, name, desc in tiles)
    return page(f"""
<div class="abs" style="left:90px;top:90px;width:1820px;text-align:center">
  <span class="tag">WHAT'S INSIDE • CONTENIDO</span>
  <h2 style="margin-top:26px">{title}</h2>
  <p class="sub es" style="margin-top:10px">{title_es}</p>
</div>
<div class="abs" style="left:90px;top:440px;width:1820px;display:flex;gap:34px">{cards}</div>
{FOOT}""", "light")


def devices(dash, phone_shot, guide, last="🔒 Locked dashboard — formulas can't break"):
    return page(f"""
<div class="abs" style="left:90px;top:86px;width:1820px;text-align:center">
  <h2>Works on <span class="t">every device</span></h2>
  <p class="sub" style="margin-top:14px">Funciona en todos tus dispositivos</p>
</div>
{laptop(dash, 90, 400, 900)}
{phone(phone_shot, 1040, 380, 330, 660)}
<div class="abs" style="left:1440px;top:390px;width:470px">
  <ul class="checks" style="font-size:31px">
    <li>💻 PC &amp; Mac — Excel 2010+ or Google Sheets</li>
    <li>📱 iPhone &amp; Android — free Excel or Sheets app</li>
    <li>🌎 Every heading &amp; guide in English + Español</li>
    <li>{last}</li>
  </ul>
</div>
<div class="abs" style="left:90px;top:1095px;width:1820px;height:310px;display:flex;justify-content:center">
  <div class="card" style="height:100%"><img src="{img(guide + '_strip')}" style="height:100%;width:auto"></div>
</div>""")


def bundle_hero():
    return page(f"""
<div class="abs" style="left:90px;top:80px;width:1820px;text-align:center">
  <div class="brand">PROFITTRACK<small>RESELLER BUNDLE</small></div>
  <h1 style="margin-top:26px;font-size:96px">The Complete <span class="t">Reseller Toolkit</span></h1>
  <p class="sub" style="margin-top:20px">3 spreadsheets: Profit • Inventory • Expenses &amp; Mileage &nbsp;·&nbsp; <span class="es">3 hojas de cálculo</span></p>
</div>
<div class="abs card" style="left:90px;top:520px;width:600px;transform:rotate(-4deg)"><img src="{img('pt_dash')}"></div>
<div class="abs card" style="left:1310px;top:520px;width:600px;transform:rotate(4deg)"><img src="{img('ex_dash')}"></div>
<div class="abs card" style="left:640px;top:470px;width:720px;z-index:2"><img src="{img('iv_dash')}"></div>
<div class="abs" style="left:90px;top:1190px;width:1820px;display:flex;justify-content:space-around;font-size:40px;font-weight:800">
  <span>📊 Profit Tracker</span><span>📦 Inventory</span><span>🧾 Expenses &amp; Mileage</span>
</div>
<div class="abs" style="left:0;right:0;top:1270px;text-align:center"><span class="pill solid" style="font-size:32px">Bundle &amp; save — 3 tools, 1 price</span></div>
{FOOT}""")


def bundle_inside():
    cols = [
        ("pt_dash_top", "📊 Profit Tracker", ["Net profit & margin per sale, fees auto-calculated", "⚠ Low-margin alert under 15%",
                                         "Profit by platform + monthly trend", "BONUS: Buy / Pass sourcing calculator"]),
        ("iv_dash_top", "📦 Inventory", ["1,000 items with SKU & bin location", "Fresh → Watch → Stale age alerts",
                                     "Stock value, sell-through, days to sell", "10 oldest unsold items list"]),
        ("ex_dash", "🧾 Expenses & Mileage", ["Reseller expense categories + receipt check", "IRS rate applied by trip date",
                                               "2026: 72.5¢ → 76¢ on July 1, built in", "Total tax deductions by year"]),
    ]
    html = "".join(f"""
<div style="flex:1">
  <div class="card" style="height:330px"><img src="{img(s)}" style="height:100%;object-fit:cover;object-position:left top"></div>
  <div style="font-size:44px;font-weight:800;margin:30px 0 22px">{t}</div>
  <ul class="checks" style="font-size:29px">{''.join(f'<li>{x}</li>' for x in items)}</ul>
</div>""" for s, t, items in cols)
    return page(f"""
<div class="abs" style="left:90px;top:80px;width:1820px;text-align:center">
  <span class="tag">YOU GET 3 EXCEL FILES • 3 ARCHIVOS</span>
  <h2 style="margin-top:26px">Everything a reseller needs to <span class="t">track</span></h2>
</div>
<div class="abs" style="left:90px;top:360px;width:1820px;display:flex;gap:44px">{html}</div>
{FOOT}""", "light")


def bundle_price():
    row = lambda name, a, b: (f'<tr><td>{name}</td><td class="r">{a}</td><td class="r">{b}</td></tr>')
    return page(f"""
<style>
table {{ width: 100%; border-collapse: collapse; font-size: 40px; }}
td, th {{ padding: 28px 36px; border-bottom: 2px solid #CBD5E1; }}
th {{ background: #16325C; color: #fff; text-align: left; font-size: 32px; letter-spacing: 1px; }}
.r {{ text-align: right; }}
tr.total td {{ background: #0B1F3A; color: #fff; font-weight: 800; }}
tr.best td {{ background: #14B8A6; color: #0B1F3A; font-weight: 900; font-size: 48px; }}
</style>
<div class="abs" style="left:90px;top:80px;width:1820px;text-align:center">
  <span class="tag">BUNDLE &amp; SAVE • AHORRA</span>
  <h2 style="margin-top:26px">3 tools for <span class="t">less</span> than buying separately</h2>
</div>
<div class="abs card" style="left:260px;top:390px;width:1480px">
<table>
  <tr><th>Product</th><th class="r">Regular price</th><th class="r">Launch sale</th></tr>
  {row('📊 Profit Tracker', '$14.99', '$7.49')}
  {row('📦 Inventory', '$12.99', '$6.49')}
  {row('🧾 Expenses &amp; Mileage', '$12.99', '$6.49')}
  <tr class="total"><td>Bought separately</td><td class="r">$40.97</td><td class="r">$20.47</td></tr>
  <tr class="best"><td>🧰 Reseller Bundle (all 3)</td><td class="r">$29.99</td><td class="r">$14.99</td></tr>
</table></div>
<p class="abs sub" style="left:0;right:0;top:1250px;text-align:center;color:#475569;font-size:30px">
  Prices at launch — see the listing for the current price. / Precios de lanzamiento.</p>
{FOOT}""", "light")


# ---------------------------------------------------------------- image plan
PLAN = {
    "profittrack": [
        ("01-hero", hero("PROFIT TRACKER", "Know your REAL", "profit on every flip",
                         "Sales tracker + automatic dashboard for resellers.<br><span class='es'>Registro de ventas y panel automático.</span>",
                         ["Fees, net profit &amp; margin calculated for you", "⚠ Alert on every sale under 15% margin",
                          "Profit by platform, monthly trend, Top 5", "BONUS: Buy / Pass sourcing calculator"],
                         "pt_dash", "pt_phone", ("eBay • Poshmark • Etsy • FB",))),
        ("02-inside", inside("5 tabs, ready to use", "5 pestañas listas para usar", [
            ("pt_cover", "Cover", "One-click links / Enlaces"),
            ("pt_dash_top", "Dashboard", "KPIs &amp; charts / Panel"),
            ("pt_tracker", "Tracker", "Log every sale / Registro"),
            ("pt_sourcing", "Sourcing List", "BONUS: Buy or pass / Bono"),
            ("pt_guide", "Quick Start", "Step-by-step EN + ES / Guía"),
        ])),
        ("03-dashboard", feature("LIVE DASHBOARD • PANEL", "Your whole business <span class='t'>at a glance</span>",
                                 "Todo tu negocio de un vistazo — se actualiza solo", "pt_dash", [
            ("Revenue, profit, margin, sales", "4 KPI cards update the second you log a sale."),
            ("Profit by platform", "See whether eBay, Poshmark, Etsy or Facebook pays you best."),
            ("Monthly trend + Top 5", "Spot your best months and most profitable items."),
        ], shot_w=1230)),
        ("04-tracker", feature_wide("SALES TRACKER • REGISTRO", "Fees, profit &amp; margin — <span class='t'>calculated for you</span>",
                                    "Comisiones, ganancia y margen — calculados automáticamente", "pt_tracker_calc", [
            ("Type 6 numbers", "Cost, shipping, price, fee %, other costs."),
            ("Get net profit + margin", "Real formulas, nothing to calculate by hand."),
            ("⚠ Low-margin alert", "Any sale under 15% margin turns red."),
        ])),
        ("05-sourcing", feature_wide("BONUS • BONO", "Should you buy it? <span class='t'>Know before you pay</span>",
                                     "¿Lo compras? Sábelo antes de pagar", ("pt_sourcing_in", "pt_sourcing_out"), [
            ("Set your rules", "Minimum margin and minimum profit per item."),
            ("✔ BUY or ✖ PASS", "Instant decision with estimated profit, margin and ROI."),
            ("Max Buy Price", "The most you can pay and still hit your target — negotiate with it."),
        ], shot_top=360)),
        ("06-devices", devices("pt_dash", "pt_phone", "pt_guide")),
    ],
    "expenses": [
        ("01-hero", hero("EXPENSES &amp; MILEAGE", "Don't miss a", "single tax deduction",
                         "Expense + mileage tracker built for resellers.<br><span class='es'>Registro de gastos y millaje para revendedores.</span>",
                         ["Total deductions for the tax year, automatically", "IRS mileage rate applied by trip date",
                          "2026 rates built in: 72.5¢ → 76¢ on July 1", "Missing-receipt &amp; missing-info checks"],
                         "ex_dash", "ex_phone")),
        ("02-dashboard", feature("TAX-YEAR DASHBOARD • PANEL", "All your deductions <span class='t'>in one place</span>",
                                 "Todas tus deducciones en un solo lugar", "ex_dash", [
            ("Total deductions", "Deductible expenses + mileage deduction for any tax year."),
            ("By category", "12 reseller categories: supplies, postage, fees, ads, storage…"),
            ("By month", "Expenses and mileage side by side, month by month."),
        ], shot_w=1230)),
        ("03-mileage", feature_wide("MILEAGE LOG • MILLAJE", "Every trip × the right IRS rate — <span class='t'>automatically</span>",
                                    "Cada viaje × la tarifa correcta del IRS — automático", "ex_mileage_calc", [
            ("Odometer or miles", "Enter start/end readings, or just the miles from Google Maps."),
            ("Round trip = ×2", "One dropdown doubles the miles for you."),
            ("Rate by date", "Jan–Jun 2026 at 72.5¢, from Jul 1 at 76¢ — add future rates in one line."),
        ])),
        ("04-expenses", feature_wide("EXPENSE LOG • GASTOS", "Log it once, <span class='t'>deduct it right</span>",
                                     "Regístralo una vez, dedúcelo bien", "ex_expenses", [
            ("Business-use %", "Phone 50%? Internet 30%? The deductible amount is calculated."),
            ("Receipt check", "Flags missing dates, categories and receipts."),
            ("Organizing tool", "Share the totals with your tax preparer. Not tax advice."),
        ], shot_top=350)),
        ("05-devices", devices("ex_dash", "ex_phone", "ex_guide")),
    ],
    "inventory": [
        ("01-hero", hero("INVENTORY", "Know what's sitting", "on your shelves",
                         "Inventory tracker with stale-item alerts.<br><span class='es'>Control de inventario con alertas.</span>",
                         ["Stock value &amp; potential revenue, live", "✔ Fresh → ● Watch → ⚠ Stale alerts",
                          "Sell-through rate &amp; average days to sell", "10 oldest unsold items to reprice"],
                         "iv_dash", "iv_phone")),
        ("02-dashboard", feature("INVENTORY DASHBOARD • PANEL", "What you own, what it's worth, <span class='t'>what's stuck</span>",
                                 "Qué tienes, cuánto vale y qué no se vende", "iv_dash", [
            ("8 KPIs", "In stock, value, potential revenue, stale, sold, days to sell, sell-through, profit."),
            ("By category", "Where your money is tied up."),
            ("By age", "0–30, 31–60, 61–90 and 90+ days at a glance."),
        ], shot_w=1150)),
        ("03-alerts", feature("AGE ALERTS • ALERTAS", "Stale stock <span class='t'>flags itself</span>",
                              "El inventario estancado se marca solo", "iv_alerts", [
            ("Days held, automatic", "Counts up every day from the purchase date."),
            ("You set the limits", "Watch at 60 days, Stale at 90 — change them in Settings."),
            ("Profit at a glance", "Potential profit for unsold items, gross profit for sold."),
        ], shot_w=1180)),
        ("04-oldest", feature_wide("REPRICE LIST • LISTA", "Your 10 oldest items — <span class='t'>your to-do list</span>",
                                   "Tus 10 artículos más antiguos — tu lista de pendientes", "iv_oldest", [
            ("Reprice", "Lower the price on items past your Stale limit."),
            ("Relist or bundle", "Fresh listings and lots move old stock."),
            ("Find it fast", "Bin / location column tells you where it is."),
        ], shot_top=380)),
        ("05-devices", devices("iv_dash", "iv_phone", "iv_guide")),
    ],
    "pricing": [
        ("01-hero", hero("PRICING CALCULATOR", "Stop guessing", "your prices",
                         "Handmade product pricing calculator for Etsy.<br><span class='es'>Calculadora de precios para productos hechos a mano.</span>",
                         ["Materials + your time + every Etsy fee", "Break-even &amp; recommended price (.99)",
                          "Profit per sale &amp; what you earn per hour", "Price your whole shop — 200 products"],
                         "hp_calc", "hp_phone", ("Etsy • Craft fairs",))),
        ("02-calculator", feature("PRICE ONE PRODUCT • UN PRODUCTO", "Your perfect price <span class='t'>in 60 seconds</span>",
                                  "Tu precio ideal en 60 segundos", "hp_calc", [
            ("Pick your materials", "From your own supply library — cost per unit already calculated."),
            ("Add time &amp; shipping", "Your hourly rate, packaging, overhead, free or paid shipping."),
            ("Get your price", "Break-even, recommended (.99), profit, margin and $ per hour."),
        ], shot_w=1150)),
        ("03-product-list", feature_wide("WHOLE SHOP • TODO TU CATÁLOGO", "Which products <span class='t'>are losing money?</span>",
                                         "¿Qué productos te hacen perder dinero?", ("hp_list_in", "hp_list_out"), [
            ("200 products", "Recommended vs. your current price for every item."),
            ("Real margin + $/hour", "See what each product really pays you after Etsy fees."),
            ("⚠ / ● / ✔ flags", "Fix losing products first, then raise the ones below target."),
        ])),
        ("04-fees", feature("EVERY ETSY FEE • TODAS LAS COMISIONES", "Fees included — <span class='t'>no surprises</span>",
                            "Comisiones incluidas — sin sorpresas", "hp_calc_results", [
            ("6.5% + 3% + $0.25 + $0.20", "Transaction, processing and listing fees built in (US 2026, editable)."),
            ("Offsite Ads option", "Price safely for 12–15% Offsite Ads sales with one switch."),
            ("Classic formula check", "See why cost × 2 × 2 isn't enough once fees and time count."),
        ], shot_w=760)),
        ("05-devices", devices("hp_calc", "hp_phone", "hp_guide", last="🧵 Materials library — 200 supplies, cost per unit automatic")),
    ],
    "budget": [
        ("01-hero", hero("BILINGUAL BUDGET", "Your money,", "in both languages",
                         "Monthly budget planner — English + Español.<br><span class='es'>Tu dinero, en los dos idiomas.</span>",
                         ["Budget vs. actual for every category", "50/30/20 check · Regla 50/30/20",
                          "Savings goals with progress bars", "Debt payoff: snowball &amp; avalanche"],
                         "bp_dash", "bp_phone", ("Any currency",))),
        ("02-inside", inside("6 tabs in English + Español", "6 pestañas en inglés y español", [
            ("bp_dash_top", "Dashboard", "Your month / Tu mes"),
            ("bp_tx", "Transactions", "Movimientos"),
            ("bp_budget", "Budget", "Presupuesto"),
            ("bp_goals", "Savings Goals", "Metas de ahorro"),
            ("bp_debts", "Debts", "Deudas"),
            ("bp_guide", "Quick Start", "Guía rápida"),
        ])),
        ("03-dashboard", feature("DASHBOARD • PANEL", "See where your money <span class='t'>really goes</span>",
                                 "Mira a dónde va tu dinero de verdad", "bp_dash_top", [
            ("Pick any month", "Income, spending, money left over and savings rate."),
            ("Budget vs. actual", "✔ under / ⚠ over for every category."),
            ("50/30/20 check", "Needs, wants and savings vs. the ideal mix."),
        ], shot_w=1180)),
        ("04-goals", feature_wide("SAVINGS GOALS • METAS DE AHORRO", "Reach every goal — <span class='t'>on time</span>",
                                  "Alcanza cada meta a tiempo", ("bp_goals_in", "bp_goals_out"), stacked=True, callouts=[
            ("Target + date", "Emergency fund, trip, car, holidays — any goal."),
            ("Progress bars", "See exactly how far you've come."),
            ("Save per month", "How much to set aside each month to make your date."),
        ])),
        ("05-debts", feature_wide("DEBT PAYOFF • PAGO DE DEUDAS", "Know your <span class='t'>debt-free date</span>",
                                  "Conoce tu fecha libre de deudas", ("bp_debts_in", "bp_debts_out"), stacked=True, callouts=[
            ("Payoff date", "Months to pay off and the exact month you're done."),
            ("Total interest", "See what each debt really costs you."),
            ("Snowball &amp; avalanche", "Both payoff orders, calculated for you."),
        ])),
        ("06-devices", devices("bp_dash", "bp_phone", "bp_guide", last="👨‍👩‍👧 Share in Google Sheets — budget together")),
    ],
    "bundle": [
        ("01-hero", bundle_hero()),
        ("02-inside", bundle_inside()),
        ("03-price", bundle_price()),
        ("04-devices", devices("pt_dash", "pt_phone", "pt_guide")),
    ],
}


def freebie_cover():
    """Gumroad cover, 1280 x 720."""
    return f"""<!doctype html><html><head><meta charset="utf-8"><style>{CSS}
body {{ width: 1280px; height: 720px; }}</style></head><body class="navy">
<div class="abs" style="left:60px;top:56px;width:560px">
  <span class="tag" style="font-size:24px">FREE • GRATIS</span>
  <h1 style="margin-top:22px;font-size:66px">Flip Profit<br><span class="t">Calculator</span></h1>
  <p class="sub" style="margin-top:18px;font-size:27px">Know your profit <b>before</b> you buy.<br><span class="es">Sabe tu ganancia antes de comprar.</span></p>
  <ul class="checks" style="margin-top:26px;font-size:24px">
    <li>eBay • Poshmark • Etsy • Mercari • FB</li><li>Fees, profit, margin &amp; ROI</li><li>✔ Good flip / ● Thin / ⚠ Loss</li>
  </ul>
</div>
<div class="abs" style="left:650px;top:60px;width:580px">
  <div class="tag" style="font-size:18px;margin-bottom:10px">YOU TYPE • ESCRIBES</div>
  <div class="card"><img src="{img('fr_items')}"></div>
  <div style="text-align:center;font-size:44px;color:#14B8A6;font-weight:900;line-height:1.1">↓</div>
  <div class="tag" style="font-size:18px;margin-bottom:10px">YOU GET • OBTIENES</div>
  <div class="card"><img src="{img('fr_result')}"></div>
  <div class="pills" style="margin-top:22px;justify-content:center"><span class="pill" style="font-size:22px">Excel</span><span class="pill" style="font-size:22px">Google Sheets</span><span class="pill" style="font-size:22px">EN + ES</span></div>
</div>
</body></html>"""


def freebie_thumb():
    """Gumroad thumbnail, 600 x 600."""
    return f"""<!doctype html><html><head><meta charset="utf-8"><style>{CSS}
body {{ width: 600px; height: 600px; }}</style></head><body class="navy">
<div class="abs" style="left:0;right:0;top:48px;text-align:center">
  <span class="tag" style="font-size:26px">FREE • GRATIS</span>
  <h1 style="margin-top:22px;font-size:62px">Flip Profit<br><span class="t">Calculator</span></h1>
</div>
<div class="abs card" style="left:40px;top:270px;width:520px"><img src="{img('fr_result')}"></div>
<div class="abs" style="left:0;right:0;bottom:36px;text-align:center;font-size:24px;font-weight:700;color:#C7D2FE">Excel • Google Sheets • EN + ES</div>
</body></html>"""


EXTRA = {"freebie/gumroad-cover": (freebie_cover, 1280, 720), "freebie/gumroad-thumb": (freebie_thumb, 600, 600)}


if __name__ == "__main__":
    only = set(sys.argv[1:])
    os.makedirs(HTML_DIR, exist_ok=True)
    with sync_playwright() as p:
        browser = p.chromium.launch(executable_path=CHROME)
        pg = browser.new_page(viewport={"width": 2000, "height": 1500})
        for product, images in PLAN.items():
            os.makedirs(os.path.join(OUT, product), exist_ok=True)
            for name, html in images:
                key = f"{product}/{name}"
                if only and key not in only and product not in only:
                    continue
                path = os.path.join(HTML_DIR, f"{product}-{name}.html")
                with open(path, "w", encoding="utf-8") as f:
                    f.write(html)
                pg.goto(f"file://{path}")
                pg.wait_for_timeout(300)
                png = os.path.join(HTML_DIR, f"{product}-{name}.png")
                pg.screenshot(path=png)
                out = os.path.join(OUT, product, f"{name}.jpg")
                Image.open(png).convert("RGB").save(out, quality=90, optimize=True)
                print("image", out)
        for key, (fn, w, h) in EXTRA.items():
            if only and key not in only and key.split("/")[0] not in only:
                continue
            os.makedirs(os.path.join(OUT, key.split("/")[0]), exist_ok=True)
            pg2 = browser.new_page(viewport={"width": w, "height": h})
            path = os.path.join(HTML_DIR, key.replace("/", "-") + ".html")
            with open(path, "w", encoding="utf-8") as f:
                f.write(fn())
            pg2.goto(f"file://{path}")
            pg2.wait_for_timeout(300)
            png = path[:-5] + ".png"
            pg2.screenshot(path=png)
            Image.open(png).convert("RGB").save(os.path.join(OUT, key + ".jpg"), quality=90, optimize=True)
            print("image", key)
            pg2.close()
        browser.close()
