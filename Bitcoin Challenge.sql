-- 1. What is the earliest and latest market_date values?
SELECT      MIN(market_date) AS earliest_date,
            MAX(market_date) AS latest_date
            
FROM        trading.daily_btc;


-- 2. What was the historic all-time high and low values for the close_price and their dates?
(
SELECT      market_date,
            close_price
            
FROM        trading.daily_btc

WHERE       close_price IS NOT NULL

ORDER BY    close_price DESC

LIMIT 1
)
UNION
(
SELECT      market_date,
            close_price
            
FROM        trading.daily_btc

WHERE       close_price IS NOT NULL

ORDER BY    close_price

LIMIT 1
);

-- 3. Which date had the most volume traded and what was the close_price for that day?
SELECT      market_date,
            close_price,
            volume
            
FROM        trading.daily_btc

WHERE       volume IS NOT NULL

ORDER BY    volume DESC

LIMIT       1;


-- 4. How many days had a low_price price which was 10% less than the open_price?
--    And what percentage of the total number o trading days is this (not including
--    days with volume = NULL)
WITH cte AS
(
SELECT      SUM(CASE WHEN 100 * (open_price - low_price) / open_price >= 10 THEN 1 ELSE 0 END) AS low_open_10,
            SUM(CASE WHEN volume IS NOT NULL THEN 1 ELSE 0 END) AS total_days
            
FROM        trading.daily_btc
)
SELECT      low_open_10,
            total_days,
            100 * low_open_10 / total_days AS percent
            
FROM        cte;


-- 5 What percentage of days have a higher close_price than open_price?
with cte AS
(
SELECT      SUM(CASE WHEN close_price > open_price THEN 1 ELSE 0 END) AS open_close,
            COUNT(*) AS total_days
            
FROM        trading.daily_btc

WHERE       volume IS NOT NULL
)
SELECT      open_close, 
            total_days,
            ROUND(100 * open_close / total_days::FLOAT) AS percent

FROM        cte;


-- 6 What was the largest difference between high_price and low_price and 
--   which date did it occur?
SELECT      market_date,
            high_price,
            low_price,
            high_price - low_price AS delta,
            RANK() OVER(
                        ORDER BY high_price - low_price DESC NULLS LAST
                        ) AS delta_rank

FROM        trading.daily_btc

LIMIT       1;


-- 7. If you invested $10,000 on the 1st January 2016 - how much is your investment 
--    worth in 1st of January 2021 and what is your total growth of your investment 
--    as a percentage of your original investment? Use the `close_price` for this calculation.
WITH start_bitcoin AS 
(
SELECT      10000 / close_price AS bitcoin_volume,
            close_price AS start_price
FROM        trading.daily_btc
WHERE       market_date = '2016-01-01'
),
bitcoin_investment AS 
(
SELECT      close_price AS end_price
FROM        trading.daily_btc
WHERE       market_date = '2021-01-01'
)
SELECT      bitcoin_volume,
            start_price,
            end_price,
            ROUND(100 * (end_price - start_price) / start_price) AS ROI,
            ROUND(bitcoin_volume * end_price) AS final_investment
            
FROM        start_bitcoin
CROSS JOIN  bitcoin_investment;