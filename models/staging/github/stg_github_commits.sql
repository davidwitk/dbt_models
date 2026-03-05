with source as (
    select * from {{ source('s3', 'raw_github_commits') }}
),

base as (

    select
        sha as commit_sha,
        node_id,
        repo_full_name,

        -- Timestamps
        author_date as created_at,
        committer_date,

        -- Author Info
        author_login as user_id, -- Using login as unique identifier
        author_name,

        -- Committer Info
        committer_login,
        committer_name,

        -- Details
        message,
        comment_count,
        verified as is_verified_signature,

        -- URLs
        html_url
    from source

)

select * from base
