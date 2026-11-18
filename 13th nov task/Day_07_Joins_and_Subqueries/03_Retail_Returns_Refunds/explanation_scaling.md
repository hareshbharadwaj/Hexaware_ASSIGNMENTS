# Retail Returns and Refunds – Explanation and Scaling Notes

## Query logic

- Return rate is calculated as returned quantity divided by sold quantity, multiplied by 100.
- Customers with a return but no refund are identified using `NOT EXISTS`.
- Refund totals are aggregated by store; stores without refunds remain in the output because the query uses LEFT JOIN.
- Employee/manager reporting uses a self join on `employees.manager_id`.
- `ANY` compares a store's refund total with at least one other store in the same region; `ALL` requires it to exceed every other store's total in that region.
- Two nested-query examples compare product return rates and store refund totals against overall averages.

## NOT IN and NULL

If a `NOT IN` subquery returns even one NULL, the predicate can evaluate to UNKNOWN and unexpectedly return no rows. `NOT EXISTS` expresses the anti-match condition without that problem.

## If data volume grows 100 times

1. Keep indexes on foreign keys and common join columns: store, order, product, return and refund IDs.
2. Add or evaluate composite indexes for frequent filters, such as `(status, refund_date)`, `(return_date, order_item_id)` and `(store_id, order_date)`.
3. Avoid wrapping indexed filter columns in functions; use range predicates where possible.
4. Use `EXPLAIN ANALYZE` to inspect actual row counts, access paths and execution time.
5. Aggregate returns/refunds once in derived tables or summary tables when several reports reuse the same totals.
6. Consider date/region partitioning only after measuring table size and query patterns.
7. Select only required columns instead of using `SELECT *`, and paginate detail reports.
8. Recheck the query plan after data growth; an index that helps a small sample may not be optimal at production scale.

## Execution results

The assignment requests execution results for the two nested subqueries. Their result sets depend on the database contents. Run `schema.sql`, `seed.sql` and `advanced_reports.sql` in MySQL 8.4, then capture the result grids from your own MySQL session rather than treating illustrative sample data as measured production output.
