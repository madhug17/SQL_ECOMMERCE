SELECT p.product_id , p.product_name FROM products p 
where NOT EXISTS(
    SELECT 1 FROM order_items oi 
    where  oi.product_id = p.product_id
);
