{{
  config(
    materialized = 'view'
  )
}}

with

piscines_frequentation as (
    select * from {{ ref('stg_strasbourgdata_piscines_frequentation') }}
)

select * from piscines_frequentation
