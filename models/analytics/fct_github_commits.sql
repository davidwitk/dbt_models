{{ 
  config(
    materialized='external' if target.name == 'prod_duckdb' else 'table',
    location='s3://data-lake-chodera/fct_github_commits.parquet' if target.name == 'prod_duckdb' else '',
  ) 
}}

with

commits as (
    select * from {{ ref('stg_github_commits') }}
)

select * from commits
