with table_stats as (
    select * from {{ ref('snapshot_stg_postgres_admin_table_stats') }}
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
    {{ dbt_utils.date_spine(
        start_date = "to_date('2023-10-13', 'yyyy-mm-dd')",
        datepart = "day",
        end_date = "current_date + interval '1 day'"
       )
    }}

),

spined as (

    select
        {{ dbt_utils.generate_surrogate_key(['date_spine.date_day', 'prep.table_id']) }} as table_day_id,
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
