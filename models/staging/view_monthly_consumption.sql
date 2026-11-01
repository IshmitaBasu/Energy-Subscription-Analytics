with source as (

    select *
    from {{ source('energy_subscription_raw', 'monthly_consumption') }}

),

renamed as (

    select
        nullif(trim(cast(contract_id as string)), '') as contract_id,
        cast(consumption_month as date) as consumption_month,
        cast(consumption_kwh as numeric) as consumption_kwh
    from source

)

select *
from renamed

