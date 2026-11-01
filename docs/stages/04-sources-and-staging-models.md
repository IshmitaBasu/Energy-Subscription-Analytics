# Stage 4 — Sources and staging models

**Status:** Planned

## Purpose

Declare raw BigQuery tables as dbt sources and build one lightly cleaned staging model per source.

## Tasks

- [ ] Declare the loaded raw tables in dbt source YAML, with descriptions.
- [ ] Add source tests for required identifiers and fields.
- [ ] Build a staging model for each source table.
- [ ] Standardize names, data types, and date formats in staging.
- [ ] Keep business definitions and revenue calculations out of staging.
- [ ] Build the staging selection and inspect representative records.
- [ ] Document any cleanup that changes or excludes source values.

## Expected outputs

- Source declarations and descriptions.
- Staging SQL models with consistent naming and types.
- Basic source/staging tests.

## Completion criteria

- [ ] All downstream raw inputs are declared as dbt sources.
- [ ] Staging models build successfully and have understandable columns.
- [ ] Cleanup behavior is visible and documented.

## Work log

Not started.
