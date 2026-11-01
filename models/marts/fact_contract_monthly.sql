with contract_months as (

    select *
    from {{ ref('view_contract_months') }}

),

calculated as (

    select
        contract_month_key,
        contract_id,
        customer_id,
        tariff_id,
        reporting_month,
        month_end_date,
        days_in_month,
        active_days,
        is_active_at_month_end,
        if(is_active_at_month_end, 1, 0) as active_contract_count,
        has_consumption_record,
        is_consumption_known,
        consumption_kwh,
        base_fee_eur_monthly,
        unit_rate_eur_per_kwh,
        base_fee_eur_monthly
            * safe_divide(
                cast(active_days as numeric),
                cast(days_in_month as numeric)
            ) as base_fee_revenue_eur,
        consumption_kwh * unit_rate_eur_per_kwh
            as usage_revenue_eur
    from contract_months

),

final as (

    select
        *,
        if(
            is_consumption_known,
            base_fee_revenue_eur + usage_revenue_eur,
            null
        ) as total_revenue_eur,
        is_consumption_known as is_revenue_complete
    from calculated

)

select *
from final

