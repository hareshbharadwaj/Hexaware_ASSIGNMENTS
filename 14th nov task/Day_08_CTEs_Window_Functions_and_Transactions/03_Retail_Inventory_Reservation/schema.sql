-- Day 8 Set 3: Retail Inventory Reservation | MySQL 8.4
CREATE DATABASE IF NOT EXISTS day8_retail;
USE day8_retail;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS order_lines;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
CREATE TABLE products (
 product_id INT PRIMARY KEY,
 product_name VARCHAR(80) NOT NULL,
 category VARCHAR(50) NOT NULL,
 stock INT NOT NULL CHECK(stock>=0),
 price DECIMAL(10,2) NOT NULL CHECK(price>=0)
) ENGINE=InnoDB;
CREATE TABLE orders (
 order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 customer_id INT NOT NULL,
 order_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 status ENUM('PENDING','CONFIRMED','CANCELLED') NOT NULL
) ENGINE=InnoDB;
CREATE TABLE order_lines (
 order_id BIGINT NOT NULL,
 product_id INT NOT NULL,
 qty INT NOT NULL CHECK(qty>0),
 unit_price DECIMAL(10,2) NOT NULL,
 PRIMARY KEY(order_id,product_id),
 FOREIGN KEY(order_id) REFERENCES orders(order_id),
 FOREIGN KEY(product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;
CREATE TABLE sales (
 product_id INT NOT NULL,
 sale_month DATE NOT NULL,
 units INT NOT NULL CHECK(units>=0),
 PRIMARY KEY(product_id,sale_month),
 FOREIGN KEY(product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;
