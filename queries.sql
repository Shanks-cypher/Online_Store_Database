USE online_store;

-- 1. Show all customers
SELECT * FROM customers;

-- 2. Low stock products (<20)
SELECT product_id, name, stock_quantity
FROM products
WHERE stock_quantity < 20;

-- 3. Orders with customer information
SELECT o.order_id, c.name AS customer_name, o.order_date, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 4. Total revenue
SELECT SUM(amount) AS total_revenue FROM payments;

-- 5. Revenue per customer
SELECT c.name, SUM(p.amount) AS revenue_generated
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id;

-- 6. Products most sold
SELECT pr.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
GROUP BY pr.product_id
ORDER BY units_sold DESC;

-- 7. Detailed invoice for each order
SELECT o.order_id, c.name, pr.name AS product, oi.quantity, oi.subtotal
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
JOIN customers c ON o.customer_id = c.customer_id;
