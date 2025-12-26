with movies as (
    select * from {{ ref('stg_letterboxd_diary') }}
),

final as (

    select
        watch_date,
        title,
        year,
        rating,
        screen_type,
        is_rewatch,
        letterboxd_url
    from movies

)

select * from final
