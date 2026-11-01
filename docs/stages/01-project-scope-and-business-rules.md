# Stage 1 — Project scope and business rules

**Status:** Complete

## Purpose

Decide what the project will measure and establish unambiguous definitions before generating data or writing transformations. These definitions will drive the synthetic data, dbt model grains, tests, and dashboard.

## Proposed first-version scope

- One reporting region and one currency.
- Monthly reporting; no interval-level meter readings.
- Customers, tariffs, contracts, and monthly consumption.
- A compact dimensional model and two headline metrics: active contracts and revenue.
- Synthetic data only; this project is not a production implementation.

## Finalized decisions

These decisions are the source of truth for synthetic data, model logic, tests, and metric definitions.

| Topic | Decision |
|---|---|
| Reporting currency | EUR |
| Reporting time grain | Calendar month |
| Active contract | Count contracts active on the last calendar day of each reporting month. A contract is active on a date when its start date is on or before that date and its end/cancellation date is either absent or on/after that date. Start and end dates are inclusive. |
| Revenue | Monthly base fee plus monthly consumption in kWh multiplied by the tariff unit rate. |
| Partial-month base fee | Prorate by active calendar days divided by the number of days in the month. |
| Missing monthly consumption | Keep missing distinct from zero. Keep the known base-fee component, but mark total monthly revenue incomplete/null when consumption is missing; do not silently substitute zero. |
| Tariff rate changes | One fixed unit rate per tariff in the first version; no effective-dated rate changes. |
| Scope | Germany (`DE`), one currency (EUR), monthly consumption, and synthetic data only. |

End/cancellation dates are treated as inclusive for active-day calculations and contract activity.

## Tasks

- [x] Confirm the business questions the dashboard should answer.
- [x] Confirm the proposed scope and definitions above.
- [x] Define how contract start, end, and cancellation dates affect active status.
- [x] Define the revenue formula, partial-month treatment, and applicable tariff rate.
- [x] Define how missing consumption and months without a consumption record are represented.
- [x] Record the final decisions in this file and use the same definitions in model descriptions and tests.

## Business questions

Initial questions to answer:

1. How many contracts are active at the end of each reporting month?
2. What is the recognized revenue by calendar month?
3. How do contract counts and revenue vary by tariff?

## Completion criteria

- [x] Every decision in the table has a final value.
- [x] The active-contract and revenue definitions are precise enough to implement and test.
- [x] The questions and scope fit a small synthetic dataset.

## Work log

- Created the initial project roadmap and documentation structure.
- Confirmed the proposed business-rule defaults.
- Defined monthly active contracts, prorated base fees, revenue completeness, and fixed tariff rates.
