# Hexaware — Day 5 Assignment

**Date:** 11 November 2026  
**Track:** Java Track — Databases, Normalisation and Data Definition  
**Database:** MySQL 8.4 LTS  
**Prepared by:** Haresh Bharadwaj R (192321037)

## Assignment sets

### Set 1 — Retail Inventory Management
- Normalisation to 3NF and insert/update/delete anomalies
- ER model: Supplier, Category, Warehouse, Product and Inventory
- InnoDB schema with primary/foreign keys, UNIQUE, CHECK, DEFAULT and referential actions
- Ten sample records per table and four intentionally invalid INSERT examples
- Supplier UPDATE, discontinued SKU DELETE, before/after SELECT
- System schemas and information_schema table metadata

### Set 2 — Bank Branch Accounts
- 3NF/BCNF decomposition, candidate keys and key selection
- AUTO_INCREMENT identifiers, unique account numbers and DECIMAL money values
- DELETE vs TRUNCATE vs DROP and AUTO_INCREMENT behaviour
- CRUD and retrieval using AND, OR, IN, BETWEEN and LIKE
- ALTER TABLE: add KYC status, rename manager table and drop a CHECK constraint

### Set 3 — Hospital Patient Records
- 3NF decomposition into Patient, Doctor, Department, Visit and Billing
- Valid visit date, non-negative bill amount and default OPEN status
- Database creation, table rename, DROP and recreation
- CRUD, monthly patient visits and doctors by department
- SQL vs NoSQL comparison

## Files

| File | Description |
|---|---|
| `Set1_Retail_Inventory.sql` | Retail inventory schema, seed data and task queries |
| `Set2_Bank_Branch_Accounts.sql` | Bank accounts schema, seed data, DDL and retrieval |
| `Set3_Hospital_Patient_Records.sql` | Hospital records schema, seed data and queries |

## Run

Open the required SQL file in MySQL Workbench (MySQL 8.4) and execute it. Run each set independently. The intentionally failing INSERT examples in Set 1 are commented out; uncomment and execute them one at a time to capture the expected constraint errors.

**Evidence note:** SQL scripts and the solution write-up are provided as reproducible work. Screenshots of successful and deliberately failing database execution must be captured from an actual local MySQL 8.4 instance; they are not fabricated.
