with source as (
    select * from {{ source('s3', 'raw_mubi_top_movies_details') }}
),

base as (

    select
        md5(movie_id :: varchar || strftime(_extracted_at :: timestamp, '%Y-%m-%d')) as movie_week_id,

        movie_id,
        movie_title,
        movie_title_locale,
        movie_year,
        movie_popularity,
        movie_canonical_url as movie_url,

        -- Director data: This is a 1:n relation. For now, we only fetch the first director.
        -- noqa: disable=all
        CAST(movie_directors AS JSON) AS movie_directors_json,
        json_array_length(CAST(movie_directors AS JSON)) AS director_count,
        
        -- Fixed: Replaced json_extract_scalar with json_extract_string
        json_extract_string(CAST(movie_directors AS JSON), '$[0].id') AS director_id_first,
        json_extract_string(CAST(movie_directors AS JSON), '$[0].name') AS director_name_first,
        json_extract_string(CAST(movie_directors AS JSON), '$[0].canonical_url') AS director_url_first,
        -- noqa: enable=all

        -- Meta data
        _extracted_at :: timestamp as _extracted_at

    from source

)

select * from base
