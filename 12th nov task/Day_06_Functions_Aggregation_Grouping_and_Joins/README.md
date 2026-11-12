# Hexaware Java Track – Day 6 SQL Assignment
**Topic:** Functions, Aggregation, Grouping and Joins – MySQL 8.4 LTS

## Assignment sets
1. Retail Sales Reporting
2. Insurance Policy Reporting
3. Telecom Usage and Billing

## Folder structure
- `01_Retail/` – schema, sample seed data and eight reporting queries.
- `02_Insurance/` – schema, sample seed data and eight reporting queries.
- `03_Telecom/` – schema, sample seed data and eight reporting queries.
- Downloadable black-and-white PDF solution is provided with the assignment deliverables.

## Run
Use MySQL 8.4 LTS. For each set, execute in order: `schema.sql`, `seed.sql`, then `reports.sql`.

Example:
```bash
mysql -u root -p < 01_Retail/schema.sql
mysql -u root -p < 01_Retail/seed.sql
mysql -u root -p < 01_Retail/reports.sql
```

## Important assumptions
The assignment brief names the business tables and reporting requirements but does not provide physical schemas or sample rows. The included schemas and sample data are illustrative, created to make the SQL runnable. Date-relative reports use `CURRENT_DATE()` and will change with the execution date. Monetary totals are based on `quantity * unit_price` for retail and `amount` / `premium_amount` for the other sets.

## SQL concepts demonstrated
`UPPER`, `CONCAT`, `DATEDIFF`, `DATE_FORMAT`, `ROUND`, `DATE_ADD`, `CASE`, `SUBSTRING`, `IFNULL`/`COALESCE`, `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, `INNER JOIN`, `LEFT JOIN`, and `CROSS JOIN`.
