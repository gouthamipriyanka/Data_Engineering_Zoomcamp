{{ config(materialized="table") }}

-- fare_amount > 0, trip_distance > 0, and payment_type_description in ('Cash',
-- 'Credit card'))
with
    trips_data as (select * from {{ ref("fact_trips") }}),

    trips_filtered as (
        select *
        from trips_data
        where
            fare_amount > 0
            and trip_distance > 0
            and payment_type_description in ('Cash', 'Credit card')
    )

-- partition by service_type, year and and month
-- values of p97, p95, p90 for Green Taxi and Yellow Taxi, in April 2020?
select
    service_type,
    extract(year from pickup_datetime) as trip_year,
    extract(month from pickup_datetime) as trip_month,
    percentile_cont(fare_amount, 0.97) over (
        partition by
            service_type,
            extract(year from pickup_datetime),
            extract(month from pickup_datetime)
    ) as percentile_97,
    percentile_cont(fare_amount, 0.95) over (
        partition by
            service_type,
            extract(year from pickup_datetime),
            extract(month from pickup_datetime)
    ) as percentile_95,
    percentile_cont(fare_amount, 0.90) over (
        partition by
            service_type,
            extract(year from pickup_datetime),
            extract(month from pickup_datetime)
    ) as percentile_90
from trips_filtered
