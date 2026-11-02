with monthly_revenue as (
    select
        fact.reporting_month,
        sum(fact.total_revenue_eur) as recognized_revenue_eur
    from `esa_dev_marts.fact_contract_monthly` as fact
    [[where {{reporting_month}}]]
    group by fact.reporting_month
)

select
    recognized_revenue_eur
from monthly_revenue
order by reporting_month desc
limit 1
