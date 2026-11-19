-- Hexaware Java Track - Day 10: Triggers (MySQL 8.4 LTS)
-- Three independent exercise sets. Run each SET in its own schema/session.
-- InnoDB is used throughout.

-- SET 1: RETAIL PRICE CHANGE AUDIT
CREATE DATABASE IF NOT EXISTS day10_retail;
USE day10_retail;
CREATE TABLE IF NOT EXISTS product_price (
 product_id BIGINT PRIMARY KEY, product_name VARCHAR(120) NOT NULL,
 cost_price DECIMAL(10,2) NOT NULL, selling_price DECIMAL(10,2) NOT NULL,
 CHECK (cost_price >= 0), CHECK (selling_price >= 0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS price_audit (
 audit_id BIGINT AUTO_INCREMENT PRIMARY KEY, product_id BIGINT NOT NULL,
 old_price DECIMAL(10,2) NOT NULL, new_price DECIMAL(10,2) NOT NULL,
 changed_by VARCHAR(288) NOT NULL,
 changed_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB;
DROP TRIGGER IF EXISTS trg_price_before_update;
DROP TRIGGER IF EXISTS trg_price_after_update;
DELIMITER $$
CREATE TRIGGER trg_price_before_update BEFORE UPDATE ON product_price
FOR EACH ROW
BEGIN
 IF NEW.selling_price < NEW.cost_price THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Selling price cannot be below cost price';
 END IF;
END$$
CREATE TRIGGER trg_price_after_update AFTER UPDATE ON product_price
FOR EACH ROW
BEGIN
 IF NOT (OLD.selling_price <=> NEW.selling_price) THEN
  INSERT INTO price_audit(product_id,old_price,new_price,changed_by,changed_at)
  VALUES(OLD.product_id,OLD.selling_price,NEW.selling_price,CURRENT_USER(),CURRENT_TIMESTAMP(6));
 END IF;
END$$
DELIMITER ;

-- SET 2: BANK ACCOUNT BALANCE GUARD
CREATE DATABASE IF NOT EXISTS day10_bank;
USE day10_bank;
CREATE TABLE IF NOT EXISTS accounts (
 account_id BIGINT PRIMARY KEY, account_type ENUM('SAVINGS','CURRENT') NOT NULL,
 balance DECIMAL(14,2) NOT NULL, last_txn_date DATETIME NULL,
 CHECK (balance >= 0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS account_transaction (
 txn_id BIGINT PRIMARY KEY, account_id BIGINT NOT NULL,
 txn_type ENUM('CREDIT','DEBIT') NOT NULL, amount DECIMAL(14,2) NOT NULL,
 txn_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK (amount > 0), FOREIGN KEY(account_id) REFERENCES accounts(account_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS account_transaction_audit (
 audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 action_name ENUM('INSERT','UPDATE','DELETE') NOT NULL,
 txn_id BIGINT NOT NULL, account_id BIGINT NOT NULL,
 old_amount DECIMAL(14,2) NULL, new_amount DECIMAL(14,2) NULL,
 changed_by VARCHAR(288) NOT NULL,
 changed_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB;
DROP TRIGGER IF EXISTS trg_accounts_before_update;
DROP TRIGGER IF EXISTS trg_txn_after_insert;
DROP TRIGGER IF EXISTS trg_txn_after_update;
DROP TRIGGER IF EXISTS trg_txn_after_delete;
DELIMITER $$
CREATE TRIGGER trg_accounts_before_update BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
 IF NEW.account_type='SAVINGS' AND NEW.balance < 0 THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Savings account balance cannot be negative';
 END IF;
END$$
CREATE TRIGGER trg_txn_after_insert AFTER INSERT ON account_transaction
FOR EACH ROW
BEGIN
 INSERT INTO account_transaction_audit(action_name,txn_id,account_id,old_amount,new_amount,changed_by)
 VALUES('INSERT',NEW.txn_id,NEW.account_id,NULL,NEW.amount,CURRENT_USER());
 UPDATE accounts SET last_txn_date=NEW.txn_time WHERE account_id=NEW.account_id;
END$$
CREATE TRIGGER trg_txn_after_update AFTER UPDATE ON account_transaction
FOR EACH ROW
BEGIN
 INSERT INTO account_transaction_audit(action_name,txn_id,account_id,old_amount,new_amount,changed_by)
 VALUES('UPDATE',NEW.txn_id,NEW.account_id,OLD.amount,NEW.amount,CURRENT_USER());
 UPDATE accounts SET last_txn_date=GREATEST(COALESCE(last_txn_date,NEW.txn_time),NEW.txn_time)
 WHERE account_id=NEW.account_id;
END$$
CREATE TRIGGER trg_txn_after_delete AFTER DELETE ON account_transaction
FOR EACH ROW
BEGIN
 INSERT INTO account_transaction_audit(action_name,txn_id,account_id,old_amount,new_amount,changed_by)
 VALUES('DELETE',OLD.txn_id,OLD.account_id,OLD.amount,NULL,CURRENT_USER());
 UPDATE accounts SET last_txn_date=(SELECT MAX(t.txn_time) FROM account_transaction t
 WHERE t.account_id=OLD.account_id) WHERE account_id=OLD.account_id;
END$$
DELIMITER ;

-- SET 3: HOSPITAL BED CAPACITY CONTROL
CREATE DATABASE IF NOT EXISTS day10_hospital;
USE day10_hospital;
CREATE TABLE IF NOT EXISTS ward (
 ward_id BIGINT PRIMARY KEY, ward_name VARCHAR(100) NOT NULL,
 bed_capacity INT NOT NULL CHECK (bed_capacity > 0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS admission (
 admission_id BIGINT PRIMARY KEY, patient_name VARCHAR(120) NOT NULL,
 ward_id BIGINT NOT NULL, admitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(ward_id) REFERENCES ward(ward_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS admission_audit (
 audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 action_name ENUM('INSERT','UPDATE','DELETE') NOT NULL,
 admission_id BIGINT NOT NULL, old_ward_id BIGINT NULL, new_ward_id BIGINT NULL,
 old_patient_name VARCHAR(120) NULL, new_patient_name VARCHAR(120) NULL,
 changed_by VARCHAR(288) NOT NULL,
 changed_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB;
DROP TRIGGER IF EXISTS trg_admission_before_insert;
DROP TRIGGER IF EXISTS trg_admission_after_insert;
DROP TRIGGER IF EXISTS trg_admission_after_update;
DROP TRIGGER IF EXISTS trg_admission_after_delete;
DELIMITER $$
CREATE TRIGGER trg_admission_before_insert BEFORE INSERT ON admission
FOR EACH ROW
BEGIN
 DECLARE v_capacity INT DEFAULT NULL;
 DECLARE v_occupied INT DEFAULT 0;
 SELECT bed_capacity INTO v_capacity FROM ward WHERE ward_id=NEW.ward_id;
 IF v_capacity IS NULL THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ward does not exist';
 END IF;
 SELECT COUNT(*) INTO v_occupied FROM admission WHERE ward_id=NEW.ward_id;
 IF v_occupied >= v_capacity THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Admission rejected: ward has reached bed capacity';
 END IF;
END$$
CREATE TRIGGER trg_admission_after_insert AFTER INSERT ON admission
FOR EACH ROW
BEGIN
 INSERT INTO admission_audit(action_name,admission_id,old_ward_id,new_ward_id,old_patient_name,new_patient_name,changed_by)
 VALUES('INSERT',NEW.admission_id,NULL,NEW.ward_id,NULL,NEW.patient_name,CURRENT_USER());
END$$
CREATE TRIGGER trg_admission_after_update AFTER UPDATE ON admission
FOR EACH ROW
BEGIN
 INSERT INTO admission_audit(action_name,admission_id,old_ward_id,new_ward_id,old_patient_name,new_patient_name,changed_by)
 VALUES('UPDATE',NEW.admission_id,OLD.ward_id,NEW.ward_id,OLD.patient_name,NEW.patient_name,CURRENT_USER());
END$$
CREATE TRIGGER trg_admission_after_delete AFTER DELETE ON admission
FOR EACH ROW
BEGIN
 INSERT INTO admission_audit(action_name,admission_id,old_ward_id,new_ward_id,old_patient_name,new_patient_name,changed_by)
 VALUES('DELETE',OLD.admission_id,OLD.ward_id,NULL,OLD.patient_name,NULL,CURRENT_USER());
END$$
DELIMITER ;

-- Concurrency note: count-then-insert can race. Production code should serialize
-- admissions with a transaction/stored procedure that locks the ward row, checks
-- occupancy, and inserts while holding the lock.
