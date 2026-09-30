"""Build ProfitTrack — Reseller Profit Tracker & Dashboard (bilingual EN/ES)."""
from datetime import date

from openpyxl import Workbook
from openpyxl.chart import BarChart, LineChart, Reference
from openpyxl.chart.label import DataLabelList
from openpyxl.chart.text import RichText, Text
from openpyxl.chart.title import Title
from openpyxl.drawing.text import CharacterProperties, Paragraph, ParagraphProperties, RegularTextRun
from openpyxl.drawing.text import Font as DFont
from openpyxl.comments import Comment
from openpyxl.formatting.rule import CellIsRule, FormulaRule
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter
from openpyxl.worksheet.datavalidation import DataValidation

OUT = "product/ProfitTrack_Reseller_Profit_Tracker.xlsx"

# ---------- Brand ----------
NAVY = "0B1F3A"
NAVY_2 = "16325C"
TEAL = "14B8A6"
TEAL_DARK = "0F766E"
TEAL_LIGHT = "CCFBF1"
INPUT_FILL = "F0FDFA"   # very light teal = cells the user types in
CALC_FILL = "F1F5F9"    # light slate = formula cells (don't type here)
WHITE = "FFFFFF"
SLATE = "475569"
RED = "DC2626"
RED_LIGHT = "FEE2E2"
GREEN_LIGHT = "DCFCE7"
GREEN = "15803D"
FONT = "Arial"

CUR = '$#,##0.00;[Red]-$#,##0.00;"-"'
CUR0 = '$#,##0;[Red]-$#,##0;"-"'
PCT = '0.0%;[Red]-0.0%;"-"'
DATE_FMT = "yyyy-mm-dd"

FIRST, LAST = 6, 505  # Tracker data rows (500 sales)
RETURNED = "Returned / Devuelto"
PLATFORMS = ["eBay", "Facebook Marketplace", "Etsy", "Poshmark", "Other"]
STATUSES = ["Sold / Vendido", "Shipped / Enviado", "Delivered / Entregado",
            "Pending / Pendiente", RETURNED]


def fill(c):
    return PatternFill("solid", start_color=c, end_color=c)


def font(size=10, bold=False, color="000000", italic=False):
    return Font(name=FONT, size=size, bold=bold, color=color, italic=italic)


thin = Side(style="thin", color="CBD5E1")
BORDER = Border(left=thin, right=thin, top=thin, bottom=thin)
CENTER = Alignment(horizontal="center", vertical="center", wrap_text=True)
LEFT = Alignment(horizontal="left", vertical="center", wrap_text=True)


def paint(ws, rng, color):
    for row in ws[rng]:
        for c in row:
            c.fill = fill(color)


def banner(ws, last_col, title, subtitle):
    """Navy title bar in rows 1-3, used on every sheet except the cover."""
    paint(ws, f"A1:{last_col}3", NAVY)
    ws["A1"].value = None
    ws.merge_cells(f"B1:{last_col}1")
    ws["B1"] = "ProfitTrack"
    ws["B1"].font = font(9, True, TEAL)
    ws["B1"].alignment = Alignment(vertical="bottom")
    ws.merge_cells(f"B2:{last_col}2")
    ws["B2"] = title
    ws["B2"].font = font(18, True, WHITE)
    ws["B2"].alignment = Alignment(vertical="center")
    ws.merge_cells(f"B3:{last_col}3")
    ws["B3"] = subtitle
    ws["B3"].font = font(10, False, "C7D2FE", italic=True)
    ws["B3"].alignment = Alignment(vertical="top")
    ws.row_dimensions[1].height = 18
    ws.row_dimensions[2].height = 30
    ws.row_dimensions[3].height = 20
    paint(ws, f"A4:{last_col}4", TEAL)
    ws.row_dimensions[4].height = 4
    ws.column_dimensions["A"].width = 2.5


def header_cell(c, text):
    c.value = text
    c.font = font(10, True, WHITE)
    c.fill = fill(NAVY_2)
    c.alignment = CENTER
    c.border = BORDER


wb = Workbook()

# =====================================================================
# COVER
# =====================================================================
cv = wb.active
cv.title = "Cover"
cv.sheet_view.showGridLines = False
for col in range(1, 13):
    cv.column_dimensions[get_column_letter(col)].width = 11
paint(cv, "A1:L40", NAVY)
paint(cv, "A13:L13", TEAL)
cv.row_dimensions[13].height = 5

cv.merge_cells("B4:K4")
cv["B4"] = "RESELLER TOOLKIT  •  KIT PARA REVENDEDORES"
cv["B4"].font = font(11, True, TEAL)
cv["B4"].alignment = CENTER

cv.merge_cells("B6:K8")
cv["B6"] = "ProfitTrack"
cv["B6"].font = font(48, True, WHITE)
cv["B6"].alignment = CENTER

cv.merge_cells("B9:K9")
cv["B9"] = "Reseller Profit Tracker & Dashboard"
cv["B9"].font = font(18, True, TEAL_LIGHT)
cv["B9"].alignment = CENTER
cv.merge_cells("B10:K10")
cv["B10"] = "Registro de Ganancias y Panel para Revendedores"
cv["B10"].font = font(14, False, "C7D2FE", italic=True)
cv["B10"].alignment = CENTER
cv.merge_cells("B11:K11")
cv["B11"] = "eBay  •  Facebook Marketplace  •  Etsy  •  Poshmark  •  Other / Otro"
cv["B11"].font = font(10, False, "94A3B8")
cv["B11"].alignment = CENTER
for r in (6, 7, 8):
    cv.row_dimensions[r].height = 22
cv.row_dimensions[9].height = 28
cv.row_dimensions[10].height = 22

cv.merge_cells("B15:K15")
cv["B15"] = "WHAT'S INSIDE  /  CONTENIDO   (click to open • clic para abrir)"
cv["B15"].font = font(12, True, TEAL)
cv["B15"].alignment = CENTER

contents = [
    ("Dashboard", "📊  Dashboard / Panel", "KPIs, profit by platform, monthly trend, Top 5 / Indicadores, ganancia por plataforma, tendencia mensual, Top 5"),
    ("Tracker", "🧾  Tracker / Registro", "Log every sale – fees, profit & margin auto-calculated / Registra cada venta – comisiones, ganancia y margen automáticos"),
    ("Sourcing List", "🔍  Sourcing List / Lista de Compras (BONUS)", "Check profit BEFORE you buy / Calcula la ganancia ANTES de comprar"),
    ("Quick Start Guide", "🚀  Quick Start Guide / Guía Rápida", "Step-by-step setup in 5 minutes / Configuración paso a paso en 5 minutos"),
]
r = 17
for sheet, label, desc in contents:
    cv.merge_cells(f"C{r}:J{r}")
    c = cv[f"C{r}"]
    c.value = label
    c.hyperlink = f"#'{sheet}'!A1"
    c.font = Font(name=FONT, size=13, bold=True, color=WHITE, underline="single")
    c.alignment = LEFT
    cv.merge_cells(f"C{r+1}:J{r+1}")
    d = cv[f"C{r+1}"]
    d.value = desc
    d.font = font(9, False, "94A3B8")
    d.alignment = LEFT
    cv.row_dimensions[r].height = 22
    cv.row_dimensions[r + 1].height = 26
    r += 3

cv.merge_cells("B31:K31")
cv["B31"] = "Works in Microsoft Excel 2010+ • Google Sheets • LibreOffice   |   Compatible con Excel 2010+ • Google Sheets • LibreOffice"
cv["B31"].font = font(9, False, "94A3B8")
cv["B31"].alignment = CENTER
cv.merge_cells("B33:K33")
cv["B33"] = "Start here → Quick Start Guide   |   Empieza aquí → Guía Rápida"
cv["B33"].font = Font(name=FONT, size=11, bold=True, color=TEAL, underline="single")
cv["B33"].hyperlink = "#'Quick Start Guide'!A1"
cv["B33"].alignment = CENTER
cv.merge_cells("B36:K36")
cv["B36"] = "© ProfitTrack  •  v1.0  •  For personal use only – do not resell or redistribute / Solo para uso personal – prohibida su reventa o distribución"
cv["B36"].font = font(8, False, "64748B")
cv["B36"].alignment = CENTER

# =====================================================================
# TRACKER
# =====================================================================
tr = wb.create_sheet("Tracker")
tr.sheet_view.showGridLines = False
banner(tr, "O", "Sales Tracker  /  Registro de Ventas",
       "Type in the light-teal columns only. Grey columns calculate automatically.  •  "
       "Escribe solo en las columnas verde claro. Las columnas grises se calculan solas.")

headers = [
    ("B", "Product Name\nNombre del Producto", 30, "in"),
    ("C", "Platform\nPlataforma", 20, "in"),
    ("D", "Sale Date\nFecha de Venta", 13, "in"),
    ("E", "Purchase Cost\nCosto de Compra", 13, "in"),
    ("F", "Shipping In\nEnvío (Entrada)", 13, "in"),
    ("G", "Sale Price\nPrecio de Venta", 13, "in"),
    ("H", "Platform Fee %\n% Comisión", 12, "in"),
    ("I", "Platform Fee $\nComisión $", 13, "calc"),
    ("J", "Shipping Out\nEnvío (Salida)", 13, "in"),
    ("K", "Other Costs\nOtros Costos", 12, "in"),
    ("L", "Net Profit\nGanancia Neta", 13, "calc"),
    ("M", "Profit Margin %\nMargen %", 12, "calc"),
    ("N", "Status\nEstado", 20, "in"),
    ("O", "Margin Alert (<15%)\nAlerta de Margen", 26, "calc"),
]
tr.row_dimensions[5].height = 36
for col, text, width, _ in headers:
    header_cell(tr[f"{col}5"], text)
    tr.column_dimensions[col].width = width
# helper column for Top-5 ranking (hidden)
tr["P5"] = "Rank key (helper)"
tr["P5"].font = font(8, False, "94A3B8")
tr.column_dimensions["P"].hidden = True

tr["I5"].comment = Comment("Auto: Sale Price × Fee %\nAuto: Precio de Venta × % Comisión", "ProfitTrack")
tr["L5"].comment = Comment("Auto: Sale Price − Purchase Cost − Shipping In − Platform Fee − Shipping Out − Other Costs\n"
                           "Auto: Precio − Costo − Envío entrada − Comisión − Envío salida − Otros", "ProfitTrack")
tr["M5"].comment = Comment("Auto: Net Profit ÷ Sale Price\nAuto: Ganancia Neta ÷ Precio de Venta", "ProfitTrack")
tr["H5"].comment = Comment("Enter as a percent, e.g. 13.25%. Typical rates are listed in the Quick Start Guide.\n"
                           "Escribe el porcentaje, ej. 13.25%. Las tarifas típicas están en la Guía Rápida.", "ProfitTrack")
tr["O5"].comment = Comment("Flags any sale with a profit margin below 15%.\nMarca cualquier venta con margen menor al 15%.", "ProfitTrack")

for r in range(FIRST, LAST + 1):
    tr[f"I{r}"] = f'=IF(G{r}="","",G{r}*H{r})'
    tr[f"L{r}"] = f'=IF(OR(B{r}="",G{r}=""),"",G{r}-E{r}-F{r}-I{r}-J{r}-K{r})'
    tr[f"M{r}"] = f'=IF(L{r}="","",IF(G{r}=0,0,L{r}/G{r}))'
    tr[f"O{r}"] = f'=IF(M{r}="","",IF(M{r}<0.15,"⚠ LOW MARGIN / MARGEN BAJO","✔ OK"))'
    tr[f"P{r}"] = f'=IF(OR(L{r}="",N{r}="{RETURNED}"),"",L{r}+ROW()/1000000)'
    for col, _, _, kind in headers:
        c = tr[f"{col}{r}"]
        c.fill = fill(INPUT_FILL if kind == "in" else CALC_FILL)
        c.border = BORDER
        c.font = font(10, color="1E3A8A" if kind == "in" else "000000")
        c.alignment = Alignment(vertical="center", horizontal="left" if col in "BCNO" else "right")
    for col in "EFGIJKL":
        tr[f"{col}{r}"].number_format = CUR
    tr[f"H{r}"].number_format = "0.00%"
    tr[f"M{r}"].number_format = PCT
    tr[f"D{r}"].number_format = DATE_FMT
    tr[f"D{r}"].alignment = Alignment(horizontal="center", vertical="center")
    tr[f"O{r}"].alignment = Alignment(horizontal="center", vertical="center")
    tr[f"P{r}"].font = font(8, color="94A3B8")

# Example rows (realistic, clearly marked as examples)
samples = [
    ("Nike Air Max 90 – Size 10", "eBay", date(2026, 1, 8), 22.00, 0, 89.99, 0.1325, 12.45, 0),
    ("Levi's 501 Vintage Jeans", "Poshmark", date(2026, 1, 19), 6.00, 0, 45.00, 0.20, 0, 0),
    ("Pyrex Butterprint Bowl Set", "Facebook Marketplace", date(2026, 2, 3), 8.00, 0, 40.00, 0, 0, 0),
    ("Handmade Ceramic Mug (Vintage)", "Etsy", date(2026, 2, 14), 3.00, 0, 28.00, 0.095, 6.50, 0.25),
    ("Patagonia Better Sweater – M", "eBay", date(2026, 2, 27), 12.00, 0, 64.00, 0.1325, 9.80, 0),
    ("LEGO Star Wars 75192 (sealed)", "eBay", date(2026, 3, 10), 450.00, 0, 799.00, 0.1325, 45.00, 0),
    ("Coach Tabby Shoulder Bag", "Poshmark", date(2026, 3, 22), 35.00, 0, 180.00, 0.20, 0, 0),
    ("Mid-Century Teak Side Table", "Facebook Marketplace", date(2026, 4, 5), 40.00, 0, 150.00, 0, 0, 10.00),
    ("Vintage Band Tee – Nirvana", "Etsy", date(2026, 4, 18), 4.00, 0, 55.00, 0.095, 5.25, 0.25),
    ("Kitchenaid Mixer Attachment", "eBay", date(2026, 5, 2), 15.00, 5.00, 38.00, 0.1325, 9.20, 0),
    ("Lululemon Align Leggings", "Poshmark", date(2026, 5, 16), 10.00, 0, 48.00, 0.20, 0, 0),
    ("Nintendo Switch Games Lot (4)", "Facebook Marketplace", date(2026, 6, 1), 60.00, 0, 110.00, 0.10, 8.50, 0),
    ("Dansk Kobenstyle Casserole", "Etsy", date(2026, 6, 20), 12.00, 0, 85.00, 0.095, 14.00, 0.25),
    ("Funko Pop Exclusive", "Other", date(2026, 7, 7), 14.00, 0, 22.00, 0.10, 4.50, 0),
    ("Carhartt Detroit Jacket", "eBay", date(2026, 7, 25), 18.00, 0, 135.00, 0.1325, 15.00, 0),
    ("Dooney & Bourke Wallet", "Poshmark", date(2026, 8, 9), 9.00, 0, 42.00, 0.20, 0, 1.00),
    ("Vintage Polaroid SX-70", "eBay", date(2026, 8, 28), 45.00, 0, 210.00, 0.1325, 12.00, 0),
    ("Air Jordan 1 Mid – Size 9", "eBay", date(2026, 9, 12), 70.00, 0, 95.00, 0.1325, 14.00, 0),
    ("Anthropologie Maxi Dress", "Poshmark", date(2026, 9, 21), 7.00, 0, 36.00, 0.20, 0, 0),
    ("Fire-King Jadeite Mug", "Etsy", date(2026, 9, 26), 2.00, 0, 30.00, 0.095, 7.00, 0.25),
]
sample_status = ["Delivered / Entregado"] * 14 + ["Delivered / Entregado", RETURNED,
                                                  "Delivered / Entregado", "Shipped / Enviado",
                                                  "Sold / Vendido", "Pending / Pendiente"]
for i, (s, st) in enumerate(zip(samples, sample_status)):
    r = FIRST + i
    name, plat, d, cost, shin, price, fee, shout, other = s
    tr[f"B{r}"], tr[f"C{r}"], tr[f"D{r}"] = name, plat, d
    tr[f"E{r}"], tr[f"F{r}"], tr[f"G{r}"], tr[f"H{r}"] = cost, shin, price, fee
    tr[f"J{r}"], tr[f"K{r}"], tr[f"N{r}"] = shout, other, st
tr["B6"].comment = Comment("Rows 6–25 are EXAMPLES. Select them and press Delete (don't delete the rows) to start fresh.\n"
                           "Las filas 6–25 son EJEMPLOS. Selecciónalas y presiona Suprimir (no borres las filas) para empezar.",
                           "ProfitTrack")

dv_plat = DataValidation(type="list", formula1='"' + ",".join(PLATFORMS) + '"', allow_blank=True,
                         errorTitle="Platform / Plataforma",
                         error="Choose a platform from the list.\nElige una plataforma de la lista.",
                         promptTitle="Platform / Plataforma", prompt="Pick from the list / Elige de la lista")
dv_stat = DataValidation(type="list", formula1='"' + ",".join(STATUSES) + '"', allow_blank=True,
                         errorTitle="Status / Estado",
                         error="Choose a status from the list.\nElige un estado de la lista.")
dv_date = DataValidation(type="date", operator="greaterThan", formula1="36526", allow_blank=True,
                         errorTitle="Date / Fecha", error="Enter a valid date (e.g. 2026-03-15).\nEscribe una fecha válida.")
dv_pct = DataValidation(type="decimal", operator="between", formula1="0", formula2="1", allow_blank=True,
                        errorTitle="Fee % / Comisión %",
                        error="Enter a percent between 0% and 100% (e.g. 13.25%).\nEscribe un porcentaje entre 0% y 100%.")
dv_money = DataValidation(type="decimal", operator="greaterThanOrEqual", formula1="0", allow_blank=True,
                          errorTitle="Amount / Monto", error="Enter a number ≥ 0.\nEscribe un número ≥ 0.")
for dv in (dv_plat, dv_stat, dv_date, dv_pct, dv_money):
    tr.add_data_validation(dv)
dv_plat.add(f"C{FIRST}:C{LAST}")
dv_stat.add(f"N{FIRST}:N{LAST}")
dv_date.add(f"D{FIRST}:D{LAST}")
dv_pct.add(f"H{FIRST}:H{LAST}")
for col in "EFGJK":
    dv_money.add(f"{col}{FIRST}:{col}{LAST}")

tr.conditional_formatting.add(f"O{FIRST}:O{LAST}", FormulaRule(
    formula=[f'AND(ISNUMBER(M{FIRST}),M{FIRST}<0.15)'], fill=fill(RED_LIGHT), font=Font(name=FONT, bold=True, color=RED)))
tr.conditional_formatting.add(f"O{FIRST}:O{LAST}", FormulaRule(
    formula=[f'AND(ISNUMBER(M{FIRST}),M{FIRST}>=0.15)'], fill=fill(GREEN_LIGHT), font=Font(name=FONT, color=GREEN)))
tr.conditional_formatting.add(f"M{FIRST}:M{LAST}", FormulaRule(
    formula=[f'AND(ISNUMBER(M{FIRST}),M{FIRST}<0.15)'], font=Font(name=FONT, bold=True, color=RED)))
tr.conditional_formatting.add(f"B{FIRST}:O{LAST}", FormulaRule(
    formula=[f'$N{FIRST}="{RETURNED}"'], font=Font(name=FONT, italic=True, color="94A3B8")))

tr.freeze_panes = "C6"
tr.auto_filter.ref = f"B5:O{LAST}"
tr.print_title_rows = "5:5"

# =====================================================================
# DASHBOARD
# =====================================================================
db = wb.create_sheet("Dashboard", 1)
db.sheet_view.showGridLines = False
banner(db, "N", "Dashboard  /  Panel de Control",
       "Updates automatically from the Tracker. Returned sales are excluded.  •  "
       "Se actualiza automáticamente desde el Registro. Las ventas devueltas se excluyen.")
widths = {"B": 16, "C": 14, "D": 3, "E": 16, "F": 14, "G": 3, "H": 16, "I": 14, "J": 3,
          "K": 16, "L": 14, "M": 3, "N": 12}
for k, v in widths.items():
    db.column_dimensions[k].width = v

T = "Tracker!"
rng = lambda col: f"{T}${col}${FIRST}:${col}${LAST}"  # noqa: E731
VALID = f'{rng("B")},"<>",{rng("G")},"<>",{rng("N")},"<>{RETURNED}"'

kpis = [
    ("B", "C", "TOTAL REVENUE", "Ingresos Totales", f"=SUMIFS({rng('G')},{VALID})", CUR0),
    ("E", "F", "TOTAL PROFIT", "Ganancia Total", f"=SUMIFS({rng('L')},{VALID})", CUR0),
    ("H", "I", "AVG. PROFIT MARGIN", "Margen Promedio", "=IF(B8=0,0,E8/B8)", PCT),
    ("K", "L", "NUMBER OF SALES", "Número de Ventas", f"=COUNTIFS({VALID})", "#,##0"),
]
db.row_dimensions[6].height = 20
db.row_dimensions[7].height = 16
db.row_dimensions[8].height = 38
db.row_dimensions[9].height = 18
for c1, c2, en, es, f, fmt in kpis:
    paint(db, f"{c1}6:{c2}9", NAVY)
    db.merge_cells(f"{c1}6:{c2}6")
    db.merge_cells(f"{c1}7:{c2}7")
    db.merge_cells(f"{c1}8:{c2}8")
    db.merge_cells(f"{c1}9:{c2}9")
    db[f"{c1}6"] = en
    db[f"{c1}6"].font = font(9, True, TEAL)
    db[f"{c1}7"] = es
    db[f"{c1}7"].font = font(8, False, "C7D2FE", italic=True)
    db[f"{c1}8"] = f
    db[f"{c1}8"].font = font(22, True, WHITE)
    db[f"{c1}8"].number_format = fmt
    for rr in (6, 7, 8):
        db[f"{c1}{rr}"].alignment = Alignment(horizontal="center", vertical="center")
    paint(db, f"{c1}9:{c2}9", TEAL)
db["H9"] = "weighted: profit ÷ revenue / ponderado"
db["H9"].font = font(7, False, WHITE)
db["H9"].alignment = Alignment(horizontal="center", vertical="center")
db["B9"] = '=TEXT(SUMIFS(' + rng("I") + ',' + VALID + '),"$#,##0")&" in fees / en comisiones"'
db["B9"].font = font(7, False, WHITE)
db["B9"].alignment = Alignment(horizontal="center", vertical="center")
db["E9"] = '=IF(K8=0,"",TEXT(E8/K8,"$#,##0.00")&" avg / sale · prom / venta")'
db["E9"].font = font(7, False, WHITE)
db["E9"].alignment = Alignment(horizontal="center", vertical="center")
db["K9"] = f'=COUNTIFS({rng("O")},"⚠*")&" low-margin / margen bajo"'
db["K9"].font = font(7, False, WHITE)
db["K9"].alignment = Alignment(horizontal="center", vertical="center")


def section_title(ws, cell_rng, text):
    ws.merge_cells(cell_rng)
    c = ws[cell_rng.split(":")[0]]
    c.value = text
    c.font = font(12, True, NAVY)
    c.alignment = Alignment(vertical="center")
    c.border = Border(bottom=Side(style="medium", color=TEAL))


# ---- Profit by platform table (B12:F17) ----
section_title(db, "B11:F11", "Profit by Platform  /  Ganancia por Plataforma")
db.row_dimensions[12].height = 30
for col, text in zip("BCDEF", ["Platform\nPlataforma", "Sales\nVentas", "", "Revenue\nIngresos", "Profit\nGanancia"]):
    if text:
        header_cell(db[f"{col}12"], text)
db.merge_cells("C12:D12")
header_cell(db["G12"], "")
db["G12"].fill = fill(WHITE)
db["G12"].border = Border()
header_cell(db["H12"], "Margin\nMargen")
for i, p in enumerate(PLATFORMS):
    r = 13 + i
    crit = f'{VALID},{rng("C")},$B{r}'
    db[f"B{r}"] = p
    db.merge_cells(f"C{r}:D{r}")
    db[f"C{r}"] = f"=COUNTIFS({crit})"
    db[f"E{r}"] = f"=SUMIFS({rng('G')},{crit})"
    db[f"F{r}"] = f"=SUMIFS({rng('L')},{crit})"
    db[f"H{r}"] = f"=IF(E{r}=0,0,F{r}/E{r})"
    for col in "BCEFH":
        c = db[f"{col}{r}"]
        c.border = BORDER
        c.font = font(10, bold=(col == "B"))
        c.fill = fill(TEAL_LIGHT if i % 2 == 0 else WHITE)
    db[f"D{r}"].border = BORDER
    db[f"C{r}"].alignment = Alignment(horizontal="center")
    db[f"E{r}"].number_format = CUR
    db[f"F{r}"].number_format = CUR
    db[f"H{r}"].number_format = PCT
r = 18
db[f"B{r}"] = "TOTAL"
db.merge_cells(f"C{r}:D{r}")
db[f"C{r}"] = "=SUM(C13:C17)"
db[f"E{r}"] = "=SUM(E13:E17)"
db[f"F{r}"] = "=SUM(F13:F17)"
db[f"H{r}"] = f"=IF(E{r}=0,0,F{r}/E{r})"
for col in "BCEFH":
    c = db[f"{col}{r}"]
    c.font = font(10, True, WHITE)
    c.fill = fill(NAVY)
    c.border = BORDER
db[f"C{r}"].alignment = Alignment(horizontal="center")
db[f"E{r}"].number_format = CUR
db[f"F{r}"].number_format = CUR
db[f"H{r}"].number_format = PCT
db["B19"] = "Totals match the KPI cards above. / Los totales coinciden con los indicadores."
db["B19"].font = font(8, False, SLATE, italic=True)

# ---- Monthly trend table (B22:F34) ----
section_title(db, "B21:H21", "Monthly Profit Trend  /  Tendencia Mensual de Ganancia")
db["B22"] = "Year / Año:"
db["B22"].font = font(10, True, NAVY)
db["C22"] = f'=IF(COUNT({rng("D")})=0,YEAR(TODAY()),YEAR(MAX({rng("D")})))'
db["C22"].font = font(11, True, "1E3A8A")
db["C22"].fill = fill("FEF9C3")
db["C22"].border = BORDER
db["C22"].alignment = Alignment(horizontal="center")
db["C22"].comment = Comment("Shows the year of your latest sale. Type any year (e.g. 2027) to change it.\n"
                            "Muestra el año de tu última venta. Escribe otro año (ej. 2027) para cambiarlo.", "ProfitTrack")
db.merge_cells("E22:H22")
db["E22"] = "← type a year to change / escribe un año para cambiar"
db["E22"].font = font(8, False, SLATE, italic=True)
db.row_dimensions[23].height = 30
for col, text in zip("BCEFH", ["Month\nMes", "Sales\nVentas", "Revenue\nIngresos", "Profit\nGanancia", "Margin\nMargen"]):
    header_cell(db[f"{col}23"], text)
db.merge_cells("C23:D23")
months = ["Jan / Ene", "Feb / Feb", "Mar / Mar", "Apr / Abr", "May / May", "Jun / Jun",
          "Jul / Jul", "Aug / Ago", "Sep / Sep", "Oct / Oct", "Nov / Nov", "Dec / Dic"]
for m, label in enumerate(months, start=1):
    r = 23 + m
    crit = f'{VALID},{rng("D")},">="&DATE($C$22,{m},1),{rng("D")},"<"&DATE($C$22,{m + 1},1)'
    db[f"B{r}"] = label
    db.merge_cells(f"C{r}:D{r}")
    db[f"C{r}"] = f"=COUNTIFS({crit})"
    db[f"E{r}"] = f"=SUMIFS({rng('G')},{crit})"
    db[f"F{r}"] = f"=SUMIFS({rng('L')},{crit})"
    db[f"H{r}"] = f"=IF(E{r}=0,0,F{r}/E{r})"
    for col in "BCEFH":
        c = db[f"{col}{r}"]
        c.border = BORDER
        c.font = font(10, bold=(col == "B"))
        c.fill = fill(TEAL_LIGHT if m % 2 else WHITE)
    db[f"D{r}"].border = BORDER
    db[f"C{r}"].alignment = Alignment(horizontal="center")
    db[f"E{r}"].number_format = CUR
    db[f"F{r}"].number_format = CUR
    db[f"H{r}"].number_format = PCT
r = 36
db[f"B{r}"] = "YEAR / AÑO"
db.merge_cells(f"C{r}:D{r}")
db[f"C{r}"] = "=SUM(C24:C35)"
db[f"E{r}"] = "=SUM(E24:E35)"
db[f"F{r}"] = "=SUM(F24:F35)"
db[f"H{r}"] = f"=IF(E{r}=0,0,F{r}/E{r})"
for col in "BCEFH":
    c = db[f"{col}{r}"]
    c.font = font(10, True, WHITE)
    c.fill = fill(NAVY)
    c.border = BORDER
db[f"C{r}"].alignment = Alignment(horizontal="center")
db[f"E{r}"].number_format = CUR
db[f"F{r}"].number_format = CUR
db[f"H{r}"].number_format = PCT

# ---- Top 5 products (B39:L45) ----
section_title(db, "B39:L39", "Top 5 Most Profitable Sales  /  Top 5 Ventas Más Rentables")
db.row_dimensions[40].height = 30
top_cols = [("B", "#"), ("C", "Product\nProducto"), ("H", "Platform\nPlataforma"), ("I", "Sale Date\nFecha"),
            ("K", "Net Profit\nGanancia"), ("L", "Margin\nMargen")]
for col, text in top_cols:
    header_cell(db[f"{col}40"], text)
db.merge_cells("C40:G40")
db.merge_cells("I40:J40")
for n in range(1, 6):
    r = 40 + n
    key = f"LARGE(Tracker!$P${FIRST}:$P${LAST},{n})"
    row_idx = f"MATCH({key},Tracker!$P${FIRST}:$P${LAST},0)"
    db[f"B{r}"] = n
    db.merge_cells(f"C{r}:G{r}")
    db[f"C{r}"] = f'=IFERROR(INDEX(Tracker!$B${FIRST}:$B${LAST},{row_idx}),"—")'
    db[f"H{r}"] = f'=IFERROR(INDEX(Tracker!$C${FIRST}:$C${LAST},{row_idx}),"")'
    db.merge_cells(f"I{r}:J{r}")
    db[f"I{r}"] = f'=IFERROR(INDEX(Tracker!$D${FIRST}:$D${LAST},{row_idx}),"")'
    db[f"K{r}"] = f'=IFERROR(INDEX(Tracker!$L${FIRST}:$L${LAST},{row_idx}),"")'
    db[f"L{r}"] = f'=IFERROR(INDEX(Tracker!$M${FIRST}:$M${LAST},{row_idx}),"")'
    for col in "BCDEFGHIJKL":
        c = db[f"{col}{r}"]
        c.border = BORDER
        c.fill = fill(TEAL_LIGHT if n % 2 else WHITE)
        c.font = font(10)
    db[f"B{r}"].font = font(11, True, WHITE)
    db[f"B{r}"].fill = fill(TEAL_DARK)
    db[f"B{r}"].alignment = Alignment(horizontal="center")
    db[f"I{r}"].number_format = DATE_FMT
    db[f"I{r}"].alignment = Alignment(horizontal="center")
    db[f"K{r}"].number_format = CUR
    db[f"K{r}"].font = font(10, True, GREEN)
    db[f"L{r}"].number_format = PCT
    db.row_dimensions[r].height = 20
db["B46"] = "Ranked by net profit per sale (returns excluded). / Ordenado por ganancia neta por venta (sin devoluciones)."
db["B46"].font = font(8, False, SLATE, italic=True)

# ---- Charts ----
def small_title(text):
    cp = CharacterProperties(sz=1200, b=True, solidFill=NAVY, latin=DFont(typeface=FONT))
    para = Paragraph(pPr=ParagraphProperties(defRPr=cp), r=[RegularTextRun(rPr=cp, t=text)])
    return Title(tx=Text(rich=RichText(p=[para])), overlay=False)


bar = BarChart()
bar.type = "col"
bar.title = small_title("Profit by Platform / Ganancia por Plataforma")
bar.style = 10
bar.y_axis.title = "Profit / Ganancia ($)"
bar.y_axis.numFmt = "$#,##0"
bar.y_axis.majorGridlines = None
bar.add_data(Reference(db, min_col=6, min_row=12, max_row=17), titles_from_data=True)
bar.set_categories(Reference(db, min_col=2, min_row=13, max_row=17))
bar.legend = None
bar.series[0].graphicalProperties.solidFill = TEAL
bar.series[0].graphicalProperties.line.solidFill = TEAL_DARK
bar.dataLabels = DataLabelList()
bar.dataLabels.showVal = True
bar.dataLabels.showSerName = False
bar.dataLabels.showCatName = False
bar.dataLabels.showLegendKey = False
bar.dataLabels.numFmt = "$#,##0"
bar.height, bar.width = 5.9, 16.5
bar.x_axis.delete = False
bar.y_axis.delete = False
db.add_chart(bar, "J11")

line = LineChart()
line.title = small_title("Monthly Profit & Revenue / Ganancia e Ingresos Mensuales")
line.style = 12
line.y_axis.title = "Profit / Ganancia ($)"
line.y_axis.numFmt = "$#,##0"
line.add_data(Reference(db, min_col=6, min_row=23, max_row=35), titles_from_data=True)
line.add_data(Reference(db, min_col=5, min_row=23, max_row=35), titles_from_data=True)
line.set_categories(Reference(db, min_col=2, min_row=24, max_row=35))
s_profit, s_rev = line.series
s_profit.graphicalProperties.line.solidFill = TEAL
s_profit.graphicalProperties.line.width = 32000
s_profit.marker.symbol = "circle"
s_profit.marker.size = 7
s_profit.marker.graphicalProperties.solidFill = TEAL
s_profit.marker.graphicalProperties.line.solidFill = TEAL_DARK
s_rev.graphicalProperties.line.solidFill = NAVY_2
s_rev.graphicalProperties.line.dashStyle = "dash"
s_rev.graphicalProperties.line.width = 19000
s_rev.smooth = False
s_profit.smooth = False
line.legend.position = "b"
line.height, line.width = 8.0, 16.5
line.x_axis.delete = False
line.y_axis.delete = False
db.add_chart(line, "J22")

# =====================================================================
# SOURCING LIST (BONUS)
# =====================================================================
sc = wb.create_sheet("Sourcing List")
sc.sheet_view.showGridLines = False
banner(sc, "Q", "Sourcing List (Bonus)  /  Lista de Compras (Bono)",
       "Check the expected profit BEFORE you buy.  •  Calcula la ganancia esperada ANTES de comprar.")

section_title(sc, "B6:F6", "Your Buying Rules  /  Tus Reglas de Compra")
rules = [
    (7, "Minimum margin / Margen mínimo", 0.30, "0%"),
    (8, "Minimum profit per item / Ganancia mínima por artículo", 10, CUR),
]
for r, label, val, fmt in rules:
    sc.merge_cells(f"B{r}:E{r}")
    sc[f"B{r}"] = label
    sc[f"B{r}"].font = font(10, True, NAVY)
    sc[f"B{r}"].border = BORDER
    sc[f"F{r}"] = val
    sc[f"F{r}"].number_format = fmt
    sc[f"F{r}"].font = font(11, True, "1E3A8A")
    sc[f"F{r}"].fill = fill("FEF9C3")
    sc[f"F{r}"].border = BORDER
    sc[f"F{r}"].alignment = Alignment(horizontal="center")
sc["F7"].comment = Comment("Your target — change it anytime. / Tu objetivo — cámbialo cuando quieras.", "ProfitTrack")
sc.merge_cells("H7:Q8")
sc["H7"] = ("An item gets ✔ BUY only if it meets BOTH rules. 'Max Buy Price' = the most you can pay and still hit your minimum margin.\n"
            "Un artículo obtiene ✔ COMPRAR solo si cumple AMBAS reglas. 'Precio Máx. de Compra' = lo máximo que puedes pagar y aún lograr tu margen mínimo.")
sc["H7"].font = font(9, False, SLATE, italic=True)
sc["H7"].alignment = LEFT

S_FIRST, S_LAST = 11, 110
s_headers = [
    ("B", "Item\nArtículo", 28, "in"),
    ("C", "Where Found\nDónde lo Encontré", 17, "in"),
    ("D", "Target Platform\nPlataforma", 19, "in"),
    ("E", "Asking Price\nPrecio de Compra", 13, "in"),
    ("F", "Shipping In\nEnvío (Entrada)", 12, "in"),
    ("G", "Est. Sale Price\nPrecio Est. Venta", 13, "in"),
    ("H", "Fee %\n% Comisión", 10, "in"),
    ("I", "Est. Fee $\nComisión Est. $", 12, "calc"),
    ("J", "Est. Ship Out\nEnvío Est. Salida", 12, "in"),
    ("K", "Other Costs\nOtros Costos", 11, "in"),
    ("L", "Est. Profit\nGanancia Est.", 12, "calc"),
    ("M", "Est. Margin\nMargen Est.", 11, "calc"),
    ("N", "ROI %\nRetorno %", 10, "calc"),
    ("O", "Max Buy Price\nPrecio Máx. Compra", 14, "calc"),
    ("P", "Decision\nDecisión", 22, "calc"),
    ("Q", "Notes\nNotas", 22, "in"),
]
sc.row_dimensions[10].height = 36
for col, text, width, _ in s_headers:
    header_cell(sc[f"{col}10"], text)
    sc.column_dimensions[col].width = width
sc["N10"].comment = Comment("Return on investment: Est. Profit ÷ (Asking Price + Shipping In)\n"
                            "Retorno de inversión: Ganancia Est. ÷ (Precio de Compra + Envío Entrada)", "ProfitTrack")
sc["O10"].comment = Comment("Highest purchase price that still meets your minimum margin AND minimum profit.\n"
                            "Precio de compra más alto que aún cumple tu margen mínimo Y ganancia mínima.", "ProfitTrack")
for r in range(S_FIRST, S_LAST + 1):
    sc[f"I{r}"] = f'=IF(G{r}="","",G{r}*H{r})'
    sc[f"L{r}"] = f'=IF(OR(B{r}="",G{r}=""),"",G{r}-E{r}-F{r}-I{r}-J{r}-K{r})'
    sc[f"M{r}"] = f'=IF(L{r}="","",IF(G{r}=0,0,L{r}/G{r}))'
    sc[f"N{r}"] = f'=IF(L{r}="","",IF(E{r}+F{r}=0,"∞",L{r}/(E{r}+F{r})))'
    sc[f"O{r}"] = (f'=IF(L{r}="","",MAX(0,MIN(G{r}*(1-H{r}-$F$7),G{r}*(1-H{r})-$F$8)-J{r}-K{r}-F{r}))')
    sc[f"P{r}"] = (f'=IF(L{r}="","",IF(AND(M{r}>=$F$7,L{r}>=$F$8),"✔ BUY / COMPRAR","✖ PASS / NO COMPRAR"))')
    for col, _, _, kind in s_headers:
        c = sc[f"{col}{r}"]
        c.fill = fill(INPUT_FILL if kind == "in" else CALC_FILL)
        c.border = BORDER
        c.font = font(10, color="1E3A8A" if kind == "in" else "000000")
        c.alignment = Alignment(vertical="center", horizontal="left" if col in "BCDPQ" else "right")
    for col in "EFGIJKLO":
        sc[f"{col}{r}"].number_format = CUR
    sc[f"H{r}"].number_format = "0.00%"
    sc[f"M{r}"].number_format = PCT
    sc[f"N{r}"].number_format = '0%;[Red]-0%;"-"'
    sc[f"P{r}"].alignment = Alignment(horizontal="center", vertical="center")

s_samples = [
    ("Vintage Pendleton Wool Shirt", "Goodwill", "eBay", 8.00, 0, 55.00, 0.1325, 8.50, 0, "Check tags / Revisar etiquetas"),
    ("Le Creuset Dutch Oven 5.5qt", "Estate sale", "Facebook Marketplace", 60.00, 0, 180.00, 0, 0, 0, "Local pickup / Recoger local"),
    ("Target Brand Graphic Tee", "Garage sale", "Poshmark", 3.00, 0, 12.00, 0.20, 0, 0, ""),
    ("Vintage Pyrex Casserole", "Thrift store", "Etsy", 12.00, 0, 45.00, 0.095, 12.00, 0.25, ""),
    ("Bose QC45 Headphones", "FB Marketplace", "eBay", 95.00, 0, 140.00, 0.1325, 10.00, 0, "Test first / Probar primero"),
]
for i, s in enumerate(s_samples):
    r = S_FIRST + i
    for col, v in zip("BCDEFGHJKQ", s):
        sc[f"{col}{r}"] = v if v != "" else None

sc_dv_plat = DataValidation(type="list", formula1='"' + ",".join(PLATFORMS) + '"', allow_blank=True)
sc_dv_pct = DataValidation(type="decimal", operator="between", formula1="0", formula2="1", allow_blank=True,
                           error="Enter a percent between 0% and 100%.\nEscribe un porcentaje entre 0% y 100%.")
sc.add_data_validation(sc_dv_plat)
sc.add_data_validation(sc_dv_pct)
sc_dv_plat.add(f"D{S_FIRST}:D{S_LAST}")
sc_dv_pct.add(f"H{S_FIRST}:H{S_LAST}")
sc_dv_pct.add("F7")
sc.conditional_formatting.add(f"P{S_FIRST}:P{S_LAST}", FormulaRule(
    formula=[f'LEFT(P{S_FIRST},1)="✔"'], fill=fill(GREEN_LIGHT), font=Font(name=FONT, bold=True, color=GREEN)))
sc.conditional_formatting.add(f"P{S_FIRST}:P{S_LAST}", FormulaRule(
    formula=[f'LEFT(P{S_FIRST},1)="✖"'], fill=fill(RED_LIGHT), font=Font(name=FONT, bold=True, color=RED)))
sc.conditional_formatting.add(f"M{S_FIRST}:M{S_LAST}", FormulaRule(
    formula=[f'AND(ISNUMBER(M{S_FIRST}),M{S_FIRST}<$F$7)'], font=Font(name=FONT, bold=True, color=RED)))
sc.freeze_panes = "C11"

# =====================================================================
# QUICK START GUIDE
# =====================================================================
qs = wb.create_sheet("Quick Start Guide")
qs.sheet_view.showGridLines = False
banner(qs, "E", "Quick Start Guide  /  Guía Rápida",
       "Up and running in 5 minutes.  •  Listo en 5 minutos.")
qs.column_dimensions["B"].width = 6
qs.column_dimensions["C"].width = 58
qs.column_dimensions["D"].width = 58
qs.column_dimensions["E"].width = 2

qs.row_dimensions[6].height = 22
header_cell(qs["B6"], "#")
header_cell(qs["C6"], "ENGLISH")
header_cell(qs["D6"], "ESPAÑOL")

steps = [
    ("Clear the example data. Go to Tracker, select cells B6:N25 and press Delete. Do the same on Sourcing List (B11:K15 and Q11:Q15). Never delete whole rows or the grey columns.",
     "Borra los datos de ejemplo. Ve a Tracker (Registro), selecciona B6:N25 y presiona Suprimir. Haz lo mismo en Sourcing List (B11:K15 y Q11:Q15). Nunca borres filas completas ni las columnas grises."),
    ("Log each sale on the Tracker — one row per item. Type only in the light-teal columns: Product Name, Platform (dropdown), Sale Date, Purchase Cost, Shipping In, Sale Price, Platform Fee %, Shipping Out, Other Costs and Status (dropdown).",
     "Registra cada venta en Tracker — una fila por artículo. Escribe solo en las columnas verde claro: Nombre, Plataforma (lista), Fecha, Costo de Compra, Envío (Entrada), Precio de Venta, % Comisión, Envío (Salida), Otros Costos y Estado (lista)."),
    ("Enter the platform fee as a percent (e.g. 13.25%). See the fee reference table below. If you enter a flat fee instead, put it in 'Other Costs'.",
     "Escribe la comisión como porcentaje (ej. 13.25%). Consulta la tabla de comisiones abajo. Si pagas una tarifa fija, ponla en 'Otros Costos'."),
    ("The grey columns calculate automatically: Platform Fee $ = Sale Price × Fee %;  Net Profit = Sale Price − Purchase Cost − Shipping In − Platform Fee $ − Shipping Out − Other Costs;  Margin % = Net Profit ÷ Sale Price.",
     "Las columnas grises se calculan solas: Comisión $ = Precio × % Comisión;  Ganancia Neta = Precio − Costo − Envío (Entrada) − Comisión $ − Envío (Salida) − Otros Costos;  Margen % = Ganancia Neta ÷ Precio."),
    ("Watch the Margin Alert column. Any sale under 15% margin is flagged red '⚠ LOW MARGIN' so you can spot items that aren't worth your time.",
     "Revisa la columna Alerta de Margen. Toda venta con margen menor al 15% se marca en rojo '⚠ MARGEN BAJO' para detectar artículos que no valen la pena."),
    ("If an item is returned, set Status to 'Returned / Devuelto'. It stays in your log (greyed out) but is excluded from every Dashboard number.",
     "Si un artículo se devuelve, cambia el Estado a 'Returned / Devuelto'. Se queda en tu registro (en gris) pero se excluye de todos los números del Panel."),
    ("Open the Dashboard to see your KPIs, profit by platform, the monthly trend chart and your Top 5 sales. Everything updates instantly. Change the yellow Year cell to view another year.",
     "Abre el Dashboard (Panel) para ver tus indicadores, ganancia por plataforma, la gráfica mensual y tus Top 5 ventas. Todo se actualiza al instante. Cambia la celda amarilla del Año para ver otro año."),
    ("BONUS — before buying inventory, use the Sourcing List. Set your minimum margin and minimum profit (yellow cells), enter the asking price and your estimated sale price, and get an instant ✔ BUY / ✖ PASS plus the Max Buy Price to negotiate with.",
     "BONO — antes de comprar mercancía, usa Sourcing List (Lista de Compras). Define tu margen y ganancia mínimos (celdas amarillas), escribe el precio de compra y el precio estimado de venta, y obtén al instante ✔ COMPRAR / ✖ NO COMPRAR y el Precio Máximo de Compra para negociar."),
    ("Google Sheets: upload the file to Google Drive → Open with Google Sheets → File → Save as Google Sheets. All formulas, dropdowns and charts keep working.",
     "Google Sheets: sube el archivo a Google Drive → Abrir con Google Sheets → Archivo → Guardar como Hojas de cálculo de Google. Todas las fórmulas, listas y gráficas siguen funcionando."),
    ("Tip: save a blank copy of this file before you start, and back up your working file monthly.",
     "Consejo: guarda una copia en blanco de este archivo antes de empezar y respalda tu archivo cada mes."),
]
r = 7
for i, (en, es) in enumerate(steps, start=1):
    qs[f"B{r}"] = i
    qs[f"B{r}"].font = font(14, True, WHITE)
    qs[f"B{r}"].fill = fill(TEAL_DARK)
    qs[f"B{r}"].alignment = CENTER
    qs[f"C{r}"] = en
    qs[f"D{r}"] = es
    for col in "CD":
        qs[f"{col}{r}"].font = font(10)
        qs[f"{col}{r}"].alignment = Alignment(wrap_text=True, vertical="top")
        qs[f"{col}{r}"].fill = fill(TEAL_LIGHT if i % 2 else WHITE)
    for col in "BCD":
        qs[f"{col}{r}"].border = BORDER
    longest = max(len(en), len(es))
    qs.row_dimensions[r].height = max(30, 15 * (longest // 62 + 1) + 6)
    r += 1

r += 1
qs.merge_cells(f"B{r}:D{r}")
qs[f"B{r}"] = "Color Legend  /  Leyenda de Colores"
qs[f"B{r}"].font = font(12, True, NAVY)
qs[f"B{r}"].border = Border(bottom=Side(style="medium", color=TEAL))
r += 1
legend = [
    (INPUT_FILL, "Light teal = type your data here", "Verde claro = escribe tus datos aquí"),
    (CALC_FILL, "Grey = automatic formula – don't type here", "Gris = fórmula automática – no escribas aquí"),
    ("FEF9C3", "Yellow = settings you can change (Year, buying rules)", "Amarillo = ajustes que puedes cambiar (Año, reglas de compra)"),
]
for color, en, es in legend:
    qs[f"B{r}"].fill = fill(color)
    qs[f"B{r}"].border = BORDER
    qs[f"C{r}"] = en
    qs[f"D{r}"] = es
    for col in "CD":
        qs[f"{col}{r}"].font = font(10)
        qs[f"{col}{r}"].border = BORDER
    r += 1

r += 1
qs.merge_cells(f"B{r}:D{r}")
qs[f"B{r}"] = "Platform Fee Reference (approximate)  /  Referencia de Comisiones (aproximada)"
qs[f"B{r}"].font = font(12, True, NAVY)
qs[f"B{r}"].border = Border(bottom=Side(style="medium", color=TEAL))
r += 1
header_cell(qs[f"B{r}"], "")
header_cell(qs[f"C{r}"], "Platform – typical fee  /  Plataforma – comisión típica")
header_cell(qs[f"D{r}"], "Notes  /  Notas")
r += 1
fees = [
    ("eBay – about 13.25% (most categories)", "Plus ~$0.30–0.40 per order → add to Other Costs. / Más ~$0.30–0.40 por pedido → agrégalo a Otros Costos."),
    ("Poshmark – 20% (sales $15+)", "Sales under $15: flat $2.95 → put 0% and $2.95 in Other Costs. / Ventas menores a $15: $2.95 fijo → 0% y $2.95 en Otros Costos."),
    ("Etsy – about 9.5% (6.5% transaction + 3% payment)", "Plus $0.20 listing + $0.25 processing → Other Costs. / Más $0.20 de publicación + $0.25 de procesamiento → Otros Costos."),
    ("Facebook Marketplace – 0% local / ~10% shipped", "Local cash pickup has no fee. / La venta local en efectivo no tiene comisión."),
    ("Other (Mercari, Depop, Vinted, in-person…)", "Enter the rate you actually paid. / Escribe la comisión que realmente pagaste."),
]
for en, es in fees:
    qs[f"C{r}"] = en
    qs[f"D{r}"] = es
    for col in "BCD":
        qs[f"{col}{r}"].border = BORDER
        qs[f"{col}{r}"].font = font(10)
        qs[f"{col}{r}"].alignment = Alignment(wrap_text=True, vertical="top")
    qs.row_dimensions[r].height = 30
    r += 1
qs.merge_cells(f"B{r}:D{r}")
qs[f"B{r}"] = ("Fees change often – always check each platform's current fee page. Rates above are for reference only (US, 2026). / "
               "Las comisiones cambian con frecuencia – revisa siempre la página oficial de cada plataforma. Tarifas solo de referencia (EE. UU., 2026).")
qs[f"B{r}"].font = font(8, False, SLATE, italic=True)
qs[f"B{r}"].alignment = Alignment(wrap_text=True, vertical="top")
qs.row_dimensions[r].height = 26

r += 2
qs.merge_cells(f"B{r}:D{r}")
qs[f"B{r}"] = "FAQ  /  Preguntas Frecuentes"
qs[f"B{r}"].font = font(12, True, NAVY)
qs[f"B{r}"].border = Border(bottom=Side(style="medium", color=TEAL))
r += 1
faq = [
    ("Q: How many sales can I log?  A: 500 rows are ready. Need more? Copy the last row down – formulas copy with it (also extend the Tracker ranges on the Dashboard).",
     "P: ¿Cuántas ventas puedo registrar?  R: Hay 500 filas listas. ¿Necesitas más? Copia la última fila hacia abajo – las fórmulas se copian (también amplía los rangos del Tracker en el Panel)."),
    ("Q: Why is Average Margin 'weighted'?  A: It's Total Profit ÷ Total Revenue, so a $500 sale counts more than a $5 sale – the most accurate picture of your business.",
     "P: ¿Por qué el Margen Promedio es 'ponderado'?  R: Es Ganancia Total ÷ Ingresos Totales, así una venta de $500 pesa más que una de $5 – la imagen más precisa de tu negocio."),
    ("Q: A sale has no profit showing.  A: Profit appears once Product Name and Sale Price are filled in.",
     "P: Una venta no muestra ganancia.  R: La ganancia aparece cuando llenas el Nombre del Producto y el Precio de Venta."),
]
for en, es in faq:
    qs[f"C{r}"] = en
    qs[f"D{r}"] = es
    for col in "CD":
        qs[f"{col}{r}"].font = font(10)
        qs[f"{col}{r}"].alignment = Alignment(wrap_text=True, vertical="top")
        qs[f"{col}{r}"].border = BORDER
    qs.row_dimensions[r].height = 48
    r += 1

# ---------- Workbook-wide finishing ----------
for ws in wb.worksheets:
    ws.sheet_properties.tabColor = NAVY if ws.title in ("Cover", "Quick Start Guide") else TEAL
    ws.page_setup.orientation = "landscape"
    ws.page_setup.fitToWidth = 1
    ws.page_setup.fitToHeight = 0
    ws.sheet_properties.pageSetUpPr.fitToPage = True
wb.active = 0
wb.properties.title = "ProfitTrack — Reseller Profit Tracker & Dashboard"
wb.properties.creator = "ProfitTrack"
wb.save(OUT)
print("saved", OUT)
