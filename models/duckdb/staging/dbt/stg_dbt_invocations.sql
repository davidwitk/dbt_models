with unioned as (
    -- Unioning the Postgres and S3 (DuckDB) sources for invocations  
    select
        'postgres' as source,
        *
    from {{ source('postgres', 'invocations') }}
    union all
    select
        'duckdb' as source,
        *
    from {{ source('s3', 'raw_dbt_invocations') }}
),

base as (

    select
        source,
        command_invocation_id,
        dbt_version,
        project_name,
        run_started_at,
        dbt_command,
        full_refresh_flag,
        target_profile_name,
        target_name,
        target_schema,
        target_threads,
        dbt_cloud_project_id,
        dbt_cloud_job_id,
        dbt_cloud_run_id,
        dbt_cloud_run_reason_category,
        dbt_cloud_run_reason,
        env_vars,
        dbt_vars,
        invocation_args,
        dbt_custom_envs
    from unioned

)

select * from base
