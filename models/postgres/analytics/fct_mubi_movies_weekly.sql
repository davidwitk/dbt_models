with

movies as (
    select * from {{ ref('stg_mubi_top_movies') }}
),

movie_details as (
    select * from {{ ref('stg_mubi_top_movies_details') }}
),

final as (

    select
        movies.movie_week_id,
        movies.date_week,

        -- Movie data
        movies.movie_id,
        movie_details.movie_title,
        movie_details.movie_title_locale,
        movie_details.movie_year,
        movies.movie_rank,
        movie_details.movie_popularity,
        movie_details.movie_url,

        -- Director data
        movie_details.movie_directors,
        movie_details.director_count,
        movie_details.director_id_first,
        movie_details.director_name_first,
        movie_details.director_url_first,

        -- List data
        movies.list_id,
        movies.list_created_at,
        movies.list_updated_at,
        movies.list_title,
        movies.list_user_id,
        movies.list_url,

        movies.is_latest_day,
        movies.first_extraction_day_overall,
        movies.first_extraction_day

    from movies
    left join movie_details using (movie_week_id)

)

select * from final
