select
    fact.reporting_month,
    sum(fact.total_revenue_eur) as recognized_revenue_eur,
    countif(not fact.is_revenue_complete) as incomplete_contract_months
from `esa_dev_marts.fact_contract_monthly` as fact
[[where {{reporting_month}}]]
group by fact.reporting_month
order by fact.reporting_month
