
    
    

select
    sha as unique_field,
    count(*) as n_records

from "prod"."raw_github__repositories"."commits"
where sha is not null
group by sha
having count(*) > 1


