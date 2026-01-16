with disk_space as (
    select * from "prod"."staging"."stg_nextcloud_disk_space"
)

select * from disk_space