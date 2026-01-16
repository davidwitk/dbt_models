with movies as (
    select * from "prod"."staging"."stg_imdb_movies"
),

final as (

    select
        id,
        movie_id,

        extracted_at,

        title,
        title_first,

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