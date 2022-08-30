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