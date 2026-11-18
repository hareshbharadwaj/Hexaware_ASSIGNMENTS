USE day8_airline;

-- Atomic booking. Run the statements as one transaction.
START TRANSACTION;
SELECT status
FROM seats
WHERE flight_id=501 AND seat_no='12A'
FOR UPDATE;
-- Application validates that exactly one row exists and status='AVAILABLE'.
INSERT INTO bookings(flight_id,seat_no,passenger,fare)
VALUES(501,'12A','Nila',4500.00);
UPDATE seats
SET status='BOOKED'
WHERE flight_id=501 AND seat_no='12A' AND status='AVAILABLE';
-- Require ROW_COUNT()=1. If not, ROLLBACK in the application.
SELECT ROW_COUNT() AS seat_rows_changed;
COMMIT;

-- Verify.
SELECT s.flight_id,s.seat_no,s.status,b.passenger,b.fare
FROM seats s LEFT JOIN bookings b
 ON b.flight_id=s.flight_id AND b.seat_no=s.seat_no
WHERE s.flight_id=501 ORDER BY s.seat_no;

-- Concurrency test instructions are in locking_experiment.md.
