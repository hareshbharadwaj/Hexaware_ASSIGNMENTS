# Autocommit and Isolation-Level Experiment

## Autocommit
With `autocommit=1`, each standalone statement commits automatically. Use `START TRANSACTION` to group related writes; they remain pending until `COMMIT` or `ROLLBACK`.

Check with `SELECT @@autocommit;`. To demonstrate, update a test account without starting a transaction and observe that a second session can see the committed value immediately.

## READ COMMITTED (two sessions)
**Session A**
```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT balance FROM day8_bank.accounts WHERE account_id=1;
-- Keep transaction open.
```
**Session B**
```sql
UPDATE day8_bank.accounts SET balance=balance+10 WHERE account_id=1;
COMMIT;
```
**Session A** repeats the same SELECT. It can see Session B's newly committed value: a non-repeatable read is possible.

## REPEATABLE READ (two sessions)
Repeat the experiment with Session A set to `REPEATABLE READ`. After its first consistent read, Session A normally continues to see the same snapshot value on repeated consistent SELECTs until it commits. InnoDB locking reads such as `SELECT ... FOR UPDATE` are current reads, not snapshot reads.

Record the actual values and server version from your own two-session run. Do not report an experiment as executed unless it was run.
