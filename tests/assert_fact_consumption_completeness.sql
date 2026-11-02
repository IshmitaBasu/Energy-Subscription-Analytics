select
    contract_month_key,
    has_consumption_record,
    is_consumption_known,
    consumption_kwh,
    usage_revenue_eur,
    total_revenue_eur,
    is_revenue_complete
from {{ ref('fact_contract_monthly') }}
where is_consumption_known != (consumption_kwh is not null)
    or is_revenue_complete != is_consumption_known
    or (
        not is_consumption_known
        and (usage_revenue_eur is not null or total_revenue_eur is not null)
    )
    or (
        is_consumption_known
        and (usage_revenue_eur is null or total_revenue_eur is null)
    )
    or (
        consumption_kwh = 0
        and usage_revenue_eur != 0
    )
    or (
        not has_consumption_record
        and is_consumption_known
    )

