# Local Metabase dashboard

Stage 8 uses Metabase `v0.65.2` to present the certified BigQuery marts as a compact portfolio dashboard. The dashboard contains three KPI cards, two monthly trend charts, and two tariff breakdowns.

This is a local portfolio demonstration, not a production deployment.

## What is versioned

The repository contains:

- the pinned Docker Compose runtime in `metabase/docker-compose.yml`;
- the SQL behind all seven saved questions in `metabase/queries/`;
- the chart names, visualization settings, filters, layout, and reconciliation targets in this guide.

The interactive Metabase questions and dashboard metadata are stored in the local Docker volume `esa-metabase-data`. They are not portable Git files in the open-source edition. Another reviewer can recreate the report by following this guide and using the versioned SQL templates.

## Security boundary

- Sync only the `esa_dev_marts` BigQuery dataset.
- Use a dedicated service account rather than personal OAuth credentials.
- Grant `BigQuery Data Viewer` and `BigQuery Metadata Viewer` only on `esa_dev_marts`.
- Grant `BigQuery Job User` on the query-execution project.
- Keep the downloaded service-account JSON outside Git. `metabase/credentials/` is ignored as an additional safeguard.
- Bind Metabase only to `127.0.0.1`; do not expose this portfolio instance publicly.

## Start and stop Metabase

From the repository root:

```powershell
docker compose -f metabase\docker-compose.yml pull
docker compose -f metabase\docker-compose.yml up -d
docker compose -f metabase\docker-compose.yml ps
```

Open <http://localhost:3000> after the health check reports `healthy`.

Stop the container without deleting the locally saved questions or dashboard:

```powershell
docker compose -f metabase\docker-compose.yml down
```

View startup or connection errors:

```powershell
docker compose -f metabase\docker-compose.yml logs -f metabase
```

Do not run `docker compose down --volumes` unless you intentionally want to delete the local Metabase users, database connection, questions, and dashboard.

## Connect BigQuery

1. Complete the local Metabase administrator setup.
2. Open **Admin settings > Databases > Add a database**.
3. Select **Google BigQuery**.
4. Use `Energy Subscription Analytics` as the display name.
5. Enter the Google Cloud query-execution project ID.
6. Upload the dedicated read-only service-account JSON.
7. Under dataset filtering, select **Only these** and enter `esa_dev_marts`.
8. Save the connection and run a schema sync.
9. Confirm that only `dim_customer`, `dim_tariff`, `dim_contract`, and `fact_contract_monthly` are exposed.

## Saved questions

Create a collection named `Energy Subscription Analytics`. Create each question as a native BigQuery query using the corresponding versioned SQL file.

| SQL file | Saved question | Visualization | Status |
|---|---|---|---|
| `kpi_active_contracts.sql` | Active contracts | Number, zero decimals | Created |
| `kpi_recognized_revenue.sql` | Recognized revenue | Number, EUR, two decimals | Created |
| `kpi_incomplete_contract_months.sql` | Incomplete contract-months | Number, zero decimals, warning colour | Created |
| `monthly_active_contracts.sql` | Active contracts over time | Line chart | Created |
| `monthly_revenue_and_completeness.sql` | Monthly recognized revenue and completeness | Combo: revenue line and incomplete-record bars | Created |
| `active_contracts_by_tariff.sql` | Active contracts by tariff | Horizontal bar chart | Created |
| `recognized_revenue_by_tariff.sql` | Recognized revenue by tariff | Horizontal bar chart, EUR | Created |

Use blue for active contracts, green for recognized revenue, and amber for incomplete contract-months. Line, combo, and horizontal bar charts communicate these comparisons more clearly than pie charts.

### Configure the SQL variable

Every query uses the optional variable `reporting_month`. Configure it consistently:

- **Variable type:** Field Filter
- **Field to map to:** `fact_contract_monthly.reporting_month`
- **Table and field alias:** `fact.reporting_month`
- **Required:** Off

The explicit alias is required because each template refers to `fact_contract_monthly` as `fact`. It also allows Metabase dashboard filters such as Month and Year and Date Range to connect to native SQL questions.

When the filter is empty, KPI and tariff queries deliberately select the latest available reporting month. Trend queries return the complete 24-month period.

## Dashboard

Create the dashboard **Energy Subscription Analytics - Synthetic Portfolio Demo** and add this text card at the top:

> Synthetic portfolio data. Recognized revenue includes only contract-months with known consumption; review the incomplete-record indicator before interpreting totals.

Arrange the questions as follows:

```text
+------------------+--------------------+----------------------------+
| Active contracts | Recognized revenue | Incomplete contract-months |
+------------------+--------------------+----------------------------+

+-------------------------------------------------------------------+
| Monthly recognized revenue and completeness                       |
+-------------------------------------------------------------------+

+-------------------------------------------------------------------+
| Active contracts over time                                        |
+-------------------------------------------------------------------+

+---------------------------------+---------------------------------+
| Active contracts by tariff      | Recognized revenue by tariff    |
+---------------------------------+---------------------------------+
```

### Dashboard filters

Add **Selected month** as **Time > Date picker > Month and Year**. Connect it to `reporting_month` on:

- Active contracts
- Recognized revenue
- Incomplete contract-months
- Active contracts by tariff
- Recognized revenue by tariff

Add **Time period** as **Time > Date picker > Date Range**. Connect it to `reporting_month` on:

- Active contracts over time
- Monthly recognized revenue and completeness

Keeping the filters separate prevents a selected KPI month from collapsing each trend chart to one point.

## Reconciliation targets

The dashboard queries were independently executed against `esa_dev_marts` before the cards were created.

| Month | Active contracts | Recognized revenue | Incomplete contract-months |
|---|---:|---:|---:|
| 2024-01 | 75 | EUR 11,011.64 | 5 |
| 2025-05 | 144 | EUR 24,038.86 | 5 |
| 2025-12 | 117 | EUR 20,704.29 | 13 |

With no Selected month filter, the latest-month cards show December 2025: 117 active contracts, EUR 20,704.29 recognized revenue, and 13 incomplete contract-months.

December 2025 tariff targets are:

| Tariff | Active contracts | Recognized revenue | Incomplete contract-months |
|---|---:|---:|---:|
| Flex | 33 | EUR 5,218.24 | 4 |
| Standard | 31 | EUR 5,365.81 | 2 |
| Saver | 28 | EUR 6,350.50 | 2 |
| Green | 25 | EUR 3,769.74 | 5 |

## Local-only limitation

The named volume uses Metabase's embedded H2 application database because this is a small local portfolio demonstration. It is not suitable for production. The dashboard queries physical BigQuery marts and does not claim a hosted dbt Semantic Layer integration.
