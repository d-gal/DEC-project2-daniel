{{
    config(
        materialized="table"
    )
}}

select
    *
from {{ source('northwind', 'us_states') }}
