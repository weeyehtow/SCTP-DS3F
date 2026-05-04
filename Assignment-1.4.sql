--Assignment1.3  
/*Goal: Identify the most "undervalued" town.

    Find the average resale_price per town.
    Filter for towns where the average price is less than $450,000.
    Within those towns, find the top 5 largest flats (by floor_area_sqm) currently available.
    Level Up: Create a new column called price_per_sqm and find which town has the lowest average price per square meter.
*/
SELECT
    town,
    CAST(block ||' '|| street_name AS VARCHAR) AS address,
    floor_area_sqm,
    ROUND(AVG(resale_price),2) AS average_resale_price, --average resale_price per town
    ROUND(AVG(resale_price/floor_area_sqm)) AS price_per_sqm--new calculated column price per sqm
FROM resale_flat_prices_2017
GROUP BY town, block,street_name, floor_area_sqm,resale_price
HAVING average_resale_price < 450000 --Filter for towns where the average price is less than $450,000
ORDER BY floor_area_sqm DESC, price_per_sqm DESC LIMIT 5; --find the top 5 largest flats (by floor_area_sqm), and find which town has the lowest average price per square meter
--Q1: Select the minimum and maximum price per sqm of all the flats.
SELECT
    ROUND(MIN(resale_price/floor_area_sqm),2) AS min_resale_price_per_sqm,ROUND(MAX(resale_price/floor_area_sqm),2) AS max_resale_price_per_sqm
FROM resale_flat_prices_2017;

--Q2: Select the average price per sqm for flats in each town.
SELECT
    town,
    ROUND(AVG(resale_price/floor_area_sqm),2) AS average_price_per_sqm
FROM resale_flat_prices_2017
GROUP BY town
ORDER BY average_price_per_sqm ASC;

/*Q3: Categorize flats into price ranges and count how many flats fall into each category:

    Under $400,000: 'Budget'
    $400,000 to $700,000: 'Mid-Range'
    Above $700,000: 'Premium' Show the counts in descending order.*/
SELECT
    town,
    CASE
        WHEN resale_price > 700000 THEN 'Premium'
        WHEN resale_price >= 400000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS category,
    COUNT(block) AS number_of_flats,
FROM resale_flat_prices_2017
GROUP BY town,category
ORDER BY town ASC, number_of_flats DESC;
--Q4: Count the number of flats sold in each town during the first quarter of 2017 (January to March).
SELECT
    town,
    SUBSTRING(month, 6, 2) || '-' || SUBSTRING(month, 1, 4) AS transaction_month,
    COUNT(block) AS number_of_flats
FROM resale_flat_prices_2017
WHERE 
    CAST(month || '-01' AS DATE) >= '2017-01-01' AND CAST(month || '-01' AS DATE) <= '2017-03-01'
GROUP BY town, transaction_month
ORDER BY town ASC, transaction_month ASC;