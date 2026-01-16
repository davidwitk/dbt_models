with source as (
    select * from "prod"."raw_nextcloud"."df"
),

base as (

    select
        hostname as host_name,
        inserted_at,
        filesystem as file_system,
        blocks as size_kb,
        used as size_used_kb,
        available as size_available_kb,
        -- capacity as size_used_percentage,
        mounted as mount_path
    from source

)

select * from base