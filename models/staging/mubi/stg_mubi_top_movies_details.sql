with

source as (
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

        -- Meta data
        _sdc_batched_at,
        _extracted_at :: timestamp as _sdc_extracted_at

    from source

)

select * from base
