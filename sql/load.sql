SET NAMES utf8mb4;

START TRANSACTION;

DROP TEMPORARY TABLE IF EXISTS seq;
DROP TEMPORARY TABLE IF EXISTS ref_ken;
DROP TEMPORARY TABLE IF EXISTS ref_medical_procedure;
CREATE TEMPORARY TABLE seq (n INT PRIMARY KEY);
INSERT INTO seq(n)
SELECT ones.i + tens.i * 10 + hundreds.i * 100 + 1 AS n
FROM (
    SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) ones
CROSS JOIN (
    SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
) tens
CROSS JOIN (
    SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) hundreds
WHERE ones.i + tens.i * 10 + hundreds.i * 100 + 1 <= 600;

-- Doctors and core medical staff.
INSERT INTO Personel (AMKA, Name, Surname, Birthdate, Email, Phone, HiringDate)
SELECT
    CONCAT('2000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 10), 'Andreas', 'Eleni', 'Dimitris', 'Maria', 'Nikos', 'Sofia', 'Giorgos', 'Katerina', 'Petros', 'Anna'),
    ELT(1 + MOD(n, 10), 'Papadopoulos', 'Nikolaou', 'Georgiou', 'Konstantinou', 'Ioannou', 'Dimitriou', 'Apostolou', 'Pappa', 'Vasileiou', 'Markou'),
    CASE WHEN n IN (15, 31, 47, 63, 79) THEN DATE_ADD('1995-01-01', INTERVAL n DAY)
         ELSE DATE_ADD('1968-01-01', INTERVAL (n * 137) DAY) END,
    CONCAT('doctor', n, '@ygieiapolis.gr'),
    CONCAT('2108', LPAD(n, 6, '0')),
    DATE_ADD('2004-01-01', INTERVAL (n * 53) DAY)
FROM seq
WHERE n <= 80;

INSERT INTO Doctor (Doctor_AMKA, LicenseNumber, Major, `Rank`, Supervisor_AMKA)
SELECT
    CONCAT('2000000', LPAD(n, 4, '0')),
    CONCAT('LIC-', LPAD(1000 + n, 4, '0')),
    ELT(1 + MOD(n, 8), 'Cardiology', 'Surgery', 'Emergency Medicine', 'Intensive Care', 'Pathology', 'Radiology', 'Microbiology', 'Neurology'),
    CASE
        WHEN n <= 15 THEN 'Director'
        WHEN n <= 35 THEN 'Attending A'
        WHEN n <= 60 THEN 'Attending B'
        ELSE 'Resident'
    END,
    CASE
        WHEN n <= 15 THEN NULL
        WHEN n <= 35 THEN CONCAT('2000000', LPAD(1 + MOD(n - 16, 15), 4, '0'))
        WHEN n <= 60 THEN CONCAT('2000000', LPAD(16 + MOD(n - 36, 20), 4, '0'))
        ELSE CONCAT('2000000', LPAD(36 + MOD(n - 61, 25), 4, '0'))
    END
FROM seq
WHERE n <= 80;

-- Explicit supervision examples for the recursive hierarchy query:
-- Resident -> Attending B -> Attending A -> Director.
UPDATE Doctor SET Supervisor_AMKA = '20000000036' WHERE Doctor_AMKA = '20000000061';
UPDATE Doctor SET Supervisor_AMKA = '20000000016' WHERE Doctor_AMKA = '20000000036';
UPDATE Doctor SET Supervisor_AMKA = '20000000001' WHERE Doctor_AMKA = '20000000016';

-- Hospital departments.
INSERT INTO Department (Department_id, Name, Description, BedTotal, Floor_Building, Head_AMKA) VALUES
(1, 'Cardiology', 'Cardiac care and monitoring', 10, 'A-2', '20000000001'),
(2, 'Surgery', 'Surgical cases and postoperative care', 10, 'B-3', '20000000002'),
(3, 'Emergency', 'Emergency department and triage admissions', 10, 'A-0', '20000000003'),
(4, 'ICU', 'Intensive care unit', 10, 'C-1', '20000000004'),
(5, 'Pathology', 'Internal medicine ward', 10, 'B-2', '20000000005'),
(6, 'Radiology', 'Diagnostic imaging and interventional radiology', 10, 'C-0', '20000000006'),
(7, 'Microbiology', 'Clinical laboratory and microbiology', 10, 'D-1', '20000000007'),
(8, 'Neurology', 'Neurological admissions and stroke follow-up', 10, 'D-2', '20000000008'),
(9, 'Orthopedics', 'Orthopedic and trauma care', 10, 'E-1', '20000000009'),
(10, 'Pulmonology', 'Respiratory medicine ward', 10, 'E-2', '20000000010'),
(11, 'Gastroenterology', 'Digestive diseases and endoscopy follow-up', 10, 'F-1', '20000000011'),
(12, 'Nephrology', 'Renal medicine and dialysis support', 10, 'F-2', '20000000012'),
(13, 'Oncology', 'Oncology admissions and treatment monitoring', 10, 'G-1', '20000000013'),
(14, 'Pediatrics', 'Pediatric clinical care', 10, 'G-2', '20000000014'),
(15, 'Urology', 'Urological care and procedures', 10, 'H-1', '20000000015');

INSERT INTO Doctor_Department (Doctor_AMKA, Department_id)
SELECT CONCAT('2000000', LPAD(n, 4, '0')), 1 + MOD(n - 1, 15)
FROM seq
WHERE n <= 80;

INSERT INTO Doctor_Department (Doctor_AMKA, Department_id)
SELECT CONCAT('2000000', LPAD(n, 4, '0')), 1 + MOD(n + 3, 15)
FROM seq
WHERE n <= 30;

-- Nurses and administrative staff.
INSERT INTO Personel (AMKA, Name, Surname, Birthdate, Email, Phone, HiringDate)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 10), 'Marios', 'Eva', 'Thanos', 'Lydia', 'Pavlos', 'Nefeli', 'Aris', 'Rania', 'Manolis', 'Ioanna'),
    ELT(1 + MOD(n, 10), 'Alexiou', 'Beka', 'Chatzis', 'Drosou', 'Efthimiou', 'Zervas', 'Iliou', 'Karagianni', 'Leventis', 'Xenou'),
    DATE_ADD('1978-01-01', INTERVAL (n * 97) DAY),
    CONCAT('staff', n, '@ygieiapolis.gr'),
    CONCAT('211', LPAD(n, 7, '0')),
    DATE_ADD('2010-01-01', INTERVAL (n * 31) DAY)
FROM seq
WHERE n <= 180;

INSERT INTO Nurse (Nurse_AMKA, `Rank`, Department_id)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 3), 'Assistant Nurse', 'Nurse', 'Head Nurse'),
    1 + MOD(n - 1, 15)
FROM seq
WHERE n BETWEEN 1 AND 120;

INSERT INTO Staff (Staff_AMKA, Role, Office, Department_id)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 4), 'Secretary', 'Accountant', 'Admissions Clerk', 'IT Support'),
    CONCAT('Office ', 100 + n),
    1 + MOD(n - 1, 15)
FROM seq
WHERE n BETWEEN 121 AND 180;

INSERT INTO Bed (Bed_id, Department_id, Type, Status)
SELECT
    (1 + FLOOR((n - 1) / 10)) * 100 + (1 + MOD(n - 1, 10)),
    1 + FLOOR((n - 1) / 10),
    ELT(1 + MOD(n, 3), 'Single', 'Shared', 'ICU'),
    ELT(1 + MOD(n, 3), 'Available', 'Occupied', 'Maintenance')
FROM seq
WHERE n <= 150;

-- Patients.
INSERT INTO Patient (Patient_AMKA, Name, Surname, FathersName, Birthdate, Sex, Weight, Height, Address, Phone, Email, Job, Nationality, Insurance)
SELECT
    CONCAT('1000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 10), 'Kostas', 'Eleni', 'Giorgos', 'Maria', 'Nikos', 'Sofia', 'Dimitra', 'Antonis', 'Katerina', 'Spyros'),
    ELT(1 + MOD(n, 10), 'Papadaki', 'Nikolaidi', 'Georgiou', 'Kosta', 'Ioannidi', 'Dimitriadi', 'Petrou', 'Stavrou', 'Vlachou', 'Mara'),
    ELT(1 + MOD(n, 5), 'Ioannis', 'Petros', 'Dimitrios', 'Christos', 'Michail'),
    DATE_ADD('1945-01-01', INTERVAL (n * 123) DAY),
    IF(MOD(n, 2) = 0, 'F', 'M'),
    55 + MOD(n * 7, 45),
    1.55 + MOD(n, 35) / 100,
    CONCAT('Street ', n, ', Athens'),
    CONCAT('690', LPAD(n, 7, '0')),
    CONCAT('patient', n, '@example.gr'),
    ELT(1 + MOD(n, 6), 'Teacher', 'Engineer', 'Student', 'Retired', 'Driver', 'Employee'),
    'Greek',
    ELT(1 + MOD(n, 4), 'EFKA', 'Private', 'Uninsured', 'Public')
FROM seq
WHERE n <= 200;

INSERT INTO EmergencyContact (EmergencyContact_id, Name, Number, Relation)
SELECT n, CONCAT('Contact ', n), CONCAT('697', LPAD(n, 7, '0')), ELT(1 + MOD(n, 4), 'Parent', 'Spouse', 'Sibling', 'Friend')
FROM seq
WHERE n <= 200;

INSERT INTO Patient_EmergencyContact (Patient_AMKA, EmergencyContact_id)
SELECT CONCAT('1000000', LPAD(n, 4, '0')), n
FROM seq
WHERE n <= 200;

-- Reference data from CSV files.
LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/ken.csv'
INTO TABLE KEN
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(KEN_id, Description, Base_cost, AverageStay, Additional_daily_cost);

CREATE TEMPORARY TABLE ref_ken AS
SELECT ROW_NUMBER() OVER (ORDER BY KEN_id) AS rn, KEN_id
FROM KEN;
SET @ken_count = (SELECT COUNT(*) FROM ref_ken);

-- Rooms.
INSERT INTO Room (Room_id, Type, Name) VALUES
(1, 'Operating Room', 'OR-1'),
(2, 'Operating Room', 'OR-2'),
(3, 'Operating Room', 'OR-3'),
(4, 'Operating Room', 'OR-4'),
(5, 'Intervention Room', 'IR-1'),
(6, 'Intervention Room', 'IR-2'),
(7, 'Radiology Room', 'XR-1'),
(8, 'Endoscopy Room', 'END-1'),
(9, 'Laboratory', 'LAB-1'),
(10, 'Minor Surgery Room', 'MSR-1');

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/medical_procedures.csv'
INTO TABLE MedicalProcedure
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(MedicalProcedure_id, Name, Category, Duration, Cost);

CREATE TEMPORARY TABLE ref_medical_procedure AS
SELECT ROW_NUMBER() OVER (ORDER BY MedicalProcedure_id) AS rn, MedicalProcedure_id
FROM MedicalProcedure;
SET @medical_procedure_count = (SELECT COUNT(*) FROM ref_medical_procedure);

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/active_substances.csv'
INTO TABLE ActiveSubstance
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Substance_id, Name);
SET @substance_count = (SELECT COUNT(*) FROM ActiveSubstance);

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/medicines.csv'
INTO TABLE Medicine
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Medicine_id, Name);
SET @medicine_count = (SELECT COUNT(*) FROM Medicine);

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/medicine_substances.csv'
INTO TABLE Medicine_Substance
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Medicine_id, Substance_id);

INSERT INTO Patient_Allergy (Patient_AMKA, Substance_id)
SELECT CONCAT('1000000', LPAD(n, 4, '0')), 1 + MOD(n - 1, @substance_count)
FROM seq
WHERE n <= 80;

INSERT INTO Triage (Triage_id, Patient_AMKA, Nurse_AMKA, Symptoms, Urgency_level, Arrival_time)
SELECT
    n,
    CONCAT('1000000', LPAD(1 + MOD(n - 1, 200), 4, '0')),
    CONCAT('3000000', LPAD(1 + MOD(n - 1, 120), 4, '0')),
    ELT(1 + MOD(n, 6), 'Chest pain', 'Fever and cough', 'Abdominal pain', 'Shortness of breath', 'Injury', 'Dizziness'),
    1 + MOD(n, 5),
    DATE_ADD('2026-01-01 08:00:00', INTERVAL (n * 7) HOUR)
FROM seq
WHERE n <= 300;

-- Hospitalisations.
INSERT INTO Hospitalisation (Hospitalisation_id, Patient_AMKA, Department_id, Bed_id, EntryDate, ReleaseDate, FirstDiagnosis, FinalDiagnosis, KEN_id, Cost)
SELECT
    s.n,
    CONCAT('1000000', LPAD(1 + MOD(s.n - 1, 200), 4, '0')),
    1 + MOD(s.n - 1, 15),
    (1 + MOD(s.n - 1, 15)) * 100 + 1 + MOD(s.n - 1, 10),
    DATE_ADD('2024-01-03', INTERVAL (s.n * 3) DAY),
    DATE_ADD(DATE_ADD('2024-01-03', INTERVAL (s.n * 3) DAY), INTERVAL (2 + MOD(s.n, 20)) DAY),
    ELT(1 + MOD(s.n, 6), 'I50 Heart failure', 'K35 Acute appendicitis', 'J18 Pneumonia', 'I63 Stroke', 'A41 Sepsis', 'E11 Diabetes mellitus'),
    ELT(1 + MOD(s.n, 6), 'I50.9 Heart failure resolved', 'K35 Appendicitis treated', 'J18.9 Pneumonia improved', 'I63.9 Stroke rehabilitation', 'A41.9 Sepsis controlled', 'E11 Diabetes stabilized'),
    CASE 1 + MOD(s.n, 6)
        WHEN 1 THEN CONVERT(0xCE9A3432CEA7 USING utf8mb4) -- heart failure
        WHEN 2 THEN CONVERT(0xCEA03037CEA7 USING utf8mb4) -- appendicitis
        WHEN 3 THEN CONVERT(0xCE913232CEA7 USING utf8mb4) -- respiratory
        WHEN 4 THEN CONVERT(0xCE9D3330CEA7 USING utf8mb4) -- stroke
        WHEN 5 THEN CONVERT(0xCEA13230CEA7 USING utf8mb4) -- sepsis
        WHEN 6 THEN CONVERT(0xCE983230CEA7 USING utf8mb4) -- diabetes
    END,
    1200 + MOD(s.n * 137, 5200)
FROM seq s
WHERE s.n <= 500;

-- Rows used by the query set.
UPDATE Hospitalisation
SET Patient_AMKA = '10000000001',
    Department_id = 1,
    Bed_id = 101,
    KEN_id = CONVERT(0xCE913232CEA7 USING utf8mb4),
    FirstDiagnosis = 'J18 Pneumonia',
    FinalDiagnosis = 'J18.9 Pneumonia improved'
WHERE Hospitalisation_id IN (1, 2, 3, 4);

UPDATE Hospitalisation
SET EntryDate = '2026-03-20', ReleaseDate = '2026-04-10', Cost = 2400
WHERE Hospitalisation_id = 1;

UPDATE Hospitalisation
SET EntryDate = '2025-01-10', ReleaseDate = '2025-01-28', Cost = 2100
WHERE Hospitalisation_id = 2;

INSERT INTO Exam (Exam_id, Type, Date, Result_text, Result_value, Unit, Cost, Hospitalisation_id, Doctor_AMKA)
SELECT
    n,
    ELT(1 + MOD(n, 6), 'Blood count', 'CRP', 'Troponin', 'Glucose', 'Chest X-Ray', 'Creatinine'),
    DATE_ADD('2024-01-04', INTERVAL (n * 4) DAY),
    ELT(1 + MOD(n, 4), 'Normal', 'Slightly elevated', 'Requires follow up', 'Improved'),
    ROUND(10 + MOD(n * 13, 180) / 3, 2),
    ELT(1 + MOD(n, 5), 'mg/dL', 'U/L', 'ng/L', 'mmol/L', ''),
    15 + MOD(n * 11, 160),
    1 + MOD(n - 1, 500),
    CONCAT('2000000', LPAD(1 + MOD(n - 1, 80), 4, '0'))
FROM seq
WHERE n <= 300;

INSERT INTO Hospitalisation_Procedure (id, Hospitalisation_id, MedicalProcedure_id, Date, Room_id)
SELECT
    s.n,
    1 + MOD(s.n - 1, 500),
    rmp.MedicalProcedure_id,
    DATE_ADD('2026-01-05', INTERVAL MOD(s.n * 3, 120) DAY),
    1 + MOD(s.n - 1, 10)
FROM seq s
JOIN ref_medical_procedure rmp ON rmp.rn = 1 + MOD(s.n - 1, @medical_procedure_count)
WHERE s.n <= 200;

-- 2026 procedure used in query checks.
UPDATE Hospitalisation_Procedure
SET Hospitalisation_id = 1,
    MedicalProcedure_id = (SELECT mp.MedicalProcedure_id FROM MedicalProcedure mp WHERE mp.Category LIKE (CONVERT(0xCE922E25 USING utf8mb4) COLLATE utf8mb4_unicode_ci) LIMIT 1),
    Date = '2026-04-05',
    Room_id = 1
WHERE id = 120;

INSERT INTO MedicalProcedure_Staff (Hospitalisation_Procedure, Personel_AMKA, Role)
SELECT
    n,
    CONCAT('2000000', LPAD(1 + MOD(n - 1, 80), 4, '0')),
    'Lead doctor'
FROM seq
WHERE n <= 200;

-- Young lead doctor for the B-category procedure.
UPDATE MedicalProcedure_Staff
SET Personel_AMKA = '20000000015'
WHERE Hospitalisation_Procedure = 120 AND Role = 'Lead doctor';

-- Lead procedure distribution for Q11.
UPDATE MedicalProcedure_Staff
SET Personel_AMKA = '20000000015'
WHERE Hospitalisation_Procedure BETWEEN 1 AND 24 AND Role = 'Lead doctor';

INSERT INTO MedicalProcedure_Staff (Hospitalisation_Procedure, Personel_AMKA, Role)
SELECT
    n,
    CONCAT('3000000', LPAD(1 + MOD(n - 1, 120), 4, '0')),
    'Assistant'
FROM seq
WHERE n <= 200;

-- Prescriptions.
INSERT INTO Prescription (Prescription_id, Doctor_AMKA, Patient_AMKA, Medicine_id, Dose, Frequency, StartDate, EndDate)
SELECT
    n,
    CONCAT('2000000', LPAD(1 + MOD(n - 1, 80), 4, '0')),
    CONCAT('1000000', LPAD(1 + MOD(n - 1, 200), 4, '0')),
    1 + MOD(n - 1, @medicine_count),
    ELT(1 + MOD(n, 4), '500mg', '1 tablet', '10mg', '2 puffs'),
    ELT(1 + MOD(n, 4), 'Once daily', 'Twice daily', 'Every 8 hours', 'As needed'),
    DATE_ADD('2024-01-06', INTERVAL (n * 3) DAY),
    DATE_ADD('2024-01-16', INTERVAL (n * 3) DAY)
FROM seq
WHERE n <= 300;

-- One week of shifts for all departments.
INSERT INTO Shift (Shift_id, Date, Type, Department_id)
SELECT
    n,
    DATE_ADD('2026-04-01', INTERVAL FLOOR((n - 1) / 45) DAY),
    ELT(1 + MOD(FLOOR((n - 1) / 15), 3), 'Morning', 'Evening', 'Night'),
    1 + MOD(n - 1, 15)
FROM seq
WHERE n <= 315;

-- Shift staffing.
INSERT IGNORE INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, CONCAT('2000000', LPAD(sh.Department_id + 15 * k.k, 4, '0'))
FROM seq s
JOIN Shift sh ON sh.Shift_id = s.n
JOIN (SELECT 0 k UNION ALL SELECT 1 UNION ALL SELECT 2) k
WHERE s.n <= 315;

INSERT IGNORE INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, CONCAT('3000000', LPAD(sh.Department_id + 15 * MOD(s.n + k.k, 8), 4, '0'))
FROM seq s
JOIN Shift sh ON sh.Shift_id = s.n
JOIN (SELECT 0 k UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) k
WHERE s.n <= 315;

INSERT IGNORE INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, CONCAT('3000000', LPAD(120 + sh.Department_id + 15 * MOD(s.n + k.k, 4), 4, '0'))
FROM seq s
JOIN Shift sh ON sh.Shift_id = s.n
JOIN (SELECT 0 k UNION ALL SELECT 1) k
WHERE s.n <= 315;

INSERT INTO Rating (Rating_id, Patient_AMKA, Hospitalisation_id, Medical_care, Nursing_care, Food, Hygiene, Overall_experience)
SELECT
    n,
    CONCAT('1000000', LPAD(1 + MOD(n - 1, 200), 4, '0')),
    n,
    1 + MOD(n, 5),
    1 + MOD(n + 1, 5),
    1 + MOD(n + 2, 5),
    1 + MOD(n + 3, 5),
    1 + MOD(n + 4, 5)
FROM seq
WHERE n <= 300;



DROP TEMPORARY TABLE ref_medical_procedure;
DROP TEMPORARY TABLE ref_ken;
DROP TEMPORARY TABLE seq;

COMMIT;
