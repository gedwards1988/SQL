-- 1. What is the total amount each customer spent at the restaurant?
SELECT      sales.customer_id,
            SUM(menu.price) AS total_sales
            
FROM        dannys_diner.sales
JOIN        dannys_diner.menu
            ON menu.product_id = sales.product_id
            
GROUP BY    1

ORDER BY    sales.customer_id;


-- 2. How many days has each customer visited the restaurant?
SELECT      sales.customer_id,
            COUNT (DISTINCT sales.order_date)
            
FROM        dannys_diner.sales

GROUP BY    1;


-- 3. What was the first item from the menu purchased by each customer?
WITH ordered_sales AS
(
    SELECT      DISTINCT customer_id,
                order_date,
                menu.product_name,
                RANK() OVER(PARTITION BY customer_id
                            ORDER BY order_date ASC) AS order_rank
    
    FROM        dannys_diner.sales
    INNER JOIN  dannys_diner.menu
                ON menu.product_id = sales.product_id
)
SELECT      customer_id,
            product_name
            
FROM        ordered_sales

WHERE       order_rank = 1

ORDER BY    1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT      menu.product_name,
            COUNT(sales.order_date) AS total_purchases

FROM        dannys_diner.menu
INNER JOIN  dannys_diner.sales
            ON sales.product_id = menu.product_id
            
GROUP BY    menu.product_name
            
ORDER BY    2 DESC

LIMIT       1;


-- 5. Which item was the most popular for each customer?
WITH cte AS 
(
  SELECT      sales.customer_id,
              menu.product_name,
              COUNT(sales.order_date) AS item_quantity,
              RANK() OVER(
                          PARTITION BY sales.customer_id
                          ORDER BY COUNT(sales.order_date) DESC
                          ) AS item_rank
            
  FROM        dannys_diner.sales
  INNER JOIN  dannys_diner.menu
              ON menu.product_id = sales.product_id
              
  GROUP BY    1, 2
)
SELECT        customer_id,
              product_name,
              item_quantity
              
FROM          cte 

WHERE         item_rank = 1;


-- 6. Which item was purchased first by the customer after they became a member?
WITH member_sales_cte AS 
(
  SELECT      sales.customer_id,
              sales.order_date,
              menu.product_name,
              RANK() OVER(
                          PARTITION BY sales.customer_id
                          ORDER BY sales.order_date
                          ) AS order_rank
  FROM        dannys_diner.sales
  INNER JOIN  dannys_diner.menu
              ON menu.product_id = sales.product_id
  INNER JOIN  dannys_diner.members
              ON members.customer_id = sales.customer_id
              
  WHERE       sales.order_date >= members.join_date
)
SELECT        customer_id,
              order_date,
              product_name
              
FROM          member_sales_cte

WHERE         order_rank = 1;

-- 7. Which item was purchased just before the customer became a member?
WITH member_sales_cte AS 
(
  SELECT      sales.customer_id,
              sales.order_date,
              menu.product_name,
              RANK() OVER(
                          PARTITION BY sales.customer_id
                          ORDER BY sales.order_date DESC
                          ) AS order_rank
  FROM        dannys_diner.sales
  INNER JOIN  dannys_diner.menu
              ON menu.product_id = sales.product_id
  INNER JOIN  dannys_diner.members
              ON members.customer_id = sales.customer_id
              
  WHERE       members.join_date > sales.order_date
)
SELECT        customer_id,
              order_date,
              product_name
              
FROM          member_sales_cte

WHERE         order_rank = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT      members.customer_id,
            COUNT(DISTINCT menu.product_name) AS unique_items,
            SUM(menu.price) as total_spent

FROM        dannys_diner.members
INNER JOIN  dannys_diner.sales
            ON members.customer_id = sales.customer_id
INNER JOIN  dannys_diner.menu
            ON menu.product_id = sales.product_id
            
WHERE       sales.order_date < members.join_date
            
GROUP BY    members.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
  SELECT      sales.customer_id,
              SUM(
                  CASE
                    WHEN menu.product_name = 'sushi' THEN menu.price * 10 * 2
                    ELSE menu.price * 10
                  END
                  ) AS points
  
  FROM        dannys_diner.sales
  LEFT JOIN   dannys_diner.menu
              ON menu.product_id = sales.product_id
              

  GROUP BY    1;
