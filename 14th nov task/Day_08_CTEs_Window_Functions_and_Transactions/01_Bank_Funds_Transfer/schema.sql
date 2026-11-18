-- Day 8 Set 1: Bank Funds Transfer | MySQL 8.4
CREATE DATABASE IF NOT EXISTS day8_bank;
USE day8_bank;
DROP TABLE IF EXISTS bank_txns;
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
 account_id INT PRIMARY KEY,
 holder VARCHAR(80) NOT NULL,
 balance DECIMAL(12,2) NOT NULL CHECK(balance>=0),
 status ENUM('ACTIVE','BLOCKED') NOT NULL
) ENGINE=InnoDB;
CREATE TABLE bank_txns (
 txn_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 from_id INT NOT NULL,
 to_id INT NOT NULL,
 amount DECIMAL(12,2) NOT NULL CHECK(amount>0),
 txn_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 description VARCHAR(100),
 FOREIGN KEY(from_id) REFERENCES accounts(account_id),
 FOREIGN KEY(to_id) REFERENCES accounts(account_id)
) ENGINE=InnoDB;
