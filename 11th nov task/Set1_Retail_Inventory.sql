-- SET 1: RETAIL INVENTORY MANAGEMENT | MySQL 8.4
CREATE DATABASE IF NOT EXISTS retail_inventory;
USE retail_inventory;
CREATE TABLE suppliers (supplier_id INT AUTO_INCREMENT PRIMARY KEY, supplier_name VARCHAR(100) NOT NULL, supplier_phone VARCHAR(20) NOT NULL, CONSTRAINT uq_supplier UNIQUE (supplier_name,supplier_phone)) ENGINE=InnoDB;
CREATE TABLE categories (category_id INT AUTO_INCREMENT PRIMARY KEY, category_name VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE warehouses (warehouse_id INT AUTO_INCREMENT PRIMARY KEY, warehouse_name VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE products (sku VARCHAR(20) PRIMARY KEY, product_name VARCHAR(120) NOT NULL, category_id INT NOT NULL, supplier_id INT NOT NULL, reorder_level INT NOT NULL DEFAULT 5, CONSTRAINT fk_product_category FOREIGN KEY(category_id) REFERENCES categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE, CONSTRAINT fk_product_supplier FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id) ON DELETE RESTRICT ON UPDATE CASCADE, CHECK(reorder_level>=0)) ENGINE=InnoDB;
CREATE TABLE inventory (sku VARCHAR(20) NOT NULL, warehouse_id INT NOT NULL, quantity INT NOT NULL DEFAULT 0, PRIMARY KEY(sku,warehouse_id), CONSTRAINT fk_inventory_product FOREIGN KEY(sku) REFERENCES products(sku) ON DELETE RESTRICT ON UPDATE CASCADE, CONSTRAINT fk_inventory_warehouse FOREIGN KEY(warehouse_id) REFERENCES warehouses(warehouse_id) ON DELETE RESTRICT ON UPDATE CASCADE, CHECK(quantity>=0)) ENGINE=InnoDB;
INSERT INTO suppliers(supplier_name,supplier_phone) VALUES ('Apex Supplies','9000000001'),('Bright Traders','9000000002'),('Crown Distributors','9000000003'),('Delta Wholesale','9000000004'),('Evergreen Goods','9000000005'),('Firstline Supply','9000000006'),('Global Merchants','9000000007'),('Horizon Products','9000000008'),('Indus Supply Co','9000000009'),('Jupiter Stores','9000000010');
INSERT INTO categories(category_name) VALUES ('Electronics'),('Grocery'),('Stationery'),('Furniture'),('Appliances'),('Sports'),('Clothing'),('Personal Care'),('Books'),('Accessories');
INSERT INTO warehouses(warehouse_name) VALUES ('Chennai Central'),('Tambaram'),('Ambattur'),('Guindy'),('Porur'),('Velachery'),('Avadi'),('Perungudi'),('Sholinganallur'),('Madhavaram');
INSERT INTO products(sku,product_name,category_id,supplier_id,reorder_level) VALUES ('SKU001','Wireless Mouse',1,1,10),('SKU002','Rice 5kg',2,2,15),('SKU003','Notebook Pack',3,3,20),('SKU004','Office Chair',4,4,4),('SKU005','Mixer Grinder',5,5,5),('SKU006','Football',6,6,8),('SKU007','Cotton Shirt',7,7,6),('SKU008','Hand Wash',8,8,12),('SKU009','Database Textbook',9,9,3),('SKU010','USB Cable',10,10,10);
INSERT INTO inventory(sku,warehouse_id,quantity) VALUES ('SKU001',1,40),('SKU002',2,80),('SKU003',3,100),('SKU004',4,12),('SKU005',5,25),('SKU006',6,18),('SKU007',7,30),('SKU008',8,55),('SKU009',9,14),('SKU010',10,60);
-- Failing tests: uncomment/run individually
-- INSERT INTO products VALUES ('SKU001','Duplicate Mouse',1,1,5);
-- INSERT INTO products VALUES ('SKU999','Orphan Product',999,1,5);
-- INSERT INTO inventory VALUES ('SKU001',2,-10);
-- INSERT INTO suppliers(supplier_name,supplier_phone) VALUES (NULL,'9111111111');
SELECT * FROM suppliers WHERE supplier_id=1;
UPDATE suppliers SET supplier_phone='9888800001' WHERE supplier_id=1;
SELECT * FROM suppliers WHERE supplier_id=1;
SELECT * FROM products WHERE sku='SKU010';
DELETE FROM inventory WHERE sku='SKU010';
DELETE FROM products WHERE sku='SKU010';
SELECT * FROM products WHERE sku='SKU010';
SELECT TABLE_NAME,ENGINE,TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA='retail_inventory' AND TABLE_TYPE='BASE TABLE';
