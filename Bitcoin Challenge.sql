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