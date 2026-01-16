with
    base as (select * from "prod"."raw_dbt"."models"),
    enhanced as (

        select
            
md5(cast(coalesce(cast(command_invocation_id as TEXT), '') || '-' || coalesce(cast(node_id as TEXT), '') as TEXT))
            as model_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
             database
            ,
             schema
            ,  -- noqa
            name,
            depends_on_nodes,
            package_name,
            path,
            checksum,
            materialization,
            tags,
            meta,
            alias
        from base

    )

select *
from enhanced