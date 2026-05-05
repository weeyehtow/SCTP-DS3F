SHOW TABLES; --display the names of all tables

SHOW ALL TABLES; --display detailed information of the tables (database,schema,name,column_names,column_types,temporary table status - not temporary, occupies local storage)

DESCRIBE address;
DESCRIBE car;
DESCRIBE claim;
DESCRIBE client;

SUMMARIZE address; --gives a quick summary incl descriptive statistics such as average, std dev, quartiles
SUMMARIZE car;
SUMMARIZE claim;
SUMMARIZE client;

--Exercise Writing JOIN statements
SELECT *
FROM claim --specify first table
INNER JOIN car ON claim.car_id = car.id; --do an inner join of claim to car table

SELECT * 
FROM claim
LEFT JOIN car on claim.id = car.id;

SELECT 
    car.id,
    claim.car_id,
    claim.id AS claim_id --to rename to prevent name conflict
FROM claim
RIGHT JOIN car on claim.car_id=car.id;

SELECT
    claim.id
FROM claim;

SELECT *
FROM claim;
FULL JOIN car on claim.car_id=car.id;

--exercise 3
SELECT
  cl.id, cl.claim_date, cl.claim_amt,
  c.car_type,
  cli.first_name, cli.last_name,
  a.city, a.state
FROM claim cl
INNER JOIN car c ON cl.car_id = c.id
INNER JOIN client cli ON cl.client_id = cli.id
INNER JOIN address a ON cli.address_id = a.id;

SELECT --statement to create running total(cummulative amount)
    id,
    claim_amt,
    SUM(claim_amt) OVER (ORDER BY id) AS running_total
FROM claim;

SELECT --partition statement --gives a claim breakdown by car + total claims made per car
    id,
    car_id,
    claim_amt,
    SUM(claim_amt) OVER (PARTITION BY car_id ORDER BY id) AS running_total 
FROM claim;

-- Exercise 4: Calculate a running total of insurance payouts over time (ordered by claim_date).

SELECT
    claim_date,
    claim_amt,
    SUM(claim_amt) OVER (ORDER BY claim_date) AS running_total
FROM claim;

--RANK
SELECT
    id,
    car_id,
    claim_amt,
    RANK() OVER (PARTITION BY car_id ORDER BY claim_amt DESC) as rank
FROM claim;