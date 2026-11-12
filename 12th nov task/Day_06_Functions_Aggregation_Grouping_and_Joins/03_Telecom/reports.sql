USE day6_telecom;
-- 1. Total call minutes per plan
SELECT p.plan_name,ROUND(SUM(cr.duration_minutes),2) AS total_call_minutes
FROM plans p JOIN subscribers s ON s.plan_id=p.plan_id
JOIN call_records cr ON cr.subscriber_id=s.subscriber_id GROUP BY p.plan_id,p.plan_name;
-- 2. Subscribers exceeding data limit
SELECT s.subscriber_id,s.subscriber_name,s.data_limit_gb,ROUND(SUM(du.data_used_gb),2) AS used_gb
FROM subscribers s JOIN data_usage du ON du.subscriber_id=s.subscriber_id
GROUP BY s.subscriber_id,s.subscriber_name,s.data_limit_gb HAVING SUM(du.data_used_gb)>s.data_limit_gb;
-- 3. Month-wise billed revenue
SELECT DATE_FORMAT(invoice_date,'%Y-%m') AS revenue_month,ROUND(SUM(amount),2) AS billed_revenue
FROM invoices GROUP BY DATE_FORMAT(invoice_date,'%Y-%m') ORDER BY revenue_month;
-- 4. Unpaid invoices overdue by more than 15 days
SELECT invoice_id,CONCAT('INVOICE-',SUBSTRING(invoice_number,-3)) AS display_invoice,due_date,
 DATEDIFF(CURRENT_DATE(),due_date) AS days_overdue FROM invoices
WHERE paid_date IS NULL AND DATEDIFF(CURRENT_DATE(),due_date)>15;
-- 5. Subscribers with no usage
SELECT s.subscriber_id,s.subscriber_name FROM subscribers s LEFT JOIN data_usage du
 ON du.subscriber_id=s.subscriber_id WHERE du.usage_id IS NULL;
-- 6. ARPU by circle
SELECT s.circle,ROUND(SUM(i.amount)/COUNT(DISTINCT s.subscriber_id),2) AS arpu
FROM subscribers s LEFT JOIN invoices i ON i.subscriber_id=s.subscriber_id GROUP BY s.circle;
-- 7. Plan popularity
SELECT p.plan_name,COUNT(s.subscriber_id) AS subscriber_count FROM plans p
LEFT JOIN subscribers s ON s.plan_id=p.plan_id GROUP BY p.plan_id,p.plan_name ORDER BY subscriber_count DESC;
-- 8. Top ten data consumers
SELECT s.subscriber_id,s.subscriber_name,ROUND(SUM(du.data_used_gb),2) AS total_data_gb
FROM subscribers s JOIN data_usage du ON du.subscriber_id=s.subscriber_id
GROUP BY s.subscriber_id,s.subscriber_name ORDER BY total_data_gb DESC LIMIT 10;
-- NULL handling: SUM/AVG ignore NULL; COALESCE can convert a NULL aggregate to zero.
SELECT s.subscriber_id,SUM(du.data_used_gb) AS raw_sum,AVG(du.data_used_gb) AS raw_average,
 COALESCE(SUM(du.data_used_gb),0) AS sum_with_zero,COALESCE(AVG(du.data_used_gb),0) AS average_with_zero
FROM subscribers s LEFT JOIN data_usage du ON du.subscriber_id=s.subscriber_id GROUP BY s.subscriber_id;
-- Revenue per plan and circle with a join and aggregate
SELECT p.plan_name,s.circle,ROUND(SUM(i.amount),2) AS revenue
FROM plans p JOIN subscribers s ON s.plan_id=p.plan_id
JOIN invoices i ON i.subscriber_id=s.subscriber_id GROUP BY p.plan_id,p.plan_name,s.circle;
-- COUNT(*) counts joined rows; COUNT(column) counts non-NULL values.
