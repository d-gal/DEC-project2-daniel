select
    {{ dbt_utils.generate_surrogate_key(['customers.customer_id']) }} as customer_key,
    customers.company_name,
    customers.contact_name,
    customers.contact_title,
    customers.address,
    customers.city,
    customers.region,
    customers.postal_code,
    customers.country,
    customers.phone,
    customers.fax

from {{ ref('customers') }} as customers
