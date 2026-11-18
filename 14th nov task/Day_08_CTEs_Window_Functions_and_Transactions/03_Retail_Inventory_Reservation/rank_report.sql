USE day8_retail;

-- Products with stock below the average stock of their own category.
SELECT p.product_id,p.product_name,p.category,p.stock
FROM products p
WHERE p.stock < (
 SELECT AVG(x.stock) FROM products x WHERE x.category=p.category
);

-- Top three products by confirmed sales in each category.
WITH ranked AS (
 SELECT p.category,p.product_id,p.product_name,
        SUM(ol.qty) AS units_sold,
        ROW_NUMBER() OVER(
          PARTITION BY p.category
          ORDER BY SUM(ol.qty) DESC,p.product_id
        ) AS row_num
 FROM products p
 JOIN order_lines ol ON ol.product_id=p.product_id
 JOIN orders o ON o.order_id=ol.order_id AND o.status='CONFIRMED'
 GROUP BY p.category,p.product_id,p.product_name
)
SELECT category,product_id,product_name,units_sold
FROM ranked WHERE row_num<=3
ORDER BY category,row_num;

-- Month-on-month product sales change using LAG and LEAD.
SELECT product_id,sale_month,units,
       LAG(units) OVER(PARTITION BY product_id ORDER BY sale_month) AS previous_month_units,
       units-LAG(units) OVER(PARTITION BY product_id ORDER BY sale_month) AS change_from_previous,
       LEAD(units) OVER(PARTITION BY product_id ORDER BY sale_month) AS next_month_units
FROM sales
ORDER BY product_id,sale_month;
