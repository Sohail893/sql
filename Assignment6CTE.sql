--CTE Question
--Rewrite this derived table query as a CTE:

SELECT AVG(order_count) AS avg_orders
FROM (
    SELECT store_id, COUNT(*) AS order_count
    FROM sales.orders
    GROUP BY store_id
) AS store_counts;

WITH order_per_store AS (

  SELECT 
  store_id, 
  count(*) AS order_count 
  FROM sales.orders
  GROUP BY store_id
)
SELECT  AVG(order_count) AS avg_order_per_store 
FROM order_per_store;

/*Write a CTE called cte_high_value_products that returns products with list_price > 2000. 
Then query the CTE to return only 
Mountain Bikes from that list, joining to production.categories.*/

WITH cte_high_value_products as (
SELECT 
p.category_id,
p.product_name,
p.list_price

 FROM production.products as p
 where p.list_price >2000
 )
SELECT
     hvp.product_name,
     hvp.list_price,
     c.category_name
  from cte_high_value_products as hvp
  inner join production.categories as c
  on hvp.category_id = c.category_id
  where c.category_name = 'Mountain Bikes';

/*Write two CTEs in one WITH clause: one that counts orders per customer,
and one that sums revenue per customer. Join them in the outer query to return customer_id, 
order_count, and total_revenue side by side.*/


SELECT * FROM sales.customers;
SELECT * FROM sales.orders;
--

WITH order_counts AS (
    SELECT
        customer_id,
        COUNT(order_id) AS order_count
    FROM sales.orders
    GROUP BY customer_id
),

customer_revenue AS (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.orders AS o
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)

SELECT
    oc.customer_id,
    oc.order_count,
    cr.total_revenue
FROM order_counts AS oc
INNER JOIN customer_revenue AS cr
    ON oc.customer_id = cr.customer_id;

/*Using a recursive CTE, generate a list of numbers from 1 to 10.
Each row should have the number and its square (n * n).*/

  WITH cte_numbers (n, square) AS (
    SELECT 1, 1 * 1              -- anchor: starts from 1

    UNION ALL

    SELECT n + 1, (n + 1) * (n + 1)
    FROM cte_numbers
    WHERE n < 10                 -- termination: stop at 10
)
SELECT n, square
FROM cte_numbers;

/*Using the recursive CTE org chart from section 9.6.2 as a starting point, modify 
it to also show the manager's first_name alongside each employee. 
Add a level column (0 for the top manager,
1 for their direct reports, 2 for the next level down).*/

 WITH cte_org AS (
    -- Anchor: top manager
    SELECT 
        staff_id,
        first_name,
        manager_id,
        null as manager_name,
        0 as level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: direct reports
    SELECT 
        e.staff_id,
        e.first_name,
        e.manager_id,
        o.first_name AS manager_name,
        o.level + 1 
    FROM sales.staffs e
    INNER JOIN cte_org o
        ON o.staff_id = e.manager_id
)
SELECT *
FROM cte_org;