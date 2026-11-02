with monthly_active_contracts as (
    select
        fact.reporting_month,
        sum(fact.active_contract_count) as active_contracts
    from `esa_dev_marts.fact_contract_monthly` as fact
    [[where {{reporting_month}}]]
    group by fact.reporting_month
)

select
    active_contracts
from monthly_active_contracts
order by reporting_month desc
limit 1
