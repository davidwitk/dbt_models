with date_spine as (

    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
     + 
    
    p6.generated_number * power(2, 6)
     + 
    
    p7.generated_number * power(2, 7)
     + 
    
    p8.generated_number * power(2, 8)
     + 
    
    p9.generated_number * power(2, 9)
     + 
    
    p10.generated_number * power(2, 10)
     + 
    
    p11.generated_number * power(2, 11)
     + 
    
    p12.generated_number * power(2, 12)
     + 
    
    p13.generated_number * power(2, 13)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
     cross join 
    
    p as p6
     cross join 
    
    p as p7
     cross join 
    
    p as p8
     cross join 
    
    p as p9
     cross join 
    
    p as p10
     cross join 
    
    p as p11
     cross join 
    
    p as p12
     cross join 
    
    p as p13
    
    

    )

    select *
    from unioned
    where generated_number <= 13164
    order by generated_number



),

all_periods as (

    select (
        

    '2010-01-01' :: date + ((interval '1 day') * (row_number() over (order by generated_number) - 1))


    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= current_date + interval '20 year'

)

select * from filtered



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