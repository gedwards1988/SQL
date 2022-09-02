-- Moving Averages
WITH moving_average AS 
(
  SELECT      market_date,
              volume,
              AVG(volume) OVER(
                                ORDER BY market_date
                                RANGE BETWEEN '7 DAYS' PRECEDING
                                AND
                                '1 DAY' PRECEDING
                              ) AS last_7_day_avg
  FROM        daily_polka   
)

SELECT      market_date,
            volume,
            ROUND(COALESCE(last_7_day_avg, 0)) AS "7_day_avg",
			
            CASE
                WHEN volume > last_7_day_avg THEN 1 ELSE 0
            END AS higher_volume,
			
            CASE
                WHEN volume > last_7_day_avg THEN 'Higher'
                WHEN volume = last_7_day_avg THEN 'Equal'
                WHEN volume < last_7_day_avg THEN 'Lower'
            END AS volume_status
            
FROM        moving_average;




