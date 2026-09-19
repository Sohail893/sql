 /*Write a query using a scalar subquery that returns all products with a list_price'
 above the average price in their brand.
 Use a correlated subquery in WHERE.*/
 SELECT product_name ,list_price from production.products
 where list_price > (select avg(list_price) from
 production.products);

 /*Write a query using IN that returns all orders placed by customers living in New York or California.*/
 SELECT * FROM sales.customers;
 SELECT * FROM sales.orders;

 SELECT order_id  , customer_id, order_date from sales.orders
 where customer_id in (SELECT customer_id from sales.customers where state in( 'NY','CA'));

 /*The following query is meant to find customers who never ordered, but has a NULL trap. Fix it:

SELECT customer_id FROM sales.customers
WHERE customer_id NOT IN (SELECT customer_id FROM sales.orders);
*/
SELECT customer_id FROM sales.customers 
where  NOT EXISTS ( SELECT customer_id from sales.orders);



SELECT customer_id FROM sales.customers
where NOT EXISTS ( SELECT 1 from sales.orders);

/*Using a derived table in FROM, write a query that 
finds the average number of items per order across all orders.*/

  SELECT AVG(item_count) AS average_items_per_order
FROM (
    SELECT 
        order_id,
        COUNT(item_id) AS item_count
    FROM sales.order_items
    GROUP BY order_id
) AS item_order_counts;

/*Rewrite the EXISTS example from section 8.6 using IN instead. Which version is safer and why?*/

/*Customers who placed at least one order in 20178*/

SELECT *
FROM sales.customers
WHERE customer_id IN (
    SELECT customer_id
    FROM sales.orders
    WHERE YEAR(order_date) = 2018
);

/*The EXISTS version is generally safer when NULL values may be involved,
especially when using NOT IN. EXISTS checks whether a matching row exists,
so it does not have the same NULL problem as NOT IN.*/

/*Use CROSS APPLY to return the top 3 most recent orders for each customer.
Show customer_id, first_name, order_id, and order_date.*/
SELECT * FROM sales.orders
SELECT * from sales.customers;

SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM sales.customers c
CROSS APPLY (
    SELECT TOP 3
        order_id,
        order_date
    FROM sales.orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC
) o
ORDER BY c.customer_id ,o.order_date DESC;



