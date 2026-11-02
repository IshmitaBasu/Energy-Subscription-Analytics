select
    contract_month_key,
    reporting_month,
    month_end_date,
    days_in_month
from {{ ref('fact_contract_monthly') }}
where reporting_month != date_trunc(reporting_month, month)
    or month_end_date != last_day(reporting_month, month)
    or days_in_month != extract(day from last_day(reporting_month, month))

