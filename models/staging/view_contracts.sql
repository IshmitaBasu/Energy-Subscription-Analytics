with source as (

    select *
    from {{ source('energy_subscription_raw', 'contracts') }}

),

renamed as (
    select
        nullif(trim(cast(contract_id as string)), '') as contract_id,
        nullif(trim(cast(customer_id as string)), '') as customer_id,
        nullif(trim(cast(tariff_id as string)), '') as tariff_id,
        cast(contract_start_date as date) as contract_start_date,
        cast(contract_end_date as date) as contract_end_date,
        lower(nullif(trim(cast(contract_status as string)), '')) as contract_status
    from source
)

select *
from renamed

