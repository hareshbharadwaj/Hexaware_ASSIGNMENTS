# Cursor versus INSERT ... SELECT timing

The cursor processes each prepaid subscriber below 50 units and inserts one notification per fetch. The set-based alternative inserts all qualifying notifications with one INSERT ... SELECT statement. Run each approach on equivalent data, clearing notifications before each run. Example timing statements:

```sql
TRUNCATE TABLE subscriber_notifications;
SET @t0=NOW(6);
CALL sp_notify_low_balance_cursor();
SELECT TIMESTAMPDIFF(MICROSECOND,@t0,NOW(6)) AS cursor_elapsed_us;

TRUNCATE TABLE subscriber_notifications;
SET @t0=NOW(6);
INSERT INTO subscriber_notifications(subscriber_id,message)
SELECT subscriber_id,'Your prepaid balance is below 50 units'
FROM subscribers WHERE subscriber_type='PREPAID' AND balance<50;
SELECT ROW_COUNT() AS rows_inserted,
       TIMESTAMPDIFF(MICROSECOND,@t0,NOW(6)) AS set_based_elapsed_us;
```

The measured values depend on server load, indexes and row count; do not report assumed timings.
