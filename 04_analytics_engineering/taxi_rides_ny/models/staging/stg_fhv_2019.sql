{{
    config(
        materialized='view'
    )
}}

WITH fhv_raw_data as (
    SELECT * FROM {{ source('staging','fhv_tripdata') }}
    where dispatching_base_num is not null
)

SELECT * FROM fhv_raw_data