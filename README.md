E-Commerce Sales & Inventory Management System (PostgreSQL)
A SQL portfolio project that models an e-commerce business and uses PostgreSQL to analyze sales, revenue, product profitability, customer orders, payments, reviews, and inventory levels.
Project Overview
This project demonstrates how a relational database can support day-to-day e-commerce operations and business reporting. It includes a multi-table schema, analytical SQL queries, indexing experiments, and query-plan inspection with PostgreSQL.
Objectives
- Design and query a relational database for an e-commerce business.
- Practice SQL from fundamentals through advanced querying.
- Analyze revenue, delivered orders, product sales, and estimated product profit.
- Identify inventory items at or below their reorder levels.
- Explore indexes and evaluate query plans using EXPLAIN ANALYZE.
Technology Stack
- Database: PostgreSQL
- SQL concepts: joins, aggregations, subqueries, CTEs, window functions
- Performance tools: indexes, EXPLAIN, EXPLAIN ANALYZE
- Editor: Visual Studio Code with a PostgreSQL-compatible SQL extension
Database Schema
The project uses these nine tables:
Table	Purpose
customers	Customer details and city
categories	Product category names
suppliers	Supplier contact and location details
products	Product details, category, supplier, selling price, and cost price
inventory	Stock quantity and reorder level
orders	Customer orders, dates, and order status
order_items	Products, quantities, and unit prices within each order
payment	Payment amount, method, status, and date
reviews	Customer ratings and product feedback


Main relationships
- A customer can place multiple orders.
- An order can contain multiple order items.
- Each order item references a product.
- Products can belong to a category and be associated with a supplier.
- Inventory records track stock for products.
- Payments are associated with orders.
- Reviews connect customers and products.
The exact constraints and cardinalities depend on the schema defined in the SQL scripts.

SQL Concepts Practiced
Fundamentals
- SELECT, WHERE, ORDER BY, DISTINCT
- Aggregate functions such as COUNT, SUM, and AVG
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
Advanced SQL
- Subqueries and correlated subqueries
- EXISTS and NOT EXISTS
- Common Table Expressions (CTEs) using WITH
- Window functions such as RANK() and ROW_NUMBER()
- Conditional filtering and multi-table analysis
Indexing and optimization
- B-tree indexes
- Hash indexes
- Composite indexes and leftmost-prefix behavior
- Query-plan analysis using EXPLAIN and EXPLAIN ANALYZE
- Understanding sequential scans, index scans, joins, sorting, and aggregation plans
- Refreshing planner statistics with ANALYZE
Business Questions
The SQL queries are intended to answer questions such as:
1. What is the total value of items ordered?
2. What is the revenue from delivered orders?
3. Which products have the highest units sold?
4. What is the estimated product-level profit?
5. Which products are at or below their reorder level?
6. How can customer orders and product performance be analyzed with joins and aggregations?
7. How does PostgreSQL execute selected queries, and which indexes may be useful?
Example Queries
Revenue from delivered orders
SELECT
    SUM(oi.quantity * oi.unit_price) AS delivered_revenue
FROM orders AS o
JOIN order_items AS oi
    ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED';
Best-selling products by units sold
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items AS oi
JOIN products AS p
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;
Products requiring restocking
SELECT
    p.product_id,
    p.product_name,
    i.stock_quantity,
    i.reorder_level
FROM products AS p
JOIN inventory AS i
    ON i.product_id = p.product_id
WHERE i.stock_quantity <= i.reorder_level
ORDER BY i.stock_quantity ASC;
Estimated profit by product
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS estimated_profit
FROM order_items AS oi
JOIN products AS p
    ON p.product_id = oi.product_id
JOIN orders AS o
    ON o.order_id = oi.order_id
WHERE o.status = 'DELIVERED'
GROUP BY p.product_id, p.product_name
ORDER BY estimated_profit DESC;
Calculation note: This is estimated product profit based on the stored cost price. It does not include shipping, taxes, discounts, returns, or other operating expenses. The revenue examples use order_items values; payment records are not used to calculate recognized or collected revenue.
Getting Started
1. Install PostgreSQL
Install PostgreSQL and ensure the PostgreSQL server is running. You can use Visual Studio Code with a PostgreSQL-compatible extension to execute the scripts.
2. Create a database
In PostgreSQL, create a database:
CREATE DATABASE ecommerce_db;
Connect to ecommerce_db before running the project scripts.
3. Run the SQL files in order
Use the actual filenames in this repository. A typical execution order is:
1. Schema/table creation script
2. Sample data or seed script
3. Business analysis query scripts
4. Index creation script
5. Query optimization and EXPLAIN ANALYZE experiments
If the scripts use a different order or filenames, follow the dependencies in those scripts.
4. Verify the tables
SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
5. Inspect a query plan
EXPLAIN ANALYZE
SELECT
    o.order_id,
    o.customer_id,
    o.order_date
FROM orders AS o
WHERE o.status = 'DELIVERED';
EXPLAIN ANALYZE executes the query and reports the actual plan and timing. Use it carefully with statements that modify data; for read-only analysis, start with SELECT queries.
Suggested Repository Structure
Adapt this structure to match the SQL files you actually created:
ecommerce-sales-inventory-sql/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_basic_queries.sql
│   ├── 04_joins_and_aggregations.sql
│   ├── 05_advanced_sql.sql
│   ├── 06_business_analysis.sql
│   ├── 07_indexes.sql
│   └── 08_query_optimization.sql
└── screenshots/
    └── query-results.png
Only include filenames and screenshots that exist in your repository. If your scripts are currently stored at the root, you can move them into sql/ and update the names above.
Key Learning Outcomes
- Translating business questions into SQL queries.
- Joining related tables using primary-key and foreign-key relationships.
- Summarizing transactional data with aggregates and window functions.
- Identifying low-stock products from inventory data.
- Understanding how index type and column order affect potential query usage.
- Reading PostgreSQL execution plans and using measurements rather than assumptions to assess query performance.
Limitations and Future Improvements
- Add data validation and constraints where appropriate.
- Add more representative sample data and document how it was generated.
- Compare query plans before and after selected indexes using the same data and query.
- Add date-based sales trends, customer retention analysis, and category-level performance reports.
- Evaluate payment status and refunds separately from order-item revenue.
- Add automated database setup and repeatable validation scripts.
Author
Madhu Goud
GitHub: madhug17