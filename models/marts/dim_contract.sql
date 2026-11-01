select
    contract_id,
    customer_id,
    tariff_id,
    contract_start_date,
    contract_end_date,
    contract_status
from {{ ref('stg_contracts') }}

