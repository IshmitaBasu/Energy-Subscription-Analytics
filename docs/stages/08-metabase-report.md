# Stage 8 — Metabase report

**Status:** Planned

## Purpose

Present a small, clear report based on the modeled BigQuery data rather than raw source tables.

## Tasks

- [ ] Choose a local or hosted Metabase setup and review its cost and security implications.
- [ ] Connect Metabase to the appropriate BigQuery dataset with appropriately scoped credentials.
- [ ] Use the modeled marts as the primary reporting surface.
- [ ] Create a dashboard with active-contract count, monthly revenue trend, and a useful breakdown such as tariff.
- [ ] Add clear titles, units, date filters, and a synthetic-data note.
- [ ] Reconcile dashboard values with dbt model and metric results.
- [ ] Ensure screenshots and repository files do not expose credentials or private details.
- [ ] Document how to start, access, and stop the reporting setup.

## Expected outputs

- A compact Metabase dashboard using the certified/modelled data.
- Setup and validation notes; a safe preview image if useful.

## Completion criteria

- [ ] Dashboard totals reconcile with the warehouse.
- [ ] Filters and chart labels are understandable.
- [ ] The report can be viewed without exposing secrets.

## Work log

Not started.
