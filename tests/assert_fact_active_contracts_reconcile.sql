with reporting_months as (

    select distinct reporting_month, month_end_date
    from {{ ref('fact_contract_monthly') }}

),

direct_contract_counts as (

    select
        reporting_months.reporting_month,
        countif(
            contracts.contract_start_date <= reporting_months.month_end_date
            and (
                contracts.contract_end_date is null
                or contracts.contract_end_date >= reporting_months.month_end_date
            )
        ) as active_contracts
    from reporting_months
    cross join {{ ref('view_contracts') }} as contracts
    group by 1

),

fact_contract_counts as (

    select
        reporting_month,
        sum(active_contract_count) as active_contracts
    from {{ ref('fact_contract_monthly') }}
    group by 1

)

select
    direct_contract_counts.reporting_month,
    direct_contract_counts.active_contracts as expected_active_contracts,
    fact_contract_counts.active_contracts as actual_active_contracts
from direct_contract_counts
inner join fact_contract_counts
    using (reporting_month)
where direct_contract_counts.active_contracts
    != fact_contract_counts.active_contracts

