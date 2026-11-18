-- Day 7 / Set 2: Bank Loan Portfolio
-- MySQL 8.4 LTS
CREATE DATABASE IF NOT EXISTS day7_bank;
USE day7_bank;

DROP TABLE IF EXISTS guarantors;
DROP TABLE IF EXISTS repayments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

CREATE TABLE branches (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(100) NOT NULL,
  city VARCHAR(80) NOT NULL
);
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL
);
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  branch_id INT NOT NULL,
  manager_id INT NULL,
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
CREATE TABLE loans (
  loan_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  employee_id INT NOT NULL,
  principal DECIMAL(12,2) NOT NULL,
  issued_on DATE NOT NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
CREATE TABLE repayments (
  repayment_id INT PRIMARY KEY,
  loan_id INT NOT NULL,
  installment_no INT NOT NULL,
  due_date DATE NOT NULL,
  paid_date DATE NULL,
  amount DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
  UNIQUE KEY uq_loan_installment (loan_id,installment_no)
);
CREATE TABLE guarantors (
  loan_id INT NOT NULL,
  guarantor_customer_id INT NOT NULL,
  PRIMARY KEY (loan_id,guarantor_customer_id),
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
  FOREIGN KEY (guarantor_customer_id) REFERENCES customers(customer_id)
);

CREATE INDEX idx_loan_branch_customer ON loans(branch_id,customer_id);
CREATE INDEX idx_loan_customer ON loans(customer_id);
CREATE INDEX idx_repayment_loan_due ON repayments(loan_id,due_date,paid_date);
CREATE INDEX idx_guarantor_customer ON guarantors(guarantor_customer_id);
