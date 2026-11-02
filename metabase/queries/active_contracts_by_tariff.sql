with tariff_monthly as (
    select
        fact.reporting_month,
        tariff.tariff_name,
        sum(fact.active_contract_count) as active_contracts
    from `esa_dev_marts.fact_contract_monthly` as fact
    inner join `esa_dev_marts.dim_tariff` as tariff
        on fact.tariff_id = tariff.tariff_id
    [[where {{reporting_month}}]]
    group by
        fact.reporting_month,
        tariff.tariff_name
),
latest_month as (
    select max(reporting_month) as reporting_month
    from tariff_monthly
)

select
    tariff_monthly.tariff_name,
    tariff_monthly.active_contracts
from tariff_monthly
inner join latest_month
    using (reporting_month)
order by active_contracts desc
