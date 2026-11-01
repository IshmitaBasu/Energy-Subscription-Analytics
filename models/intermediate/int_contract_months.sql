with reporting_months as (

    select reporting_month
    from unnest(
        generate_date_array(
            date '2024-01-01',
            date '2025-12-01',
            interval 1 month
        )
    ) as reporting_month

),

contracts as (

    select *
    from {{ ref('stg_contracts') }}

),

monthly_consumption as (

    select *
    from {{ ref('stg_monthly_consumption') }}

),

tariffs as (

    select *
    from {{ ref('stg_tariffs') }}

),

contract_months as (

    select
        concat(
            contracts.contract_id,
            '-',
            format_date('%Y-%m', reporting_months.reporting_month)
        ) as contract_month_key,
        contracts.contract_id,
        contracts.customer_id,
        contracts.tariff_id,
        contracts.contract_start_date,
        contracts.contract_end_date,
        reporting_months.reporting_month,
        last_day(reporting_months.reporting_month, month) as month_end_date,
        extract(
            day from last_day(reporting_months.reporting_month, month)
        ) as days_in_month,
        date_diff(
            least(
                coalesce(
                    contracts.contract_end_date,
                    last_day(reporting_months.reporting_month, month)
                ),
                last_day(reporting_months.reporting_month, month)
            ),
            greatest(
                contracts.contract_start_date,
                reporting_months.reporting_month
            ),
            day
        ) + 1 as active_days,
        contracts.contract_start_date
            <= last_day(reporting_months.reporting_month, month)
            and (
                contracts.contract_end_date is null
                or contracts.contract_end_date
                    >= last_day(reporting_months.reporting_month, month)
            ) as is_active_at_month_end
    from contracts
    cross join reporting_months
    where
        contracts.contract_start_date
            <= last_day(reporting_months.reporting_month, month)
        and coalesce(contracts.contract_end_date, date '9999-12-31')
            >= reporting_months.reporting_month

),

joined as (

    select
        contract_months.contract_month_key,
        contract_months.contract_id,
        contract_months.customer_id,
        contract_months.tariff_id,
        contract_months.reporting_month,
        contract_months.month_end_date,
        contract_months.days_in_month,
        contract_months.contract_start_date,
        contract_months.contract_end_date,
        contract_months.active_days,
        contract_months.is_active_at_month_end,
        monthly_consumption.contract_id is not null
            as has_consumption_record,
        monthly_consumption.consumption_kwh is not null
            as is_consumption_known,
        monthly_consumption.consumption_kwh,
        tariffs.base_fee_eur_monthly,
        tariffs.unit_rate_eur_per_kwh
    from contract_months
    left join monthly_consumption
        on contract_months.contract_id = monthly_consumption.contract_id
        and contract_months.reporting_month
            = monthly_consumption.consumption_month
    inner join tariffs
        on contract_months.tariff_id = tariffs.tariff_id

)

select *
from joined

