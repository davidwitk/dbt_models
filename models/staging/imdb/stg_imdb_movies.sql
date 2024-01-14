with

source as (
    select * from {{ source('raw_imdb', 'imdb') }}
),

base as (

    select
        id,
        regexp_replace(link, 'https://imdb.com/title|/', '', 'g') as movie_id,
        extracted_at :: timestamp,
        title,
        first_value(title) over (partition by regexp_replace(link, 'https://imdb.com/title|/', '', 'g') order by extracted_at :: timestamp) as title_first,
        rank,
        coalesce(split_part(rating, chr(160), 1) :: decimal, rating_20230119_2215) as rating,
        rating_count,
        year,
        link
    from source

),

final as (

    select
        *,
        min(extracted_at :: date) over () as first_extraction_day_overall,
        min(extracted_at :: date) over (partition by title_first) as first_extraction_day
    from base

)

select * from final
