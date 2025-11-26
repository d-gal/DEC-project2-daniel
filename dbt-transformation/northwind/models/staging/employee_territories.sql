{{
    config(
        materialized="table"
    )
}}

select
    *
from {{ source('northwind', 'employee_territories') }}
