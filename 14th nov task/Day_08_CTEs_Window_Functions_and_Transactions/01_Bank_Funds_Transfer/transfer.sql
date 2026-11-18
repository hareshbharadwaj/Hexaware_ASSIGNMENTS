USE day8_bank;

-- Successful transfer. Execute as one script in a client that stops on SQL errors.
-- Lock both accounts in a consistent order to reduce deadlock risk.
START TRANSACTION;
SELECT account_id,balance,status
FROM accounts
WHERE account_id IN (1,2)
ORDER BY account_id
FOR UPDATE;

-- Validate in the application: both rows exist, both are ACTIVE,
-- amount is positive, source has sufficient funds.
UPDATE accounts
SET balance=balance-1000.00
WHERE account_id=1 AND status='ACTIVE' AND balance>=1000.00;
-- Inspect ROW_COUNT(); if it is not 1, issue ROLLBACK and stop.
SELECT ROW_COUNT() AS debit_rows_changed;

UPDATE accounts
SET balance=balance+1000.00
WHERE account_id=2 AND status='ACTIVE';
SELECT ROW_COUNT() AS credit_rows_changed;

INSERT INTO bank_txns(from_id,to_id,amount,description)
VALUES(1,2,1000.00,'Funds transfer');
COMMIT;

-- Verify balances and ledger.
SELECT * FROM accounts ORDER BY account_id;
SELECT * FROM bank_txns ORDER BY txn_id;

-- Deliberate failure simulation: destination 999 does not exist.
-- The debit occurs, credit affects zero rows, so rollback is required.
START TRANSACTION;
UPDATE accounts SET balance=balance-500.00
WHERE account_id=1 AND status='ACTIVE' AND balance>=500.00;
SELECT ROW_COUNT() AS debit_rows_changed;
UPDATE accounts SET balance=balance+500.00
WHERE account_id=999 AND status='ACTIVE';
SELECT ROW_COUNT() AS credit_rows_changed;
-- After observing credit_rows_changed = 0, run:
ROLLBACK;
-- Evidence: the balance is restored to its pre-test value.
SELECT * FROM accounts WHERE account_id IN (1,2);

-- SAVEPOINT demonstration: transfer remains, fee posting is undone.
START TRANSACTION;
UPDATE accounts SET balance=balance-200.00
WHERE account_id=1 AND status='ACTIVE' AND balance>=200.00;
UPDATE accounts SET balance=balance+200.00
WHERE account_id=2 AND status='ACTIVE';
INSERT INTO bank_txns(from_id,to_id,amount,description)
VALUES(1,2,200.00,'Transfer before savepoint');
SAVEPOINT before_fee;
UPDATE accounts SET balance=balance-25.00
WHERE account_id=1 AND status='ACTIVE' AND balance>=25.00;
ROLLBACK TO SAVEPOINT before_fee;
RELEASE SAVEPOINT before_fee;
COMMIT;
-- Transfer is committed; fee is not.
SELECT * FROM accounts WHERE account_id IN (1,2);
SELECT * FROM bank_txns ORDER BY txn_id;
