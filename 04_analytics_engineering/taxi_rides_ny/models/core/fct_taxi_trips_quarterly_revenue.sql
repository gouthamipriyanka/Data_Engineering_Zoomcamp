-- Compute the Quarterly Revenues for each year for based on total_amount
{{ config(materialized="table") }}

with
    trips_data as (select * from {{ ref("fact_trips") }}),

    quarterly_trips_data as (
        select
            total_amount,
            service_type,
            extract(quarter from pickup_datetime) as trip_quarter,
            extract(year from pickup_datetime) as trip_year
        from trips_data
    ),

    -- Computing the quarterly revenues for each year
    total_quarterly_data as (
        select sum(total_amount) as total_amount, service_type, trip_quarter, trip_year
        from quarterly_trips_data
        group by service_type, trip_quarter, trip_year
    ),

-- Calculating YOY revenue growth
        total_quarterly_revenue  as (select
            ot.service_type,
            ot.trip_year as current_year,
            ot.trip_quarter as current_quarter,
            round(ot.total_amount) current_total,
            round(lyt.total_amount) as last_year_total,
            lyt.trip_year as last_year,
            lyt.trip_quarter as last_year_quarter
        from total_quarterly_data as ot
        left outer join
            total_quarterly_data as lyt
            on ot.trip_year = lyt.trip_year + 1
            and ot.trip_quarter = lyt.trip_quarter
            and ot.service_type = lyt.service_type
        order by ot.service_type, ot.trip_year
    )

select
    service_type,
    current_year,
    current_quarter,
    round(
        ifnull(
            ((current_total - last_year_total) / nullif(last_year_total, 0))
            * 100,
            0
        ),
        2
    ) as yoy_revenue_percentage
from total_quarterly_revenue
ORDER BY service_type, current_year, current_quarter 