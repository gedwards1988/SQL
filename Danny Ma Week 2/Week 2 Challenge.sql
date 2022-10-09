-- 1. How many pizzas were ordered
SELECT      COUNT(*)

FROM        pizza_runner.customer_orders;


-- 2. How many unique customer orders were made?
SELECT      COUNT(DISTINCT order_id)

FROM        pizza_runner.customer_orders;


-- 3. How many successful orders were delivered by each runner?
SELECT      runner_id,
            COUNT(order_id)

FROM        pizza_runner.runner_orders

WHERE       pickup_time != 'null'

GROUP BY    1

ORDER BY    1;

-- 4. How many types of each pizza were delivered?
WITH cte AS 
(
  SELECT      customer_orders.order_id AS order_id,
              pizza_name,
              pickup_time
  
  FROM        pizza_runner.customer_orders
  INNER JOIN  pizza_runner.pizza_names
                ON pizza_names.pizza_id = customer_orders.pizza_id
  INNER JOIN  pizza_runner.runner_orders
                ON runner_orders.order_id = customer_orders.order_id
                
  WHERE       pickup_time != 'null'
)
SELECT      pizza_name,
            COUNT(order_id)
            
FROM        cte 

GROUP BY    1;

-- 5. How many vegetarian and Meatlovers were ordered by each customer?

SELECT      customer_id,
            SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
            SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
            
FROM pizza_runner.customer_orders

GROUP BY    1

ORDER BY    1;

-- 6. What is the maximum number of pizzas delivered in a single order?
WITH pizza_orders AS 
(
  SELECT        customer_orders.order_id AS order_id,
                pickup_time,
                COUNT(customer_orders.order_id) OVER (
                              PARTITION BY customer_orders.order_id)
                AS counts
    
  FROM        	pizza_runner.customer_orders
  INNER JOIN  	pizza_runner.runner_orders
					ON runner_orders.order_id = customer_orders.order_id
                  
  WHERE       	pickup_time != 'null'
)
SELECT      	MAX(counts) AS pizza_count

FROM        	pizza_orders;


