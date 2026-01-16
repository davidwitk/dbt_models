
    
    

select
    id as unique_field,
    count(*) as n_records

from "prod"."analytics"."fct_imdb_movies_daily"
where id is not null
group by id
having count(*) > 1


