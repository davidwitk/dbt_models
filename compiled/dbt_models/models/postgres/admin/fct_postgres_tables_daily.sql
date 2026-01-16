with table_stats as (
    select * from "prod"."dbt_snapshots"."snapshot_stg_postgres_admin_table_stats"
),

prep as (

    select
        dbt_valid_from as valid_from,
        dbt_valid_to as valid_to,
        table_id,
        schema_name,
        table_name,
        size_in_bytes,
        size_in_mb,
        row_count,
        column_count,
        row_number() over (
            partition by date_trunc('day', dbt_valid_from), table_id
            order by dbt_valid_from desc
        ) = 1 as is_last_snapshot_of_day
    from table_stats

),

date_spine as (

-- start_date is date the first snapshot was made
    





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
    
    

    )

    select *
    from unioned
    where generated_number <= 827
    order by generated_number



),

all_periods as (

    select (
        

    to_date('2023-10-13', 'yyyy-mm-dd') + ((interval '1 day') * (row_number() over (order by generated_number) - 1))


    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= current_date + interval '1 day'

)

select * from filtered



),

spined as (

    select
        md5(cast(coalesce(cast(date_spine.date_day as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(prep.table_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as table_day_id,
        date_spine.date_day :: date,
        min(date_spine.date_day) over (partition by prep.table_id) = date_spine.date_day as _is_first_day,
        prep.*
    from date_spine
    inner join prep on
        date_spine.date_day >= date_trunc('day', prep.valid_from)
        and (date_spine.date_day < date_trunc('day', prep.valid_to) or prep.valid_to is null)
        and prep.is_last_snapshot_of_day

),

final as (

    select
        date_day,
        table_day_id,
        table_id,

        schema_name,
        table_name,

        size_in_bytes,
        size_in_mb,

        column_count,
        row_count,

        _is_first_day
    from spined

)

select * from final