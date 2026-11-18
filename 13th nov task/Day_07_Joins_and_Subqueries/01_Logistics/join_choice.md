# Logistics – Join Choice Table

| Question / report | Join type | Why it is appropriate |
|---|---|---|
| Delayed shipments with customer, carrier and origin hub | INNER JOIN | A delayed shipment report needs matching customer, carrier and hub records. |
| Outbound shipment count for every hub | LEFT JOIN | Keeps hubs with zero outbound shipments in the result. |
| Employee and supervisor names | LEFT self join | Both roles are rows in the employee table; LEFT keeps top-level employees with no supervisor. |
| All hubs with outbound shipment details | RIGHT JOIN | Preserves every hub even when no shipment originates there. A LEFT JOIN with hubs first is an equivalent, often clearer alternative. |
| Shipment, customer, carrier and destination details | INNER JOIN | Only complete matching shipment relationships are relevant. |
| Delivery-event history for every shipment | LEFT JOIN | Shipments without any event record must still appear. |
| Shipments handled by employees at a selected hub | INNER JOIN | Requires a matching employee and hub. |
| Shipment count for every customer | LEFT JOIN | Retains customers who have never shipped. |
| Shipment count for every carrier | LEFT JOIN | Retains carriers with no shipments. |
| Employee pairs at the same hub | Self join | Compares two employee rows from the same table; employee IDs prevent duplicate/reversed pairs. |

The assignment asks for a comparison of two subqueries rewritten as joins. The SQL file includes both forms and `EXPLAIN ANALYZE` statements. The more readable form depends on the report; actual speed must be measured on the same MySQL server and dataset because the optimizer may transform equivalent queries.
