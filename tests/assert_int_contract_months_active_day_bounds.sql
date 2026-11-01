select
    contract_month_key,
    active_days,
    days_in_month
from {{ ref('int_contract_months') }}
where active_days < 1
    or active_days > days_in_month

