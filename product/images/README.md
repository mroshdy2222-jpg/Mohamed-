# Etsy listing images / صور صفحات البيع

All images are 2000 × 1500 px (4:3) JPG, the size Etsy recommends. Upload them in this order; the first image is the search thumbnail.
كل الصور 2000×1500 بكسل. ارفعها بالترتيب ده، وأول صورة هي اللي بتظهر في نتايج البحث.

| Listing | Images (in order) |
|---|---|
| ProfitTrack Profit Tracker | `profittrack/01-hero` → `02-inside` → `03-dashboard` → `04-tracker` → `05-sourcing` → `06-devices` |
| ProfitTrack Expenses & Mileage | `expenses/01-hero` → `02-dashboard` → `03-mileage` → `04-expenses` → `05-devices` |
| ProfitTrack Inventory | `inventory/01-hero` → `02-dashboard` → `03-alerts` → `04-oldest` → `05-devices` |
| Reseller Bundle | `bundle/01-hero` → `02-inside` → `03-price` → `04-devices` |

Every screenshot inside the images is a real render of the Excel file in this folder (`build/shots.py`). Rebuild them with:

```
python3 build/shots.py && python3 build/listing_images.py
```

If you change the prices, update `bundle/03-price` (in `build/listing_images.py`) and rebuild.
