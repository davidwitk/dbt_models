with movies as (
    select * from {{ ref('stg_letterboxd_diary') }}
),

final as (

    select
        imdb_id,
        title,
        watch_date,
        year,
        rating,
        screen_type,
        is_rewatch,
        tmdb_rating,
        tmdb_rating_count,
        countries,
        genres,
        letterboxd_url,
        imdb_url
    from movies

)

select * from final
