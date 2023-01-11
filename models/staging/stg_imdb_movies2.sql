with

source as (
    select * from {{ source('public', 'imdb') }}
),

base as (

    select
        id,
        extracted_at :: timestamp,

        case
            when title in ('The Godfather Part II', 'The Godfather: Part II') then 'The Godfather Part II'
            else title
        end as title,

        rank,
        rating,
        rating_count,
        year,
        link
    from source

),

final as (

    select
        *,
        row_number() over (partition by title order by extracted_at desc) = 1 as is_latest_day
        min(extracted_at :: date) over () as first_extraction_day_overall,
        min(extracted_at :: date) over (partition by title) as first_extraction_day
    from base

)

select * from final
