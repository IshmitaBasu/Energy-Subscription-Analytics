select
    contract_month_key,
    active_days,
    days_in_month,
    consumption_kwh,
    base_fee_eur_monthly,
    unit_rate_eur_per_kwh,
    base_fee_revenue_eur,
    usage_revenue_eur,
    total_revenue_eur
from {{ ref('fact_contract_monthly') }}
where base_fee_revenue_eur != round(
        base_fee_eur_monthly
            * safe_divide(
                cast(active_days as numeric),
                cast(days_in_month as numeric)
            ),
        2
    )
    or (
        is_consumption_known
        and usage_revenue_eur != round(
            consumption_kwh * unit_rate_eur_per_kwh,
            2
        )
    )
    or (
        is_consumption_known
        and total_revenue_eur != base_fee_revenue_eur + usage_revenue_eur
    )

