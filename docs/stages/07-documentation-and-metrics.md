# Stage 7 — Documentation and metrics

**Status:** Complete

## Purpose

Make models and business metrics understandable to someone who did not build them, and verify metric results independently.

## Tasks

- [x] Complete model and column descriptions, including grains and important caveats.
- [x] Generate and review dbt documentation.
- [x] Define the active-contract metric using the agreed as-of-date logic.
- [x] Define monthly revenue with its formula, currency, time grain, and exclusions.
- [x] Confirm supported MetricFlow configuration and commands for the selected dbt versions.
- [x] Query metrics for sample periods and compare them with direct calculations.
- [x] Document known limitations and any simplifications.

## Expected outputs

- Readable dbt documentation.
- MetricFlow definitions for active contracts and revenue.
- Independently checked sample metric results.

## Completion criteria

- [x] A reader can find each model's purpose, grain, and key rules.
- [x] Both metric definitions have explicit time and aggregation behavior.
- [x] Metric outputs match independently checked examples.

## Implemented semantic model

`fact_contract_monthly` is exposed as the `energy_contract_monthly` semantic model using dbt 1.12's model-embedded YAML specification.

- Primary entity: `contract_month`, represented by `contract_month_key`.
- Foreign entities: `contract`, `customer`, and `tariff`.
- Aggregation time dimension: `reporting_month`, at calendar-month granularity.
- Daily time spine: `view_time_spine_daily`, one row per day from 2020-01-01 through 2030-12-31.

| Metric | Expression | Rule |
|---|---|---|
| `active_contracts` | `sum(active_contract_count)` | Counts contracts active on the final calendar day; additive across contracts but not across time |
| `recognized_revenue_eur` | `sum(total_revenue_eur)` | Sums EUR revenue only where consumption is known; null incomplete rows are excluded |

Revenue must be interpreted with the incomplete contract-month count from the fact. The revenue metric does not replace missing consumption with zero.

## Validation evidence

- Pinned `dbt-metricflow[dbt-bigquery]==0.15.0`, which supports the project's dbt Core 1.12.6 and dbt-bigquery 1.12.1 versions.
- Generated `manifest.json`, `semantic_manifest.json`, `catalog.json`, and the dbt documentation site successfully.
- Reviewed the manifest: all 10 dbt models and every declared model column have non-empty descriptions.
- MetricFlow semantic and BigQuery warehouse validation completed with zero errors, future errors, or warnings.
- A full build completed successfully: 4 seeds, 6 views, 4 tables, 4 unit tests, and 123 data tests. Final result: `PASS=141`, `WARN=0`, `ERROR=0`, `SKIP=0`.
- Queried both metrics for all 24 reporting months and compared them row by row with a direct aggregation over `fact_contract_monthly`: 24 rows compared and zero mismatches.

Representative reconciled values:

| Month | Active contracts | Recognized revenue | Incomplete contract-months |
|---|---:|---:|---:|
| 2024-01 | 75 | EUR 11,011.64 | 5 |
| 2025-05 | 144 | EUR 24,038.86 | 5 |
| 2025-12 | 117 | EUR 20,704.29 | 13 |

## Repeatable commands

```powershell
dbt docs generate

$env:DBT_PROFILES_DIR = "$env:USERPROFILE\.dbt"
$env:PYTHONIOENCODING = "utf-8"

dbt parse --no-partial-parse
mf validate-configs --show-all --verbose-issues
mf list metrics
mf query --metrics active_contracts,recognized_revenue_eur `
  --group-by metric_time__month `
  --order metric_time__month
```

The explicit profile path is needed because the local `mf` CLI defaults to looking for `profiles.yml` in the current directory. UTF-8 avoids a Windows console-encoding failure in MetricFlow's status spinner.

## Known limitations

- Metrics use synthetic monthly data for Germany and EUR only.
- Each tariff has one fixed rate; there is no effective-dated price history.
- Contract dates are inclusive and activity is measured only at calendar month end.
- Revenue is a simplified calculable-revenue measure, not an invoice or production accounting implementation.
- Incomplete contract-months are excluded from revenue and must be displayed as a companion quality indicator.
- MetricFlow is validated locally; no hosted dbt Semantic Layer integration is claimed.

## Work log

Completed on 2026-11-01. Stage 8 can now build the Metabase dashboard from the certified physical marts and reconcile it to these metric results.
