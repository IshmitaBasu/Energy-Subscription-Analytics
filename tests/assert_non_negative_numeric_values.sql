select
    'view_monthly_consumption' as model_name,
    contract_id as record_id,
    'consumption_kwh' as field_name,
    consumption_kwh as invalid_value
from {{ ref('view_monthly_consumption') }}
where consumption_kwh < 0

union all

select
    'view_tariffs' as model_name,
    tariff_id as record_id,
    'base_fee_eur_monthly' as field_name,
    base_fee_eur_monthly as invalid_value
from {{ ref('view_tariffs') }}
where base_fee_eur_monthly < 0

union all

select
    'view_tariffs' as model_name,
    tariff_id as record_id,
    'unit_rate_eur_per_kwh' as field_name,
    unit_rate_eur_per_kwh as invalid_value
from {{ ref('view_tariffs') }}
where unit_rate_eur_per_kwh < 0

union all

select
    'fact_contract_monthly' as model_name,
    contract_month_key as record_id,
    'base_fee_revenue_eur' as field_name,
    base_fee_revenue_eur as invalid_value
from {{ ref('fact_contract_monthly') }}
where base_fee_revenue_eur < 0

union all

select
    'fact_contract_monthly' as model_name,
    contract_month_key as record_id,
    'usage_revenue_eur' as field_name,
    usage_revenue_eur as invalid_value
from {{ ref('fact_contract_monthly') }}
where usage_revenue_eur < 0

union all

select
    'fact_contract_monthly' as model_name,
    contract_month_key as record_id,
    'total_revenue_eur' as field_name,
    total_revenue_eur as invalid_value
from {{ ref('fact_contract_monthly') }}
where total_revenue_eur < 0

