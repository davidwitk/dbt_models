with

repos as (
    select * from {{ ref('stg_github_repositories') }}
)

select * from repos
