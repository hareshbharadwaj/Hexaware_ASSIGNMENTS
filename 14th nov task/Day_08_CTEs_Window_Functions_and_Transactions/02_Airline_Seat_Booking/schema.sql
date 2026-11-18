-- Day 8 Set 2: Airline Seat Booking | MySQL 8.4
CREATE DATABASE IF NOT EXISTS day8_airline;
USE day8_airline;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS seats;
CREATE TABLE seats (
 flight_id INT NOT NULL,
 seat_no VARCHAR(5) NOT NULL,
 status ENUM('AVAILABLE','BOOKED') NOT NULL DEFAULT 'AVAILABLE',
 PRIMARY KEY(flight_id,seat_no)
) ENGINE=InnoDB;
CREATE TABLE bookings (
 booking_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 flight_id INT NOT NULL,
 seat_no VARCHAR(5) NOT NULL,
 passenger VARCHAR(80) NOT NULL,
 fare DECIMAL(10,2) NOT NULL CHECK(fare>=0),
 booked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_flight_seat(flight_id,seat_no),
 FOREIGN KEY(flight_id,seat_no) REFERENCES seats(flight_id,seat_no)
) ENGINE=InnoDB;
