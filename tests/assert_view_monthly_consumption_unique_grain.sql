select
    contract_id,
    consumption_month,
    count(*) as row_count
from {{ ref('view_monthly_consumption') }}
group by 1, 2
having count(*) > 1

