USE day7_bank;

-- 1. Loans overdue by more than three unpaid instalments as of today.
SELECT l.loan_id,c.customer_name,b.branch_name,
       COUNT(*) AS overdue_unpaid_installments
FROM loans l
JOIN customers c ON c.customer_id=l.customer_id
JOIN branches b ON b.branch_id=l.branch_id
JOIN repayments r ON r.loan_id=l.loan_id
WHERE r.due_date<CURRENT_DATE AND r.paid_date IS NULL
GROUP BY l.loan_id,c.customer_name,b.branch_name
HAVING COUNT(*)>3;

-- 2. Customers with loans in more than one branch.
SELECT c.customer_name,COUNT(DISTINCT l.branch_id) AS branch_count
FROM customers c JOIN loans l ON l.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING COUNT(DISTINCT l.branch_id)>1;

-- 3. Guarantors who are also borrowers (self relationship through customer IDs).
SELECT DISTINCT g_customer.customer_name AS guarantor,
       borrower.customer_name AS borrower,
       g.loan_id
FROM guarantors g
JOIN customers g_customer ON g_customer.customer_id=g.guarantor_customer_id
JOIN loans l ON l.loan_id=g.loan_id
JOIN customers borrower ON borrower.customer_id=l.customer_id
WHERE EXISTS (
  SELECT 1 FROM loans own_loan
  WHERE own_loan.customer_id=g.guarantor_customer_id
);

-- 4. Branches with no loans (LEFT JOIN).
SELECT b.branch_id,b.branch_name
FROM branches b LEFT JOIN loans l ON l.branch_id=b.branch_id
WHERE l.loan_id IS NULL;

-- 5. Loan details with customer, branch and employee (INNER JOIN).
SELECT l.loan_id,c.customer_name,b.branch_name,e.employee_name,l.principal,l.status
FROM loans l
JOIN customers c ON c.customer_id=l.customer_id
JOIN branches b ON b.branch_id=l.branch_id
JOIN employees e ON e.employee_id=l.employee_id;

-- 6. Repayment schedule, including loans with no repayment rows (LEFT JOIN).
SELECT l.loan_id,r.installment_no,r.due_date,r.paid_date,r.amount
FROM loans l LEFT JOIN repayments r ON r.loan_id=l.loan_id
ORDER BY l.loan_id,r.installment_no;

-- 7. Employees and their managers (self join).
SELECT e.employee_name AS employee,m.employee_name AS manager,b.branch_name
FROM employees e
LEFT JOIN employees m ON m.employee_id=e.manager_id
JOIN branches b ON b.branch_id=e.branch_id;

-- 8. Total principal exposure per customer.
SELECT c.customer_name,COALESCE(SUM(l.principal),0) AS total_exposure
FROM customers c LEFT JOIN loans l ON l.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name;

-- 9. Branch-wise loan count and total principal (LEFT JOIN keeps empty branches).
SELECT b.branch_name,COUNT(l.loan_id) AS loan_count,
       COALESCE(SUM(l.principal),0) AS total_principal
FROM branches b LEFT JOIN loans l ON l.branch_id=b.branch_id
GROUP BY b.branch_id,b.branch_name;

-- 10. Loan with its guarantor details (LEFT JOIN because a guarantor may be absent).
SELECT l.loan_id,c.customer_name AS borrower,gc.customer_name AS guarantor
FROM loans l JOIN customers c ON c.customer_id=l.customer_id
LEFT JOIN guarantors g ON g.loan_id=l.loan_id
LEFT JOIN customers gc ON gc.customer_id=g.guarantor_customer_id;

-- Correlated subquery: customer exposure exceeds the average exposure of their branch.
SELECT c.customer_id,c.customer_name,l.branch_id,
       (SELECT SUM(l2.principal) FROM loans l2
        WHERE l2.customer_id=c.customer_id AND l2.branch_id=l.branch_id) AS customer_branch_exposure
FROM customers c JOIN loans l ON l.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name,l.branch_id
HAVING customer_branch_exposure > (
  SELECT AVG(branch_customer_exposure)
  FROM (
    SELECT l3.branch_id,l3.customer_id,SUM(l3.principal) AS branch_customer_exposure
    FROM loans l3 GROUP BY l3.branch_id,l3.customer_id
  ) exposure_by_customer
  WHERE exposure_by_customer.branch_id=l.branch_id
);

-- Uncorrelated subquery: total exposure greater than the average customer exposure overall.
SELECT c.customer_id,c.customer_name,SUM(l.principal) AS total_exposure
FROM customers c JOIN loans l ON l.customer_id=c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(l.principal) > (
  SELECT AVG(customer_total)
  FROM (
    SELECT SUM(principal) AS customer_total
    FROM loans GROUP BY customer_id
  ) totals
);

-- Customers with a loan but no repayment in the last 60 days (EXISTS + NOT EXISTS).
SELECT c.customer_id,c.customer_name
FROM customers c
WHERE EXISTS (SELECT 1 FROM loans l WHERE l.customer_id=c.customer_id)
  AND NOT EXISTS (
    SELECT 1 FROM loans l
    JOIN repayments r ON r.loan_id=l.loan_id
    WHERE l.customer_id=c.customer_id
      AND r.paid_date >= CURRENT_DATE - INTERVAL 60 DAY
  );

-- Branches whose highest loan is greater than the average of all branch maximum loans.
SELECT b.branch_id,b.branch_name,MAX(l.principal) AS highest_loan
FROM branches b JOIN loans l ON l.branch_id=b.branch_id
GROUP BY b.branch_id,b.branch_name
HAVING MAX(l.principal) > (
  SELECT AVG(branch_maximum)
  FROM (
    SELECT MAX(principal) AS branch_maximum
    FROM loans GROUP BY branch_id
  ) branch_maxima
);

-- ANY: loans larger than at least one loan in another branch.
SELECT loan_id,principal,branch_id
FROM loans
WHERE principal > ANY (
  SELECT principal FROM loans other
  WHERE other.branch_id<>loans.branch_id
);

-- ALL: loans larger than every loan issued by branch 2.
SELECT loan_id,principal
FROM loans
WHERE principal > ALL (
  SELECT principal FROM loans WHERE branch_id=2
);

-- NOT IN NULL pitfall demonstration.
-- If the subquery can return NULL, NOT IN may evaluate to UNKNOWN for every candidate.
SELECT c.customer_id,c.customer_name
FROM customers c
WHERE c.customer_id NOT IN (
  SELECT l.customer_id FROM loans l
  WHERE l.customer_id IS NOT NULL
);
-- Safer anti-join form; this remains correct even if the subquery's compared column contains NULL.
SELECT c.customer_id,c.customer_name
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 FROM loans l WHERE l.customer_id=c.customer_id
);
