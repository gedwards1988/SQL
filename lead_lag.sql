--1. Data before and after a null value
SELECT    *

FROM      trading.daily_btc

WHERE     market_date BETWEEN ('2020-04-17'::DATE -1)
                              AND
                              ('2020-04-17'::DATE +1);
                              
--2. LAG/LEAD to fill missing values
SELECT    market_date,
          open_price,
          LAG(open_price, 1) OVER(
                                  ORDER BY market_date
                                  ) AS lag_open_price,
          -- Using future data to predict previous value                        
          LEAD(open_price, 1) OVER(
                                  ORDER BY market_date DESC
                                  ) AS lead_open_price

FROM      trading.daily_btc

WHERE     market_date BETWEEN ('2020-04-17'::DATE -1)
                              AND
                              ('2020-04-17'::DATE +1);
-- Whenever you need a previous rows with time based data
-- use LAG and order ASC

-- 3. COALESCE to update Null Rows
WITH april_17_data AS
(
  SELECT    market_date,
            open_price,
            LAG(open_price, 1) OVER(
                                    ORDER BY market_date ASC
                                    )AS lag_open_price
  
  FROM      trading.daily_btc
  
  WHERE     market_date BETWEEN ('2020-04-17'::DATE -1)
                              AND
                              ('2020-04-17'::DATE +1)
)
SELECT      market_date,
            open_price,
            lag_open_price,
            COALESCE(open_price, lag_open_price) AS coalesce_open_price
            
FROM        april_17_data;


-- 4a) Running total using self join (1.351 Seconds - 2553 Rows)
SELECT      t1.market_date,
            t1.volume,
            SUM(t2.volume) AS running_total
            
FROM        trading.daily_btc t1
INNER JOIN  trading.daily_btc t2
              ON t1.market_date >= t2.market_date
              
GROUP BY    1,2

ORDER BY    1,2;


-- 4b) Running Total Using Window Function (0.031 seconds - 2553 rows)
SELECT		market_date,
			volume,
            SUM(volume) OVER(
							ORDER BY market_date ASC
                            ) AS running_total
                            
FROM		trading.daily_btc;












