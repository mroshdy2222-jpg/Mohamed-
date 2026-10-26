"""Pinterest pins (1000 x 1500, 2:3) built from the real workbook screenshots."""
import os

from PIL import Image
from playwright.sync_api import sync_playwright

from listing_images import CHROME, CSS, HTML_DIR, ROOT, img

OUT = os.path.join(ROOT, "product", "images", "pinterest")

PIN_CSS = CSS + """
body { width: 1000px; height: 1500px; }
.pin-h { font-size: 82px; line-height: 1.02; font-weight: 800; letter-spacing: -1.5px; }
.pin-h .t { color: #14B8A6; }
.pin-es { font-size: 32px; font-style: italic; color: #94A3B8; font-weight: 500; margin-top: 16px; }
.mini { list-style: none; font-size: 31px; font-weight: 700; }
.mini li { margin: 0 0 14px 0; }
.mini li::before { content: '✓  '; color: #14B8A6; font-weight: 900; }
.cta { position: absolute; left: 0; right: 0; bottom: 0; height: 120px; background: #14B8A6; color: #0B1F3A;
       display: flex; flex-direction: column; align-items: center; justify-content: center; }
.cta b { font-size: 38px; font-weight: 900; letter-spacing: 1px; }
.cta span { font-size: 22px; font-weight: 700; opacity: .75; margin-top: 2px; }
"""


def pin(kicker, line1, line2, es, shots, bullets, cta, cta_sub="Excel • Google Sheets • iPhone • Android • PC / Mac"):
    h = {1: 640, 2: 330, 3: 210}[len(shots)]
    cards = "".join(f'<div class="card" style="margin-bottom:22px;max-width:880px"><img src="{img(s)}" style="max-height:{h}px;width:auto;max-width:100%"></div>' for s in shots)
    items = "".join(f"<li>{b}</li>" for b in bullets)
    return f"""<!doctype html><html><head><meta charset="utf-8"><style>{PIN_CSS}</style></head><body class="navy">
<div class="abs" style="left:60px;top:60px;width:880px">
  <span class="tag" style="font-size:24px">{kicker}</span>
  <div class="pin-h" style="margin-top:26px">{line1}<br><span class="t">{line2}</span></div>
  <div class="pin-es">{es}</div>
</div>
<div class="abs" style="left:60px;top:400px;bottom:150px;width:880px;display:flex;flex-direction:column;justify-content:center;align-items:center">
  {cards}
  <ul class="mini" style="align-self:flex-start;margin-top:18px">{items}</ul>
</div>
<div class="cta"><b>{cta}</b><span>{cta_sub}</span></div>
</body></html>"""


PINS = {
    "01-profit-tracker": pin("FOR RESELLERS • REVENDEDORES", "Know your REAL", "profit on every flip",
                             "Conoce tu ganancia real en cada reventa", ["pin_pt_platform", "pin_pt_tracker"],
                             ["Fees &amp; net profit calculated for you", "⚠ Alert on sales under 15% margin", "English + Español"],
                             "INSTANT DOWNLOAD ON ETSY"),
    "02-inventory": pin("FOR RESELLERS • REVENDEDORES", "What's sitting", "on your shelves?",
                        "¿Qué tienes estancado en inventario?", ["pin_iv_alerts", "pin_iv_oldest"],
                        ["Fresh → Watch → Stale alerts", "Stock value &amp; days to sell", "10 oldest items to reprice"],
                        "INSTANT DOWNLOAD ON ETSY"),
    "03-expenses": pin("TAX TIME • IMPUESTOS", "Don't miss a single", "tax deduction",
                       "No pierdas ni una deducción", ["pin_ex_mileage", "pin_ex_cats"],
                       ["Expenses + mileage in one file", "IRS rate applied by trip date", "2026: 72.5¢ → 76¢ built in"],
                       "INSTANT DOWNLOAD ON ETSY"),
    "04-bundle": pin("RESELLER BUNDLE • PAQUETE", "The complete", "reseller toolkit",
                     "El kit completo para revendedores", ["pt_kpis", "iv_kpis", "ex_kpis"],
                     ["Profit • Inventory • Expenses &amp; Mileage", "3 spreadsheets, 1 price", "English + Español"],
                     "BUNDLE &amp; SAVE ON ETSY"),
    "05-pricing": pin("FOR MAKERS • ARTESANOS", "Stop guessing", "your Etsy prices",
                      "Deja de adivinar tus precios", ["pin_hp", "pin_hp_status"],
                      ["Materials + time + every Etsy fee", "Recommended price &amp; $ per hour", "Price your whole shop"],
                      "INSTANT DOWNLOAD ON ETSY"),
    "06-budget-en": pin("BUDGET PLANNER • PRESUPUESTO", "Your money,", "in both languages",
                        "Tu dinero, en los dos idiomas", ["bp_kpis", "bp_goals_out"],
                        ["Budget vs. actual · 50/30/20", "Savings goals &amp; debt payoff", "Every heading in EN + ES"],
                        "INSTANT DOWNLOAD ON ETSY"),
    "07-budget-es": pin("PRESUPUESTO • BUDGET", "Toma el control", "de tu dinero",
                        "Take control of your money — English + Español", ["bp_kpis", "bp_debts_out"],
                        ["Presupuesto vs. real · regla 50/30/20", "Metas de ahorro y pago de deudas", "Todo en español e inglés"],
                        "DESCARGA INSTANTÁNEA EN ETSY", "Excel • Google Sheets • iPhone • Android • Computadora"),
    "08-free-calculator": pin("FREE • GRATIS", "Is this flip", "worth it?",
                              "¿Vale la pena esta reventa?", ["fr_items", "fr_result"],
                              ["Fees, profit, margin &amp; ROI", "eBay • Poshmark • Etsy • Mercari • FB", "Free for resellers"],
                              "FREE DOWNLOAD — LINK IN PIN", "Excel • Google Sheets • English + Español"),
}

if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(HTML_DIR, exist_ok=True)
    with sync_playwright() as p:
        browser = p.chromium.launch(executable_path=CHROME)
        pg = browser.new_page(viewport={"width": 1000, "height": 1500})
        for name, html in PINS.items():
            path = os.path.join(HTML_DIR, f"pin-{name}.html")
            with open(path, "w", encoding="utf-8") as f:
                f.write(html)
            pg.goto(f"file://{path}")
            pg.wait_for_timeout(300)
            png = path[:-5] + ".png"
            pg.screenshot(path=png)
            Image.open(png).convert("RGB").save(os.path.join(OUT, f"{name}.jpg"), quality=90, optimize=True)
            print("pin", name)
        browser.close()
