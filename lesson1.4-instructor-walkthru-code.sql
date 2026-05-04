-- Generate data dictionary skeleton from schema metadata
SELECT
    table_schema,
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
ORDER BY table_name, ordinal_position;

-- quick overview of the table
DESCRIBE main.resale_flat_prices_2017;

-- See all columns
-- Not recommended for large tables because it is inefficient
SELECT *
FROM resale_flat_prices_2017;

-- Select specific columns and sort
SELECT town, flat_type, resale_price
FROM resale_flat_prices_2017
ORDER BY resale_price DESC; -- default is ASC

-- Sort by town, then by price
SELECT town, street_name, resale_price,
FROM resale_flat_prices_2017
ORDER BY town ASC, resale_price DESC;


SELECT month, town, resale_price
FROM resale_flat_prices_2017;

SELECT *
FROM resale_flat_prices_2017
WHERE town = 'PUNGGOL'
ORDER BY resale_price DESC;
-- WHERE clause is used to filter rows

-- Calc price in K and rename
SELECT 
-- data retrieval
    street_name,
    -- data transformation
    resale_price / 1000 AS price_k
FROM resale_flat_prices_2017
WHERE
-- data filtering
    town = 'PUNGGOL'
    AND resale_price > 500000
ORDER BY resale_price DESC;


SELECT town, flat_type, floor_area_sqm, resale_price
FROM resale_flat_prices_2017
WHERE floor_area_sqm > 100 AND resale_price < 600000
ORDER BY resale_price ASC;

-- Select flats with floor area greater than 100 sqm.
SELECT *
FROM resale_flat_prices_2017
WHERE floor_area_sqm > 100;

-- Select flats with resale price between 400,000 and 500,000.
SELECT *
FROM resale_flat_prices_2017
WHERE resale_price BETWEEN 400000 AND 500000;

-- Select flats with lease commence date later than year 2000 and floor area greater than 100 sqm.
SELECT *
FROM resale_flat_prices_2017
WHERE lease_commence_date > 2000 AND floor_area_sqm > 100;

SELECT *
FROM resale_flat_prices_2017
WHERE town IN ('BUKIT MERAH', 'BUKIT TIMAH');

SELECT * 
FROM resale_flat_prices_2017
WHERE town LIKE 'B%';
-- B% means town name starts with B
-- % wildcard matches any sequence of characters
-- BUKIT% match BUKIT MERAH, BUKIT TIMAH
-- %MER% match BUKIT MERAH
-- B%T% match BUKIT TIMAH
-- _ wildcard matches exactly one character
-- _EDOK matches BEDOK

SELECT DISTINCT town
FROM resale_flat_prices_2017;

-- Return the unique flat types and flat models.
SELECT DISTINCT flat_type FROM resale_flat_prices_2017;
SELECT DISTINCT flat_model FROM resale_flat_prices_2017;

-- Find all towns starting with "P".
SELECT DISTINCT town
FROM resale_flat_prices_2017
WHERE town LIKE 'P%';

-- Using functions
SELECT
    LOWER(town) AS town_lower,
    CONCAT(block, ' ', street_name) AS address
FROM resale_flat_prices_2017;

-- Aggregate means to combine multiple values into a single summary value

-- How many transactions happened?
SELECT COUNT(*) FROM resale_flat_prices_2017;

-- What is the most expensive flat ever sold in this dataset?
SELECT MAX(resale_price) FROM resale_flat_prices_2017;

-- Average resale price overall
SELECT ROUND(AVG(resale_price),2) AS avg_price_overall
FROM resale_flat_prices_2017;

-- Average price per town
SELECT 
    town,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town;

-- Select the average resale price of flats in Bishan.
SELECT AVG(resale_price) AS avg_price_bishan
FROM resale_flat_prices_2017
WHERE town = 'BISHAN';

-- Select the total resale value (price) of flats in Tampines.
SELECT SUM(resale_price) AS total_resale_value_tampines
FROM resale_flat_prices_2017
WHERE town = 'TAMPINES';

-- Think of sorting mail into mailboxes
-- Without GROUP BY - you see every letter
-- With GROUP BY - one mailbox per person with a count of letters

-- without GROUP BY: return all individual transactions
SELECT town, resale_price
FROM resale_flat_prices_2017
WHERE town IN ('BEDOK', 'PUNGGOL');

-- with GROUP BY: return one row per town
SELECT town, AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
WHERE town IN ('BEDOK', 'PUNGGOL')
GROUP BY town;
-- Result: 2 rows only - Bedok and Punggol

-- Group By Rule - SELECT and GROUP BY must match
-- Wrong Example
SELECT town, resale_price
FROM resale_flat_prices_2017
GROUP BY town;

-- Correct Example
SELECT town, AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town;

-- Another Example
SELECT town, flat_type, AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town, flat_type;
-- This creates groups for each unique combination
-- e.g. BEDOK + 3 RM, BEDOK + 4 RM, etc...

SELECT 
    town,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
WHERE avg_price > 600000
ORDER BY avg_price DESC;


SELECT
    town,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
WHERE resale_price > 600000
GROUP BY town;

SELECT
    town,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town
HAVING AVG(resale_price) > 600000;

SELECT
    town,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town
HAVING avg_price > 600000
ORDER BY avg_price DESC;

SELECT
    town,
    lease_commence_date,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY town, lease_commence_date;

-- Select the average resale price by flat type.
SELECT
    flat_type,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY flat_type;

-- Select the average resale price by flat type and flat model.
SELECT
    flat_type,
    flat_model,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
GROUP BY flat_type, flat_model;

-- Select the average resale price by town and lease commence date, only for lease commence dates after year 2010, sorted by town (descending) and lease commence date (descending).
SELECT
    town,
    lease_commence_date,
    AVG(resale_price) AS avg_price
FROM resale_flat_prices_2017
WHERE lease_commence_date > 2010
GROUP BY town, lease_commence_date
ORDER BY town DESC, lease_commence_date DESC;

-- What happens if you forget the GROUP BY but use an AVG()?
SELECT AVG(resale_price) FROM resale_flat_prices_2017;

SELECT town, AVG(resale_price) FROM resale_flat_prices_2017;


-- CASE statement
SELECT
    town,
    resale_price,
    CASE
        WHEN resale_price > 1000000 THEN 'Million Dollar Club'
        WHEN resale_price > 500000 THEN 'Mid-Range'
        ELSE 'Entry-Level'
    END AS price_category
FROM resale_flat_prices_2017;

SELECT
    town,
    flat_type,
    CASE
        WHEN flat_type IN ('1 ROOM', '2 ROOM', '3 ROOM') THEN 'Small'
        WHEN flat_type = '4 ROOM' THEN 'Medium'
        ELSE 'Large'
    END AS flat_size
FROM resale_flat_prices_2017;
    
-- Design your own "budget/mid/high-end" categories based on resale_price.
SELECT
    town,
    resale_price,
    CASE
        WHEN resale_price > 1000000 THEN 'High-End'
        WHEN resale_price > 500000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_category
FROM resale_flat_prices_2017;
        
    
-- Design a "old vs new" label based on lease_commence_date.
SELECT
    town,
    lease_commence_date,
    CASE
        WHEN lease_commence_date BETWEEN 1990 AND 2010 THEN 'Mid-Age'
        ELSE 'New'
    END AS age_category
FROM resale_flat_prices_2017;
        
-- Casting Numbers
SELECT
    town,
    resale_price,
    -- CAST(resale_price AS INTEGER) AS resale_price_int
    resale_price::INTEGER AS resale_price_int
FROM resale_flat_prices_2017;
        
-- Casting Date
-- ANSI SQL Style (maximum portability)
SELECT
    month,
    -- 2017-01 concatenate with -01 becomes 2017-01-01
    CAST(month || '-01' AS DATE) AS transaction_date,
    EXTRACT(YEAR FROM CAST(month || '-01' AS DATE)) AS sale_year
FROM resale_flat_prices_2017;
    
-- DuckDB/PostgreSQL style
SELECT
    month,
    (month || '-01')::DATE AS transaction_date,
    date_part('year', (month || '-01')::DATE) AS sale_year
FROM resale_flat_prices_2017;

 