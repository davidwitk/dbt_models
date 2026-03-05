with source as (
    select * from {{ source('s3', 'raw_s3_file_inventory') }}
),

base as (

    select
        file_name,
        relative_path,
        split_part(relative_path, '/', 1) as folder_level_1,
        split_part(relative_path, '/', 2) as folder_level_2,
        split_part(relative_path, '/', 3) as folder_level_3,
        file_url,
        mime_type,
        modification_date,
        size_in_bytes,
        round(size_in_bytes / pow(1024, 2), 2) as size_mb,
        round(size_in_bytes / pow(1024, 3), 2) as size_gb
    from source

)

select * from base
