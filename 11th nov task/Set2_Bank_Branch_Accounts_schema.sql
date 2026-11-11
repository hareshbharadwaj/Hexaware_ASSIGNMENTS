-- Bank Branch Accounts schema | MySQL 8.4
CREATE DATABASE IF NOT EXISTS bank_branch;
USE bank_branch;
CREATE TABLE customers(customer_id INT AUTO_INCREMENT PRIMARY KEY,customer_name VARCHAR(100) NOT NULL,address_line VARCHAR(200) NOT NULL) ENGINE=InnoDB;
CREATE TABLE branches(branch_id INT AUTO_INCREMENT PRIMARY KEY,branch_name VARCHAR(100) NOT NULL UNIQUE,branch_code CHAR(5) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE account_types(account_type_id INT AUTO_INCREMENT PRIMARY KEY,type_name VARCHAR(20) NOT NULL UNIQUE,CHECK(type_name IN ('SAVINGS','CURRENT','SALARY','FIXED_DEPOSIT'))) ENGINE=InnoDB;
CREATE TABLE relationship_managers(manager_id INT AUTO_INCREMENT PRIMARY KEY,manager_name VARCHAR(100) NOT NULL,email VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE accounts(account_id BIGINT AUTO_INCREMENT PRIMARY KEY,account_number VARCHAR(20) NOT NULL UNIQUE,customer_id INT NOT NULL,account_type_id INT NOT NULL,branch_id INT NOT NULL,manager_id INT NOT NULL,opened_on DATE NOT NULL,balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(account_type_id) REFERENCES account_types(account_type_id),FOREIGN KEY(branch_id) REFERENCES branches(branch_id),FOREIGN KEY(manager_id) REFERENCES relationship_managers(manager_id),CHECK(balance>=0)) ENGINE=InnoDB;
