USE day6_retail;
-- 1. Top five products by revenue
SELECT p.product_id, p.product_name, ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name ORDER BY revenue DESC LIMIT 5;
-- 2. Month-wise sales
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_sales
FROM orders o JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m') ORDER BY sales_month;
-- 3. Customers with more than three orders (HAVING)
SELECT c.customer_id, UPPER(c.customer_name) AS customer_name, COUNT(o.order_id) AS order_count
FROM customers c JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name HAVING COUNT(o.order_id) > 3;
-- 4. Average basket value per city
SELECT c.city, ROUND(AVG(t.order_value), 2) AS avg_basket_value
FROM customers c JOIN (
 SELECT o.order_id,o.customer_id,SUM(oi.quantity*oi.unit_price) AS order_value
 FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY o.order_id,o.customer_id
) t ON t.customer_id=c.customer_id
GROUP BY c.city ORDER BY avg_basket_value DESC;
-- 5. Orders without payment
SELECT o.order_id,CONCAT('ORDER-',o.order_id) AS order_reference,o.order_date,o.payment_status
FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.payment_status IS NULL OR o.payment_status <> 'PAID'
GROUP BY o.order_id,o.order_date,o.payment_status;
-- 6. Customers with no orders
SELECT c.customer_id,c.customer_name FROM customers c
LEFT JOIN orders o ON o.customer_id=c.customer_id WHERE o.order_id IS NULL;
-- 7. Product-category revenue share
SELECT p.category,ROUND(SUM(oi.quantity*oi.unit_price),2) AS category_revenue,
 ROUND(100*SUM(oi.quantity*oi.unit_price)/(SELECT SUM(quantity*unit_price) FROM order_items),2) AS revenue_share_percent
FROM products p JOIN order_items oi ON oi.product_id=p.product_id GROUP BY p.category;
-- 8. Day with highest sales
SELECT o.order_date,ROUND(SUM(oi.quantity*oi.unit_price),2) AS daily_sales
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
GROUP BY o.order_date ORDER BY daily_sales DESC LIMIT 1;
-- NULL demonstration: COUNT(*) counts rows; COUNT(column), SUM and AVG ignore NULL.
SELECT COUNT(*) AS all_rows,COUNT(payment_status) AS known_statuses,
 SUM(CASE WHEN payment_status IS NULL THEN 1 ELSE 0 END) AS null_status_rows FROM orders;
SELECT COUNT(payment_status) AS non_null_statuses,
 SUM(CASE WHEN payment_status IS NULL THEN 0 ELSE 1 END) AS non_null_sum,
 AVG(CASE WHEN payment_status IS NULL THEN NULL ELSE 1 END) AS avg_non_null_flag FROM orders;
-- WHERE filters rows before grouping; HAVING filters groups after aggregation.
