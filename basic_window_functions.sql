-- Showing the various Window Functions available with a use case for each

DROP TABLE IF EXISTS customer_sales;
CREATE TABLE customer_sales 
(
	customer_id CHAR(1) NOT NULL,
    sale_id INTEGER,
    sales INTEGER
);
 
INSERT INTO customer_sales
VALUES
('A', 1, 300),
('A', 1, 150),
('A', 2, 100),
('B', 1, 100),
('B', 1, 200),
('B', 2, 200),
('B', 3, 200);
 
SELECT * FROM customer_sales;

SELECT		customer_id,
			sale_id,
			sales,
            -- Sum of sales by customer_id and sale_id
			SUM(sales) OVER(
							PARTITION BY customer_id,
										 sale_id
                            ) AS 'sum_sales_cust&sale',
                            
			-- Sum of sales by customer_id
			SUM(sales) OVER(
							PARTITION BY customer_id
                            ) AS 'sum_customer_sales',
                            
			-- Sum of sales for all rows */
			SUM(sales) OVER() AS 'total_sales',
            
            -- Average sale by customer
            ROUND(AVG(sales) OVER(
									PARTITION BY customer_id
								 ), 2) AS 'Average_Customer_Sales',
                                 
			-- Rank the customer sales by size in descending order
			RANK() OVER(
						PARTITION BY customer_id
						ORDER BY sales DESC
                        ) AS 'Cust_Sale_Rank',
                        
			-- Dense Rank the customer sale by size in descending order
			DENSE_RANK() OVER(
							PARTITION BY customer_id
                            ORDER BY sales DESC
							 ) AS 'Cust_Sale_Dense_Rank',
                             
            -- Creating a Moving Average of 2 days                 
			AVG(sales) OVER(
							ORDER BY sales
                            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
						  )	AS two_day_moving_average,
                          
            -- Cumulative Sum of Sales              
			SUM(sales) OVER(
							ORDER BY sales
						   ) AS CUM
FROM		customer_sales;