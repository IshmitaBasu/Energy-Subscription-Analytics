select
    customer_id,
    signup_date,
    customer_segment,
    region
from {{ ref('stg_customers') }}

