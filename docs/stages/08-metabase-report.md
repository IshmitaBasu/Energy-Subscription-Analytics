# Stage 8 — Metabase report

**Status:** Complete — local dashboard built, filtered, and reconciled

## Purpose

Present a small, clear report based on the modeled BigQuery data rather than raw source tables.

## Tasks

- [x] Choose a local or hosted Metabase setup and review its cost and security implications.
- [x] Connect Metabase to the appropriate BigQuery dataset with appropriately scoped credentials.
- [x] Use the modeled marts as the only reporting surface in the dashboard SQL.
- [x] Create a dashboard with active-contract count, monthly revenue trend, and tariff breakdowns.
- [x] Specify clear titles, units, date filters, chart types, layout, and a synthetic-data note.
- [x] Reconcile every dashboard query with dbt model and metric results.
- [x] Ensure repository files cannot include the planned local credential directory or application data.
- [x] Document how to start, access, stop, troubleshoot, and safely reset the reporting setup.

## Expected outputs

- A compact Metabase dashboard using the certified/modelled data.
- Setup and validation notes; a safe preview image if useful.

## Completion criteria

- [x] Dashboard totals reconcile with the warehouse.
- [x] Filters and chart labels are understandable.
- [x] The report can be viewed locally without exposing secrets.

## Work log

- Selected the open-source Metabase Docker image, pinned at `v0.65.2`, for a reproducible local-only portfolio runtime.
- Added a Compose configuration bound to `127.0.0.1:3000` with persistent application state in the named `esa-metabase-data` volume.
- Added seven native BigQuery SQL templates for three KPI cards, two time-series charts, and two tariff bar charts.
- Designed single-month KPI/tariff filters separately from the trend date-range filter so active-contract counts are never summed across months.
- Executed all seven SQL templates against `esa_dev_marts`; all completed successfully.
- Reconciled December 2025 totals to 117 active contracts, EUR 20,704.29 recognized revenue, and 13 incomplete contract-months.
- Reconciled December 2025 tariff values, including 33 active Flex contracts and EUR 6,350.50 recognized Saver revenue.
- Added explicit least-privilege service-account guidance, credential ignore rules, dashboard layout instructions, chart formatting, and start/stop commands under `metabase/`.
- Downloaded and started the pinned container locally.
- Created the local Metabase administrator, connected BigQuery successfully with the dedicated read-only service account, and synchronized the reporting database.
- Created all seven saved questions: three KPI cards, two monthly trend charts, and two tariff bar charts.
- Standardized every native SQL question on an optional `reporting_month` Field Filter mapped to `fact_contract_monthly.reporting_month`, with `fact.reporting_month` configured as the table and field alias.
- Built `Energy Subscription Analytics - Synthetic Portfolio Demo` with the three KPI cards first, monthly trends next, and tariff comparisons last.
- Connected a Month and Year filter to the KPI and tariff cards and a separate Date Range filter to the two trend charts.
- Stored the interactive Metabase state in the local `esa-metabase-data` Docker volume; versioned all seven SQL templates and the complete recreation instructions under `metabase/`.
- Captured a credential-safe dashboard preview and linked it from the main project README.
