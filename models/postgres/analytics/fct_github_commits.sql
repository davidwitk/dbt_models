with commits as (
    select * from {{ ref('stg_github_commits') }}
)

select * from commits
