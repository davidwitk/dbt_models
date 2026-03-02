with source as (
    select * from {{ source('s3', 'raw_github_prs') }}
),

base as (

    select
        id as pull_request_id,
        node_id,
        repo_full_name,

        -- Timestamps
        created_at,
        updated_at,
        closed_at,
        merged_at,

        -- Details
        title,
        body,
        number as pull_request_number,
        user_login as author_username,

        -- Status
        state,
        locked as is_locked,
        merge_commit_sha,

        -- URLs
        html_url,
        url as api_url
    from source

)

select * from base
