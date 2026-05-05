--Assignment 1.5
/*Question 1
Using the claim and car tables, 
write a SQL query to return a table containing id, claim_date, travel_time, claim_amt from claim, and car_type, car_use from car. 
Use an appropriate join based on the car_id.*/
SELECT 
    claim.id,
    claim.claim_date,
    claim.travel_time,
    claim.claim_amt,
    car.car_type,
    car.car_use
FROM claim
LEFT JOIN car ON claim.car_id = car.id;

/*Question 2
Write a SQL query to compute the running total of the travel_time column for each car_id in the claim table. 
The resulting table should contain id, car_id, travel_time, running_total.*/
SELECT
    id,
    car_id,
    travel_time,
    SUM (travel_time) OVER (PARTITION BY car_id ORDER BY id) AS running_total
FROM claim;

/*Question 3
Using a Common Table Expression (CTE), 
write a SQL query to return a table containing id, resale_value, car_use from car, 
where the car resale value is less than the average resale value for the car use.*/

WITH avg_resale_value AS (
    SELECT car_use,
           AVG(resale_value) AS avg_resale_amt
    FROM car
    GROUP BY car_use
)
SELECT
    car.id,
    car.resale_value,
    car.car_use
FROM car
JOIN avg_resale_value ON car.car_use = avg_resale_value.car_use
WHERE car.resale_value < avg_resale_value.avg_resale_amt;