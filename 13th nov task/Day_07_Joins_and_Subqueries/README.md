# Day 7 – Joins and Subqueries (MySQL 8.4 LTS)

This folder contains a runnable practice implementation for the three business sets in the Hexaware Day 7 assignment.

## Folder layout

- `01_Logistics/` – hubs, carriers, customers, employees, shipments and delivery events.
- `02_Bank_Loan_Portfolio/` – branches, customers, employees, loans, repayments and guarantors.
- `03_Retail_Returns_Refunds/` – stores, regions, employees, products, orders, returns and refunds.

Each set has:
- `schema.sql` – creates and selects its own database and tables.
- `seed.sql` – inserts a small, deterministic sample dataset.
- `advanced_reports.sql` – joins, self joins, IN/EXISTS/NOT EXISTS, ANY/ALL, nested queries and explanatory comments.

## Run order

Use MySQL 8.4 LTS. Execute each set independently and in this order:

1. Open the relevant `schema.sql`.
2. Run `seed.sql`.
3. Run `advanced_reports.sql`.

Example using the MySQL command-line client:

```bash
mysql -u root -p < 01_Logistics/schema.sql
mysql -u root -p < 01_Logistics/seed.sql
mysql -u root -p < 01_Logistics/advanced_reports.sql
```

Repeat for the other two folders. Each schema uses a separate database, so the sets do not overwrite one another.

## Important implementation notes

- The assignment provides business questions, not a prescribed relational schema or sample rows. The schemas and seed records here are an explicit, practical model created to make every report executable.
- The queries use the table and column names defined in the matching `schema.sql`.
- MySQL supports `ANY` and `ALL` with subqueries. The examples are written for MySQL 8.4.
- The bank 60-day repayment report uses `CURRENT_DATE`; its result changes with the date on which it is executed.
- A `NOT IN` subquery can return UNKNOWN when its result contains NULL. A corresponding `NOT EXISTS` query is included as the safe alternative.
- The assignment asks for query execution results and performance comparisons. Those depend on the local dataset and indexes; run the scripts in MySQL to capture your actual output and use `EXPLAIN ANALYZE` for measured comparisons.

