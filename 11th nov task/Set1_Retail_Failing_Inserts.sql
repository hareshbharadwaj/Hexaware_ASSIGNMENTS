USE retail_inventory;
-- Execute separately; each statement is intentionally invalid.
-- Duplicate primary key
INSERT INTO products VALUES ('SKU001','Duplicate Mouse',1,1,5);
-- Missing parent category
INSERT INTO products VALUES ('SKU999','Orphan Product',999,1,5);
-- Negative quantity
INSERT INTO inventory VALUES ('SKU001',2,-10);
-- NULL mandatory supplier name
INSERT INTO suppliers(supplier_name,supplier_phone) VALUES (NULL,'9111111111');