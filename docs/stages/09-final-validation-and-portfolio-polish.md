# Stage 9 — Final validation and portfolio polish

**Status:** Complete — validated November 2, 2026

## Purpose

Verify the implemented project from deterministic inputs through the dashboard, remove accidental exposure of local or cloud details, and describe only work that was executed and checked.

## Tasks

- [x] Regenerate the source inputs and run a full non-partial build using the documented local toolchain.
- [x] Run the complete dbt build and test suite.
- [x] Generate and review the dbt documentation artifacts.
- [x] Validate MetricFlow configuration and execute both governed metrics.
- [x] Execute all seven versioned Metabase SQL templates against BigQuery.
- [x] Check prospective Git files for credentials, personal information, and accidental generated output.
- [x] Verify local Markdown links, Compose rendering, Metabase health, and dashboard-preview safety.
- [x] Finish the root README with architecture, grains, metrics, commands, dashboard preview, limitations, cleanup guidance, and validation evidence.
- [x] Add accurate completed-project CV wording.
- [x] Inventory the cloud footprint without deleting intentionally retained development resources.

## Expected outputs

- Reproducible project instructions and a successful final validation.
- Clear portfolio documentation and an accurate completed-project status.
- A credential-safe dashboard preview.
- No credentials, unnecessary generated output, or unintended scheduled cloud jobs in the repository or project footprint.

## Completion criteria

- [x] Another person can understand the project and reproduce the core models and tests.
- [x] Final outputs reconcile with the documented business rules.
- [x] Documentation accurately reflects the implemented scope.
- [x] Repository and cloud-footprint checks are complete.

## Final validation results

| Check | Result |
|---|---|
| Python | 3.11.0 |
| dbt Core | 1.12.6 |
| dbt BigQuery adapter | 1.12.1 |
| MetricFlow CLI | 0.15.0 |
| dbt connection | Passed |
| dbt build | `PASS=141`, `WARN=0`, `ERROR=0`, `SKIP=0` |
| Build contents | 4 seeds, 6 views, 4 tables, 4 unit tests, 123 data tests |
| dbt documentation | Manifest and BigQuery catalog generated |
| MetricFlow validation | 0 errors, 0 future errors, 0 warnings |
| Metric query | 2 metrics returned for all 24 reporting months |
| Metabase SQL | 7 of 7 templates executed successfully |
| Metabase runtime | Container healthy; `/api/health` returned `ok` |
| Synthetic regeneration | Deterministic; no CSV diff |
| Local Markdown links | No broken links |
| Credential scan | No private keys, service-account JSON, tokens, emails, or tracked local credentials found |
| BigQuery footprint | Only `esa_dev`, `esa_dev_staging`, and `esa_dev_marts`; Data Transfer API disabled |

## Reconciliation evidence

The final MetricFlow query returned the documented 24 monthly rows. Representative results remained:

| Month | Active contracts | Recognized revenue |
|---|---:|---:|
| 2024-01 | 75 | EUR 11,011.64 |
| 2025-05 | 144 | EUR 24,038.86 |
| 2025-12 | 117 | EUR 20,704.29 |

These values match the independent fact aggregation and the Metabase-query reconciliation targets.

## Repository and security review

- Replaced the personal Google Cloud project ID in versioned documentation with `YOUR_GCP_PROJECT_ID`.
- Confirmed that `.env` files, dbt profiles, service-account files, Metabase credentials and local data, dbt artifacts, logs, and virtual environments are ignored.
- Confirmed that no credential-shaped JSON file is available for commit.
- Confirmed that the dashboard preview contains synthetic analytics only and no visible credentials.
- Confirmed that the Docker Compose file renders successfully and binds Metabase only to `127.0.0.1:3000`.
- Preserved the user's working tree and local Metabase volume; no commit, dataset deletion, IAM change, or destructive cleanup was performed.

## Cloud-resource decision

The three small BigQuery datasets are intentional project outputs and remain available for the local dashboard. The project does not use scheduled transfers, orchestration, reservations, or always-on cloud compute. The dedicated read-only Metabase identity is also intentionally retained while the portfolio dashboard is in use.

## Final CV wording

**Energy Subscription Analytics — dbt + BigQuery | 2026**

Built a reproducible analytics-engineering portfolio project using synthetic customer, tariff, contract, and electricity-consumption data. Developed tested staging and dimensional marts in BigQuery with explicit grains and reconciliation rules, validated MetricFlow metrics for active contracts and recognized revenue, and delivered a Metabase dashboard over certified marts. Portfolio implementation; not a production billing system.
