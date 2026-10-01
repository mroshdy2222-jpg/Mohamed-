"""Render real screenshots of workbook ranges (LibreOffice -> PDF -> PNG, auto-cropped)."""
import os
import subprocess
import sys
import tempfile

from openpyxl import load_workbook
from openpyxl.worksheet.page import PageMargins
from PIL import Image, ImageChops

OUT_DIR = "build/shots"

SHOTS = {
    "product/ProfitTrack_Reseller_Profit_Tracker.xlsx": [
        ("pt_cover", "Cover", "A1:L38"),
        ("pt_dash", "Dashboard", "A1:T46"),
        ("pt_dash_top", "Dashboard", "A5:T36"),
        ("pt_kpis", "Dashboard", "B6:L9"),
        ("pt_top5", "Dashboard", "B39:L46"),
        ("pt_tracker", "Tracker", "A1:O25"),
        ("pt_tracker_calc", "Tracker", "G5:O25"),
        ("pt_phone", "Tracker", "B5:C30"),
        ("pt_sourcing", "Sourcing List", "A1:Q15"),
        ("pt_sourcing_calc", "Sourcing List", "B10:P15"),
        ("pt_sourcing_in", "Sourcing List", "B10:G15"),
        ("pt_sourcing_out", "Sourcing List", "L10:P15"),
        ("pt_guide", "Quick Start Guide", "A1:D11"),
        ("pt_guide_strip", "Quick Start Guide", "A1:D7"),
        ("pin_pt_tracker", "Tracker", "L5:O18"),
        ("pin_pt_platform", "Dashboard", "B12:F18"),
    ],
    "product/ProfitTrack_Expense_Mileage_Tracker.xlsx": [
        ("ex_cover", "Cover", "A1:L40"),
        ("ex_dash", "Dashboard", "A1:R48"),
        ("ex_kpis", "Dashboard", "B6:J11"),
        ("ex_expenses", "Expenses", "A1:L23"),
        ("ex_mileage", "Mileage", "A1:M21"),
        ("ex_mileage_calc", "Mileage", "B5:M21"),
        ("ex_phone", "Expenses", "B5:D23"),
        ("ex_settings", "Settings", "A1:F21"),
        ("ex_guide", "Quick Start Guide", "A1:D11"),
        ("ex_guide_strip", "Quick Start Guide", "A1:D7"),
        ("pin_ex_mileage", "Mileage", "J5:M18"),
        ("pin_ex_cats", "Dashboard", "B14:E27"),
    ],
    "product/ProfitTrack_Handmade_Pricing_Calculator.xlsx": [
        ("hp_cover", "Cover", "A1:L40"),
        ("hp_calc", "Calculator", "A1:J36"),
        ("hp_calc_results", "Calculator", "I6:J28"),
        ("hp_calc_inputs", "Calculator", "B6:G36"),
        ("hp_list", "Product List", "A1:R19"),
        ("hp_list_status", "Product List", "I11:R19"),
        ("hp_list_in", "Product List", "B11:G19"),
        ("hp_list_out", "Product List", "K11:R19"),
        ("hp_materials", "Materials", "A1:H17"),
        ("hp_phone", "Calculator", "I6:J23"),
        ("hp_guide", "Quick Start Guide", "A1:D11"),
        ("hp_guide_strip", "Quick Start Guide", "A1:D7"),
        ("pin_hp", "Calculator", "I6:J15"),
        ("pin_hp_status", "Product List", "O11:R19"),
    ],
    "product/ProfitTrack_Bilingual_Budget_Planner.xlsx": [
        ("bp_cover", "Cover", "A1:L42"),
        ("bp_dash", "Dashboard", "A1:O70"),
        ("bp_dash_top", "Dashboard", "A5:O52"),
        ("bp_kpis", "Dashboard", "B6:G16"),
        ("bp_bva", "Dashboard", "B18:G40"),
        ("bp_5030", "Dashboard", "I18:O42"),
        ("bp_year", "Dashboard", "B55:R70"),
        ("bp_tx", "Transactions", "A1:I30"),
        ("bp_budget", "Budget", "A1:F30"),
        ("bp_goals", "Savings Goals", "A1:J9"),
        ("bp_debts", "Debts", "A1:L9"),
        ("bp_goals_in", "Savings Goals", "B5:E9"),
        ("bp_goals_out", "Savings Goals", "F5:J9"),
        ("bp_debts_in", "Debts", "B5:F9"),
        ("bp_debts_out", "Debts", "G5:L9"),
        ("bp_phone", "Transactions", "B5:D30"),
        ("bp_guide", "Quick Start Guide", "A1:D11"),
        ("bp_guide_strip", "Quick Start Guide", "A1:D7"),
    ],
    "product/FREE_ProfitTrack_Flip_Calculator.xlsx": [
        ("fr_calc", "Flip Calculator", "A1:M12"),
        ("fr_table", "Flip Calculator", "B5:M10"),
        ("fr_items", "Flip Calculator", "B5:E10"),
        ("fr_result", "Flip Calculator", "J5:M10"),
        ("fr_phone", "Flip Calculator", "B5:D14"),
    ],
    "product/ProfitTrack_Inventory_Tracker.xlsx": [
        ("iv_cover", "Cover", "A1:L37"),
        ("iv_dash", "Dashboard", "A1:R56"),
        ("iv_dash_top", "Dashboard", "A5:R43"),
        ("iv_kpis", "Dashboard", "B6:J14"),
        ("iv_oldest", "Dashboard", "B45:M56"),
        ("iv_inventory", "Inventory", "A1:Q27"),
        ("iv_alerts", "Inventory", "I5:Q27"),
        ("iv_phone", "Inventory", "C5:D27"),
        ("iv_guide", "Quick Start Guide", "A1:D11"),
        ("iv_guide_strip", "Quick Start Guide", "A1:D7"),
        ("pin_iv_alerts", "Inventory", "N5:Q18"),
        ("pin_iv_oldest", "Dashboard", "B46:F56"),
    ],
}


def trim(img, pad=0):
    bg = Image.new(img.mode, img.size, (255, 255, 255))
    box = ImageChops.difference(img, bg).getbbox()
    if box:
        img = img.crop((max(0, box[0] - pad), max(0, box[1] - pad),
                        min(img.width, box[2] + pad), min(img.height, box[3] + pad)))
    return img


def render(xlsx, name, sheet, rng, tmp, dpi):
    wb = load_workbook(xlsx)
    target = wb[sheet]
    wb.active = wb.sheetnames.index(sheet)
    for ws in wb.worksheets:
        if ws.title != sheet:
            ws.sheet_state = "hidden"
    target.print_area = rng
    target.print_title_rows = None
    target.page_margins = PageMargins(left=0, right=0, top=0, bottom=0, header=0, footer=0)
    target.page_setup.fitToWidth = 1
    target.page_setup.fitToHeight = 1
    target.sheet_properties.pageSetUpPr.fitToPage = True
    target.oddHeader.center.text = ""
    target.oddFooter.center.text = ""
    path = os.path.join(tmp, f"{name}.xlsx")
    wb.save(path)
    subprocess.run(["soffice", "--headless", "--convert-to", "pdf", "--outdir", tmp, path],
                   check=True, capture_output=True, timeout=240)
    subprocess.run(["pdftoppm", "-r", str(dpi), "-png", "-singlefile", "-f", "1", "-l", "1",
                    os.path.join(tmp, f"{name}.pdf"), os.path.join(tmp, name)], check=True)
    img = Image.open(os.path.join(tmp, f"{name}.png")).convert("RGB")
    trim(img).save(os.path.join(OUT_DIR, f"{name}.png"))
    print("shot", name, Image.open(os.path.join(OUT_DIR, f"{name}.png")).size)


if __name__ == "__main__":
    only = set(sys.argv[1:])
    os.makedirs(OUT_DIR, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        for xlsx, shots in SHOTS.items():
            for name, sheet, rng in shots:
                if not only or name in only:
                    render(xlsx, name, sheet, rng, tmp, dpi=300)
