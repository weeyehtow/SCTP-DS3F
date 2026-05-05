/*----------------------------------------------------------------
-- CTE 1: avg_by_car_type
-- For each car type (e.g. SUV, Pickup), calculate the average
-- claim amount filed across all claims involving that car type.
-- This gives us a market benchmark to compare individual claims against.
-- ----------------------------------------------------------------*/

WITH avg_by_car_type AS (
    SELECT
        car.car_type,  -- The category of car (e.g. SUV, Minivan)
        AVG(claim.claim_amt) AS avg_claim_amt -- Average claim amount for that car type
    FROM claim
    JOIN car ON claim.car_id = car.id -- Link each claim to its corresponding car
    GROUP BY car.car_type -- Calculate one average per car type
),

/* ----------------------------------------------------------------
-- CTE 2: client_totals
-- For each client, add up all their claim amounts into a single
-- total. Also attach their full name, state, and car type so we
-- have everything needed for the final report in one place.
-- ----------------------------------------------------------------*/
client_totals AS (
    SELECT
        claim.client_id, -- Unique ID to identify the client
        client.first_name || ' ' || client.last_name AS client_name, -- Combine first and last name into one full name column
        address.state, -- The state the client lives in
        car.car_type,  -- The type of car involved in their claims
        SUM(claim.claim_amt) AS total_claimed -- Add up all claim amounts for this client
    FROM claim
    JOIN client  ON claim.client_id   = client.id -- Connect each claim to the client who filed it
    JOIN address ON client.address_id = address.id -- Connect each client to their home address
    JOIN car     ON claim.car_id      = car.id -- Connect each claim to the car it was filed for
    GROUP BY  -- Group so that SUM() totals per unique client
        claim.client_id,
        client.first_name,
        client.last_name,
        address.state,
        car.car_type
),
/* ----------------------------------------------------------------
-- CTE 3: state_ranked
-- Within each state, rank clients from highest to lowest total
-- claim amount. Then use QUALIFY to keep only the top 2 clients
-- per state — these are the highest-risk clients in each region.
-- ----------------------------------------------------------------*/
state_ranked AS (
    SELECT
        client_name,
        state,
        car_type,
        total_claimed,
        RANK() OVER (
            PARTITION BY state -- Restart the ranking for each new state
            ORDER BY total_claimed DESC -- Rank from highest claim amount to lowest
        ) AS state_rank
    FROM client_totals
)
/*----------------------------------------------------------------
-- FINAL OUTPUT
-- Pull the finished report from the state_ranked CTE.
-- Each row represents one of the top 2 claiming clients in a state.
-- Results are sorted alphabetically by state, then by rank within it.
-- ----------------------------------------------------------------*/

SELECT
    client_name, -- Full name of the client
    state, -- State they are based in
    car_type,  -- Type of car involved in their claims
    total_claimed, -- Their total claim amount across all filed claims
    state_rank -- Their rank within their state (1 = highest claimer)
FROM state_ranked
WHERE state_rank <= 2 -- Keep only rank 1 and rank 2 per state
ORDER BY state, state_rank -- Sort alphabetically by state first then by state rank