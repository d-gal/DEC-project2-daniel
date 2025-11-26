select
    {{ dbt_utils.generate_surrogate_key(['products.product_id']) }} as products_key,
    {{ dbt_utils.generate_surrogate_key(['suppliers.supplier_id']) }} as supplier_key,
    {{ dbt_utils.generate_surrogate_key(['categories.category_id']) }} as category_key,
    products.product_name,
    products.quantity_per_unit,
    products.unit_price,
    products.units_in_stock,
    products.units_on_order,
    products.reorder_level,
    products.discontinued,
    suppliers.company_name as supplier_name,
    categories.category_name as category_name
from {{ ref('products') }} as products
inner join {{ ref('suppliers') }} as suppliers
    on suppliers.supplier_id = products.supplier_id
inner join {{ ref('categories') }} as categories
    on categories.category_id = products.category_id
