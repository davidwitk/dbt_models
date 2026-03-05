with source as (
    select * from {{ source('s3', 'raw_openweathermap_current_weather') }}
),

base as (

    select
        -- 1. IDs & Meta Data
        -- Casting to varchar to prevent hash errors between DOUBLE (old) and BIGINT (new) types
        md5(id :: varchar || _sdc_extracted_at :: varchar) as weather_id,
        cast(_sdc_extracted_at as timestamp) as _extracted_at,

        -- 2. Timestamps
        to_timestamp(cast(dt as bigint)) at time zone 'UTC' as measured_at,
        to_timestamp(cast(dt as bigint)) at time zone 'Europe/Berlin' at time zone 'UTC' as measured_at_cet,

        -- 3. Location Info
        cast(id as bigint) as location_id,
        case
            when name = 'Tiergarten' then 'Berlin'
            when name = 'Attiecoubé' then 'Abidjan'
            else name
        end as location_name,
        coalesce(sys__country, sys ->> 'country') as location_country,

        coalesce(coord__lat, cast(coord ->> 'lat' as decimal)) as location_latitude,
        coalesce(coord__lon, cast(coord ->> 'lon' as decimal)) as location_longitude,

        cast(timezone as bigint) as location_timezone, 

        -- 4. Temperature (Converting Kelvin to Celsius)
        round(coalesce(main__temp, cast(main ->> 'temp' as decimal)) - 273.15, 2) as temperature,
        round(coalesce(main__temp_max, cast(main ->> 'temp_max' as decimal)) - 273.15, 2) as temperature_temp_max,
        round(coalesce(main__temp_min, cast(main ->> 'temp_min' as decimal)) - 273.15, 2) as temperature_temp_min,
        round(coalesce(main__feels_like, cast(main ->> 'feels_like' as decimal)) - 273.15, 2) as temperature_feels_like,
        
        -- 5. Atmospheric Metrics
        coalesce(main__humidity, cast(main ->> 'humidity' as decimal)) :: int as humidity, 
        coalesce(main__pressure, cast(main ->> 'pressure' as decimal)) :: int as pressure, 

        -- 6. Weather Details
        -- Since `weather` is a VARCHAR in both schemas, we use DuckDB's native JSON path extraction 
        json_extract_string(weather, '$[0].main') as weather_type, 
        json_extract_string(weather, '$[0].description') as weather_description, 

        coalesce(clouds__all, cast(clouds ->> 'all' as int)) as cloudiness,
        cast(visibility as bigint) as visibility,

        -- 7. Sun Cycle
        to_timestamp(cast(coalesce(sys__sunrise, cast(sys ->> 'sunrise' as bigint)) as bigint)) at time zone 'UTC' as sunrise_at,
        to_timestamp(cast(coalesce(sys__sunset, cast(sys ->> 'sunset' as bigint)) as bigint)) at time zone 'UTC' as sunset_at,

        -- 8. Wind
        coalesce(wind__deg, cast(wind ->> 'deg' as decimal)) :: int as wind_direction, 
        coalesce(wind__speed, cast(wind ->> 'speed' as decimal)) as wind_speed 

    from source

)

select * from base
