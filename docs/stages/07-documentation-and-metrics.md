# Stage 7 — Documentation and metrics

**Status:** Planned

## Purpose

Make models and business metrics understandable to someone who did not build them, and verify metric results independently.

## Tasks

- [ ] Complete model and column descriptions, including grains and important caveats.
- [ ] Generate and review dbt documentation.
- [ ] Define the active-contract metric using the agreed as-of-date logic.
- [ ] Define monthly revenue with its formula, currency, time grain, and exclusions.
- [ ] Confirm supported MetricFlow configuration and commands for the selected dbt versions.
- [ ] Query metrics for sample periods and compare them with hand calculations.
- [ ] Document known limitations and any simplifications.

## Expected outputs

- Readable dbt documentation.
- MetricFlow definitions for active contracts and revenue, if supported by the selected setup.
- Independently checked sample metric results.

## Completion criteria

- [ ] A reader can find each model's purpose, grain, and key rules.
- [ ] Both metric definitions have explicit time and aggregation behavior.
- [ ] Metric outputs match independently checked examples.

## Work log

Not started.
