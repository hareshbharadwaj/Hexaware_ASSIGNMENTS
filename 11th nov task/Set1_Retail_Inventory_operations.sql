USE retail_inventory;
SELECT * FROM suppliers WHERE supplier_id=1;
UPDATE suppliers SET supplier_phone='9888800001' WHERE supplier_id=1;
SELECT * FROM suppliers WHERE supplier_id=1;
SELECT * FROM products WHERE sku='SKU010';
DELETE FROM inventory WHERE sku='SKU010';
DELETE FROM products WHERE sku='SKU010';
SELECT * FROM products WHERE sku='SKU010';
SELECT TABLE_NAME,ENGINE,TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA='retail_inventory' AND TABLE_TYPE='BASE TABLE';