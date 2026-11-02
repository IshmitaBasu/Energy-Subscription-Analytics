with fact_keys as (

    select contract_month_key
    from {{ ref('fact_contract_monthly') }}

),

view_keys as (

    select contract_month_key
    from {{ ref('view_contract_months') }}

)

select
    coalesce(fact_keys.contract_month_key, view_keys.contract_month_key)
        as contract_month_key,
    fact_keys.contract_month_key is not null as exists_in_fact,
    view_keys.contract_month_key is not null as exists_in_view
from fact_keys
full outer join view_keys
    using (contract_month_key)
where fact_keys.contract_month_key is null
    or view_keys.contract_month_key is null

