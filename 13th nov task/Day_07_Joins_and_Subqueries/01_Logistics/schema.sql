-- Day 7 / Set 1: Logistics Shipment Analysis
-- MySQL 8.4 LTS
CREATE DATABASE IF NOT EXISTS day7_logistics;
USE day7_logistics;

DROP TABLE IF EXISTS delivery_events;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS carriers;
DROP TABLE IF EXISTS hubs;

CREATE TABLE hubs (
  hub_id INT PRIMARY KEY,
  hub_name VARCHAR(80) NOT NULL,
  city VARCHAR(80) NOT NULL
);

CREATE TABLE carriers (
  carrier_id INT PRIMARY KEY,
  carrier_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  city VARCHAR(80) NOT NULL
);

CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_name VARCHAR(100) NOT NULL,
  hub_id INT NOT NULL,
  supervisor_id INT NULL,
  CONSTRAINT fk_log_emp_hub FOREIGN KEY (hub_id) REFERENCES hubs(hub_id),
  CONSTRAINT fk_log_emp_supervisor FOREIGN KEY (supervisor_id) REFERENCES employees(employee_id)
);

CREATE TABLE shipments (
  shipment_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  carrier_id INT NOT NULL,
  origin_hub_id INT NOT NULL,
  destination_hub_id INT NOT NULL,
  employee_id INT NOT NULL,
  shipped_at DATE NOT NULL,
  promised_at DATE NOT NULL,
  delivered_at DATE NULL,
  shipping_cost DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_ship_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_ship_carrier FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id),
  CONSTRAINT fk_ship_origin FOREIGN KEY (origin_hub_id) REFERENCES hubs(hub_id),
  CONSTRAINT fk_ship_destination FOREIGN KEY (destination_hub_id) REFERENCES hubs(hub_id),
  CONSTRAINT fk_ship_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE delivery_events (
  event_id INT PRIMARY KEY,
  shipment_id INT NOT NULL,
  event_type VARCHAR(40) NOT NULL,
  event_at DATETIME NOT NULL,
  notes VARCHAR(255),
  CONSTRAINT fk_event_shipment FOREIGN KEY (shipment_id) REFERENCES shipments(shipment_id)
);

CREATE INDEX idx_ship_origin_date ON shipments(origin_hub_id, shipped_at);
CREATE INDEX idx_ship_destination ON shipments(destination_hub_id);
CREATE INDEX idx_ship_carrier ON shipments(carrier_id);
CREATE INDEX idx_ship_customer ON shipments(customer_id);
CREATE INDEX idx_event_shipment_time ON delivery_events(shipment_id, event_at);
