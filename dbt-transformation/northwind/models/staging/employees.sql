{{
    config(
        materialized="table"
    )
}}

select
    *
from {{ source('northwind', 'employees') }}
