with
    base as (select * from "prod"."raw_dbt"."seeds"),
    enhanced as (

        select
            
md5(cast(coalesce(cast(command_invocation_id as TEXT), '') || '-' || coalesce(cast(node_id as TEXT), '') as TEXT))
            as seed_execution_id,
            command_invocation_id,
            node_id,
            run_started_at,
             database
            ,
             schema
            ,
            name,
            package_name,
            path,
            checksum,
            meta,
            alias
        from base

    )

select *
from enhanced