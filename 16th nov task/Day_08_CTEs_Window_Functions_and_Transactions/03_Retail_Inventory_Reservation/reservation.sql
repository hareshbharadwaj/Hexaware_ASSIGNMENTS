USE day8_retail;

-- Atomic reservation. The conditional stock update prevents negative inventory.
START TRANSACTION;
UPDATE products
SET stock=stock-3
WHERE product_id=1 AND stock>=3;
SELECT ROW_COUNT() AS stock_rows_changed;
-- If ROW_COUNT() is not 1, ROLLBACK and stop.
INSERT INTO orders(customer_id,status) VALUES(101,'PENDING');
SET @new_order_id=LAST_INSERT_ID();
INSERT INTO order_lines(order_id,product_id,qty,unit_price)
SELECT @new_order_id,product_id,3,price
FROM products WHERE product_id=1;
-- If payment succeeds:
UPDATE orders SET status='CONFIRMED' WHERE order_id=@new_order_id;
COMMIT;

-- Payment failure simulation: stock decrement and order rows are all rolled back.
START TRANSACTION;
UPDATE products SET stock=stock-2
WHERE product_id=2 AND stock>=2;
SELECT ROW_COUNT() AS stock_rows_changed;
INSERT INTO orders(customer_id,status) VALUES(102,'PENDING');
SET @failed_order_id=LAST_INSERT_ID();
INSERT INTO order_lines(order_id,product_id,qty,unit_price)
SELECT @failed_order_id,product_id,2,price
FROM products WHERE product_id=2;
-- Simulate payment failure:
ROLLBACK;
-- Verify stock and order count remain as before this test.
SELECT * FROM products ORDER BY product_id;
SELECT * FROM orders ORDER BY order_id;

-- Insufficient stock demonstration: product 3 has only 5 units in the seed data.
START TRANSACTION;
UPDATE products SET stock=stock-999
WHERE product_id=3 AND stock>=999;
SELECT ROW_COUNT() AS stock_rows_changed;
-- Expected 0. No order should be inserted; roll back the transaction.
ROLLBACK;
