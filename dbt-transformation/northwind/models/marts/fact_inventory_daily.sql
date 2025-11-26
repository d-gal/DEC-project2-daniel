
{{
    config(
        materialized='incremental',
        unique_key=['products_key', 'snapshot_date'],
        on_schema_change='fail',
        tags=['fact', 'inventory', 'snapshot']
    )
}}

WITH current_inventory AS (
    SELECT
        products_key,
        product_name,
        units_in_stock,
        units_on_order,
        reorder_level,
        unit_price,
        discontinued
    FROM {{ ref('dim_product') }}
),

snapshot AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['products_key', 'CURRENT_DATE']) }} 
            AS inventory_snapshot_key,
        products_key,
        CURRENT_DATE AS snapshot_date,
        
        -- Core inventory metrics
        product_name,
        units_in_stock,
        units_on_order,
        reorder_level,
        
        -- Calculated measures
        units_in_stock + units_on_order AS available_to_promise,
        units_in_stock * unit_price AS stock_value,
        
        -- Business flags
        CASE 
            WHEN units_in_stock = 0 AND NOT discontinued 
            THEN TRUE 
            ELSE FALSE 
        END AS is_stockout,
        
        CASE 
            WHEN units_in_stock <= reorder_level AND NOT discontinued 
            THEN TRUE 
            ELSE FALSE 
        END AS is_below_reorder_level,

        discontinued AS is_discontinued,
        
        -- Metadata
        CURRENT_TIMESTAMP AS dbt_created_at
        
    FROM current_inventory
)

SELECT * FROM snapshot