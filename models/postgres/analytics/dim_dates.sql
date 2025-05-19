with date_spine as (

    {{ dbt_utils.date_spine(
        start_date = "'2010-01-01' :: date",
        datepart = "day",
        end_date = "current_date + interval '20 year'"
       )
    }}

),

base as (

    select
        date_day :: date as date_day, 

        date_part('year', date_day) as date_year,
        date_part('month', date_day) as date_month,
        date_part('quarter', date_day) as date_quarter,
        to_char(date_day, 'iw') :: int as date_week,

        to_char(date_day, 'Day') as day_name,
        to_char(date_day, 'Month') as month_name,
        date_part('year', date_day) || '-Q' || date_part('quarter', date_day) as quarter_name,

        row_number() over (partition by date_part('year', date_day) order by date_day) as day_of_year,
        row_number() over (partition by date_part('year', date_day), date_part('quarter', date_day) order by date_day) as day_of_quarter,
        date_part('day', date_day) as day_of_month,
        count(*) over (partition by date_part('year', date_day), date_part('month', date_day)) as days_in_month,
        to_char(date_day, 'd') :: int as day_of_week, -- 1 is Sunday

        to_char(date_day, 'd') :: int in (2, 3, 4, 5, 6) as is_weekday,
        to_char(date_day, 'd') :: int in (7, 1) as is_weekend

    from date_spine

),

final as (

    select
        base.*,

        first_value(date_day :: date) over (partition by date_year order by date_day asc rows between unbounded preceding and unbounded following) as first_day_of_year,
        last_value(date_day :: date) over (partition by date_year order by date_day asc rows between unbounded preceding and unbounded following) as last_day_of_year,
        date_day = first_value(date_day :: date) over (partition by date_year order by date_day asc rows between unbounded preceding and unbounded following) as is_first_day_of_year,
        date_day = last_value(date_day :: date) over (partition by date_year order by date_day asc rows between unbounded preceding and unbounded following) as is_last_day_of_year,

        date_trunc('month', date_day) :: date as first_day_of_month,
        last_value(date_day :: date) over (partition by date_year, date_month order by date_day asc rows between unbounded preceding and unbounded following) as last_day_of_month,
        date_day = date_trunc('month', date_day) :: date as is_first_day_of_month,
        date_day = last_value(date_day :: date) over (partition by date_year, date_month order by date_day asc rows between unbounded preceding and unbounded following) as is_last_day_of_month,
        max(case when to_char(date_day, 'd') :: int in (7, 1) then date_day else null end) over (partition by date_year, date_month) = date_day as is_last_weekday_of_month,

        first_value(date_day :: date) over (partition by date_year, date_quarter order by date_day asc rows between unbounded preceding and unbounded following) as first_day_of_quarter,
        last_value(date_day :: date) over (partition by date_year, date_quarter order by date_day asc rows between unbounded preceding and unbounded following) as last_day_of_quarter,
        date_day = first_value(date_day :: date) over (partition by date_year, date_quarter order by date_day asc rows between unbounded preceding and unbounded following) as is_first_day_of_quarter,
        date_day = last_value(date_day :: date) over (partition by date_year, date_quarter order by date_day asc rows between unbounded preceding and unbounded following) as is_last_day_of_quarter,

        date_trunc('week', date_day) :: date as first_day_of_week,
        last_value(date_day :: date) over (partition by date_trunc('week', date_day) :: date order by date_day asc rows between unbounded preceding and unbounded following) as last_day_of_week,
        date_day = date_trunc('week', date_day) :: date as is_first_day_of_week,
        date_day = last_value(date_day :: date) over (partition by date_trunc('week', date_day) :: date order by date_day asc rows between unbounded preceding and unbounded following) as is_last_day_of_week

    from base

)

select * from final
