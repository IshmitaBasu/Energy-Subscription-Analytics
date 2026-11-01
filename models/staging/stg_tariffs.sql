with source as (

    select *
    from {{ source('energy_subscription_raw', 'tariffs') }}

),

renamed as (

    select
        nullif(trim(cast(tariff_id as string)), '') as tariff_id,
        nullif(trim(cast(tariff_name as string)), '') as tariff_name,
        cast(base_fee_eur_monthly as numeric) as base_fee_eur_monthly,
        cast(unit_rate_eur_per_kwh as numeric) as unit_rate_eur_per_kwh,
        upper(nullif(trim(cast(region as string)), '')) as region
    from source

)

select *
from renamed

