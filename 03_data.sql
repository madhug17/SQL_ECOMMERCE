
-- ============================================
-- E-COMMERCE PROJECT
-- SQL 04: BUSINESS LOGIC AND REUSABLE QUERIES
-- Database: ecommerce_db (PostgreSQL)
-- ============================================


-- 1. COUNT ORDERS PER CUSTOMER
SELECT
    c.customer_id,
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;


-- 2. CUSTOMER AND PRODUCT DETAILS
SELECT
    c.name AS customer_name,
    p.product_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.status <> 'CANCELLED'
GROUP BY
    c.customer_id,
    c.name,
    p.product_id,
    p.product_name
ORDER BY total_orders DESC;


-- 3. TOTAL QUANTITY SOLD PER PRODUCT
-- Exclude cancelled orders
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;


-- 4. TOTAL SALES PER PRODUCT
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_sales DESC;


-- 5. PRODUCTS WITH MORE THAN 2 UNITS SOLD
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 2
ORDER BY total_sales DESC;


-- 6. PRODUCTS WITH SALES ABOVE ₹5,000
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY total_sales DESC;


-- 7. LOW-STOCK PRODUCT ALERT
SELECT
    p.product_id,
    p.product_name,
    i.stock_quantity,
    i.reorder_level,
    CASE
        WHEN i.stock_quantity <= i.reorder_level
            THEN 'LOW STOCK'
        ELSE 'STOCK AVAILABLE'
    END AS stock_status
FROM products p
JOIN inventory i
    ON p.product_id = i.product_id
ORDER BY i.stock_quantity ASC;


-- 8. PRODUCT PROFIT ANALYSIS
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    SUM(oi.quantity * (oi.unit_price - p.cost_price))
        AS estimated_profit
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY estimated_profit DESC;


-- 9. CREATE A REUSABLE VIEW FOR PRODUCT SALES
CREATE OR REPLACE VIEW product_sales_view AS
SELECT
    p.product_id,
    p.product_name,
    o.order_id,
    o.status,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS sales_amount
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id;


-- 10. USE THE VIEW TO GET TOTAL SALES PER PRODUCT
SELECT
    product_id,
    product_name,
    SUM(sales_amount) AS total_sales
FROM product_sales_view
WHERE status <> 'CANCELLED'
GROUP BY product_id, product_name
ORDER BY total_sales DESC;


-- 11. USE THE VIEW TO FIND PRODUCTS WITH MORE THAN 2 UNITS SOLD
SELECT
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM product_sales_view
WHERE status <> 'CANCELLED'
GROUP BY product_id, product_name
HAVING SUM(quantity) > 2
ORDER BY total_quantity_sold DESC;


-- 12. ORDER STATUS SUMMARY
SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;


-- 13. REVENUE BY CUSTOMER
SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_purchase_amount
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.customer_id, c.name
ORDER BY total_purchase_amount DESC;


-- 14. AVERAGE PRODUCT RATING
SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(r.review_id) AS total_reviews
FROM products p
LEFT JOIN reviews r
    ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC NULLS LAST;


-- 15. FINAL INVENTORY REPORT
SELECT
    p.product_name,
    i.stock_quantity,
    i.reorder_level,
    CASE
        WHEN i.stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN i.stock_quantity <= i.reorder_level THEN 'REORDER'
        ELSE 'IN STOCK'
    END AS inventory_status
FROM products p
JOIN inventory i
    ON p.product_id = i.product_id
ORDER BY i.stock_quantity ASC;
