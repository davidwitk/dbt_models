with source as (
    select * from {{ source('s3', 'raw_github_repos') }}
),

base as (

    select
        id as repository_id,
        node_id,

        -- Timestamps
        created_at,
        updated_at,
        pushed_at,

        -- Metadata
        name,
        full_name,
        html_url,
        description,
        default_branch,
        homepage,
        language,
        license_name,

        -- Identity
        owner_login as owner,
        owner_id,

        -- Status & Stats
        private as is_private,
        visibility,
        archived as is_archived,
        disabled as is_disabled,
        fork as is_fork,
        is_template,
        size,

        stargazers_count,
        watchers_count,
        forks_count,
        open_issues_count,

        -- Features
        has_issues,
        has_projects,
        has_wiki,
        has_pages,
        has_downloads
    from source

)

select * from base
