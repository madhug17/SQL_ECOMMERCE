
-- =====================================================
-- PROJECT: E-Commerce Sales & Inventory Management
-- FILE: 02_insert_data.sql
-- DATABASE: ecommerce_db
-- =====================================================

-- 1. CUSTOMERS
INSERT INTO customers
(customer_id, name, email, phone, city)
VALUES
(1, 'Rahul Sharma', 'rahul@example.com', '9000000001', 'Hyderabad'),
(2, 'Priya Reddy', 'priya@example.com', '9000000002', 'Warangal'),
(3, 'Arjun Kumar', 'arjun@example.com', '9000000003', 'Karimnagar'),
(4, 'Sneha Rao', 'sneha@example.com', '9000000004', 'Hyderabad'),
(5, 'Vikram Singh', 'vikram@example.com', '9000000005', 'Nizamabad')
ON CONFLICT DO NOTHING;


-- 2. CATEGORIES
INSERT INTO categories
(category_id, category_name)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books'),
(4, 'Home Appliances')
ON CONFLICT DO NOTHING;


-- 3. SUPPLIERS
INSERT INTO suppliers
(supplier_id, supplier_name, email, phone, city)
VALUES
(1, 'Tech World', 'tech@example.com', '9100000001', 'Hyderabad'),
(2, 'Fashion Hub', 'fashion@example.com', '9100000002', 'Warangal'),
(3, 'Book House', 'books@example.com', '9100000003', 'Vijayawada'),
(4, 'Home Needs', 'home@example.com', '9100000004', 'Hyderabad')
ON CONFLICT DO NOTHING;


-- 4. PRODUCTS
INSERT INTO products
(product_id, product_name, category_id, supplier_id, price, cost_price)
VALUES
(1, 'Laptop', 1, 1, 55000.00, 45000.00),
(2, 'Smartphone', 1, 1, 25000.00, 20000.00),
(3, 'T-Shirt', 2, 2, 600.00, 300.00),
(4, 'Jeans', 2, 2, 1200.00, 700.00),
(5, 'SQL Book', 3, 3, 500.00, 250.00),
(6, 'DBMS Book', 3, 3, 650.00, 350.00),
(7, 'Mixer Grinder', 4, 4, 3000.00, 2200.00),
(8, 'Air Fryer', 4, 4, 5000.00, 3800.00)
ON CONFLICT DO NOTHING;


-- 5. INVENTORY
INSERT INTO inventory
(inventory_id, product_id, stock_quantity, reorder_level)
VALUES
(1, 1, 10, 3),
(2, 2, 20, 5),
(3, 3, 50, 10),
(4, 4, 25, 8),
(5, 5, 30, 5),
(6, 6, 15, 5),
(7, 7, 8, 3),
(8, 8, 4, 5)
ON CONFLICT DO NOTHING;


-- 6. ORDERS
INSERT INTO orders
(order_id, customer_id, order_date, status)
VALUES
(1, 1, '2026-09-01', 'DELIVERED'),
(2, 2, '2026-09-03', 'DELIVERED'),
(3, 3, '2026-09-05', 'SHIPPED'),
(4, 4, '2026-09-07', 'PLACED'),
(5, 1, '2026-09-10', 'DELIVERED'),
(6, 5, '2026-09-12', 'CANCELLED')
ON CONFLICT DO NOTHING;


-- 7. ORDER ITEMS
INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 1, 55000.00),
(2, 1, 5, 2, 500.00),
(3, 2, 3, 3, 600.00),
(4, 2, 4, 1, 1200.00),
(5, 3, 2, 1, 25000.00),
(6, 4, 7, 1, 3000.00),
(7, 5, 6, 2, 650.00),
(8, 5, 8, 1, 5000.00),
(9, 6, 3, 2, 600.00)
ON CONFLICT DO NOTHING;


-- 8. PAYMENTS
-- Your existing table name is payment (singular).
INSERT INTO payment
(payment_id, order_id, amount, payment_method, payment_status)
VALUES
(1, 1, 56000.00, 'UPI', 'PAID'),
(2, 2, 3000.00, 'CARD', 'PAID'),
(3, 3, 25000.00, 'UPI', 'PAID'),
(4, 4, 3000.00, 'COD', 'PENDING'),
(5, 5, 6300.00, 'CARD', 'PAID'),
(6, 6, 1200.00, 'UPI', 'REFUNDED')
ON CONFLICT DO NOTHING;


-- 9. REVIEWS
INSERT INTO reviews
(review_id, customer_id, product_id, rating, review_text)
VALUES
(1, 1, 1, 5, 'Excellent laptop'),
(2, 2, 3, 4, 'Good quality'),
(3, 3, 2, 5, 'Great performance'),
(4, 4, 7, 3, 'Average product'),
(5, 1, 5, 4, 'Helpful book')
ON CONFLICT DO NOTHING;


-- =====================================================
-- VERIFY INSERTED DATA
-- =====================================================

SELECT 'customers' AS table_name, COUNT(*) AS total FROM customers
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
SELECT 'reviews', COUNT(*) FROM reviews;
