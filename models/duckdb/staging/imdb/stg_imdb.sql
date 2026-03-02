with source as (
    select * from {{ source('s3', 'imdb_top_250') }}
),

base as (

    select
        id,
        regexp_replace(link, '/$', '') as movie_id,
        extracted_at :: timestamp as extracted_at,
        title,
        first_value(title) over (partition by movie_id order by extracted_at :: timestamp) as title_first,
        rank :: int as rank,
        case
            when rating_20230119_2215 is not null then rating_20230119_2215
            else split_part(rating, chr(160), 1) :: double
        end as rating,
        rating_count :: int as rating_count,
        year :: int as year,
        link
    from source

),

final as (

    select
        *,
        row_number() over (partition by title_first order by extracted_at desc) = 1 as is_latest_day,
        min(extracted_at :: date) over () as first_extraction_day_overall,
        min(extracted_at :: date) over (partition by title_first) as first_extraction_day
    from base

)

select * from final
