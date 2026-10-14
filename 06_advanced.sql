
-- STEP 1: View all indexes in the public schema
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- STEP 2: View indexes on the orders table
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'orders';

-- STEP 3: Create an index if a suitable one doesn't already exist
CREATE INDEX IF NOT EXISTS idx_orders_customer_id
ON orders (customer_id);

-- STEP 4: Analyze query execution
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 101;

SELECT COUNT(*) AS total_orders
FROM orders;

EXPLAIN ANALYZE
SELECT * 
FROM products
WHERE price> 1000;

EXPLAIN ANALYZE
SELECT product_id , product_name ,price
FROM products
WHERE price > 1000;

-- Helps to optimize the time and cost  replace the * with wanted columns and also use indexing to 
-- it can search more faster and easier 
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = '101'
    AND status = 'DELIVERED';


SELECT order_id,order_date
FROM orders
WHERE customer_id = '101'
    AND status = 'DELIVERED';

-- JOIN Query Optimizer
EXPLAIN ANALYZE
SELECT o.order_id , c.name FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'DELIVERED';

EXPLAIN ANALYZE -- option 2 is faster then 1 
SELECT o.order_id , c.name
FROM (
    SELECT order_id, customer_id
    FROM orders
    WHERE status = 'DELIVERED'
) o
JOIN customers c ON o.customer_id = c.customer_id;


--Group BY Optimizer
SELECT
    p.product_id,
    p.product_name,
    c.name AS customer_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    p.product_id,
    p.product_name,
    c.customer_id,
    c.name
ORDER BY total_units_sold DESC;



--indentify which one is best for our project 
EXPLAIN ANALYZE
SELECT product_id, sum(quantity)
FROM order_items
GROUP BY product_id;


SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT
    product_id,
    SUM(quantity) AS total_units_sold
FROM order_items
GROUP BY product_id;


--HASHIAGGREGATE 
EXPLAIN ANALYZE
SELECT product_id, sum(quantity) as su
FROM order_items
GROUP BY product_id;

SET enable_hashagg = on;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    product_id,
    SUM(quantity) AS total_units_sold
FROM order_items
GROUP BY product_id;

--groupaggregate 
SET enable_hashagg = off;
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    product_id,
    SUM(quantity) AS total_units_sold
FROM order_items
GROUP BY product_id;


--HAVING VS WHERE

--having is used for the filtering groups 
--where is used for filter before the groups

-- FILTER GROUP WHERE
SELECT product_id,sum(quantity) as total_mall
FROM order_items
where quantity >= 2
GROUP BY product_id;

--FILTER GROUP HAVING
SELECT
    product_id,
    SUM(quantity) AS total_units
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) >= 10;

---Can we use both together?
SELECT
    product_id,
    SUM(quantity) AS total_units
FROM order_items
WHERE quantity >= 2
GROUP BY product_id
HAVING SUM(quantity) >= 10
ORDER BY total_units DESC;



