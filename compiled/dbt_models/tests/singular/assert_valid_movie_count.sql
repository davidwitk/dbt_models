/*

This test fails in case there is not the expected number of movies per extraction:
- IMDb: 250
- Mubi: 1000

*/

with

imdb as (
    select * from "prod"."analytics"."fct_imdb_movies_daily"
),

mubi as (
    select * from "prod"."analytics"."fct_mubi_movies_weekly"
),

unioned as (

    select
        'IMDb' as source,
        extracted_at :: date as extracted_date
    from imdb

    union all

    select
        'Mubi' as source,
        date_week
    from mubi

),

final as (

    select
        extracted_date,
        source,
        count(*) as movie_count
    from unioned
    group by 1, 2

)

select *
from final
where
    (source = 'IMdb' and movie_count != 250)
    or (source = 'Mubi' and movie_count != 1000)