with source as (

    select *
    from {{ source('energy_subscription_raw', 'customers') }}

),

renamed as (

    select
        nullif(trim(cast(customer_id as string)), '') as customer_id,
        cast(signup_date as date) as signup_date,
        lower(nullif(trim(cast(customer_segment as string)), '')) as customer_segment,
        upper(nullif(trim(cast(region as string)), '')) as region
    from source

)

select *
from renamed

