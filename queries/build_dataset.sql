WITH daily_rides AS (

    SELECT
        DATE(starttime) AS ride_date,
        COUNT(*) AS num_rides,
        AVG(tripduration) / 60 AS avg_duration_min

    FROM `bigquery-public-data.new_york_citibike.citibike_trips`

    WHERE starttime IS NOT NULL

    GROUP BY ride_date

),

daily_weather AS (

    SELECT
        PARSE_DATE(
            '%Y-%m-%d',
            CONCAT(year,'-',mo,'-',da)
        ) AS obs_date,

        temp AS temp_f,

        `max` AS max_temp_f,

        `min` AS min_temp_f,

        wdsp AS wind_speed_knots,

        prcp AS precip_in

    FROM `bigquery-public-data.noaa_gsod.gsod20*`

    WHERE stn = '725030'

    AND _TABLE_SUFFIX BETWEEN '13' AND '18'

)

SELECT

    daily_rides.ride_date,

    daily_rides.num_rides,

    daily_rides.avg_duration_min,

    daily_weather.temp_f,

    daily_weather.max_temp_f,

    daily_weather.min_temp_f,

    daily_weather.wind_speed_knots,

    daily_weather.precip_in,

    FORMAT_DATE('%A', daily_rides.ride_date) AS day_of_week,

    EXTRACT(MONTH FROM daily_rides.ride_date) AS month

FROM daily_rides

INNER JOIN daily_weather

ON daily_rides.ride_date = daily_weather.obs_date

ORDER BY daily_rides.ride_date;
