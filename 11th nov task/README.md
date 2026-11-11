# Hexaware Day 5 — Databases, Normalisation and Data Definition
**Date:** 11 November 2026  
**Database:** MySQL 8.4 LTS

## Main solution
- `Day_05_Database_Normalisation_Solutions.pdf` — complete written solutions for all three sets.

## Set 1 — Retail Inventory
- `Set1_Retail_Inventory_schema.sql` — table definitions and constraints.
- `Set1_Retail_Inventory_seed_data.sql` — sample rows.
- `Set1_Retail_Inventory.sql` — combined schema, seed and examples.
- `Set1_Retail_Inventory_operations.sql` — UPDATE/DELETE and metadata queries.
- `Set1_Retail_Inventory_ER.mmd` — ER diagram source.
- `Set1_Retail_Failing_Inserts.sql` — four intentional constraint failures.

## Set 2 — Bank Branch Accounts
- `Set2_Bank_Branch_Accounts_schema.sql`
- `Set2_Bank_Branch_Accounts_seed_data.sql`
- `Set2_Bank_Branch_Accounts.sql` — combined script with CRUD, DDL and retrieval.
- `Set2_Bank_Branch_Accounts_operations.sql`
- `Set2_Bank_Accounts_ER.mmd`

## Set 3 — Hospital Patient Records
- `Set3_Hospital_Patient_Records_schema.sql`
- `Set3_Hospital_Patient_Records_seed_data.sql`
- `Set3_Hospital_Patient_Records.sql` — combined script with CRUD, database administration and retrieval.
- `Set3_Hospital_Patient_Records_operations.sql`
- `Set3_Hospital_Records_ER.mmd`

## Run order
For each set, run the schema file first, then its seed_data file. Alternatively, use the combined SQL file. Run the failing-inserts file one statement at a time. ER files are Mermaid ER diagram source and can be rendered in Mermaid-compatible viewers.

## Evidence note
The scripts and diagram sources are included. Capture actual MySQL 8.4 execution screenshots for successful operations and deliberate errors; no screenshots are fabricated.
