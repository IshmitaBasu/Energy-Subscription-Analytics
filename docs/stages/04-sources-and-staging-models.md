# Stage 4 — Sources and staging models

**Status:** Complete

## Purpose

Declare raw BigQuery tables as dbt sources and build one lightly cleaned staging model per source.

## Tasks

- [x] Declare the loaded raw tables in dbt source YAML, with descriptions.
- [x] Add source tests for required identifiers and fields.
- [x] Build a staging model for each source table.
- [x] Standardize names, data types, and date formats in staging.
- [x] Keep business definitions and revenue calculations out of staging.
- [x] Build the staging selection and inspect representative records.
- [x] Document any cleanup that changes or excludes source values.

## Expected outputs

- Source declarations and descriptions.
- Staging SQL models with consistent naming and types.
- Basic source/staging tests.

## Completion criteria

- [x] All downstream raw inputs are declared as dbt sources.
- [x] Staging models build successfully and have understandable columns.
- [x] Cleanup behavior is visible and documented.

## Work log

- Declared the four seed-backed BigQuery tables under the `energy_subscription_raw` dbt source.
- Added source and staging tests for required values, primary keys, accepted categories, and relationships.
- Created `stg_customers`, `stg_tariffs`, `stg_contracts`, and `stg_monthly_consumption` as views in `esa_dev_staging`.
- Added singular tests for valid contract date order and the unique contract-month consumption grain.
- Staging trims identifiers and names, lowercases segments/statuses, uppercases region codes, and explicitly casts dates and numeric measures.
- Staging does not filter rows, impute consumption, or calculate activity or revenue. Null consumption and measured zero remain distinct.
- Ran `dbt build --select source:energy_subscription_raw+`: 58 nodes passed, with zero warnings, errors, or skips.
- Reconciled staging row counts to the sources: 180 customers, 4 tariffs, 180 contracts, and 2,796 monthly consumption rows.
