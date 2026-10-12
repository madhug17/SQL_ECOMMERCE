
-- ==========================================
-- SQL 07: INDEXING IN POSTGRESQL
-- ==========================================

-- 1. B-tree index on customer email
CREATE INDEX IF NOT EXISTS idx_customers_email
ON customers USING BTREE (email);

-- 2. B-tree index on product price
CREATE INDEX IF NOT EXISTS idx_product_pricing
ON products USING BTREE (price);

-- 3. Composite index on customer and order status
CREATE INDEX IF NOT EXISTS idx_orders_customer_status
ON orders (customer_id, status);

-- 4. Hash index on customer email
CREATE INDEX IF NOT EXISTS idx_customers_email_hash
ON customers USING HASH (email);

-- 5. Composite index for customer order history
CREATE INDEX IF NOT EXISTS idx_orders_customer_date
ON orders (customer_id, order_date DESC);

-- 6. Index for product sales analysis
CREATE INDEX IF NOT EXISTS idx_order_items_product
ON order_items (product_id);

-- 7. Index for inventory lookup
CREATE INDEX IF NOT EXISTS idx_inventory_product
ON inventory (product_id);


-- ==========================================
-- TEST 1: Search customer by email
-- ==========================================

EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE email = 'rahul@example.com';


-- ==========================================
-- TEST 2: Search products by price range
-- ==========================================

EXPLAIN ANALYZE
SELECT *
FROM products
WHERE price BETWEEN 200 AND 5000;


-- ==========================================
-- TEST 3: Find delivered orders for a customer
-- ==========================================

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 101
  AND status = 'DELIVERED';


-- ==========================================
-- TEST 4: Customer order history
-- ==========================================

EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 101
ORDER BY order_date DESC;


-- ==========================================
-- TEST 5: Total units sold per product
-- ==========================================

--EXPLAIN ANALYZE
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

