EXPLAIN (ANALYZE,BUFFERS)
SELECT o.order_id,c.name FROM orders o 
JOIN customers c on o.customer_id = c.customer_id
WHERE o.status ='DELIVERED';
--BUFFERS → How PostgreSQL accessed database pages during execution.
--BUFFERS means how many database pages PostgreSQL accessed while running your query.

EXPLAIN ANALYZE
SELECT
    o.order_id,
    c.name
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status = 'DELIVERED';

EXPLAIN ANALYZE
SELECT
    o.order_id,
    c.name
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    o.order_id,
    c.name
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

--if i want to choose the nested loop then i will enable the hash and merge off
SET enable_hashjoin = off;
SET enable_mergejoin = off;
SET enable_nestloop= off;

--  for turning on we use have to reset it 

EXPLAIN ANALYZE
SELECT o.order_id , c.name
FROM orders o 
JOIN customers c 
ON o.customer_id = c.customer_id;

RESET enable_nestloop;

ANALYZE orders;

EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id
FROM orders
WHERE status = 'DELIVERED';

EXPLAIN (ANALYZE,BUFFERS)
SELECT order_id , order_date FROM orders
WHERE customer_id=1 AND status='DELIVERED';

EXPLAIN ANALYZE
SELECT *
FROM ORDERS;

EXPLAIN ANALYZE 
SELECT order_id FROM ORDERS