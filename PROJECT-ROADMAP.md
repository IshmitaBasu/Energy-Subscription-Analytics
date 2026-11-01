# Energy Subscription Analytics: Project Roadmap

## Project goal

Build a small, reproducible analytics project using synthetic energy-subscription data. The finished portfolio project should show how raw data is transformed into documented, tested dbt models in BigQuery and used for a small set of business metrics and a Metabase report.

This is a learning and portfolio project, not a production implementation. Do not use real customer data.

## Keep the first version small

- Use a deliberately limited synthetic dataset that can be regenerated.
- Start with a single currency, one region, and a small set of tariffs and contract types.
- Use monthly consumption rather than interval-level meter readings.
- Keep revenue rules simple, explicit, and documented.
- Build only the models, metrics, and dashboard described below; treat extensions as optional.
- Prefer free or low-cost tooling, and check current cloud pricing and quotas before creating resources.

## Stages and tasks

### Stage 1 — Define the business rules and project boundaries

- [ ] Write down the questions the analysis should answer, such as how many contracts are active and how much revenue is recognized each month.
- [ ] Define what counts as an active contract, including how start dates, end dates, cancellations, and the reporting date affect the result.
- [ ] Choose a revenue definition. For the first version, use a clearly stated formula such as a monthly base fee plus monthly consumption multiplied by the applicable unit rate.
- [ ] Decide how to treat missing consumption, cancelled contracts, and months with no consumption; document the choices rather than silently filling values.
- [ ] Choose a reporting calendar and currency.
- [ ] Record these decisions in a short project specification before generating data.

**Stage complete when:** the metric definitions and important edge-case rules are written down and unambiguous.

### Stage 2 — Set up the project and tools

- [ ] Create a Git repository for the project and add a `.gitignore`.
- [ ] Create a Python environment and install a compatible dbt adapter for BigQuery.
- [ ] Initialize a dbt project and confirm that `dbt debug` can connect to the intended BigQuery project.
- [ ] Configure BigQuery credentials using a local profile or the recommended secure authentication flow; never commit credentials or secrets.
- [ ] Choose a development dataset and a separate location for any final/certified models if needed.
- [ ] Add a README with the project purpose, setup prerequisites, and a note that all data is synthetic.
- [ ] Check BigQuery pricing, quotas, and cleanup steps. Use small datasets and delete temporary resources when they are no longer needed.

**Stage complete when:** the project is in version control, dbt can connect, and setup instructions are reproducible without storing secrets in the repository.

### Stage 3 — Design and generate synthetic source data

- [ ] Define source entities and their identifiers:
  - Customers
  - Tariffs and tariff rates
  - Contracts
  - Monthly consumption
- [ ] Define the intended raw-table grain and columns before creating data.
- [ ] Ensure generated foreign keys refer to existing records and dates are internally consistent.
- [ ] Include a small number of useful scenarios, such as active, ended, and cancelled contracts; multiple tariffs; and months with different consumption.
- [ ] Generate deterministic data from a fixed random seed so it can be regenerated consistently.
- [ ] Save source data in a simple, reviewable format such as CSV, then load it into the BigQuery development dataset.
- [ ] Keep the volume modest; a few hundred customers and a few thousand monthly consumption rows are sufficient.
- [ ] Record the generation command, schema, and loading steps in the README or a data-generation script.

**Stage complete when:** each raw table has a documented grain, generated data is reproducible, and the loaded tables can be queried in BigQuery.

### Stage 4 — Declare sources and build staging models

- [ ] Declare the raw BigQuery tables as dbt sources, including descriptions and freshness settings only where they make sense.
- [ ] Add source tests for required identifiers and key fields.
- [ ] Create one staging model per source table.
- [ ] In staging models, standardize names and types, normalize dates, and perform only light cleanup.
- [ ] Keep business calculations out of staging models.
- [ ] Build and inspect the staging models with `dbt build` or the appropriate targeted dbt commands.

**Stage complete when:** every raw source used downstream is declared, staging models build successfully, and their fields have consistent names and types.

### Stage 5 — Build the dimensional marts

- [ ] Confirm and document each model's grain before implementing it.
- [ ] Create dimensions such as:
  - `dim_customer`: one row per customer.
  - `dim_tariff`: one row per tariff or tariff version, depending on how rate changes are represented.
  - `dim_contract`: one row per contract.
- [ ] Create `fact_consumption` at one row per contract per month, with consumption and the keys needed to analyze it.
- [ ] Decide how tariff-rate changes are represented. For a small first version, either keep one rate per tariff or include effective dates and select the rate that applies to each consumption month.
- [ ] Add a contract-activity model or metric logic that handles contracts active on a given date consistently.
- [ ] Add the agreed revenue calculation at a clearly stated grain, avoiding duplicated fees when joining monthly consumption to contract-level data.
- [ ] Use dbt references between models and keep the dependency flow clear: sources → staging → intermediate calculations (if needed) → marts.
- [ ] Add model and column descriptions in YAML files.

**Stage complete when:** the dimensions and fact build, their grains and joins are documented, and representative query results make business sense.

### Stage 6 — Add data quality tests

- [ ] Add `not_null` and `unique` tests to primary keys and other required fields.
- [ ] Add relationship tests for fact-to-dimension keys and other required foreign keys.
- [ ] Add accepted-value or range tests for relevant statuses, dates, and numeric measures.
- [ ] Add a test or reconciliation query for the revenue formula and monthly aggregation.
- [ ] Add a test that checks the declared fact grain (one row per contract per month).
- [ ] Run the tests against both normal data and a small intentionally invalid example where practical, to verify that failures are meaningful.
- [ ] Make test failures visible; do not make invalid records appear valid through undocumented defaults.

**Stage complete when:** `dbt build` succeeds for valid data, and the tests would catch duplicate grain keys and broken relationships.

### Stage 7 — Document and define metrics

- [ ] Generate and review dbt documentation; ensure model descriptions explain purpose, grain, and important business rules.
- [ ] Define the active-contract metric with its date logic and aggregation behavior.
- [ ] Define the revenue metric with its formula, currency, time grain, and any exclusions.
- [ ] Configure MetricFlow metrics using the syntax supported by the selected dbt and MetricFlow versions.
- [ ] Query or otherwise validate the metrics against hand-calculated examples from the synthetic data.
- [ ] Document known limitations, especially any simplified tariff or cancellation assumptions.

**Stage complete when:** documentation is readable and the two metrics return values that match independently checked examples.

### Stage 8 — Create a small Metabase report

- [ ] Connect Metabase to the appropriate BigQuery dataset using credentials with only the access needed for the project.
- [ ] Expose the certified mart models rather than raw source tables as the main reporting surface.
- [ ] Build a compact dashboard with an active-contract summary, monthly revenue trend, and one useful breakdown such as tariff or customer segment.
- [ ] Check that dashboard totals match the dbt models and metric definitions.
- [ ] Add clear titles, units, date filters, and a short note explaining the synthetic data.
- [ ] Avoid including credentials or sensitive connection details in screenshots or repository files.

**Stage complete when:** the dashboard is understandable, uses modeled data, and its displayed values reconcile to the warehouse models.

### Stage 9 — Final validation and portfolio polish

- [ ] Run the documented setup and build steps from a clean environment or a fresh checkout.
- [ ] Run the full dbt build and tests, then generate the dbt documentation site.
- [ ] Review the repository for credentials, personal data, unnecessary generated files, and accidental cloud exports.
- [ ] Add a final README section with architecture, data grains, metric definitions, setup/build commands, dashboard preview, limitations, and cleanup instructions.
- [ ] Capture a dashboard image or documentation screenshot only if it can be shared safely and clearly.
- [ ] Update the CV wording only to describe what is actually implemented and verified; keep future work labeled as planned.
- [ ] Stop or remove unused cloud resources and verify that no ongoing resources were left behind.

**Stage complete when:** another person can understand the project, reproduce the models and tests, and see an honest demonstration of the finished scope.


