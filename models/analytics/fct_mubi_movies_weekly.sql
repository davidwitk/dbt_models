with

movies as (
    select * from {{ ref('stg_mubi_top_movies') }}
),

movie_details as (
    select * from {{ ref('stg_mubi_top_movies_details') }}
),

movie_directors as (
    select * from {{ ref('stg_mubi_top_movies_details_directors') }}
),

final as (

    select
        movies.movie_week_id,

        -- Movie data
        movies.movie_id,
        movie_details.movie_title,
        movie_details.movie_title_locale,
        movie_details.movie_year,
        movies.movie_rank,
        movie_details.movie_popularity,
        movie_details.movie_url,

        -- Director data (careful, this might be a 1:n relation)
        movie_directors.director_id,
        movie_directors.director_name,
        movie_directors.director_url,

        -- List data
        movies.list_id,
        movies.list_created_at,
        movies.list_updated_at,
        movies.list_title,
        movies.list_user_id,
        movies.list_url

    from movies
    left join movie_details using (movie_week_id)
    left join movie_directors using (movie_week_id)

)

select * from final
