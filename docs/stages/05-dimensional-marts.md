# Stage 5 — Dimensional marts

**Status:** Planned

## Purpose

Create analysis-ready dimensions and facts with explicit grains and joins, implementing the business rules agreed in Stage 1.

## Confirmed first-version models and grains

- `dim_customer`: one row per customer.
- `dim_tariff`: one row per tariff, or per tariff version if effective-dated rates are used.
- `dim_contract`: one row per contract.
- `fct_contract_monthly`: one row per contract per calendar month in which the contract was active for at least one day, including months without an observed consumption record.

These grains are fixed for the first release by the [architecture document](../architecture.md). Update the architecture document if a grain or model boundary must change.

## Tasks

- [ ] Sketch model relationships and write a grain statement for every model.
- [ ] Build dimensions with stable keys and useful descriptive attributes.
- [ ] Build the complete monthly contract scaffold, then add consumption, contract, tariff, activity, revenue, and completeness fields.
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
