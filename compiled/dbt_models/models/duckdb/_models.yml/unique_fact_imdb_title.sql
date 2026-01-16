
    
    

select
    title as unique_field,
    count(*) as n_records

from (select * from "prod"."analytics"."fact_imdb" where is_latest_day) dbt_subquery
where title is not null
group by title
having count(*) > 1


