# ACID Properties – Retail Inventory Reservation

- **Atomicity:** stock decrement, order header and order lines are committed together. If payment fails or any line cannot be reserved, ROLLBACK restores all changes.
- **Consistency:** constraints such as `stock >= 0`, positive order quantities, primary keys and foreign keys keep data valid before and after the transaction.
- **Isolation:** concurrent checkouts must not both reserve the last unit. Conditional updates such as `UPDATE products SET stock=stock-1 WHERE product_id=? AND stock>=1` and row locks serialize competing changes.
- **Durability:** after COMMIT, InnoDB's committed changes persist across restart, subject to correct server durability configuration.

## Non-transactional counterexample
If inventory were stored in a non-transactional engine such as MyISAM, a stock decrement could persist while a later order insert or payment step fails. ROLLBACK cannot undo a MyISAM write. Use InnoDB for every table participating in the reservation transaction.

## Multi-product reservation
For an order containing multiple products, conditionally decrement each product's stock, verify every affected-row count, and roll back the entire transaction if any product is unavailable. Lock products in ascending product ID order to reduce deadlock risk.
