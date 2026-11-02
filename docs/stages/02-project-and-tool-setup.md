# Stage 2 — Project and tool setup

**Status:** Complete

## Purpose

Create a reproducible local development environment, initialize dbt, and establish secure access to a small BigQuery development dataset.

## Tools and accounts

- Python and a project-specific virtual environment.
- Git and a remote repository, if publishing the portfolio project.
- dbt with the BigQuery adapter.
- A Google Cloud project with BigQuery enabled and a secure local authentication method.
- VS Code is recommended as an editor. The Google Cloud CLI is recommended for local authentication.

### Environment check

Checked on 2026-11-01:

- Python 3.11.0 is available as `python` and is within the Python requirement for the selected BigQuery adapter.
- Git 2.47.0 and Docker 29.8.2 are available.
- The `py` launcher is present but points to a missing Python 3.14 installation; use `python` for this project.
- The Google Cloud CLI is installed under `%LOCALAPPDATA%\Google\Cloud SDK`, but the installation's `bin` folder is not currently on PATH in the shell.
- The `gcloud` CLI has no active account selected. Application Default Credentials are available and are sufficient for the dbt OAuth profile; direct `gcloud`/`bq` CLI commands may still require `gcloud auth login`.
- The project Git repository is initialized.

The project pins `dbt-core==1.12.6` and `dbt-bigquery==1.12.1` in `requirements.txt`. Pinning Core avoids pip selecting a pre-release Core version through the adapter's broad dependency range. The local virtual environment has dbt Core 1.12.6 and the BigQuery adapter 1.12.1 installed. Keep dependencies inside that environment. MetricFlow compatibility will be checked later, when the dbt models exist.

### Google Cloud project details

| Setting | Value | Status |
|---|---|---|
| Project ID | `YOUR_GCP_PROJECT_ID` | User-provided and kept out of versioned configuration |
| BigQuery location | `EU` | Provided |
| Development dataset | `esa_dev` | Confirmed; location `EU` |
| Synthetic source tables and rows | 4 tables; 3,160 total rows | Loaded and verified in Stage 3 |

The dataset now contains the four synthetic source tables loaded during Stage 3.

## Tasks

- [x] Review the BigQuery Sandbox limits and confirm the project/dataset location.
- [x] Select a Google Cloud project and record its ID and BigQuery location.
- [x] Create or confirm the development dataset.
- [x] Confirm Git and Python are installed and record their versions.
- [x] Install the Google Cloud CLI and authenticate locally using Application Default Credentials.
- [x] Add a project-specific dependency manifest and ignore local credentials and generated files.
- [x] Create the project virtual environment.
- [x] Install the pinned dbt Core and BigQuery adapter and record their versions.
- [x] Add the initial dbt project configuration.
- [x] Configure the local profile outside version control.
- [x] Confirm connectivity with `dbt debug`.
- [x] Add a suitable `.gitignore` and verify local environment/profile/credential paths are ignored.
- [x] Initialize Git in the project folder.
- [ ] Document clean setup and teardown instructions.

## Continue setup: Google Cloud and BigQuery

Use the BigQuery Sandbox for the first version if it is available for your account. Google describes it as usable without a credit card or billing account, but it has limits: tables expire after 60 days and free quotas apply. Keep the synthetic dataset small and check the current [Sandbox limitations](https://cloud.google.com/bigquery/docs/sandbox#limitations) before relying on it.

1. Open [BigQuery Studio](https://console.cloud.google.com/bigquery), sign in, and select `YOUR_GCP_PROJECT_ID`.
2. In BigQuery Studio, confirm or create a development dataset named `esa_dev` in the `EU` location. This project uses synthetic data, but the dataset location should still be chosen consistently.
4. Install the [Google Cloud CLI for Windows](https://cloud.google.com/sdk/docs/install), then open a new PowerShell window and run:

   ```powershell
   gcloud init
   gcloud auth application-default login
   ```

   Sign in with the same Google account that has access to the project. This uses local user authentication; do not create or commit a service-account key for this portfolio project.
5. Once the project ID and dataset location are known, configure the local dbt profile outside the repository and run `dbt debug`.

The project ID and region are not credentials, but never paste credential files or tokens into chat or commit them to Git. If the Sandbox does not provide the permissions or features needed by dbt, stop before enabling paid billing and review the available options first.

## Expected outputs

- A version-controlled project with a dbt project configuration.
- Reproducible dependency/version instructions.
- A working local BigQuery connection without secrets in the repository.

## Completion criteria

- [x] A new environment can install the documented dbt tools.
- [x] `dbt debug` succeeds using local secure authentication.
- [x] No credential, secret, or local profile file is tracked by Git.

## Work log

- Added the initial dbt project configuration, dependency pin, `.gitignore`, and standard dbt directories.
- Created `.venv` and installed dbt Core 1.12.6 with BigQuery adapter 1.12.1.
- Initialized Git in this project folder and verified that local environment and credential/profile paths are ignored.
- Configured `%USERPROFILE%\.dbt\profiles.yml` locally for `YOUR_GCP_PROJECT_ID.esa_dev` in `EU`; the profile is outside Git.
- Verified the dataset exists in `EU`. Stage 3 subsequently loaded `customers`, `tariffs`, `contracts`, and `monthly_consumption`.
- `dbt debug` and `dbt parse` both pass.
- The Google Cloud CLI binary exists but its folder is not on PATH, and no standard `gcloud` account is active. dbt works through Application Default Credentials; direct gcloud/bq CLI use may require `gcloud auth login`.
