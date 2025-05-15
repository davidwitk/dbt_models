{{
  config(
    materialized = 'view'
  )
}}

with weather as (
    select * from {{ ref('stg_openweathermap_current_weather') }}
)

select * from weather 
