-- Retail Inventory schema | MySQL 8.4
CREATE DATABASE IF NOT EXISTS retail_inventory;
USE retail_inventory;
CREATE TABLE suppliers(supplier_id INT AUTO_INCREMENT PRIMARY KEY,supplier_name VARCHAR(100) NOT NULL,supplier_phone VARCHAR(20) NOT NULL,UNIQUE(supplier_name,supplier_phone)) ENGINE=InnoDB;
CREATE TABLE categories(category_id INT AUTO_INCREMENT PRIMARY KEY,category_name VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE warehouses(warehouse_id INT AUTO_INCREMENT PRIMARY KEY,warehouse_name VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE products(sku VARCHAR(20) PRIMARY KEY,product_name VARCHAR(120) NOT NULL,category_id INT NOT NULL,supplier_id INT NOT NULL,reorder_level INT NOT NULL DEFAULT 5,FOREIGN KEY(category_id) REFERENCES categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id) ON DELETE RESTRICT ON UPDATE CASCADE,CHECK(reorder_level>=0)) ENGINE=InnoDB;
CREATE TABLE inventory(sku VARCHAR(20) NOT NULL,warehouse_id INT NOT NULL,quantity INT NOT NULL DEFAULT 0,PRIMARY KEY(sku,warehouse_id),FOREIGN KEY(sku) REFERENCES products(sku) ON DELETE RESTRICT ON UPDATE CASCADE,FOREIGN KEY(warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE,CHECK(quantity>=0)) ENGINE=InnoDB;
