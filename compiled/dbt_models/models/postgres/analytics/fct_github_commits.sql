with commits as (
    select * from "prod"."staging"."stg_github_commits"
)

select * from commits