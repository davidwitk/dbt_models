with source as (
    select * from {{ source('raw_mubi', 'top_movies__details') }}
),

base as (

    select
        md5(movie_id || to_char(_extracted_at :: timestamp, 'yyyy-mm-dd')) as movie_week_id,

        movie_id,
        movie_title,
        movie_title_locale,
        movie_year,
        movie_popularity,
        movie_canonical_url as movie_url,

        -- Director data: This is am 1:n relation. For now, we only fetch the first director.
        -- noqa: disable=all
        (movie_directors :: json),
        json_array_length(movie_directors :: json) as director_count,
        (movie_directors :: json) -> 0 ->> 'id' as director_id_first,
        (movie_directors :: json) -> 0 ->> 'name' as director_name_first,
        (movie_directors :: json) -> 0 ->> 'canonical_url' as director_url_first,
        -- noqa: enable=all

        -- Meta data
        _sdc_batched_at,
        _extracted_at :: timestamp as _sdc_extracted_at

    from source

)

select * from base
