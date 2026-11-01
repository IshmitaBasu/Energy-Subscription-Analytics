# Stage 6 — Data quality tests

**Status:** Planned

## Purpose

Make key assumptions executable so invalid keys, broken relationships, or incorrect fact grain are caught by dbt.

## Tasks

- [ ] Test primary keys for uniqueness and non-null values.
- [ ] Test required identifiers and measures for non-null values where appropriate.
- [ ] Test fact-to-dimension relationships.
- [ ] Add accepted-value or range tests for statuses, dates, and measures where useful.
- [ ] Verify `fct_contract_monthly` has no duplicate contract-month key.
- [ ] Add focused checks for revenue logic and monthly aggregation.
- [ ] Run tests against valid data and, where practical, a controlled invalid example.
- [ ] Review failures and ensure they explain the issue rather than masking it.

## Expected outputs

- dbt schema tests and any focused singular tests.
- A repeatable command for building models and running tests.

## Completion criteria

- [ ] Tests pass on valid synthetic data.
- [ ] Duplicate grain keys and broken relationships cause a test failure.
- [ ] Metric-critical rules have explicit validation.

## Work log

Not started.
