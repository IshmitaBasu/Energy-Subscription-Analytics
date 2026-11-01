# Energy Subscription Analytics

> **Status:** In progress — Stage 2 (project and tool setup)

A small portfolio project using synthetic electricity-subscription data to demonstrate data modeling with dbt and BigQuery. The planned outcome is a tested, documented dimensional data model, a small set of business metrics, and a Metabase dashboard.

This is a learning project, not a production implementation. It will use synthetic data only.

## Project goals

- Model customer, tariff, contract, and monthly electricity-consumption data.
- Make the grain of each fact and dimension explicit.
- Build and test dbt staging and dimensional models in BigQuery.
- Document business rules, model columns, and metric definitions.
- Define metrics for active contracts and revenue.
- Report on the modeled data in Metabase.

## Project status

Work is being completed one stage at a time. The stage guides record the instructions, decisions, outputs, and completion status for each part of the project.

| Stage | Name | Status |
|---|---|---|
| 1 | Project scope and business rules | Complete |
| 2 | Project and tool setup | In progress |
| 3 | Synthetic source data | Planned |
| 4 | Sources and staging models | Planned |
| 5 | Dimensional marts | Planned |
| 6 | Data quality tests | Planned |
| 7 | Documentation and metrics | Planned |
| 8 | Metabase report | Planned |
| 9 | Final validation and portfolio polish | Planned |

## Documentation

- [Project roadmap](./PROJECT-ROADMAP.md) — overall stages, task checklist, and completion criteria.
- [Stage 1: Project scope and business rules](./docs/stages/01-project-scope-and-business-rules.md)
- [Stage 2: Project and tool setup](./docs/stages/02-project-and-tool-setup.md)
- [Stage 3: Synthetic source data](./docs/stages/03-synthetic-source-data.md)
- [Stage 4: Sources and staging models](./docs/stages/04-sources-and-staging-models.md)
- [Stage 5: Dimensional marts](./docs/stages/05-dimensional-marts.md)
- [Stage 6: Data quality tests](./docs/stages/06-data-quality-tests.md)
- [Stage 7: Documentation and metrics](./docs/stages/07-documentation-and-metrics.md)
- [Stage 8: Metabase report](./docs/stages/08-metabase-report.md)
- [Stage 9: Final validation and portfolio polish](./docs/stages/09-final-validation-and-portfolio-polish.md)

## Planned technology

- Python for generating reproducible synthetic input data.
- dbt with the BigQuery adapter for transformations, tests, and model documentation.
- Google BigQuery as the warehouse.
- MetricFlow for the semantic metrics layer, subject to version compatibility.
- Metabase for a small report built on modeled data.
- Git for source control.

Exact versions and setup instructions will be recorded during Stage 2. Check current cloud pricing and quotas before creating resources. Never commit credentials, secrets, or real customer data.

## Local setup

Stage 2 setup files are in place. The project uses Python 3.11 and pins `dbt-bigquery` in [requirements.txt](./requirements.txt). Create the local environment from PowerShell in this folder:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
dbt --version
```

BigQuery authentication and `dbt debug` are not configured yet; those require a Google Cloud project and local authentication. See [Stage 2](./docs/stages/02-project-and-tool-setup.md) for the current setup status.

## Working agreement

Complete the stages in order. A stage is not marked complete until its stated checks have been carried out. Record meaningful decisions and results in that stage's guide, and update this README's status table as work progresses.
