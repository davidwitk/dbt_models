with

source as (
    select * from {{ source('raw_openweathermap', 'current_weather_stream') }}
),

base as (

    select
        md5(id || _sdc_extracted_at :: varchar) as weather_id,

        to_timestamp(dt) at time zone 'UTC' as measured_at,

        id as location_id,
        name as location_name,
        replace((sys -> 'country') :: varchar, '"', '') as location_country,

        (coord -> 'lat') :: decimal as location_latitude,
        (coord -> 'lon') :: decimal as location_longitude,

        timezone as location_timezone, -- Shift in seconds from UTC

        (main -> 'temp') :: decimal - 273.15 as temperature, -- -- Temperature is measured in Kelvin, we expose it in Celsius
        (main -> 'temp_max') :: decimal - 273.15 as temperature_temp_max, -- Maximum temperature at the moment. This is maximal currently observed temperature (within large megalopolises and urban areas).
        (main -> 'temp_min') :: decimal - 273.15 as temperature_temp_min, -- Minimum temperature at the moment. This is minimal currently observed temperature (within large megalopolises and urban areas)
        (main -> 'feels_like') :: decimal - 273.15 as temperature_feels_like,
        (main -> 'humidity') :: decimal as humidity, -- Humidity, %
        (main -> 'pressure') :: decimal as pressure, -- Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa

        replace((weather[0] -> 'main') :: varchar, '"', '') as weather_type, -- Group of weather parameters (Rain, Snow, Extreme etc.)
        replace((weather[0] -> 'description') :: varchar, '"', '') as weather_description, -- Weather condition within the group. You can get the output in your language.
        (clouds -> 'all') :: int as cloudiness, -- Cloudiness, %
        visibility, -- Visibility, meter. The maximum value of the visibility is 10km

        to_timestamp((sys -> 'sunrise') :: int) at time zone 'UTC' as sunrise_at,
        to_timestamp((sys -> 'sunset') :: int) at time zone 'UTC' as sunset_at,

        (wind -> 'deg') :: decimal as wind_direction, -- Wind direction, degrees (meteorological)
        (wind -> 'speed') :: decimal as wind_speed, -- Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour

        -- Meta data
        _sdc_batched_at,
        _sdc_extracted_at

    from source

)

select * from base
