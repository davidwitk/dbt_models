with

movies as (
    select * from {{ ref('stg_imdb_movies') }}
),

final as (

    select
        id,
        extracted_at,

        title,
        rank,
        rating,
        rating_count,
        year,
        link,

        is_latest_day,
        first_extraction_day_overall,
        first_extraction_day
    from movies

)

select * from final
