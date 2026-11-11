USE bank_branch;
SELECT * FROM accounts WHERE account_number='AC100001';
UPDATE accounts SET balance=balance+500 WHERE account_number='AC100001';
DELETE FROM accounts WHERE account_number='AC100009';
SELECT a.account_number,c.customer_name,b.branch_name,t.type_name,a.opened_on,a.balance FROM accounts a JOIN customers c ON a.customer_id=c.customer_id JOIN branches b ON a.branch_id=b.branch_id JOIN account_types t ON a.account_type_id=t.account_type_id WHERE a.opened_on BETWEEN '2026-10-01' AND '2026-12-31' AND a.balance>20000 AND (t.type_name IN ('SAVINGS','SALARY') OR c.customer_name LIKE 'A%');
CREATE TABLE ddl_test(id INT AUTO_INCREMENT PRIMARY KEY,note VARCHAR(40)) ENGINE=InnoDB;
INSERT INTO ddl_test(note) VALUES ('first'),('second');
DELETE FROM ddl_test WHERE id=1;
INSERT INTO ddl_test(note) VALUES ('after delete');
TRUNCATE TABLE ddl_test;
INSERT INTO ddl_test(note) VALUES ('after truncate');
DROP TABLE ddl_test;
ALTER TABLE accounts ADD COLUMN kyc_status ENUM('PENDING','VERIFIED','REJECTED') NOT NULL DEFAULT 'PENDING';
RENAME TABLE relationship_managers TO account_managers;
-- Inspect CHECK name before dropping; substitute the returned name below.
SELECT CONSTRAINT_NAME,CONSTRAINT_TYPE FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA='bank_branch' AND TABLE_NAME='accounts';