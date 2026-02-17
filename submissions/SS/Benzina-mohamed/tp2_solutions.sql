-- ============================================
-- TP2: Hospital Management System Solutions
-- ============================================

-- 1. Database creation
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- 2. Table creation
-- Table: specialties
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10, 2) NOT NULL
);

-- Table: doctors
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: patients
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

-- Table: consultations
CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4, 2),
    weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10, 2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: medications
CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10, 2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

-- Table: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: prescription_details
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Indexes
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

-- 4. Test Data
-- Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary healthcare', 1500.00),
('Cardiology', 'Heart and blood vessels', 3000.00),
('Pediatrics', 'Medical care for children', 2000.00),
('Dermatology', 'Skin, hair, and nails', 2500.00),
('Orthopedics', 'Musculoskeletal system', 2800.00),
('Gynecology', 'Female reproductive system', 2500.00);

-- Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('House', 'Gregory', 'g.house@hospital.com', '555-0201', 1, 'LIC001', '2010-05-12', 'Room 101', TRUE),
('Shepherd', 'Derek', 'd.shepherd@hospital.com', '555-0202', 2, 'LIC002', '2012-08-20', 'Room 202', TRUE),
('Grey', 'Meredith', 'm.grey@hospital.com', '555-0203', 3, 'LIC003', '2015-01-15', 'Room 303', TRUE),
('Wilson', 'James', 'j.wilson@hospital.com', '555-0204', 4, 'LIC004', '2011-03-10', 'Room 404', TRUE),
('Torres', 'Callie', 'c.torres@hospital.com', '555-0205', 5, 'LIC005', '2013-11-05', 'Room 505', TRUE),
('Montgomery', 'Addison', 'a.montgomery@hospital.com', '555-0206', 6, 'LIC006', '2014-06-22', 'Room 606', TRUE);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('PAT001', 'Doe', 'John', '1985-04-10', 'M', 'A+', 'john.doe@email.com', '555-3001', '123 Maple St', 'Algiers', 'Algiers', '2024-01-10', 'CNAS', '12345678', 'Pollen', 'None'),
('PAT002', 'Smith', 'Jane', '1992-11-25', 'F', 'O-', 'jane.smith@email.com', '555-3002', '456 Oak Ave', 'Oran', 'Oran', '2024-02-15', 'CASNOS', '87654321', 'None', 'Asthma'),
('PAT003', 'Brown', 'Charlie', '2015-07-05', 'M', 'B+', 'c.brown@email.com', '555-3003', '789 Pine Rd', 'Constantine', 'Constantine', '2024-03-20', 'CNAS', '11223344', 'Peanuts', 'None'),
('PAT004', 'Davis', 'Alice', '1960-01-15', 'F', 'AB+', 'a.davis@email.com', '555-3004', '321 Elm St', 'Annaba', 'Annaba', '2024-04-05', 'None', NULL, 'Penicillin', 'Hypertension'),
('PAT005', 'Miller', 'Bob', '1978-09-30', 'M', 'A-', 'b.miller@email.com', '555-3005', '654 Maple Dr', 'Setif', 'Setif', '2024-05-12', 'CNAS', '55667788', 'None', 'Diabetes'),
('PAT006', 'Wilson', 'Eve', '2000-12-12', 'F', 'O+', 'e.wilson@email.com', '555-3006', '987 Cedar Ln', 'Batna', 'Batna', '2024-06-18', 'CASNOS', '99887766', 'Dust', 'None'),
('PAT007', 'Taylor', 'Frank', '1955-03-22', 'M', 'B-', 'f.taylor@email.com', '555-3007', '159 Birch Ct', 'Tlemcen', 'Tlemcen', '2024-07-25', 'None', NULL, 'None', 'Heart Disease'),
('PAT008', 'Moore', 'Grace', '1995-06-08', 'F', 'A+', 'g.moore@email.com', '555-3008', '753 Walnut St', 'Bejaia', 'Bejaia', '2024-08-30', 'CNAS', '44332211', 'None', 'None');

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:00:00', 'Fever and cough', 'Common Cold', 'Rest and fluids', '120/80', 38.5, 75.0, 180.0, 'Completed', 1500.00, TRUE),
(2, 2, '2025-01-12 10:30:00', 'Chest pain', 'Angina', 'Refer to specialist', '140/90', 36.8, 65.0, 165.0, 'Completed', 3000.00, TRUE),
(3, 3, '2025-01-15 14:00:00', 'Routine checkup', 'Healthy', 'Growth on track', '110/70', 36.6, 30.0, 120.0, 'Completed', 2000.00, TRUE),
(4, 4, '2025-01-18 11:00:00', 'Skin rash', 'Eczema', 'Apply cream', '130/85', 36.7, 70.0, 160.0, 'Completed', 2500.00, FALSE),
(5, 5, '2025-01-20 15:30:00', 'Knee pain', 'Arthritis', 'Physical therapy', '125/82', 36.5, 85.0, 175.0, 'Completed', 2800.00, TRUE),
(6, 6, '2025-01-22 09:30:00', 'Pregnancy test', 'Positive', 'Prenatal care started', '115/75', 36.9, 60.0, 168.0, 'Completed', 2500.00, TRUE),
(1, 2, '2025-02-05 10:00:00', 'Follow up', 'Improving', 'Continue meds', '120/80', 36.6, 75.0, 180.0, 'Scheduled', 3000.00, FALSE),
(7, 1, '2025-02-10 11:30:00', 'Headache', 'Migraine', 'Avoid bright lights', '135/88', 37.0, 80.0, 178.0, 'Completed', 1500.00, TRUE);

-- Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '500mg', 'Sanofi', 250.00, 100, 20, '2026-12-31', FALSE, TRUE),
('MED002', 'Amoxicillin', 'Amoxicillin', 'Capsule', '500mg', 'GSK', 600.00, 50, 15, '2025-06-30', TRUE, TRUE),
('MED003', 'Ventoline', 'Salbutamol', 'Inhaler', '100mcg', 'GSK', 850.00, 30, 10, '2026-03-15', TRUE, TRUE),
('MED004', 'Voltarene', 'Diclofenac', 'Gel', '1%', 'Novartis', 450.00, 40, 10, '2025-11-20', FALSE, FALSE),
('MED005', 'Augmentin', 'Amoxicillin/Clavulanic Acid', 'Tablet', '1g', 'GSK', 1200.00, 25, 10, '2025-08-10', TRUE, TRUE),
('MED006', 'Zyrtec', 'Cetirizine', 'Tablet', '10mg', 'UCB', 350.00, 60, 20, '2027-01-01', FALSE, TRUE),
('MED007', 'Lipitor', 'Atorvastatin', 'Tablet', '20mg', 'Pfizer', 1500.00, 20, 5, '2026-05-20', TRUE, TRUE),
('MED008', 'Gaviscon', 'Sodium Alginate', 'Syrup', '250ml', 'Reckitt', 550.00, 45, 15, '2025-12-15', FALSE, FALSE),
('MED009', 'Spasfon', 'Phloroglucinol', 'Tablet', '80mg', 'Teva', 300.00, 80, 20, '2026-09-10', FALSE, TRUE),
('MED010', 'Lasix', 'Furosemide', 'Tablet', '40mg', 'Sanofi', 400.00, 35, 10, '2025-04-15', TRUE, TRUE);

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 5, 'Take after meals'),
(2, 30, 'Daily morning intake'),
(4, 7, 'Apply twice daily'),
(5, 15, 'Rest knee'),
(6, 90, 'Prenatal vitamins'),
(8, 3, 'Dark room rest'),
(1, 7, 'Drink plenty of water');

-- Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 tab every 8h', 5, 500.00),
(1, 2, 1, '1 cap every 12h', 5, 600.00),
(2, 7, 1, '1 tab daily', 30, 1500.00),
(3, 4, 1, 'Apply on rash', 7, 450.00),
(4, 9, 2, '1 tab if pain', 15, 600.00),
(5, 6, 1, '1 tab daily', 90, 350.00),
(6, 1, 1, '1 tab if headache', 3, 250.00),
(7, 1, 2, '1 tab every 8h', 7, 500.00),
(2, 10, 1, '1 tab daily', 30, 400.00),
(5, 1, 1, '1 tab daily', 90, 250.00),
(1, 8, 1, '1 spoon after meal', 5, 550.00),
(4, 1, 2, '1 tab every 8h', 15, 500.00);

-- 5. 30 SQL Queries

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT consultation_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       c.status 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       c.diagnosis, c.amount 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       m.commercial_name AS medication_name, 
       pd.quantity, pd.dosage_instructions 
FROM prescription_details pd
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       MAX(c.consultation_date) AS last_consultation_date,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
GROUP BY p.patient_id;

-- Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q10. Display revenue by medical specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost 
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id;

-- Q12. Count the number of consultations per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q13. Calculate total stock value of pharmacy
SELECT COUNT(medication_id) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value 
FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, ROUND(AVG(c.amount), 2) AS average_price 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count FROM patients GROUP BY blood_type;

-- Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity 
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17. List patients who have never had a consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING consultation_count > 2;

-- Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration 
FROM medications 
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);

-- Q21. Find patients who consulted more than the average
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       COUNT(c.consultation_id) AS consultation_count,
       (SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub) as average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
HAVING consultation_count > (SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub);

-- Q22. List medications more expensive than average price
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) as average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, 
       (SELECT COUNT(*) FROM consultations c2 JOIN doctors d2 ON c2.doctor_id = d2.doctor_id WHERE d2.specialty_id = s.specialty_id) as specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
WHERE s.specialty_id = (
    SELECT d3.specialty_id 
    FROM consultations c3 
    JOIN doctors d3 ON c3.doctor_id = d3.doctor_id 
    GROUP BY d3.specialty_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount, 
       (SELECT AVG(amount) FROM consultations) as average_amount 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count 
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies != 'None'
GROUP BY p.patient_id;

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue 
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27. Display top 3 most profitable specialties
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) as `rank`, s.specialty_name, SUM(c.amount) AS total_revenue 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name, available_stock AS current_stock, minimum_stock, (minimum_stock - available_stock) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT AVG(med_count) AS average_medications_per_prescription 
FROM (SELECT COUNT(medication_id) as med_count FROM prescription_details GROUP BY prescription_id) as sub;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, date_of_birth)/365.25 <= 18 THEN '0-18'
        WHEN DATEDIFF(CURRENT_DATE, date_of_birth)/365.25 <= 40 THEN '19-40'
        WHEN DATEDIFF(CURRENT_DATE, date_of_birth)/365.25 <= 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM patients
GROUP BY age_group;
