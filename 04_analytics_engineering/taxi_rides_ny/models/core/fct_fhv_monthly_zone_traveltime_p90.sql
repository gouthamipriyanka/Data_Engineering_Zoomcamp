{{ config(materialized="table") }}

-- year, month, pickup_location_id, and dropoff_location_id
with
    trip_durations as (
        select
            *, 
            timestamp_diff(dropoff_datetime, pickup_datetime, second) as trip_duration,
        from {{ ref("dim_fhv_trips") }}
    ),

p90_trip_durations AS (
    SELECT
        trip_year,
        trip_month,
        pulocationid,
        dolocationid,
        pickup_zone,
        dropoff_zone,
        percentile_cont(trip_duration, 0.90) over (
        partition by
           trip_year, trip_month, pulocationid, dolocationid
    ) AS p90_trip_duration
    FROM
        trip_durations
)

SELECT
    *
FROM
    p90_trip_durations