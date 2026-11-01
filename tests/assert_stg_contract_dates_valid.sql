select
    contract_id,
    contract_start_date,
    contract_end_date
from {{ ref('stg_contracts') }}
where contract_end_date < contract_start_date

