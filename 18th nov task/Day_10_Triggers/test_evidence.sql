-- Day 10 test evidence. Run after triggers.sql. Expected-error statements
-- raise SQLSTATE 45000; execute them separately to capture the error.

-- SET 1: RETAIL
USE day10_retail;
DELETE FROM price_audit; DELETE FROM product_price;
INSERT INTO product_price VALUES
(1,'Keyboard',500,650),(2,'Mouse',200,280),(3,'Monitor',5000,6200);
UPDATE product_price SET selling_price=675 WHERE product_id=1;
SELECT * FROM price_audit ORDER BY audit_id;
UPDATE product_price SET selling_price=selling_price+10 WHERE product_id IN (2,3);
SELECT * FROM price_audit ORDER BY audit_id;
-- Expected failure: below-cost update.
UPDATE product_price SET selling_price=450 WHERE product_id=1;
SELECT TRIGGER_NAME,EVENT_MANIPULATION,EVENT_OBJECT_TABLE,ACTION_TIMING,ACTION_STATEMENT
FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA='day10_retail';

-- SET 2: BANK
USE day10_bank;
DELETE FROM account_transaction_audit; DELETE FROM account_transaction; DELETE FROM accounts;
INSERT INTO accounts(account_id,account_type,balance) VALUES
(101,'SAVINGS',1000),(102,'SAVINGS',1500),(103,'SAVINGS',500),
(104,'SAVINGS',800),(105,'SAVINGS',1200);
INSERT INTO account_transaction(txn_id,account_id,txn_type,amount,txn_time) VALUES
(1001,101,'CREDIT',100,'2026-10-14 09:00:00'),
(1002,102,'DEBIT',50,'2026-10-14 09:10:00');
UPDATE account_transaction SET amount=60 WHERE txn_id=1002;
DELETE FROM account_transaction WHERE txn_id=1001;
SELECT * FROM account_transaction_audit ORDER BY audit_id;
SELECT account_id,last_txn_date FROM accounts ORDER BY account_id;
-- Expected failure: savings account cannot be negative.
UPDATE accounts SET balance=-1 WHERE account_id=101;
-- Batch test: account 103 violates. InnoDB rolls back all five row changes
-- from this one UPDATE statement; earlier transaction statements remain pending.
START TRANSACTION;
UPDATE accounts SET balance=CASE account_id
 WHEN 101 THEN 1100 WHEN 102 THEN 1600 WHEN 103 THEN -10
 WHEN 104 THEN 900 WHEN 105 THEN 1300 END
WHERE account_id IN (101,102,103,104,105);
SELECT account_id,balance FROM accounts ORDER BY account_id;
ROLLBACK;

-- SET 3: HOSPITAL
USE day10_hospital;
DELETE FROM admission_audit; DELETE FROM admission; DELETE FROM ward;
INSERT INTO ward VALUES(1,'General',2),(2,'ICU',1);
INSERT INTO admission(admission_id,patient_name,ward_id) VALUES
(2001,'Patient A',1),(2002,'Patient B',1);
-- Expected failure: ward is full.
INSERT INTO admission(admission_id,patient_name,ward_id) VALUES(2003,'Patient C',1);
UPDATE admission SET patient_name='Patient A Updated' WHERE admission_id=2001;
DELETE FROM admission WHERE admission_id=2002;
SELECT * FROM admission_audit ORDER BY audit_id;
-- Multi-row INSERT: second ICU row exceeds capacity. InnoDB rolls back the
-- entire INSERT statement, including the first row from that same statement.
INSERT INTO admission(admission_id,patient_name,ward_id) VALUES
(2101,'ICU Patient 1',2),(2102,'ICU Patient 2',2);
SELECT * FROM admission WHERE ward_id=2;
SELECT * FROM admission_audit ORDER BY audit_id;
