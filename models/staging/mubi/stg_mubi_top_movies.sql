with source as (
    select * from {{ source('s3', 'raw_mubi_top_movies') }}
),

base as (

    select
        md5(movie_id || strftime('%Y-%m-%d', _extracted_at :: timestamp)) as movie_week_id,

        date_trunc('week', _extracted_at :: timestamp) as date_week,

        -- Movie data
        movie_id :: int as movie_id,
        movie_rank :: int as movie_rank,

        -- List data
        list_id :: int as list_id,
        list_canonical_url as list_url,
        to_timestamp(list_created_at) as list_created_at,
        to_timestamp(list_updated_at) as list_updated_at,
        list_title_locale as list_title,
        list_user_id :: int as list_user_id,

        -- Meta data
        _extracted_at :: timestamp as _extracted_at,
        _extracted_at :: date as _extracted_date,
        row_number() over (partition by movie_id order by _extracted_at desc) = 1 as is_latest_day,
        min(_extracted_date) over () as first_extraction_day_overall,
        min(_extracted_date) over (partition by movie_id) as first_extraction_day
    from source

)

select * from base
