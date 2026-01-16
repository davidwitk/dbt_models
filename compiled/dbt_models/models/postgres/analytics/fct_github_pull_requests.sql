with pull_requests as (
    select * from "prod"."staging"."stg_github_pull_requests"
)

select * from pull_requests