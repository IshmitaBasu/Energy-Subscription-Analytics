# Stage 5 — Dimensional marts

**Status:** Complete

## Purpose

Create analysis-ready dimensions and facts with explicit grains and joins, implementing the business rules agreed in Stage 1.

## Confirmed first-version models and grains

- `dim_customer`: one row per customer.
- `dim_tariff`: one row per tariff, or per tariff version if effective-dated rates are used.
- `dim_contract`: one row per contract.
- `fact_contract_monthly`: one row per contract per calendar month in which the contract was active for at least one day, including months without an observed consumption record.

These grains are fixed for the first release by the [architecture document](../architecture.md). Update the architecture document if a grain or model boundary must change.

## Tasks

- [x] Sketch model relationships and write a grain statement for every model.
- [x] Build dimensions with stable keys and useful descriptive attributes.
- [x] Build the complete monthly contract scaffold, then add consumption, contract, tariff, activity, revenue, and completeness fields.
- [x] Apply the first-version fixed tariff rate assigned to each contract.
- [x] Implement active-contract logic at a clear reporting-date grain.
- [x] Implement revenue without duplicating contract-level fees in joins.
- [x] Add model and column descriptions.
- [x] Compare sample rows and totals against independently calculated examples.

## Expected outputs

- Documented dbt dimensions and fact models.
- A simple, auditable dependency flow from sources to marts.
- Defined handling of contract periods, tariff selection, and revenue.

## Completion criteria

- [x] Each model has a stated and verified grain.
- [x] Joins do not introduce unintended duplication.
- [x] Example active-contract and revenue results agree with the Stage 1 rules.

## Work log

- Added `view_contract_months` as a view in `esa_dev_staging`. It generates one row per contract per intersecting reporting month and left joins consumption so missing observations remain visible.
- Added `dim_customer`, `dim_tariff`, `dim_contract`, and `fact_contract_monthly` as certified tables in `esa_dev_marts`.
- Implemented inclusive active-day calculations, month-end activity flags, base-fee proration, usage revenue, total revenue, and revenue-completeness flags.
- Added model and column descriptions plus primary-key, required-field, accepted-value, relationship, active-day-bound, and fact-grain tests.
- Ran `dbt build --select +path:models/marts`: all 122 selected nodes passed with zero warnings, errors, or skips.
- Reconciled mart row counts: 180 customers, 4 tariffs, 180 contracts, and 2,867 contract-month fact rows with 2,867 distinct keys.
- Confirmed 2,796 fact rows have source consumption records, 71 lack a record, 56 contain a present-but-null value, and 52 contain measured zero consumption. The 127 incomplete rows have null total revenue.
- Reconciled all 24 monthly active-contract totals directly to staged contract dates with zero mismatched months. The monthly counts range from 72 to 144 and sum to 2,809 active contract-month flags.
- Reconciled all fact revenue formulas with zero mismatches. For `CON-0001-2024-05`, the independent calculation is `12.90 × 3 / 31 = 1.248387103` base revenue, `36.74 × 0.32 = 11.7568` usage revenue, and `13.005187103` total revenue, matching BigQuery.
