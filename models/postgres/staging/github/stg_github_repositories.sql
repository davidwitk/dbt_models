with

source as (
    select * from {{ source('raw_github__repositories', 'repositories') }}
),

base as (

    select
        id as repository_id,

        created_at,
        --pushed_at,
        updated_at,

        name,
        --repo, -- same as name
        full_name,

        clone_url,
        git_url,
        html_url,
        ssh_url,

        description,
        default_branch,
        --master_branch, -- empty
        homepage,
        language,

        org as organization,
        owner,

        -- Status
        private as is_private,
        visibility, -- private or public
        archived as is_archived,
        disabled as is_disabled,
        fork as is_fork,
        --forks,
        forks_count,
        size,

        -- Issues
        open_issues,
        open_issues_count,

        -- Options
        allow_auto_merge,
        allow_merge_commit,
        allow_rebase_merge,
        allow_squash_merge,
        delete_branch_on_merge,

        stargazers_count,
        subscribers_count,
        watchers_count,

        --watchers,
        --topics,
        --license,
        --network_count,
        --node_id,

        -- Metadata
        _sdc_batched_at,
        --_sdc_deleted_at, -- unused
        _sdc_extracted_at

    from source

)

select * from base
