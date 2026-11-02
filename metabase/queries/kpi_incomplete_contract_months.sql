with monthly_incomplete_records as (
    select
        fact.reporting_month,
        countif(not fact.is_revenue_complete) as incomplete_contract_months
    from `esa_dev_marts.fact_contract_monthly` as fact
    [[where {{reporting_month}}]]
    group by fact.reporting_month
)

select
    incomplete_contract_months
from monthly_incomplete_records
order by reporting_month desc
limit 1
