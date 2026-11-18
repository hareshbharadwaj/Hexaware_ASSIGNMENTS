USE day8_airline;

-- Fare ranking per flight. Tied fares share rank.
WITH fare_rank AS (
 SELECT flight_id,passenger,fare,
        RANK() OVER(PARTITION BY flight_id ORDER BY fare DESC) AS fare_rank,
        DENSE_RANK() OVER(PARTITION BY flight_id ORDER BY fare DESC) AS dense_fare_rank
 FROM bookings
)
SELECT * FROM fare_rank ORDER BY flight_id,fare_rank,passenger;

-- Running revenue per flight.
WITH revenue AS (
 SELECT flight_id,booking_id,passenger,booked_at,fare,
        SUM(fare) OVER(
          PARTITION BY flight_id ORDER BY booked_at,booking_id
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_revenue
 FROM bookings
)
SELECT * FROM revenue ORDER BY flight_id,booked_at,booking_id;

-- Correlated subquery: passengers whose fare is above their flight's average.
SELECT b.flight_id,b.passenger,b.fare
FROM bookings b
WHERE b.fare > (
 SELECT AVG(x.fare) FROM bookings x
 WHERE x.flight_id=b.flight_id
)
ORDER BY b.flight_id,b.fare DESC;

-- RANK vs DENSE_RANK: ties share a rank. RANK leaves gaps (1,1,3);
-- DENSE_RANK has no gaps (1,1,2).
