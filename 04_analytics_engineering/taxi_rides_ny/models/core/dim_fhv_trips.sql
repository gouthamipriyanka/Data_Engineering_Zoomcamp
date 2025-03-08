{{ config(materialized="table") }}

with
    fhv_dim_data as (
        select pickup_datetime, dropoff_datetime, pulocationid, dolocationid
        from {{ ref("stg_fhv_2019") }}
    ),

    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')


select
    f.pickup_datetime,
    f.dropoff_datetime,
    f.pulocationid,
    f.dolocationid,
    extract(year from f.pickup_datetime) as trip_year,
    extract(month from f.pickup_datetime) as trip_month,
    pickup_zone.zone as pickup_zone,
    dropoff_zone.zone as dropoff_zone,
from fhv_dim_data f
left join dim_zones as pickup_zone on f.pulocationid = pickup_zone.locationid
left join dim_zones as dropoff_zone on f.dolocationid = dropoff_zone.locationid
