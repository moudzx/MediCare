import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

BASE_URL = "https://moph.gov.lb/en/Drugs/index/0/10256/page:{}/sort:Drug.b_g/direction:asc"

all_rows = []

# Change this if pages increase
TOTAL_PAGES = 194

headers = {
    "User-Agent": "Mozilla/5.0"
}

for page in range(1, TOTAL_PAGES + 1):
    url = BASE_URL.format(page)

    print(f"Scraping page {page}...")

    try:
        response = requests.get(url, headers=headers, timeout=20)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, "html.parser")

        table = soup.find("table")

        if not table:
            print(f"No table found on page {page}")
            continue

        rows = table.find_all("tr")

        for row in rows[1:]:
            cols = row.find_all(["td", "th"])

            data = [col.get_text(strip=True) for col in cols]
            if len(data) > 0:
                all_rows.append(data)

        time.sleep(1)

    except Exception as e:
        print(f"Error on page {page}: {e}")

# Get maximum column count
max_cols = max(len(r) for r in all_rows)

# Normalize rows
normalized_rows = [
    row + [""] * (max_cols - len(row))
    for row in all_rows
]

# Column names (adjust if needed)
columns = [f"Column_{i+1}" for i in range(max_cols)]

df = pd.DataFrame(normalized_rows, columns=columns)

# Save CSV
df.to_csv("lebanon_drugs_database.csv", index=False, encoding="utf-8-sig")

print("Done!")
print(f"Saved {len(df)} rows to lebanon_drugs_database.csv")

