select
    fact.reporting_month,
    sum(fact.active_contract_count) as active_contracts
from `esa_dev_marts.fact_contract_monthly` as fact
[[where {{reporting_month}}]]
group by fact.reporting_month
order by fact.reporting_month
