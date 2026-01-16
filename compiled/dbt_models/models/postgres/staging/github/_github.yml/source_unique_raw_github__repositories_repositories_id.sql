
    
    

select
    id as unique_field,
    count(*) as n_records

from "prod"."raw_github__repositories"."repositories"
where id is not null
group by id
having count(*) > 1


