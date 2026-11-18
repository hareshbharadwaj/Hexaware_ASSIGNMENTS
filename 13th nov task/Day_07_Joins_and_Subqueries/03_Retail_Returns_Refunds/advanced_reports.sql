USE day7_retail_returns;

-- 1. Products with return rate above 10 percent (returned units / sold units).
SELECT p.product_id,p.product_name,
       SUM(r.return_quantity) AS returned_units,
       SUM(oi.quantity) AS sold_units,
       ROUND(100.0*SUM(r.return_quantity)/NULLIF(SUM(oi.quantity),0),2) AS return_rate_percent
FROM products p
JOIN order_items oi ON oi.product_id=p.product_id
LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
GROUP BY p.product_id,p.product_name
HAVING return_rate_percent>10;

-- 2. Customers with returns but no refund record (NOT EXISTS).
SELECT DISTINCT c.customer_id,c.customer_name
FROM customers c
JOIN orders o ON o.customer_id=c.customer_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN returns r ON r.order_item_id=oi.order_item_id
WHERE NOT EXISTS (SELECT 1 FROM refunds f WHERE f.return_id=r.return_id);

-- 3. Stores ranked by total refund value; top store shown first.
SELECT s.store_id,s.store_name,COALESCE(SUM(f.refund_amount),0) AS total_refund_value
FROM stores s
LEFT JOIN orders o ON o.store_id=s.store_id
LEFT JOIN order_items oi ON oi.order_id=o.order_id
LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
LEFT JOIN refunds f ON f.return_id=r.return_id
GROUP BY s.store_id,s.store_name
ORDER BY total_refund_value DESC;

-- 4. Employees and their managers (self join).
SELECT e.employee_name AS employee,m.employee_name AS manager,s.store_name
FROM employees e
LEFT JOIN employees m ON m.employee_id=e.manager_id
JOIN stores s ON s.store_id=e.store_id;

-- 5. Order details with customer, store and product (INNER JOIN).
SELECT o.order_id,c.customer_name,s.store_name,p.product_name,
       oi.quantity,oi.unit_price
FROM orders o
JOIN customers c ON c.customer_id=o.customer_id
JOIN stores s ON s.store_id=o.store_id
JOIN order_items oi ON oi.order_id=o.order_id
JOIN products p ON p.product_id=oi.product_id;

-- 6. Return and refund status details (LEFT JOIN preserves returns without refunds).
SELECT r.return_id,p.product_name,r.return_date,
       f.refund_amount,f.status,f.refund_date
FROM returns r
JOIN order_items oi ON oi.order_item_id=r.order_item_id
JOIN products p ON p.product_id=oi.product_id
LEFT JOIN refunds f ON f.return_id=r.return_id;

-- 7. Stores with no returns.
SELECT s.store_id,s.store_name
FROM stores s
WHERE NOT EXISTS (
  SELECT 1 FROM orders o
  JOIN order_items oi ON oi.order_id=o.order_id
  JOIN returns r ON r.order_item_id=oi.order_item_id
  WHERE o.store_id=s.store_id
);

-- 8. Customer order counts, including customers with no orders.
SELECT c.customer_name,COUNT(o.order_id) AS order_count
FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name;

-- 9. Refunds pending processing.
SELECT r.return_id,p.product_name,f.refund_amount,f.status
FROM refunds f
JOIN returns r ON r.return_id=f.return_id
JOIN order_items oi ON oi.order_item_id=r.order_item_id
JOIN products p ON p.product_id=oi.product_id
WHERE f.status='PENDING';

-- 10. Store-level order counts, including empty stores.
SELECT s.store_name,COUNT(o.order_id) AS order_count
FROM stores s LEFT JOIN orders o ON o.store_id=s.store_id
GROUP BY s.store_id,s.store_name;

-- NOT IN NULL pitfall: if the subquery returns a NULL customer_id, NOT IN can return no rows.
-- The column is NOT NULL in this sample schema, but the demonstration shows the general hazard.
SELECT customer_id,customer_name
FROM customers
WHERE customer_id NOT IN (SELECT CAST(NULL AS SIGNED) UNION SELECT customer_id FROM orders);
-- Correct equivalent using NOT EXISTS.
SELECT c.customer_id,c.customer_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.customer_id=c.customer_id
);

-- ANY: stores whose refund total is greater than at least one other store in the same region.
WITH store_refunds AS (
  SELECT s.store_id,s.store_name,s.region_id,COALESCE(SUM(f.refund_amount),0) AS refund_total
  FROM stores s
  LEFT JOIN orders o ON o.store_id=s.store_id
  LEFT JOIN order_items oi ON oi.order_id=o.order_id
  LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
  LEFT JOIN refunds f ON f.return_id=r.return_id
  GROUP BY s.store_id,s.store_name,s.region_id
)
SELECT sr.store_name,sr.refund_total,sr.region_id
FROM store_refunds sr
WHERE sr.refund_total > ANY (
  SELECT other.refund_total FROM store_refunds other
  WHERE other.region_id=sr.region_id AND other.store_id<>sr.store_id
);

-- ALL: stores whose refund total is greater than every other store in the same region.
WITH store_refunds AS (
  SELECT s.store_id,s.store_name,s.region_id,COALESCE(SUM(f.refund_amount),0) AS refund_total
  FROM stores s
  LEFT JOIN orders o ON o.store_id=s.store_id
  LEFT JOIN order_items oi ON oi.order_id=o.order_id
  LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
  LEFT JOIN refunds f ON f.return_id=r.return_id
  GROUP BY s.store_id,s.store_name,s.region_id
)
SELECT sr.store_name,sr.refund_total,sr.region_id
FROM store_refunds sr
WHERE sr.refund_total > ALL (
  SELECT other.refund_total FROM store_refunds other
  WHERE other.region_id=sr.region_id AND other.store_id<>sr.store_id
);

-- Nested subquery 1: products whose return rate is above the overall average product return rate.
SELECT product_name
FROM products
WHERE product_id IN (
  SELECT product_id FROM (
    SELECT oi.product_id,
           SUM(COALESCE(r.return_quantity,0))/NULLIF(SUM(oi.quantity),0) AS rate
    FROM order_items oi
    LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
    GROUP BY oi.product_id
  ) product_rates
  WHERE rate > (
    SELECT AVG(rate_value) FROM (
      SELECT SUM(COALESCE(r2.return_quantity,0))/NULLIF(SUM(oi2.quantity),0) AS rate_value
      FROM order_items oi2
      LEFT JOIN returns r2 ON r2.order_item_id=oi2.order_item_id
      GROUP BY oi2.product_id
    ) all_rates
  )
);

-- Nested subquery 2: stores whose total refunds exceed the average store refund total.
SELECT store_name
FROM stores
WHERE store_id IN (
  SELECT store_id FROM (
    SELECT s.store_id,COALESCE(SUM(f.refund_amount),0) AS refund_total
    FROM stores s
    LEFT JOIN orders o ON o.store_id=s.store_id
    LEFT JOIN order_items oi ON oi.order_id=o.order_id
    LEFT JOIN returns r ON r.order_item_id=oi.order_item_id
    LEFT JOIN refunds f ON f.return_id=r.return_id
    GROUP BY s.store_id
  ) totals
  WHERE refund_total > (
    SELECT AVG(refund_total) FROM (
      SELECT s2.store_id,COALESCE(SUM(f2.refund_amount),0) AS refund_total
      FROM stores s2
      LEFT JOIN orders o2 ON o2.store_id=s2.store_id
      LEFT JOIN order_items oi2 ON oi2.order_id=o2.order_id
      LEFT JOIN returns r2 ON r2.order_item_id=oi2.order_item_id
      LEFT JOIN refunds f2 ON f2.return_id=r2.return_id
      GROUP BY s2.store_id
    ) avg_totals
  )
);

-- Scaling note (100x data): retain FK/join indexes, index date/status filter columns,
-- avoid functions on indexed columns in WHERE, inspect EXPLAIN ANALYZE, and consider
-- summary tables/materialized reporting pipelines for repeatedly calculated return rates.
-- Join choice: INNER requires matching business records; LEFT preserves parent rows;
-- self join relates employees to managers; NOT EXISTS safely expresses anti-joins.
