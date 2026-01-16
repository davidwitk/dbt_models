with
    base as (select * from "prod"."raw_dbt"."model_executions"),
    enhanced as (

        select
            
md5(cast(coalesce(cast(command_invocation_id as TEXT), '') || '-' || coalesce(cast(node_id as TEXT), '') as TEXT))
            as model_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
            was_full_refresh,
            

  
    

    split_part(
        thread_id,
        '-',
        2
        )


  

 as thread_id,
            status,
            compile_started_at,
            query_completed_at,
            total_node_runtime,
            rows_affected
            ,
            materialization,
             schema
            ,  -- noqa
            name,
            alias,
            message,
            adapter_response
        from base

    )

select *
from enhanced