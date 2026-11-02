with customer_mismatches as (

    select
        'customer' as entity_name,
        coalesce(dimension.customer_id, view_model.customer_id) as entity_id,
        dimension.customer_id is not null as exists_in_dimension,
        view_model.customer_id is not null as exists_in_view
    from {{ ref('dim_customer') }} as dimension
    full outer join {{ ref('view_customers') }} as view_model
        using (customer_id)
    where dimension.customer_id is null
        or view_model.customer_id is null

),

tariff_mismatches as (

    select
        'tariff' as entity_name,
        coalesce(dimension.tariff_id, view_model.tariff_id) as entity_id,
        dimension.tariff_id is not null as exists_in_dimension,
        view_model.tariff_id is not null as exists_in_view
    from {{ ref('dim_tariff') }} as dimension
    full outer join {{ ref('view_tariffs') }} as view_model
        using (tariff_id)
    where dimension.tariff_id is null
        or view_model.tariff_id is null

),

contract_mismatches as (

    select
        'contract' as entity_name,
        coalesce(dimension.contract_id, view_model.contract_id) as entity_id,
        dimension.contract_id is not null as exists_in_dimension,
        view_model.contract_id is not null as exists_in_view
    from {{ ref('dim_contract') }} as dimension
    full outer join {{ ref('view_contracts') }} as view_model
        using (contract_id)
    where dimension.contract_id is null
        or view_model.contract_id is null

)

select * from customer_mismatches
union all
select * from tariff_mismatches
union all
select * from contract_mismatches

