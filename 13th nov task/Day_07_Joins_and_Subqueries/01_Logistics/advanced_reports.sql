USE day7_logistics;

-- 1. Shipments delivered more than two days after the promised date (INNER JOIN).
SELECT s.shipment_id,c.customer_name,ca.carrier_name,h.hub_name AS origin_hub,
       s.promised_at,s.delivered_at,
       DATEDIFF(s.delivered_at,s.promised_at) AS delay_days
FROM shipments s
JOIN customers c ON c.customer_id=s.customer_id
JOIN carriers ca ON ca.carrier_id=s.carrier_id
JOIN hubs h ON h.hub_id=s.origin_hub_id
WHERE s.delivered_at IS NOT NULL
  AND DATEDIFF(s.delivered_at,s.promised_at)>2;

-- 2. Every hub, including hubs with no outbound shipments (LEFT JOIN).
SELECT h.hub_id,h.hub_name,COUNT(s.shipment_id) AS outbound_shipments
FROM hubs h LEFT JOIN shipments s ON s.origin_hub_id=h.hub_id
GROUP BY h.hub_id,h.hub_name ORDER BY h.hub_id;

-- 3. Employees and their supervisors (self join).
SELECT e.employee_name AS employee,sp.employee_name AS supervisor
FROM employees e LEFT JOIN employees sp ON sp.employee_id=e.supervisor_id
ORDER BY e.employee_id;

-- 4. All hubs and any shipments originating there (RIGHT JOIN).
SELECT h.hub_name,s.shipment_id,s.shipping_cost
FROM shipments s RIGHT JOIN hubs h ON h.hub_id=s.origin_hub_id
ORDER BY h.hub_id,s.shipment_id;

-- 5. Shipment with customer, carrier and destination details (INNER JOIN).
SELECT s.shipment_id,c.customer_name,ca.carrier_name,
       d.hub_name AS destination,s.shipping_cost
FROM shipments s
JOIN customers c ON c.customer_id=s.customer_id
JOIN carriers ca ON ca.carrier_id=s.carrier_id
JOIN hubs d ON d.hub_id=s.destination_hub_id;

-- 6. Delivery-event history for each shipment (LEFT JOIN retains shipments without events).
SELECT s.shipment_id,e.event_type,e.event_at,e.notes
FROM shipments s LEFT JOIN delivery_events e ON e.shipment_id=s.shipment_id
ORDER BY s.shipment_id,e.event_at;

-- 7. Shipments handled by employees at a specified hub (INNER JOIN).
SELECT s.shipment_id,e.employee_name,h.hub_name
FROM shipments s JOIN employees e ON e.employee_id=s.employee_id
JOIN hubs h ON h.hub_id=e.hub_id
WHERE h.hub_name='Chennai Central';

-- 8. Customer shipment counts, including customers with no shipments (LEFT JOIN).
SELECT c.customer_name,COUNT(s.shipment_id) AS shipment_count
FROM customers c LEFT JOIN shipments s ON s.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name ORDER BY c.customer_id;

-- 9. All carrier records and their shipment counts (LEFT JOIN).
SELECT ca.carrier_name,COUNT(s.shipment_id) AS shipment_count
FROM carriers ca LEFT JOIN shipments s ON s.carrier_id=ca.carrier_id
GROUP BY ca.carrier_id,ca.carrier_name;

-- 10. Pairs of employees working at the same hub (self join; avoid duplicate pairs).
SELECT h.hub_name,e1.employee_name AS employee_1,e2.employee_name AS employee_2
FROM employees e1 JOIN employees e2
  ON e1.hub_id=e2.hub_id AND e1.employee_id<e2.employee_id
JOIN hubs h ON h.hub_id=e1.hub_id;

-- Customers who shipped to every hub (double NOT EXISTS / relational division).
SELECT c.customer_id,c.customer_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM hubs h
  WHERE NOT EXISTS (
    SELECT 1 FROM shipments s
    WHERE s.customer_id=c.customer_id AND s.destination_hub_id=h.hub_id
  )
);

-- Carriers whose average delivery delay exceeds the overall average delay (ANY).
SELECT ca.carrier_name,AVG(DATEDIFF(s.delivered_at,s.promised_at)) AS avg_delay_days
FROM carriers ca JOIN shipments s ON s.carrier_id=ca.carrier_id
WHERE s.delivered_at IS NOT NULL
GROUP BY ca.carrier_id,ca.carrier_name
HAVING AVG(DATEDIFF(s.delivered_at,s.promised_at)) > ANY (
  SELECT AVG(DATEDIFF(delivered_at,promised_at))
  FROM shipments WHERE delivered_at IS NOT NULL
  GROUP BY carrier_id
);

-- ALL example: carriers whose average shipping cost exceeds every other carrier's average.
SELECT ca.carrier_name,AVG(s.shipping_cost) AS avg_cost
FROM carriers ca JOIN shipments s ON s.carrier_id=ca.carrier_id
GROUP BY ca.carrier_id,ca.carrier_name
HAVING AVG(s.shipping_cost) >= ALL (
  SELECT AVG(s2.shipping_cost) FROM shipments s2
  GROUP BY s2.carrier_id
);

-- IN example: customers with at least one shipment delivered late.
SELECT customer_name FROM customers
WHERE customer_id IN (
  SELECT customer_id FROM shipments
  WHERE delivered_at IS NOT NULL AND delivered_at>promised_at
);

-- EXISTS example: hubs that have at least one outbound shipment.
SELECT h.hub_name FROM hubs h
WHERE EXISTS (SELECT 1 FROM shipments s WHERE s.origin_hub_id=h.hub_id);

-- Rewrite pair A: subquery form.
SELECT customer_name FROM customers
WHERE customer_id IN (SELECT customer_id FROM shipments WHERE shipping_cost>800);
-- Equivalent JOIN form. DISTINCT prevents duplicate customer rows.
SELECT DISTINCT c.customer_name
FROM customers c JOIN shipments s ON s.customer_id=c.customer_id
WHERE s.shipping_cost>800;
-- Compare with EXPLAIN ANALYZE on the same server/data; readability and speed are data/optimizer dependent.
EXPLAIN ANALYZE
SELECT customer_name FROM customers
WHERE customer_id IN (SELECT customer_id FROM shipments WHERE shipping_cost>800);
EXPLAIN ANALYZE
SELECT DISTINCT c.customer_name
FROM customers c JOIN shipments s ON s.customer_id=c.customer_id
WHERE s.shipping_cost>800;

-- Rewrite pair B: EXISTS form.
SELECT h.hub_name FROM hubs h
WHERE EXISTS (SELECT 1 FROM shipments s WHERE s.origin_hub_id=h.hub_id);
-- Equivalent JOIN form.
SELECT DISTINCT h.hub_name FROM hubs h
JOIN shipments s ON s.origin_hub_id=h.hub_id;

-- Second-highest distinct shipping cost per hub (nested correlated subquery).
SELECT h.hub_name,
       (SELECT MAX(s1.shipping_cost)
        FROM shipments s1
        WHERE s1.origin_hub_id=h.hub_id
          AND s1.shipping_cost < (
            SELECT MAX(s2.shipping_cost)
            FROM shipments s2 WHERE s2.origin_hub_id=h.hub_id
          )) AS second_highest_shipping_cost
FROM hubs h;

-- Join-choice table (assignment explanation):
-- INNER: matching shipment/customer/carrier/hub rows are required.
-- LEFT: preserve every parent customer, hub, carrier or shipment even when no child row exists.
-- RIGHT: preserve every hub while matching outbound shipments; equivalent LEFT JOIN is often clearer.
-- SELF: employees are related to other employees as supervisors or colleagues.
