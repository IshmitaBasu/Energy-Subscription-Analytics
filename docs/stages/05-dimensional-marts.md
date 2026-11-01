# Stage 5 — Dimensional marts

**Status:** Planned

## Purpose

Create analysis-ready dimensions and facts with explicit grains and joins, implementing the business rules agreed in Stage 1.

## Candidate models and grains

- `dim_customer`: one row per customer.
- `dim_tariff`: one row per tariff, or per tariff version if effective-dated rates are used.
- `dim_contract`: one row per contract.
- `fact_consumption`: one row per contract per calendar month.

These are candidates, not fixed requirements; confirm the grain before writing each model.

## Tasks

- [ ] Sketch model relationships and write a grain statement for every model.
- [ ] Build dimensions with stable keys and useful descriptive attributes.
- [ ] Build the monthly fact with consumption, contract, tariff, and date keys.
- [ ] Apply effective tariff rates if rates can change over time.
- [ ] Implement active-contract logic at a clear reporting-date grain.
- [ ] Implement revenue without duplicating contract-level fees in joins.
- [ ] Add model and column descriptions.
- [ ] Compare sample rows and totals against hand-calculated examples.

## Expected outputs

- Documented dbt dimensions and fact models.
- A simple, auditable dependency flow from sources to marts.
- Defined handling of contract periods, tariff selection, and revenue.

## Completion criteria

- [ ] Each model has a stated and verified grain.
- [ ] Joins do not introduce unintended duplication.
- [ ] Example active-contract and revenue results agree with the Stage 1 rules.

## Work log

Not started.
