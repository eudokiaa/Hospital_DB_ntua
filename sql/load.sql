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
    SELECT 0 i UNION ALL SELECT 1 UNION ALL SELECT 2
) hundreds
WHERE ones.i + tens.i * 10 + hundreds.i * 100 + 1 <= 250;

INSERT INTO Personel (AMKA, Name, Surname, Birthdate, Email, Phone, HiringDate) VALUES
('20000000001', 'Andreas', 'Papadopoulos', '1972-03-14', 'andreas.papadopoulos@ygieiapolis.gr', '2108000001', '2004-09-01'),
('20000000002', 'Eleni', 'Nikolaou', '1975-11-20', 'eleni.nikolaou@ygieiapolis.gr', '2108000002', '2007-02-12'),
('20000000003', 'Dimitris', 'Georgiou', '1981-06-08', 'dimitris.georgiou@ygieiapolis.gr', '2108000003', '2012-05-20'),
('20000000004', 'Maria', 'Konstantinou', '1985-02-17', 'maria.konstantinou@ygieiapolis.gr', '2108000004', '2014-10-01'),
('20000000005', 'Nikos', 'Ioannou', '1988-07-25', 'nikos.ioannou@ygieiapolis.gr', '2108000005', '2016-03-15'),
('20000000006', 'Sofia', 'Dimitriou', '1990-01-11', 'sofia.dimitriou@ygieiapolis.gr', '2108000006', '2018-06-04'),
('20000000007', 'Giorgos', 'Apostolou', '1992-04-19', 'giorgos.apostolou@ygieiapolis.gr', '2108000007', '2020-01-20'),
('20000000008', 'Katerina', 'Pappa', '1993-09-09', 'katerina.pappa@ygieiapolis.gr', '2108000008', '2021-09-06'),
('20000000009', 'Petros', 'Vasileiou', '1984-12-02', 'petros.vasileiou@ygieiapolis.gr', '2108000009', '2015-04-10'),
('20000000010', 'Anna', 'Markou', '1991-08-13', 'anna.markou@ygieiapolis.gr', '2108000010', '2019-11-18'),
('20000000011', 'Christos', 'Lambrou', '1987-05-30', 'christos.lambrou@ygieiapolis.gr', '2108000011', '2017-07-03'),
('20000000012', 'Irene', 'Stamatiou', '1994-10-22', 'irene.stamatiou@ygieiapolis.gr', '2108000012', '2022-02-14'),
('20000000013', 'Panagiotis', 'Rallis', '1983-01-28', 'panagiotis.rallis@ygieiapolis.gr', '2108000013', '2013-12-02'),
('20000000014', 'Vasiliki', 'Koutra', '1989-06-16', 'vasiliki.koutra@ygieiapolis.gr', '2108000014', '2018-08-27'),
('20000000015', 'Stavros', 'Mylonas', '1995-03-03', 'stavros.mylonas@ygieiapolis.gr', '2108000015', '2023-01-09'),
('20000000016', 'Alexandra', 'Fotiou', '1979-12-12', 'alexandra.fotiou@ygieiapolis.gr', '2108000016', '2009-09-14'),
('20000000017', 'Michalis', 'Sarris', '1986-07-07', 'michalis.sarris@ygieiapolis.gr', '2108000017', '2016-10-24'),
('20000000018', 'Daphne', 'Oikonomou', '1990-02-05', 'daphne.oikonomou@ygieiapolis.gr', '2108000018', '2020-05-11');

INSERT INTO Personel (AMKA, Name, Surname, Birthdate, Email, Phone, HiringDate)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 10), 'Marios', 'Eva', 'Thanos', 'Lydia', 'Pavlos', 'Nefeli', 'Aris', 'Rania', 'Manolis', 'Ioanna'),
    ELT(1 + MOD(n, 10), 'Alexiou', 'Beka', 'Chatzis', 'Drosou', 'Efthimiou', 'Zervas', 'Iliou', 'Karagianni', 'Leventis', 'Xenou'),
    DATE_ADD('1978-01-01', INTERVAL (n * 111) DAY),
    CONCAT('staff', n, '@ygieiapolis.gr'),
    CONCAT('211', LPAD(n, 7, '0')),
    DATE_ADD('2010-01-01', INTERVAL (n * 47) DAY)
FROM seq
WHERE n <= 60;

INSERT INTO Doctor (Doctor_AMKA, LicenseNumber, Major, `Rank`, Supervisor_AMKA) VALUES
('20000000001', 'LIC-1001', 'Cardiology', 'Director', NULL),
('20000000002', 'LIC-1002', 'Surgery', 'Director', NULL),
('20000000003', 'LIC-1003', 'Emergency Medicine', 'Director', NULL),
('20000000004', 'LIC-1004', 'Intensive Care', 'Director', NULL),
('20000000005', 'LIC-1005', 'Pathology', 'Attending A', '20000000001'),
('20000000006', 'LIC-1006', 'Cardiology', 'Attending B', '20000000001'),
('20000000007', 'LIC-1007', 'Surgery', 'Attending A', '20000000002'),
('20000000008', 'LIC-1008', 'Surgery', 'Resident', '20000000007'),
('20000000009', 'LIC-1009', 'Emergency Medicine', 'Attending A', '20000000003'),
('20000000010', 'LIC-1010', 'Emergency Medicine', 'Resident', '20000000009'),
('20000000011', 'LIC-1011', 'Intensive Care', 'Attending A', '20000000004'),
('20000000012', 'LIC-1012', 'Intensive Care', 'Resident', '20000000011'),
('20000000013', 'LIC-1013', 'Pathology', 'Attending A', '20000000005'),
('20000000014', 'LIC-1014', 'Cardiology', 'Resident', '20000000006'),
('20000000015', 'LIC-1015', 'Surgery', 'Resident', '20000000007'),
('20000000016', 'LIC-1016', 'Radiology', 'Director', NULL),
('20000000017', 'LIC-1017', 'Radiology', 'Attending A', '20000000016'),
('20000000018', 'LIC-1018', 'Microbiology', 'Director', NULL);

INSERT INTO Department (Department_id, Name, Description, BedTotal, Floor_Building, Head_AMKA) VALUES
(1, 'Cardiology', 'Cardiac care and monitoring', 10, 'A-2', '20000000001'),
(2, 'Surgery', 'Surgical cases and postoperative care', 10, 'B-3', '20000000002'),
(3, 'Emergency', 'Emergency department and triage admissions', 10, 'A-0', '20000000003'),
(4, 'ICU', 'Intensive care unit', 10, 'C-1', '20000000004'),
(5, 'Pathology', 'Internal medicine ward', 10, 'B-2', '20000000005');

INSERT INTO Doctor_Department (Doctor_AMKA, Department_id) VALUES
('20000000001', 1), ('20000000005', 1), ('20000000006', 1), ('20000000014', 1),
('20000000002', 2), ('20000000007', 2), ('20000000008', 2), ('20000000015', 2),
('20000000003', 3), ('20000000009', 3), ('20000000010', 3),
('20000000004', 4), ('20000000011', 4), ('20000000012', 4),
('20000000005', 5), ('20000000013', 5), ('20000000016', 3), ('20000000017', 3), ('20000000018', 5);

INSERT INTO Nurse (Nurse_AMKA, `Rank`, Department_id)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 3), 'Assistant Nurse', 'Nurse', 'Head Nurse'),
    1 + MOD(n, 5)
FROM seq
WHERE n BETWEEN 1 AND 35;

INSERT INTO Staff (Staff_AMKA, Role, Office, Department_id)
SELECT
    CONCAT('3000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 4), 'Secretary', 'Accountant', 'Admissions Clerk', 'IT Support'),
    CONCAT('Office ', 100 + n),
    1 + MOD(n, 5)
FROM seq
WHERE n BETWEEN 36 AND 60;

INSERT INTO Bed (Bed_id, Department_id, Type, Status)
SELECT
    (1 + FLOOR((n - 1) / 10)) * 100 + (1 + MOD(n - 1, 10)),
    1 + FLOOR((n - 1) / 10),
    ELT(1 + MOD(n, 3), 'Single', 'Shared', 'ICU'),
    ELT(1 + MOD(n, 3), 'Available', 'Occupied', 'Maintenance')
FROM seq
WHERE n <= 50;

INSERT INTO Patient (Patient_AMKA, Name, Surname, FathersName, Birthdate, Sex, Weight, Height, Address, Phone, Email, Job, Nationality, Insurance)
SELECT
    CONCAT('1000000', LPAD(n, 4, '0')),
    ELT(1 + MOD(n, 10), 'Kostas', 'Eleni', 'Giorgos', 'Maria', 'Nikos', 'Sofia', 'Dimitra', 'Antonis', 'Katerina', 'Spyros'),
    ELT(1 + MOD(n, 10), 'Papadaki', 'Nikolaidi', 'Georgiou', 'Kosta', 'Ioannidi', 'Dimitriadi', 'Petrou', 'Stavrou', 'Vlachou', 'Mara'),
    ELT(1 + MOD(n, 5), 'Ioannis', 'Petros', 'Dimitrios', 'Christos', 'Michail'),
    DATE_ADD('1945-01-01', INTERVAL (n * 222) DAY),
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
WHERE n <= 80;

INSERT INTO EmergencyContact (EmergencyContact_id, Name, Number, Relation)
SELECT n, CONCAT('Contact ', n), CONCAT('697', LPAD(n, 7, '0')), ELT(1 + MOD(n, 4), 'Parent', 'Spouse', 'Sibling', 'Friend')
FROM seq
WHERE n <= 80;

INSERT INTO Patient_EmergencyContact (Patient_AMKA, EmergencyContact_id)
SELECT CONCAT('1000000', LPAD(n, 4, '0')), n
FROM seq
WHERE n <= 80;

-- Reference data from CSV files, as requested in the assignment.
-- Run the mysql client from the project root so paths like data/ken.csv resolve correctly.
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

INSERT INTO Room (Room_id, Type, Name) VALUES
(1, 'Operating Room', 'OR-1'),
(2, 'Operating Room', 'OR-2'),
(3, 'Intervention Room', 'IR-1'),
(4, 'Radiology Room', 'XR-1'),
(5, 'Endoscopy Room', 'END-1'),
(6, 'Laboratory', 'LAB-1');

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

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/medicines.csv'
INTO TABLE Medicine
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Medicine_id, Name);

LOAD DATA LOCAL INFILE 'C:/Users/nekti/Desktop/database121/data/medicine_substances.csv'
INTO TABLE Medicine_Substance
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Medicine_id, Substance_id);

INSERT INTO Patient_Allergy (Patient_AMKA, Substance_id)
SELECT CONCAT('1000000', LPAD(n, 4, '0')), 1 + MOD(n, 8)
FROM seq
WHERE n <= 20;

INSERT INTO Triage (Triage_id, Patient_AMKA, Nurse_AMKA, Symptoms, Urgency_level, Arrival_time)
SELECT
    n,
    CONCAT('1000000', LPAD(1 + MOD(n, 80), 4, '0')),
    CONCAT('3000000', LPAD(1 + MOD(n, 35), 4, '0')),
    ELT(1 + MOD(n, 6), 'Chest pain', 'Fever and cough', 'Abdominal pain', 'Shortness of breath', 'Injury', 'Dizziness'),
    1 + MOD(n, 5),
    DATE_ADD('2024-01-01 08:00:00', INTERVAL (n * 17) HOUR)
FROM seq
WHERE n <= 150;

INSERT INTO Hospitalisation (Hospitalisation_id, Patient_AMKA, Department_id, Bed_id, EntryDate, ReleaseDate, FirstDiagnosis, FinalDiagnosis, KEN_id, Cost)
SELECT
    s.n,
    CONCAT('1000000', LPAD(1 + MOD(s.n, 80), 4, '0')),
    1 + MOD(s.n, 5),
    (1 + MOD(s.n, 5)) * 100 + 1 + MOD(s.n, 10),
    DATE_ADD('2024-01-03', INTERVAL (s.n * 6) DAY),
    DATE_ADD(DATE_ADD('2024-01-03', INTERVAL (s.n * 6) DAY), INTERVAL (2 + MOD(s.n, 12)) DAY),
    ELT(1 + MOD(s.n, 6), 'I50 Heart failure', 'K35 Acute appendicitis', 'J18 Pneumonia', 'I63 Stroke', 'A41 Sepsis', 'E11 Diabetes mellitus'),
    ELT(1 + MOD(s.n, 6), 'I50.9 Heart failure resolved', 'K35 Appendicitis treated', 'J18.9 Pneumonia improved', 'I63.9 Stroke rehabilitation', 'A41.9 Sepsis controlled', 'E11 Diabetes stabilized'),
    rk.KEN_id,
    1200 + MOD(s.n * 137, 5200)
FROM seq s
JOIN ref_ken rk ON rk.rn = 1 + MOD(s.n, @ken_count)
WHERE s.n <= 150;

INSERT INTO Exam (Exam_id, Type, Date, Result_text, Result_value, Unit, Cost, Hospitalisation_id, Doctor_AMKA)
SELECT
    n,
    ELT(1 + MOD(n, 6), 'Blood count', 'CRP', 'Troponin', 'Glucose', 'Chest X-Ray', 'Creatinine'),
    DATE_ADD('2024-01-04', INTERVAL (n * 4) DAY),
    ELT(1 + MOD(n, 4), 'Normal', 'Slightly elevated', 'Requires follow up', 'Improved'),
    ROUND(10 + MOD(n * 13, 180) / 3, 2),
    ELT(1 + MOD(n, 5), 'mg/dL', 'U/L', 'ng/L', 'mmol/L', ''),
    15 + MOD(n * 11, 160),
    1 + MOD(n, 150),
    ELT(1 + MOD(n, 18),
        '20000000001','20000000002','20000000003','20000000004','20000000005','20000000006',
        '20000000007','20000000008','20000000009','20000000010','20000000011','20000000012',
        '20000000013','20000000014','20000000015','20000000016','20000000017','20000000018')
FROM seq
WHERE n <= 250;

INSERT INTO Hospitalisation_Procedure (id, Hospitalisation_id, MedicalProcedure_id, Date, Room_id)
SELECT
    s.n,
    1 + MOD(s.n, 150),
    rmp.MedicalProcedure_id,
    DATE_ADD('2024-01-05', INTERVAL (s.n * 5) DAY),
    1 + MOD(s.n, 6)
FROM seq s
JOIN ref_medical_procedure rmp ON rmp.rn = 1 + MOD(s.n, @medical_procedure_count)
WHERE s.n <= 120;

INSERT INTO MedicalProcedure_Staff (Hospitalisation_Procedure, Personel_AMKA, Role)
SELECT
    n,
    ELT(1 + MOD(n, 18),
        '20000000001','20000000002','20000000003','20000000004','20000000005','20000000006',
        '20000000007','20000000008','20000000009','20000000010','20000000011','20000000012',
        '20000000013','20000000014','20000000015','20000000016','20000000017','20000000018'),
    'Lead doctor'
FROM seq
WHERE n <= 120;

INSERT INTO MedicalProcedure_Staff (Hospitalisation_Procedure, Personel_AMKA, Role)
SELECT
    n,
    CONCAT('3000000', LPAD(1 + MOD(n, 35), 4, '0')),
    'Assistant'
FROM seq
WHERE n <= 120;

INSERT INTO Prescription (Prescription_id, Doctor_AMKA, Patient_AMKA, Medicine_id, Dose, Frequency, StartDate, EndDate)
SELECT
    n,
    ELT(1 + MOD(n, 18),
        '20000000001','20000000002','20000000003','20000000004','20000000005','20000000006',
        '20000000007','20000000008','20000000009','20000000010','20000000011','20000000012',
        '20000000013','20000000014','20000000015','20000000016','20000000017','20000000018'),
    CONCAT('1000000', LPAD(1 + MOD(n, 80), 4, '0')),
    1 + MOD(n, 8),
    ELT(1 + MOD(n, 4), '500mg', '1 tablet', '10mg', '2 puffs'),
    ELT(1 + MOD(n, 4), 'Once daily', 'Twice daily', 'Every 8 hours', 'As needed'),
    DATE_ADD('2024-01-06', INTERVAL (n * 3) DAY),
    DATE_ADD('2024-01-16', INTERVAL (n * 3) DAY)
FROM seq
WHERE n <= 160;

INSERT INTO Shift (Shift_id, Date, Type, Department_id)
SELECT
    n,
    DATE_ADD('2026-04-01', INTERVAL FLOOR((n - 1) / 15) DAY),
    ELT(1 + MOD(n - 1, 3), 'Morning', 'Evening', 'Night'),
    1 + MOD(FLOOR((n - 1) / 3), 5)
FROM seq
WHERE n <= 150;

INSERT INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, d.Doctor_AMKA
FROM seq s
JOIN Doctor_Department d ON d.Department_id = 1 + MOD(FLOOR((s.n - 1) / 3), 5)
WHERE s.n <= 150;

INSERT INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, CONCAT('3000000', LPAD(1 + MOD(s.n + n.n, 35), 4, '0'))
FROM seq s
JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3
    UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n
WHERE s.n <= 150;

INSERT IGNORE INTO Shift_Staff (Shift_id, Personel_AMKA)
SELECT s.n, CONCAT('3000000', LPAD(36 + MOD(s.n + n.n, 25), 4, '0'))
FROM seq s
JOIN (
    SELECT 1 n UNION ALL SELECT 2
) n
WHERE s.n <= 150;

INSERT INTO Rating (Rating_id, Patient_AMKA, Hospitalisation_id, Medical_care, Nursing_care, Food, Hygiene, Overall_experience)
SELECT
    n,
    CONCAT('1000000', LPAD(1 + MOD(n, 80), 4, '0')),
    n,
    1 + MOD(n, 5),
    1 + MOD(n + 1, 5),
    1 + MOD(n + 2, 5),
    1 + MOD(n + 3, 5),
    1 + MOD(n + 4, 5)
FROM seq
WHERE n <= 100;

DROP TEMPORARY TABLE ref_medical_procedure;
DROP TEMPORARY TABLE ref_ken;
DROP TEMPORARY TABLE seq;

COMMIT;

