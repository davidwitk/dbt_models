with source as (
    select * from {{ source('s3', 'raw_mubi_top_movies_details') }}
),

base as (

    select
        md5(movie_id || _extracted_at :: date) as movie_week_id,

        movie_id :: int as movie_id,
        movie_title,
        movie_title_locale,
        movie_year :: int as movie_year,
        movie_popularity :: int as movie_popularity,
        movie_canonical_url as movie_url,

        -- Director data: This is a 1:n relation. For now, we only fetch the first director.
        -- noqa: disable=all
        movie_directors :: json as movie_directors,
        json_array_length(movie_directors :: json) as director_count,

        -- Fixed: Replaced json_extract_scalar with json_extract_string
        json_extract_string(movie_directors :: json, '$[0].id') as director_id_first,
        json_extract_string(movie_directors :: json, '$[0].name') as director_name_first,
        json_extract_string(movie_directors :: json, '$[0].canonical_url') as director_url_first,
        -- noqa: enable=all

        -- Meta data
        _extracted_at :: timestamp as _extracted_at,
        _extracted_at :: date as _extracted_date

    from source

)

select * from base
