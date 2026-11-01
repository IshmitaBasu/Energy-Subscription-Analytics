select
    contract_id,
    reporting_month,
    count(*) as row_count
from {{ ref('fct_contract_monthly') }}
group by 1, 2
having count(*) > 1

