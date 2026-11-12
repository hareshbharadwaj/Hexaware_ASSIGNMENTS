-- Telecom Usage and Billing: schema
CREATE DATABASE IF NOT EXISTS day6_telecom;
USE day6_telecom;
CREATE TABLE plans (plan_id INT PRIMARY KEY,plan_name VARCHAR(100),monthly_fee DECIMAL(10,2));
CREATE TABLE subscribers (
 subscriber_id INT PRIMARY KEY,subscriber_name VARCHAR(100),circle VARCHAR(60),
 data_limit_gb DECIMAL(8,2),plan_id INT,FOREIGN KEY(plan_id) REFERENCES plans(plan_id)
);
CREATE TABLE call_records (
 call_id INT PRIMARY KEY,subscriber_id INT,call_date DATETIME,duration_minutes DECIMAL(8,2),
 FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id)
);
CREATE TABLE invoices (
 invoice_id INT PRIMARY KEY,subscriber_id INT,invoice_number VARCHAR(30),invoice_date DATE,
 due_date DATE,amount DECIMAL(10,2),paid_date DATE,FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id)
);
CREATE TABLE data_usage (
 usage_id INT PRIMARY KEY,subscriber_id INT,usage_date DATE,data_used_gb DECIMAL(8,2),
 FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id)
);
