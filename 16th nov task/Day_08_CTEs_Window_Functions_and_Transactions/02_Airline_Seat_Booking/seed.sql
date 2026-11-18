USE day8_airline;
INSERT INTO seats(flight_id,seat_no,status) VALUES
(501,'12A','AVAILABLE'),(501,'12B','AVAILABLE'),
(501,'12C','AVAILABLE'),(502,'10A','AVAILABLE'),
(502,'10B','AVAILABLE'),(502,'10C','AVAILABLE');
-- Seed some completed bookings; these seats are marked BOOKED.
INSERT INTO bookings(flight_id,seat_no,passenger,fare,booked_at) VALUES
(501,'12B','Arun',4500,'2026-11-01 09:00:00'),
(501,'12C','Bina',4500,'2026-11-01 09:05:00'),
(502,'10B','Chitra',5200,'2026-11-02 10:00:00');
UPDATE seats SET status='BOOKED'
WHERE (flight_id=501 AND seat_no IN('12B','12C'))
   OR (flight_id=502 AND seat_no='10B');
