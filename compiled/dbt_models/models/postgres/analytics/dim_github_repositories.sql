with repos as (
    select * from "prod"."staging"."stg_github_repositories"
)

select * from repos