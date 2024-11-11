with

pull_requests as (
    select * from {{ ref('stg_github_pull_requests') }}
)

select * from pull_requests
