with

disk_space as (
    select * from {{ ref('stg_nextcloud_disk_space') }}
)

select * from disk_space
