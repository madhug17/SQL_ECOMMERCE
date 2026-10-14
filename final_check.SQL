SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE' 
ORDER BY table_name;


SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payment', COUNT(*) FROM payment
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
ORDER BY table_name;

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items,
    (SELECT COUNT(*) FROM payment) AS payments;


SELECT
    p.product_id,
    p.product_name,
    i.stock_quantity,
    i.reorder_level
FROM products p
JOIN inventory i
    ON p.product_id = i.product_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity ASC;

--profit check 
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS estimated_profit
FROM order_items oi
JOIN products p
    ON p.product_id = oi.product_id
JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY estimated_profit DESC;
