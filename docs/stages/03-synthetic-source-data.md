# Stage 3 — Synthetic source data

**Status:** Planned

## Purpose

Create small, deterministic, clearly documented source tables that exercise the business rules without using real personal or customer data.

## Planned source entities

- Customers
- Tariffs and rates
- Contracts
- Monthly consumption

The final columns and table grains depend on Stage 1 decisions. A reasonable initial scale is a few hundred customers and a few thousand contract-month consumption records.

## Tasks

- [ ] Specify each source table's grain, columns, key, and relationships.
- [ ] Create a reproducible generator using a fixed random seed.
- [ ] Include representative cases: active, ended, and cancelled contracts; multiple tariffs; and varying monthly consumption.
- [ ] Ensure generated foreign keys resolve and dates are consistent with contract periods.
- [ ] Keep missing consumption distinguishable from measured zero consumption.
- [ ] Write generated files to a clearly named local data directory.
- [ ] Load the data into the BigQuery development dataset using a documented method.
- [ ] Record how to regenerate and reload the data.

## Expected outputs

- A data-generation script.
- Small synthetic input files or a documented way to generate them.
- A source schema and load instructions.

## Completion criteria

- [ ] Re-running the generator produces the same data.
- [ ] The source grains and relationships are documented.
- [ ] The BigQuery tables can be queried and contain the expected records.

## Work log

Not started.
