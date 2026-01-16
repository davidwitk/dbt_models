

with weather as (
    select * from "prod"."staging"."stg_openweathermap_current_weather"
)

select * from weather