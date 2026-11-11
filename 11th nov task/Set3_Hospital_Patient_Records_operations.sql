USE hospital_records;
SELECT * FROM visits WHERE visit_id=1;
UPDATE visits SET status='CLOSED' WHERE visit_id=1;
DELETE FROM billing WHERE visit_id=10;
DELETE FROM visits WHERE visit_id=10;
SELECT DISTINCT p.patient_id,p.patient_name,v.visit_date FROM patients p JOIN visits v ON p.patient_id=v.patient_id WHERE v.visit_date>='2026-10-01' AND v.visit_date<'2026-11-01' ORDER BY v.visit_date;
SELECT d.doctor_name,dep.department_name FROM doctors d JOIN departments dep ON d.department_id=dep.department_id ORDER BY dep.department_name,d.doctor_name;
-- Destructive demonstration on a dedicated practice database only.
CREATE DATABASE IF NOT EXISTS hospital_training;
USE hospital_training;
CREATE TABLE demo_table(id INT PRIMARY KEY,note VARCHAR(40));
RENAME TABLE demo_table TO renamed_demo_table;
DROP DATABASE hospital_training;
CREATE DATABASE hospital_training;