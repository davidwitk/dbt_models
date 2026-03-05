with source as (
    select * from {{ source('s3', 'raw_openweathermap_current_weather') }}
),

base as (

    select
        -- 1. IDs & Meta Data
        -- Casting to varchar to prevent hash errors between DOUBLE (old) and BIGINT (new) types
        md5(id :: varchar || _sdc_extracted_at :: varchar) as weather_id,
        _sdc_extracted_at :: timestamp as _extracted_at,

        -- 2. Timestamps
        to_timestamp(dt :: bigint) at time zone 'UTC' as measured_at,
        to_timestamp(dt :: bigint) at time zone 'Europe/Berlin' at time zone 'UTC' as measured_at_cet,

        -- 3. Location Info
        id :: bigint as location_id,
        case
            when name = 'Tiergarten' then 'Berlin'
            when name = 'Attiecoubé' then 'Abidjan'
            else name
        end as location_name,
        coalesce(sys__country, sys ->> 'country') as location_country,

        coalesce(coord__lat, (coord ->> 'lat') :: decimal) as location_latitude,
        coalesce(coord__lon, (coord ->> 'lon') :: decimal) as location_longitude,

        timezone :: bigint as location_timezone,

        -- 4. Temperature (Converting Kelvin to Celsius)
        round(coalesce(main__temp, (main ->> 'temp') :: decimal) - 273.15, 2) as temperature,
        round(coalesce(main__temp_max, (main ->> 'temp_max') :: decimal) - 273.15, 2) as temperature_temp_max,
        round(coalesce(main__temp_min, (main ->> 'temp_min') :: decimal) - 273.15, 2) as temperature_temp_min,
        round(coalesce(main__feels_like, (main ->> 'feels_like') :: decimal) - 273.15, 2) as temperature_feels_like,

        -- 5. Atmospheric Metrics
        coalesce(main__humidity, (main ->> 'humidity') :: decimal) :: int as humidity,
        coalesce(main__pressure, (main ->> 'pressure') :: decimal) :: int as pressure,

        -- 6. Weather Details
        -- Since `weather` is a VARCHAR in both schemas, we use DuckDB's native JSON path extraction 
        json_extract_string(weather, '$[0].main') as weather_type,
        json_extract_string(weather, '$[0].description') as weather_description,

        coalesce(clouds__all, (clouds ->> 'all') :: int) as cloudiness,
        visibility :: bigint as visibility,

        -- 7. Sun Cycle
        to_timestamp((coalesce(sys__sunrise, (sys ->> 'sunrise') :: bigint)) :: bigint) at time zone 'UTC' as sunrise_at,
        to_timestamp((coalesce(sys__sunset, (sys ->> 'sunset') :: bigint)) :: bigint) at time zone 'UTC' as sunset_at,

        -- 8. Wind
        coalesce(wind__deg, (wind ->> 'deg') :: decimal) :: int as wind_direction,
        coalesce(wind__speed, (wind ->> 'speed') :: decimal) as wind_speed

    from source

)

select * from base
