#!/usr/bin/env python
"""Generate deterministic synthetic energy-subscription source data."""

import csv
import random
from calendar import monthrange
from datetime import date, timedelta
from pathlib import Path

SEED = 2026
CUSTOMER_COUNT = 180
REPORTING_START = date(2024, 1, 1)
REPORTING_END = date(2025, 12, 31)
CONTRACT_START_MIN = date(2023, 1, 1)
CONTRACT_START_MAX = date(2025, 6, 30)
OUTPUT_DIR = Path(__file__).resolve().parents[1] / "data" / "generated"

TARIFFS = [
    {
        "tariff_id": "TAR-001",
        "tariff_name": "Standard",
        "base_fee_eur_monthly": "12.90",
        "unit_rate_eur_per_kwh": "0.3200",
        "region": "DE",
    },
    {
        "tariff_id": "TAR-002",
        "tariff_name": "Green",
        "base_fee_eur_monthly": "14.50",
        "unit_rate_eur_per_kwh": "0.3350",
        "region": "DE",
    },
    {
        "tariff_id": "TAR-003",
        "tariff_name": "Saver",
        "base_fee_eur_monthly": "9.90",
        "unit_rate_eur_per_kwh": "0.3490",
        "region": "DE",
    },
    {
        "tariff_id": "TAR-004",
        "tariff_name": "Flex",
        "base_fee_eur_monthly": "16.00",
        "unit_rate_eur_per_kwh": "0.3050",
        "region": "DE",
    },
]

SEGMENT_KWH_RANGES = {
    "residential": (100, 550),
    "small_business": (450, 2200),
}


def month_starts(start: date, end: date) -> list[date]:
    """Return the first day of each month intersecting the inclusive interval."""
    cursor = date(start.year, start.month, 1)
    last = date(end.year, end.month, 1)
    months = []
    while cursor <= last:
        months.append(cursor)
        if cursor.month == 12:
            cursor = date(cursor.year + 1, 1, 1)
        else:
            cursor = date(cursor.year, cursor.month + 1, 1)
    return months


def write_csv(path: Path, fieldnames: list[str], rows: list[dict[str, object]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def generate() -> dict[str, int]:
    rng = random.Random(SEED)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    tariffs = list(TARIFFS)
    customer_rows = []
    contract_rows = []
    consumption_rows = []
    contract_ids = set()

    start_span = (CONTRACT_START_MAX - CONTRACT_START_MIN).days
    for customer_number in range(1, CUSTOMER_COUNT + 1):
        customer_id = f"CUS-{customer_number:04d}"
        contract_id = f"CON-{customer_number:04d}"
        segment = rng.choices(["residential", "small_business"], weights=[0.78, 0.22], k=1)[0]
        start_date = CONTRACT_START_MIN + timedelta(days=rng.randint(0, start_span))
        signup_date = start_date - timedelta(days=rng.randint(7, 120))
        status = rng.choices(["active", "ended", "cancelled"], weights=[0.62, 0.24, 0.14], k=1)[0]

        if status == "active":
            end_date = None
        else:
            max_duration = (REPORTING_END - start_date).days
            end_date = start_date + timedelta(days=rng.randint(90, max_duration))

        tariff = rng.choice(tariffs)
        customer_rows.append(
            {
                "customer_id": customer_id,
                "signup_date": signup_date.isoformat(),
                "customer_segment": segment,
                "region": "DE",
            }
        )
        contract_rows.append(
            {
                "contract_id": contract_id,
                "customer_id": customer_id,
                "tariff_id": tariff["tariff_id"],
                "contract_start_date": start_date.isoformat(),
                "contract_end_date": end_date.isoformat() if end_date else "",
                "contract_status": status,
            }
        )
        contract_ids.add(contract_id)

        service_start = max(start_date, REPORTING_START)
        service_end = min(end_date or REPORTING_END, REPORTING_END)
        for month in month_starts(service_start, service_end):
            if rng.random() < 0.025:
                continue

            days_in_month = monthrange(month.year, month.month)[1]
            month_end = date(month.year, month.month, days_in_month)
            active_days = (min(service_end, month_end) - max(service_start, month)).days + 1
            missing_draw = rng.random()
            if missing_draw < 0.02:
                consumption_value = ""
            elif missing_draw < 0.035:
                consumption_value = "0.00"
            else:
                lower, upper = SEGMENT_KWH_RANGES[segment]
                monthly_kwh = rng.uniform(lower, upper) * active_days / days_in_month
                consumption_value = f"{monthly_kwh:.2f}"

            consumption_rows.append(
                {
                    "contract_id": contract_id,
                    "consumption_month": month.isoformat(),
                    "consumption_kwh": consumption_value,
                }
            )

    customer_rows.sort(key=lambda row: row["customer_id"])
    contract_rows.sort(key=lambda row: row["contract_id"])
    consumption_rows.sort(key=lambda row: (row["contract_id"], row["consumption_month"]))

    customer_keys = {row["customer_id"] for row in customer_rows}
    tariff_keys = {row["tariff_id"] for row in tariffs}
    if len(customer_keys) != len(customer_rows):
        raise ValueError("Duplicate customer identifiers generated.")
    if len(contract_ids) != len(contract_rows):
        raise ValueError("Duplicate contract identifiers generated.")
    if any(row["customer_id"] not in customer_keys for row in contract_rows):
        raise ValueError("A generated contract references an unknown customer.")
    if any(row["tariff_id"] not in tariff_keys for row in contract_rows):
        raise ValueError("A generated contract references an unknown tariff.")
    if any(row["contract_id"] not in contract_ids for row in consumption_rows):
        raise ValueError("A consumption row references an unknown contract.")
    consumption_keys = [
        (row["contract_id"], row["consumption_month"])
        for row in consumption_rows
    ]
    if len(consumption_keys) != len(set(consumption_keys)):
        raise ValueError("Duplicate contract-month consumption rows generated.")

    write_csv(
        OUTPUT_DIR / "customers.csv",
        ["customer_id", "signup_date", "customer_segment", "region"],
        customer_rows,
    )
    write_csv(
        OUTPUT_DIR / "tariffs.csv",
        [
            "tariff_id",
            "tariff_name",
            "base_fee_eur_monthly",
            "unit_rate_eur_per_kwh",
            "region",
        ],
        tariffs,
    )
    write_csv(
        OUTPUT_DIR / "contracts.csv",
        [
            "contract_id",
            "customer_id",
            "tariff_id",
            "contract_start_date",
            "contract_end_date",
            "contract_status",
        ],
        contract_rows,
    )
    write_csv(
        OUTPUT_DIR / "monthly_consumption.csv",
        ["contract_id", "consumption_month", "consumption_kwh"],
        consumption_rows,
    )

    return {
        "customers": len(customer_rows),
        "tariffs": len(tariffs),
        "contracts": len(contract_rows),
        "monthly_consumption": len(consumption_rows),
        "missing_consumption_values": sum(row["consumption_kwh"] == "" for row in consumption_rows),
        "measured_zero_values": sum(row["consumption_kwh"] == "0.00" for row in consumption_rows),
    }


if __name__ == "__main__":
    counts = generate()
    print(f"Generated CSV files in {OUTPUT_DIR}")
    for name, count in counts.items():
        print(f"{name}: {count}")
