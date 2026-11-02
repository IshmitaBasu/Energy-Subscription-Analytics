# Stage 6 — Data quality tests

**Status:** Complete

## Purpose

Make key assumptions executable so invalid keys, broken relationships, or incorrect fact grain are caught by dbt.

## Tasks

- [x] Test primary keys for uniqueness and non-null values.
- [x] Test required identifiers and measures for non-null values where appropriate.
- [x] Test fact-to-dimension relationships.
- [x] Add accepted-value or range tests for statuses, dates, and measures where useful.
- [x] Verify `fact_contract_monthly` has no duplicate contract-month key.
- [x] Add focused checks for revenue logic and monthly aggregation.
- [x] Run tests against valid data and a controlled unit-test example that initially failed.
- [x] Review failures and ensure they explain the issue rather than masking it.

## Expected outputs

- dbt schema tests and any focused singular tests.
- A repeatable command for building models and running tests.

## Completion criteria

- [x] Tests pass on valid synthetic data.
- [x] Duplicate grain keys and broken relationships cause a test failure.
- [x] Metric-critical rules have explicit validation.

## Work log

- Retained the existing primary-key, required-field, accepted-value, relationship, fact-grain, and active-day-bound tests from Stages 4 and 5.
- Added eight focused singular tests covering non-negative measures, calendar consistency, month-end activity, revenue formulas, missing-versus-zero completeness, fact-to-view key reconciliation, dimension-to-view key reconciliation, and monthly active-contract reconciliation.
- Added four dbt unit tests for a complete full month, a prorated partial month, missing consumption, and measured-zero consumption.
- The first partial-month fixture failed because BigQuery fixed-scale division returned `4.999999995` for a mathematically €5.00 prorated fee. The test exposed the missing financial rounding rule rather than being weakened to accept the artifact.
- Updated the business rule and fact model to round base-fee and usage components to two decimal places before summing total revenue. All four unit tests then passed.
- Ran a complete `dbt build`: 4 seeds, 5 views, 4 tables, 4 unit tests, and 121 data tests completed successfully. Final result: `PASS=138`, `WARN=0`, `ERROR=0`, `SKIP=0`.
- Stage 7 later added the MetricFlow time-spine view and two tests; the current full-build totals are recorded in the README and Stage 7 work log.

## Repeatable commands

Run the complete project in dependency order:

```powershell
dbt build
```

Run the mocked calculation fixtures only:

```powershell
dbt test --select test_type:unit
```

Run warehouse data tests without unit tests:

```powershell
dbt test --select test_type:data
```
