with source as (
    select * from {{ source('s3', 'letterboxd_diary') }}
),

base as (

    select
        "Watched Date" as watch_date,
        name as title,
        year,
        rating,
        case
            when contains(tags, 'cinema') then 'cinema'
            when contains(tags, 'tv') then 'tv'
        end as screen_type,
        tags,
        rewatch as is_rewatch,
        "Letterboxd Uri" as letterboxd_url
    from source

)

select * from base
