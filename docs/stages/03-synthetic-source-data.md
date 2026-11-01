# Stage 3 — Synthetic source data

**Status:** Complete

## Purpose

Create small, deterministic, clearly documented source tables that exercise the business rules without using real personal or customer data.

## Planned source entities

- Customers
- Tariffs and rates
- Contracts
- Monthly consumption

The final columns and table grains depend on Stage 1 decisions. A reasonable initial scale is a few hundred customers and a few thousand contract-month consumption records.

## Tasks

- [x] Specify each source table's grain, columns, key, and relationships.
- [x] Create a reproducible generator using a fixed random seed.
- [x] Include representative cases: active, ended, and cancelled contracts; multiple tariffs; and varying monthly consumption.
- [x] Ensure generated foreign keys resolve and dates are consistent with contract periods.
- [x] Keep missing consumption distinguishable from measured zero consumption.
- [x] Write generated files to a clearly named local data directory.
- [x] Load the data into the BigQuery development dataset using a documented method.
- [x] Record how to regenerate and reload the data.

## First-version source design

The generator will create the following local CSVs. Identifiers are synthetic and stable across runs.

| File/table | Grain | Key fields |
|---|---|---|
| `customers.csv` | One row per customer | `customer_id` |
| `tariffs.csv` | One row per tariff | `tariff_id` |
| `contracts.csv` | One row per contract; one contract per generated customer | `contract_id` |
| `monthly_consumption.csv` | One observed row per contract per calendar month | `contract_id`, `consumption_month` |

The reporting period is January 2024 through December 2025. Contracts may start in 2023 so the beginning of the reporting period includes already-running subscriptions. Contract end dates are inclusive. An absent consumption row and a row with blank `consumption_kwh` both represent missing data; numeric zero is a measured zero.

The dataset currently contains 180 customers, 4 tariffs, 180 contracts, and 2,796 observed contract-month consumption rows. The generator includes ended and cancelled contracts, missing consumption values, measured zero values, partial contract months, and unobserved contract-months. Consumption for partial months is scaled by active days in that month.

Generate and load the source tables from PowerShell in the project root:

```powershell
.\.venv\Scripts\python.exe scripts\generate_synthetic_data.py
.\.venv\Scripts\dbt.exe seed
```

The CSVs are tracked as small, reproducible synthetic inputs and are configured as dbt seeds. Explicit seed column types preserve BigQuery `DATE`, `NUMERIC`, and `STRING` fields. `dbt seed` creates the source tables in the configured development dataset; do not use `--full-refresh` unless intentionally replacing existing seed tables.

## Expected outputs

- A data-generation script.
- Small synthetic input files or a documented way to generate them.
- A source schema and load instructions.

## Completion criteria

- [x] Re-running the generator produces the same data.
- [x] The source grains and relationships are documented.
- [x] The BigQuery tables can be queried and contain the expected records.

## Work log

- Generated and checked in deterministic synthetic CSVs under `data/generated/`.
- Verified repeatability, foreign keys, unique contract-month keys, and missing versus measured-zero examples.
- Loaded all four files into `tenji-446218.esa_dev` with `dbt seed`.
- Queried BigQuery and reconciled the table counts to the generated files: 180 customers, 4 tariffs, 180 contracts, and 2,796 monthly consumption rows.
