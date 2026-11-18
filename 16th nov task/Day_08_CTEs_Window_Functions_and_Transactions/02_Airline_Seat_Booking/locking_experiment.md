# Two-Session Seat Locking Experiment

Use two MySQL clients connected to `day8_airline`. Reset the target seat to AVAILABLE before testing if necessary.

**Session A**
```sql
START TRANSACTION;
SELECT status FROM seats
WHERE flight_id=501 AND seat_no='12A'
FOR UPDATE;
-- Pause here; the row lock is held.
```

**Session B**
```sql
START TRANSACTION;
SELECT status FROM seats
WHERE flight_id=501 AND seat_no='12A'
FOR UPDATE;
-- This statement waits while Session A holds the lock.
```

**Session A** inserts the booking, updates the seat to BOOKED, then commits:
```sql
INSERT INTO bookings(flight_id,seat_no,passenger,fare)
VALUES(501,'12A','Nila',4500);
UPDATE seats SET status='BOOKED'
WHERE flight_id=501 AND seat_no='12A' AND status='AVAILABLE';
COMMIT;
```

Session B resumes and sees BOOKED. It must not insert; issue ROLLBACK. The unique key on `(flight_id, seat_no)` in bookings is a final duplicate-booking safeguard. Capture the actual wait/lock behaviour from the two clients for the assignment evidence.
