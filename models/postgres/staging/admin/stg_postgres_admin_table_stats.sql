with

tables as (
    select * from {{ source('pg_catalog', 'pg_stat_user_tables') }}
),

columns as (
    select * from {{ source('information_schema', 'columns') }}
),

columns_by_table as (

    select
        table_schema as schema_name,
        table_name as table_name,
        count(*) as column_count
    from columns
    group by 1, 2

),

tables_base as (

    select
        schemaname || '.' || relname as table_id,
        schemaname as schema_name,
        relname as table_name,
        pg_relation_size(schemaname || '.' || relname) as size_in_bytes,
        pg_relation_size(schemaname || '.' || relname) / 1048576 :: decimal as size_in_mb,
        n_live_tup as row_count
    from tables

),

final as (

    select
        tables_base.*,
        columns_by_table.column_count
    from tables_base
    left join columns_by_table using (schema_name, table_name)

)

select * from final
