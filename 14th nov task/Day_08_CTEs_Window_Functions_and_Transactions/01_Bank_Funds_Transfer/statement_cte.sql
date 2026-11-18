USE day8_bank;

-- Monthly statement with a CTE and window functions.
-- Opening balances are captured from the seed state for demonstration.
-- For production, store an authoritative opening balance or derive from a ledger.
WITH opening AS (
 SELECT 1 AS account_id,10000.00 AS opening_balance
 UNION ALL SELECT 2,5000.00
 UNION ALL SELECT 3,2500.00
),
ledger AS (
 SELECT a.account_id,t.txn_id,t.txn_time,
        CASE WHEN t.from_id=a.account_id THEN -t.amount ELSE t.amount END AS delta
 FROM accounts a
 JOIN bank_txns t ON a.account_id IN(t.from_id,t.to_id)
 WHERE t.txn_time >= DATE_FORMAT(CURRENT_DATE,'%Y-%m-01')
   AND t.txn_time < DATE_ADD(DATE_FORMAT(CURRENT_DATE,'%Y-%m-01'),INTERVAL 1 MONTH)
),
balances AS (
 SELECT l.account_id,l.txn_id,l.txn_time,l.delta,o.opening_balance,
        o.opening_balance + SUM(l.delta) OVER(
          PARTITION BY l.account_id ORDER BY l.txn_time,l.txn_id
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_balance,
        ROW_NUMBER() OVER(
          PARTITION BY l.account_id ORDER BY l.txn_time,l.txn_id
        ) AS txn_number
 FROM ledger l JOIN opening o ON o.account_id=l.account_id
)
SELECT account_id,txn_number,txn_id,txn_time,delta,running_balance,
       LAG(running_balance) OVER(
         PARTITION BY account_id ORDER BY txn_time,txn_id
       ) AS previous_balance
FROM balances
ORDER BY account_id,txn_time,txn_id;
