-- Hospital Patient Records schema | MySQL 8.4
CREATE DATABASE IF NOT EXISTS hospital_records;
USE hospital_records;
CREATE TABLE patients(patient_id INT AUTO_INCREMENT PRIMARY KEY,patient_name VARCHAR(100) NOT NULL,address_line VARCHAR(200) NOT NULL,phone VARCHAR(20) UNIQUE) ENGINE=InnoDB;
CREATE TABLE departments(department_id INT AUTO_INCREMENT PRIMARY KEY,department_name VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE doctors(doctor_id INT AUTO_INCREMENT PRIMARY KEY,doctor_name VARCHAR(100) NOT NULL,department_id INT NOT NULL,FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE RESTRICT ON UPDATE CASCADE) ENGINE=InnoDB;
CREATE TABLE visits(visit_id BIGINT AUTO_INCREMENT PRIMARY KEY,patient_id INT NOT NULL,doctor_id INT NOT NULL,visit_date DATE NOT NULL,diagnosis VARCHAR(255) NOT NULL,prescription TEXT,status ENUM('OPEN','IN_PROGRESS','CLOSED') NOT NULL DEFAULT 'OPEN',FOREIGN KEY(patient_id) REFERENCES patients(patient_id),FOREIGN KEY(doctor_id) REFERENCES doctors(doctor_id),CHECK(visit_date<=CURRENT_DATE)) ENGINE=InnoDB;
CREATE TABLE billing(billing_id BIGINT AUTO_INCREMENT PRIMARY KEY,visit_id BIGINT NOT NULL UNIQUE,bill_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,paid_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,FOREIGN KEY(visit_id) REFERENCES visits(visit_id),CHECK(bill_amount>=0),CHECK(paid_amount>=0 AND paid_amount<=bill_amount)) ENGINE=InnoDB;
