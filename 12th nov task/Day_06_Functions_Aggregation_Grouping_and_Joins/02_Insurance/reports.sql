USE day6_insurance;
-- 1. Policies expiring in next 30 days
SELECT policy_id,CONCAT('***',SUBSTRING(policy_number,-4)) AS masked_policy,end_date,
 DATEDIFF(end_date,CURRENT_DATE()) AS days_to_expiry
FROM policies WHERE end_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(),INTERVAL 30 DAY)
 AND status='ACTIVE';
-- 2. Premium per product
SELECT pr.product_name,ROUND(SUM(p.premium_amount),2) AS total_premium
FROM products pr JOIN policies p ON p.product_id=pr.product_id GROUP BY pr.product_id,pr.product_name;
-- 3. Customers with more than one active policy
SELECT c.customer_id,c.customer_name,COUNT(*) AS active_policy_count
FROM customers c JOIN policies p ON p.customer_id=c.customer_id WHERE p.status='ACTIVE'
GROUP BY c.customer_id,c.customer_name HAVING COUNT(*)>1;
-- 4. Claim ratio per product. Pre-aggregate claims per policy to prevent join fan-out.
SELECT pr.product_name,ROUND(100*SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0),2) AS claim_ratio_percent
FROM products pr JOIN policies p ON p.product_id=pr.product_id
LEFT JOIN (SELECT policy_id,SUM(claim_amount) AS claim_total FROM claims GROUP BY policy_id) pc
 ON pc.policy_id=p.policy_id GROUP BY pr.product_id,pr.product_name;
-- 5. Policies without claims
SELECT p.policy_id,p.policy_number FROM policies p LEFT JOIN claims cl ON cl.policy_id=p.policy_id
WHERE cl.claim_id IS NULL;
-- 6. Average premium by age band
SELECT CASE WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<30 THEN 'Under 30'
 WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<45 THEN '30-44'
 WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<60 THEN '45-59' ELSE '60+' END AS age_band,
 ROUND(AVG(p.premium_amount),2) AS average_premium
FROM customers c JOIN policies p ON p.customer_id=c.customer_id GROUP BY age_band;
-- 7. Monthly new policies
SELECT DATE_FORMAT(start_date,'%Y-%m') AS policy_month,COUNT(*) AS new_policies
FROM policies GROUP BY DATE_FORMAT(start_date,'%Y-%m') ORDER BY policy_month;
-- 8. Top five agents by premium
SELECT a.agent_id,UPPER(a.agent_name) AS agent_name,ROUND(SUM(p.premium_amount),2) AS premium_sold
FROM agents a JOIN policies p ON p.agent_id=a.agent_id GROUP BY a.agent_id,a.agent_name
ORDER BY premium_sold DESC LIMIT 5;
-- HAVING: products whose claim ratio exceeds 60 percent
SELECT pr.product_name,ROUND(100*SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0),2) AS ratio_percent
FROM products pr JOIN policies p ON p.product_id=pr.product_id
LEFT JOIN (SELECT policy_id,SUM(claim_amount) AS claim_total FROM claims GROUP BY policy_id) pc
 ON pc.policy_id=p.policy_id GROUP BY pr.product_id,pr.product_name
HAVING SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0)>0.60;
-- INNER JOIN: matching entities; LEFT JOIN: retain policies without claims; CROSS JOIN: product-period matrix.
SELECT pr.product_name,yr.report_year FROM products pr
CROSS JOIN (SELECT 2025 AS report_year UNION ALL SELECT 2026) yr;
