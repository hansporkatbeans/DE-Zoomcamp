-- Question 3. Count records
-- How many taxi trips were totally made on September 18th 2019?
SELECT COUNT(1) as number_of_trips
FROM green_trip
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
  AND DATE(lpep_dropoff_datetime) = '2019-09-18';

-- Question 4. Largest trip for each day
-- Which was the pick up day with the largest trip distance Use the pick up time for your calculations.
SELECT DATE(lpep_pickup_datetime)    as pick_up_time,
       max(green_trip.trip_distance) as trip_distance
FROM green_trip
GROUP BY lpep_pickup_datetime
ORDER BY 2 DESC;

-- Question 5. Three biggest pick up Boroughs
-- Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown
-- Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
WITH cte as (SELECT green_trip."PULocationID",
                    zones."Borough",
                    sum(total_amount)                             as total_amount,
                    RANK() OVER (ORDER BY sum(total_amount) DESC) as ranking
             FROM green_trip
                      INNER JOIN zones
                                 ON green_trip."PULocationID" = zones."LocationID"
             WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
               AND zones."Borough" != 'Unknown'
             GROUP BY 1, 2)
SELECT DISTINCT "Borough"                                      as borough,
                SUM(total_amount)                             as total_pick_up_times,
                RANK() OVER (ORDER BY SUM(total_amount) DESC) as ranking
from cte
GROUP BY 1
ORDER BY 3;

-- Question 6. Largest tip
-- For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id.
SELECT green_trip."DOLocationID"                         as drop_off_zone_id,
       zones."Zone"                                      as zone_name,
       green_trip.tip_amount                             as tip_amount_total,
       RANK() OVER (ORDER BY green_trip.tip_amount DESC) as ranking
FROM green_trip
         INNER JOIN zones
                    ON green_trip."DOLocationID" = zones."LocationID"
WHERE green_trip."PULocationID" = '7' AND date_part('month', "lpep_pickup_datetime") = 9 AND date_part('year', "lpep_pickup_datetime") = 2019
GROUP BY 1, 2, 3;
