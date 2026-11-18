# Bank Loan Portfolio – Join and Subquery Justification

## Join choices

- **INNER JOIN:** used when a report requires a loan to have its matching customer, branch or loan officer.
- **LEFT JOIN:** used for branch/customer/loan reports where parent records must remain visible even when no loan, repayment or guarantor row exists.
- **Self join:** employees are joined to employees to display manager names. The guarantor report relates guarantor customer records to borrower customer records through loan IDs.
- **NOT EXISTS:** preferred for finding branches/customers without matching loans or recent repayments. It avoids the NULL behaviour that can make `NOT IN` unsafe.
- **Correlated subquery:** computes a comparison value for the current branch/customer row, such as branch-specific average customer exposure.
- **Uncorrelated subquery:** calculates an overall benchmark independently, then compares each customer's exposure against it.
- **Nested subquery:** first calculates each branch's maximum loan and then calculates the average of those branch maxima.

## Date-dependent report

The 60-day repayment query uses:

```sql
r.paid_date >= CURRENT_DATE - INTERVAL 60 DAY
```

Its result changes over time. For reproducible testing, replace `CURRENT_DATE` with a fixed date literal in a copy of the query.

## NULL safety

A `NOT IN` predicate can become UNKNOWN if its subquery contains NULL. The SQL file demonstrates this risk and then uses a correlated `NOT EXISTS` anti-join as the safe alternative.
