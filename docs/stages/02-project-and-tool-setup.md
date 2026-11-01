# Stage 2 — Project and tool setup

**Status:** In progress

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
- The Google Cloud CLI (`gcloud`) and dbt are not currently available on PATH.
- No Git repository was initialized in this project folder before setup.

The project pins `dbt-bigquery==1.12.1` in `requirements.txt`. Keep dependencies inside the project virtual environment. MetricFlow compatibility will be checked later, when the dbt models exist.

## Tasks

- [ ] Check current BigQuery pricing, quotas, and cleanup options.
- [ ] Create or select a Google Cloud project and development dataset.
- [x] Confirm Git and Python are installed and record their versions.
- [ ] Install the Google Cloud CLI and authenticate locally, if using gcloud OAuth.
- [x] Add a project-specific dependency manifest and ignore local credentials and generated files.
- [ ] Create and activate a project virtual environment.
- [ ] Install the pinned dbt BigQuery adapter and record the installed versions.
- [ ] Initialize the dbt project and configure the local profile outside version control.
- [ ] Confirm connectivity with `dbt debug`.
- [ ] Add a suitable `.gitignore`; verify credentials and local profiles are excluded.
- [ ] Initialize Git in the project folder.
- [ ] Document clean setup and teardown instructions.

## Expected outputs

- A version-controlled project with a dbt project configuration.
- Reproducible dependency/version instructions.
- A working local BigQuery connection without secrets in the repository.

## Completion criteria

- [ ] A new environment can install the documented tools.
- [ ] `dbt debug` succeeds using local secure authentication.
- [ ] No credential, secret, or local profile file is tracked by Git.

## Work log

- Added the initial dbt project configuration, dependency pin, `.gitignore`, and standard dbt directories.
- Local Python, Git, and Docker are present; Google Cloud CLI and dbt are not yet installed.
- BigQuery project creation, authentication, and connectivity remain pending.
