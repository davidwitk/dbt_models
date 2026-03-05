with date_spine as (
    select (unnest(generate_series(
        date '2010-01-01',
        current_date + interval 20 year,
        interval 1 day
    ))) :: date as date_day
),

final as (

    select
        date_day,

        -- Basic date parts
        year(date_day) as date_year,
        month(date_day) as date_month,
        quarter(date_day) as date_quarter,
        week(date_day) as date_week, -- ISO week

        -- Names and formatting
        dayname(date_day) as day_name,
        monthname(date_day) as month_name,
        year(date_day) || '-Q' || quarter(date_day) as quarter_name,

        -- Day counters
        dayofyear(date_day) as day_of_year,
        date_diff('day', date_trunc('quarter', date_day) :: date, date_day) + 1 as day_of_quarter,
        day(date_day) as day_of_month,
        day(last_day(date_day)) as days_in_month,

        -- Weekday logic: DuckDB dayofweek is 0 (Sun) to 6 (Sat). We add 1 to match Postgres 1 (Sun).
        dayofweek(date_day) + 1 as day_of_week,
        dayofweek(date_day) between 1 and 5 as is_weekday,
        dayofweek(date_day) in (0, 6) as is_weekend,

        -- Yearly
        date_trunc('year', date_day) :: date as first_day_of_year,
        make_date(year(date_day), 12, 31) as last_day_of_year,
        dayofyear(date_day) = 1 as is_first_day_of_year,
        month(date_day) = 12 and day(date_day) = 31 as is_last_day_of_year,

        -- Monthly
        date_trunc('month', date_day) :: date as first_day_of_month,
        last_day(date_day) as last_day_of_month,
        day(date_day) = 1 as is_first_day_of_month,
        date_day = last_day(date_day) as is_last_day_of_month,
        -- Fast scalar math to find the last weekday without a window function
        date_day = last_day(date_day) - (case dayofweek(last_day(date_day)) when 0 then 2 when 6 then 1 else 0 end) as is_last_weekday_of_month,

        -- Quarterly
        date_trunc('quarter', date_day) :: date as first_day_of_quarter,
        last_day(date_trunc('quarter', date_day) + interval 2 month) as last_day_of_quarter,
        date_day = date_trunc('quarter', date_day) :: date as is_first_day_of_quarter,
        date_day = last_day(date_trunc('quarter', date_day) + interval 2 month) as is_last_day_of_quarter,

        -- Weekly (Assuming ISO rules: week starts on Monday)
        date_trunc('week', date_day) :: date as first_day_of_week,
        date_trunc('week', date_day) :: date + 6 as last_day_of_week,
        isodow(date_day) = 1 as is_first_day_of_week,
        isodow(date_day) = 7 as is_last_day_of_week

    from date_spine

)

select * from final
