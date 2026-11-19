# Day 10 – Triggers (MySQL 8.4 LTS)

## Set 1 – Retail Price Change Audit
- BEFORE UPDATE checks NEW.selling_price against NEW.cost_price and rejects an invalid value using SIGNAL SQLSTATE '45000'.
- AFTER UPDATE writes OLD and NEW selling prices, CURRENT_USER(), and a microsecond timestamp to price_audit.
- MySQL triggers are row-level: an UPDATE affecting two rows invokes the trigger twice.
- Risks: hidden logic makes debugging harder; cascading trigger effects can cause unexpected side effects and performance overhead.
- Application code is preferable for complex workflows, external service calls, user interaction, or orchestration across systems.
- List triggers using information_schema.TRIGGERS filtered by TRIGGER_SCHEMA.

## Set 2 – Bank Account Balance Guard
- AFTER INSERT, UPDATE, and DELETE on account_transaction create audit rows.
- BEFORE UPDATE on accounts rejects a negative balance for SAVINGS accounts.
- For InnoDB, if a trigger signals an error during a multi-row UPDATE, the whole statement is rolled back. Other rows in that same statement are not changed. Earlier statements in the transaction remain pending until COMMIT or ROLLBACK.
- MySQL has no INSTEAD OF triggers. Use BEFORE triggers to validate/adjust NEW values and constraints for declarative row-level rules.
- Transaction triggers maintain accounts.last_txn_date; DELETE recalculates the latest remaining transaction time.
- The guard validates balance but does not itself implement a full ledger/reconciliation workflow.

## Set 3 – Hospital Bed Capacity Control
- BEFORE INSERT counts admissions in the ward and rejects an admission when occupancy is already at capacity.
- AFTER INSERT, UPDATE, and DELETE append admission history to admission_audit.
- For InnoDB, a multi-row INSERT that fails for one row is rolled back as a whole statement; earlier rows from that statement do not remain.
- CHECK is suitable for simple same-row rules, not counts in another table. A stored procedure is often better for cross-row capacity checks because it can lock the ward row, count occupancy, and insert in one transaction.
- JDBC: use Connection and PreparedStatement, catch SQLException, inspect getSQLState() (45000), rollback on failure, and verify admission/audit tables.
- Concurrency warning: count-then-insert can race. Production should serialize admissions using a transaction/stored procedure that locks the ward row (SELECT ... FOR UPDATE) or a carefully maintained counter.

## JDBC test pattern
```java
try (Connection con = dataSource.getConnection()) {
    con.setAutoCommit(false);
    try (PreparedStatement ps = con.prepareStatement(
        "INSERT INTO admission(admission_id, patient_name, ward_id) VALUES (?, ?, ?)")) {
        ps.setLong(1, 3001L);
        ps.setString(2, "Test Patient");
        ps.setLong(3, 1L);
        ps.executeUpdate();
        con.commit();
    } catch (SQLException ex) {
        con.rollback();
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("Message: " + ex.getMessage());
    }
}
```

## Execution
1. Run triggers.sql first.
2. Run test_evidence.sql in sections; expected-error statements must be executed separately.
3. Three independent schemas are used: day10_retail, day10_bank, day10_hospital.
4. Validate on MySQL 8.4 LTS before production use.
