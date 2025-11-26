{{
    config(
        materialized="table"
    )
}}

select
    *
from {{ source('northwind', 'suppliers') }}
