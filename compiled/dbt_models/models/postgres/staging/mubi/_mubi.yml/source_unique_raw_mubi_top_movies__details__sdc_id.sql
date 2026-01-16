
    
    

select
    _sdc_id as unique_field,
    count(*) as n_records

from "prod"."raw_mubi"."top_movies__details"
where _sdc_id is not null
group by _sdc_id
having count(*) > 1


