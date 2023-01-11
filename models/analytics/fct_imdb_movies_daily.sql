with 

movies as (
    select * from {{ ref('stg_imdb_movies') }}
)

select * from movies
