# Function/procedure and cursor comparison

- A **function** returns one value with `RETURN` and can be used in expressions, such as a `SELECT`.
- A **procedure** is invoked with `CALL`; it can return result sets and use OUT/INOUT parameters. It is suitable for multi-step operations.
- The cursor fetches old pending orders one row at a time and inserts follow-ups.
- The set-based `INSERT ... SELECT` performs the same selection in one SQL statement and is generally preferable for bulk work.
- For a fair performance comparison, reset `order_followups` and use the same data before each run. Record actual elapsed time locally; no benchmark is assumed.
