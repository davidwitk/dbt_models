with source as (
    select * from "prod"."raw_dbt"."model_executions"
),

base as (

    select
        command_invocation_id || node_id as model_execution_id,
        command_invocation_id,
        node_id,
        run_started_at,
        was_full_refresh,
        split_part(thread_id, '-', 2) as thread_id,
        status,
        compile_started_at,
        query_completed_at,
        total_node_runtime,
        rows_affected,
        materialization,
        schema,
        name,
        alias,
        message,
        adapter_response
    from source

)

select * from base