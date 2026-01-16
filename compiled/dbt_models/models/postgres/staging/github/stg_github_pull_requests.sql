with source as (
    select * from "prod"."raw_github__repositories"."pull_requests"
),

base as (

    select
        id as pull_request_id,

        repo_id as repository_id,
        repo as repository_name,

        created_at,
        updated_at,
        closed_at,
        merged_at,

        title,
        number as pull_request_number,

        -- Status
        state,
        draft as is_draft,
        locked as is_locked,

        -- URLs
        --url,
        html_url,
        comments_url,
        commits_url,
        diff_url

        --assignee,
        --assignees,
        --author_association,
        --requested_reviewers,
        --merge_commit_sha,
        --base,
        --head,
        --body,
        --comments,
        --labels,
        --org as organization,

        --milestone,
        --node_id,
        --patch_url,
        --pull_request,
        --reactions,
        --review_comment_url,
        --review_comments_url
        --statuses_url

        -- Metadata
        _sdc_batched_at, -- noqa
        _sdc_extracted_at

    from source

)

select * from base