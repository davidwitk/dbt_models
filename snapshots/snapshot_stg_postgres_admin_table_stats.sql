{% snapshot snapshot_stg_postgres_admin_table_stats %}

    {{
        config(
          strategy='check',
          target_schema='dbt_snapshots',
          unique_key='table_id',
          invalidate_hard_deletes=True,
          check_cols=[
              'size_in_bytes',
              'row_count',
              'column_count'
          ]
        )
    }}

    select * from {{ ref('stg_postgres_admin_table_stats') }}

{% endsnapshot %}
