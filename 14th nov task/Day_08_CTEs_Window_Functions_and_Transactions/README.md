# Day 8 – CTEs, Window Functions and Transactions
**MySQL 8.4 LTS**

This folder contains runnable examples for the three Day 8 business scenarios: bank funds transfer, airline seat booking, and retail inventory reservation.

## Structure
- `01_Bank_Funds_Transfer/` – schema, seed data, transfer/rollback/savepoint demonstrations, CTE statement and isolation notes.
- `02_Airline_Seat_Booking/` – schema, seed data, row-locking transaction, fare ranking, running revenue and correlated average fare.
- `03_Retail_Inventory_Reservation/` – schema, seed data, reservation/rollback transaction, category stock comparison, top-three sales and month-on-month reports.

## Run order
For each folder, execute `schema.sql`, then `seed.sql`, then the report/transaction scripts in the README or file comments. Use a MySQL 8.4 server. All transactional tables use InnoDB.

**Important:** Transaction and concurrency demonstrations are deliberately split into scripts and session notes. Run the two-session experiments in two separate MySQL clients; a single session cannot demonstrate blocking/isolation behaviour. Check `ROW_COUNT()` after conditional updates and issue ROLLBACK in the application when the expected row count is not returned.

The assignment provides business tasks rather than a fixed schema, so the table designs and sample records are illustrative implementations. PDF solutions are not included in this folder; add the supplied PDF separately if binary uploads are available.
