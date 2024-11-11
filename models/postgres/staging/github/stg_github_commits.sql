with source as (
    select * from {{ source('raw_github__repositories', 'commits') }}
),

base as (

    select
        sha as commit_sha,
        commit_timestamp as created_at,

        (author -> 'id') :: int as user_id,
        --committer,  

        repo_id as repository_id,
        repo as repository_name,
        --url,
        html_url,
        commit,

        --node_id,
        --org,  

        -- Metadata
        _sdc_batched_at,
        --_sdc_deleted_at, -- unused
        _sdc_extracted_at

    from source

)

select * from base
