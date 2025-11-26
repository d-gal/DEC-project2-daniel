with orders as (
    select
        order_id,
        customer_id,
        employee_id,
        order_date,
        required_date,
        shipped_date,
        ship_via,
        freight,
        ship_name,
        shipped_date - order_date as lead_time,
        shipped_date - required_date as days_late


    from {{ ref('orders') }}
),

order_details as (
    select
        order_id,
        product_id,
        unit_price,
        quantity,
        discount,
        unit_price * quantity * (1 - discount) as revenue

    from {{ ref('order_details') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['order_details.order_id', 'order_details.product_id']) }} as order_key,
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_key,
    order_details.order_id,
    order_details.product_id,
    order_details.unit_price,
    order_details.quantity,
    order_details.discount,
    order_details.revenue,
    orders.order_date,
    orders.required_date,
    orders.shipped_date,
    orders.ship_via,
    orders.freight,
    orders.ship_name
from order_details
inner join orders 
    on orders.order_id = order_details.order_id