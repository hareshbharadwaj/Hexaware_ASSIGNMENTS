-- Insurance Policy Reporting: schema
CREATE DATABASE IF NOT EXISTS day6_insurance;
USE day6_insurance;
CREATE TABLE customers (customer_id INT PRIMARY KEY,customer_name VARCHAR(100),date_of_birth DATE);
CREATE TABLE agents (agent_id INT PRIMARY KEY,agent_name VARCHAR(100));
CREATE TABLE products (product_id INT PRIMARY KEY,product_name VARCHAR(100));
CREATE TABLE policies (
 policy_id INT PRIMARY KEY,policy_number VARCHAR(30),customer_id INT,product_id INT,agent_id INT,
 start_date DATE,end_date DATE,premium_amount DECIMAL(10,2),status VARCHAR(20),
 FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
 FOREIGN KEY(product_id) REFERENCES products(product_id),
 FOREIGN KEY(agent_id) REFERENCES agents(agent_id)
);
CREATE TABLE claims (
 claim_id INT PRIMARY KEY,policy_id INT,claim_amount DECIMAL(10,2),claim_date DATE,
 FOREIGN KEY(policy_id) REFERENCES policies(policy_id)
);
