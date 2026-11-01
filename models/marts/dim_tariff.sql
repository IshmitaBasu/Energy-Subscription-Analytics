select
    tariff_id,
    tariff_name,
    base_fee_eur_monthly,
    unit_rate_eur_per_kwh,
    region
from {{ ref('view_tariffs') }}

