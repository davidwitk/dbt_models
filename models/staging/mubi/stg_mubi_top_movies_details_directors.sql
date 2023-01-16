with

source as (
    select * from {{ source('raw_mubi', 'top_movies__details__directors') }}
),

base as (

    select
        md5(movie_id || to_char(_extracted_at :: timestamp, 'yyyy-mm-dd')) as movie_week_id,

        movie_id,
        director_id,
        director_name,
        director_canonical_url as director_url,

        -- Meta data
        _sdc_batched_at,
        _extracted_at :: timestamp as _sdc_extracted_at

    from source

)

select * from base
