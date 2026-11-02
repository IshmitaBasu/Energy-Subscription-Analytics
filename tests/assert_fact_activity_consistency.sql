select
    fact.contract_month_key,
    fact.is_active_at_month_end,
    fact.active_contract_count,
    contract.contract_start_date,
    contract.contract_end_date,
    fact.month_end_date
from {{ ref('fact_contract_monthly') }} as fact
inner join {{ ref('dim_contract') }} as contract
    on fact.contract_id = contract.contract_id
where fact.is_active_at_month_end != (
        contract.contract_start_date <= fact.month_end_date
        and (
            contract.contract_end_date is null
            or contract.contract_end_date >= fact.month_end_date
        )
    )
    or fact.active_contract_count != if(fact.is_active_at_month_end, 1, 0)

