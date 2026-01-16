
    
    

select
    id as unique_field,
    count(*) as n_records

from "prod"."analytics"."fact_imdb"
where id is not null
group by id
having count(*) > 1


