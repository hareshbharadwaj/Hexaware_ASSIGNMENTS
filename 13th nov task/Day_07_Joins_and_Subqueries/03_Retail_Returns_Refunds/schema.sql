-- Day 7 / Set 3: Retail Returns and Refunds
-- MySQL 8.4 LTS
CREATE DATABASE IF NOT EXISTS day7_retail_returns;
USE day7_retail_returns;

DROP TABLE IF EXISTS refunds;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS regions;

CREATE TABLE regions (
  region_id INT PRIMARY KEY,
  region_name VARCHAR(80) NOT NULL
);
CREATE TABLE stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(100) NOT NULL,
  region_id INT NOT NULL,
  FOREIGN KEY (region_id) REFERENCES regions(region_id)
);
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL
);
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category VARCHAR(80) NOT NULL
);
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  store_id INT NOT NULL,
  manager_id INT NULL,
  FOREIGN KEY (store_id) REFERENCES stores(store_id),
  FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  employee_id INT NOT NULL,
  order_date DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (store_id) REFERENCES stores(store_id),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE returns (
  return_id INT PRIMARY KEY,
  order_item_id INT NOT NULL,
  return_date DATE NOT NULL,
  return_quantity INT NOT NULL,
  reason VARCHAR(255),
  FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);
CREATE TABLE refunds (
  refund_id INT PRIMARY KEY,
  return_id INT NOT NULL,
  refund_amount DECIMAL(10,2) NOT NULL,
  refund_date DATE NULL,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (return_id) REFERENCES returns(return_id)
);

CREATE INDEX idx_store_region ON stores(region_id);
CREATE INDEX idx_order_store_date ON orders(store_id,order_date);
CREATE INDEX idx_order_customer ON orders(customer_id);
CREATE INDEX idx_item_product ON order_items(product_id);
CREATE INDEX idx_return_item_date ON returns(order_item_id,return_date);
CREATE INDEX idx_refund_return_status ON refunds(return_id,status);
