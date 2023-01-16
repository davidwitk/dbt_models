with

source as (
    select * from {{ source('raw_mubi', 'top_movies') }}
),

base as (

    select
        md5(movie_id || to_char(_extracted_at :: timestamp, 'yyyy-mm-dd')) as movie_week_id,

        -- Movie data
        movie_id,
        movie_rank,

        -- List data
        list_id,
        list_canonical_url as list_url,
        list_created_at,
        list_updated_at,
        list_title_locale as list_title,
        list_user_id,

        -- Meta data
        _sdc_batched_at,
        _extracted_at :: timestamp as _sdc_extracted_at

    from source

)

select * from base
