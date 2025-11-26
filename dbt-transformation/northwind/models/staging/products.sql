{{
    config(
        materialized="table"
    )
}}

select
    *
from {{ source('northwind', 'products') }}
