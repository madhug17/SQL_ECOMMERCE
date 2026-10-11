SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

SELECT customer_id, email FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM ORDERS
);


WITH product_sales AS (
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
)
SELECT
    product_name,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
    DENSE_RANK() OVER(ORDER BY total_sales DESC) AS sales_dense_rank
FROM product_sales
WHERE total_sales > 5000
ORDER BY total_sales DESC;


SELECT 
    product_id, 
    product_name,
    price, 
    CASE 
        WHEN price > 5000 THEN 'expensive'
        WHEN price = 2500 THEN 'medium'
        WHEN price > 200 THEN 'low cost'
        ELSE 'affordable' 
    END AS price_category 
FROM products 
ORDER BY price DESC;

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;

SELECT c.customer_id , c.name ,sum(oi.quantity*oi.unit_price) as total
from customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi on oi.order_id = o.order_id
WHERE o.status <> 'CANCELLED'
GROUP BY c.customer_id,c.name
Having sum(oi.quantity*oi.unit_price) > 10000
ORDER BY total DESC;