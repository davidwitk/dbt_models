with source as (
    select * from {{ source('s3', 'letterboxd_diary') }}
),

base as (

    select
        imdb_id,
        name as title,
        "Watched Date" as watch_date,
        year,
        rating,
        case
            when contains(tags, 'cinema') then 'cinema'
            when contains(tags, 'tv') then 'tv'
        end as screen_type,
        tags,
        rewatch as is_rewatch,

        tmdb_rating,
        tmdb_rating_count,
        countries,
        genres,

        "Letterboxd Uri" as letterboxd_url,
        imdb_url

    from source

)

select * from base
