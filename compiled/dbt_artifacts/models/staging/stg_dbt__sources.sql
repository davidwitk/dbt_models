with
    base as (select * from "prod"."raw_dbt"."sources"),
    enhanced as (

        select
            
md5(cast(coalesce(cast(command_invocation_id as TEXT), '') || '-' || coalesce(cast(node_id as TEXT), '') as TEXT))
            as source_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
             database
            ,
             schema
            ,
            source_name,
            loader,
            name,
            identifier,
            loaded_at_field,
            freshness
        from base

    )

select *
from enhanced