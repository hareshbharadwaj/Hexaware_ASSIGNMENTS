-- Retail Sales Reporting: schema
CREATE DATABASE IF NOT EXISTS day6_retail;
USE day6_retail;
CREATE TABLE customers (
  customer_id INT PRIMARY KEY, customer_name VARCHAR(100) NOT NULL,
  city VARCHAR(60), email VARCHAR(120), created_at DATE
);
CREATE TABLE products (
  product_id INT PRIMARY KEY, product_name VARCHAR(100) NOT NULL,
  category VARCHAR(60), unit_price DECIMAL(10,2) NOT NULL
);
CREATE TABLE orders (
  order_id INT PRIMARY KEY, customer_id INT NOT NULL, order_date DATE NOT NULL,
  payment_status VARCHAR(20), FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL,
  quantity INT NOT NULL, unit_price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
