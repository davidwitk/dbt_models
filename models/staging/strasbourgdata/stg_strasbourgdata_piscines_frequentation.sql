with

source as (
    select * from {{ source('raw_strasbourgdata', 'piscines_frequentation') }}
),

base as (

    select
        md5(recordid || record_timestamp) as record_id,
        recordid as piscine_id,
        record_timestamp :: timestamp as recorded_at,
        (fields ->> 'updatedate') :: timestamp as updated_at,

        fields ->> 'name' as name,
        fields ->> 'realtimestatus' as status,
        ((fields -> 'isopen') :: int) :: boolean as is_open,
        (fields -> 'occupation') :: int as occupation,

        -- noqa: disable=PRS
        ((((fields ->> 'dayschedule') :: json) -> 0 ->> 'openingHour') :: int) as opening_hour,
        ((((fields ->> 'dayschedule') :: json) -> 0 ->> 'openingMinute') :: int) as opening_minute,
        ((((fields ->> 'dayschedule') :: json) -> 0 ->> 'closingHour') :: int) as closing_hour,
        ((((fields ->> 'dayschedule') :: json) -> 0 ->> 'closingMinute') :: int) as closing_minute,
        -- noqa: enable=PRS

        -- Meta data
        _sdc_extracted_at,
        _sdc_batched_at
    from source

)

select * from base
