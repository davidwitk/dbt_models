with

source as (
    select * from {{ source('raw_github__repositories', 'repositories') }}
),

base as (

    select


        -- Metadata
        _sdc_batched_at,
        --_sdc_deleted_at, -- unused
        _sdc_extracted_at

    from source

)

select * from base
