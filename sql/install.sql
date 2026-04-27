-- RESET
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

-- PATIENT
CREATE TABLE Patient (
    Patient_AMKA VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50),
    Surname VARCHAR(50),
    FathersName VARCHAR(50),
    Birthdate DATE,
    Sex VARCHAR(10),
    Weight FLOAT,
    Height FLOAT,
    Address VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(50),
    Job VARCHAR(50),
    Nationality VARCHAR(50),
    Insurance VARCHAR(50)
) ENGINE=InnoDB;

-- PERSONEL + ISA
CREATE TABLE Personel (
    AMKA VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50),
    Surname VARCHAR(50),
    Birthdate DATE,
    Email VARCHAR(50),
    Phone VARCHAR(20),
    HiringDate DATE
) ENGINE=InnoDB;

CREATE TABLE Doctor (
    Doctor_AMKA VARCHAR(20) PRIMARY KEY,
    LicenseNumber VARCHAR(50),
    Major VARCHAR(50),
    Rank VARCHAR(50),
    Supervisor_AMKA VARCHAR(20),
    FOREIGN KEY (Doctor_AMKA) REFERENCES Personel(AMKA),
    FOREIGN KEY (Supervisor_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

CREATE TABLE Nurse (
    Nurse_AMKA VARCHAR(20) PRIMARY KEY,
    Rank VARCHAR(50),
    Department_id INT,
    FOREIGN KEY (Nurse_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

CREATE TABLE Staff (
    Staff_AMKA VARCHAR(20) PRIMARY KEY,
    Role VARCHAR(50),
    Office VARCHAR(50),
    Department_id INT,
    FOREIGN KEY (Staff_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

-- DEPARTMENT
CREATE TABLE Department (
    Department_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    BedTotal INT,
    Floor_Building VARCHAR(50),
    Head_AMKA VARCHAR(20),
    FOREIGN KEY (Head_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

-- DOCTOR_DEPARTMENT
CREATE TABLE Doctor_Department (
    Doctor_AMKA VARCHAR(20),
    Department_id INT,
    PRIMARY KEY (Doctor_AMKA, Department_id),
    FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA),
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- BED
CREATE TABLE Bed (
    Bed_id INT PRIMARY KEY AUTO_INCREMENT,
    Department_id INT,
    Type VARCHAR(50),
    Status VARCHAR(50),
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- HOSPITALISATION
CREATE TABLE Hospitalisation (
    Hospitalisation_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_AMKA VARCHAR(20),
    Department_id INT,
    Bed_id INT,
    EntryDate DATE,
    ReleaseDate DATE,
    FirstDiagnosis TEXT,
    FinalDiagnosis TEXT,
    KEN_id INT,
    Cost DECIMAL(10,2),
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id),
    FOREIGN KEY (Bed_id) REFERENCES Bed(Bed_id)
) ENGINE=InnoDB;

-- KEN
CREATE TABLE KEN (
    KEN_id INT PRIMARY KEY AUTO_INCREMENT,
    Description TEXT,
    Base_cost DECIMAL(10,2),
    AvarageStay INT,
    Additional_daily_cost DECIMAL(10,2)
) ENGINE=InnoDB;

-- ROOM
CREATE TABLE Room (
    Room_id INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(50),
    Name VARCHAR(50)
) ENGINE=InnoDB;

-- MEDICAL PROCEDURE
CREATE TABLE MedicalProcedure (
    MedicalProcedure_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Category VARCHAR(50),
    Duration INT,
    Cost DECIMAL(10,2)
) ENGINE=InnoDB;

-- HOSPITALISATION_PROCEDURE
CREATE TABLE Hospitalisation_Procedure (
    id INT PRIMARY KEY AUTO_INCREMENT,
    Hospitalisation_id INT,
    MedicalProcedure_id INT,
    Date DATE,
    Room_id INT,
    FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id),
    FOREIGN KEY (MedicalProcedure_id) REFERENCES MedicalProcedure(MedicalProcedure_id),
    FOREIGN KEY (Room_id) REFERENCES Room(Room_id)
) ENGINE=InnoDB;

-- MEDICALPROCEDURE_STAFF
CREATE TABLE MedicalProcedure_Staff (
    Hospitalisation_Procedure INT,
    Personel_AMKA VARCHAR(20),
    Role VARCHAR(50),
    PRIMARY KEY (Hospitalisation_Procedure, Personel_AMKA),
    FOREIGN KEY (Hospitalisation_Procedure) REFERENCES Hospitalisation_Procedure(id),
    FOREIGN KEY (Personel_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

-- EXAM
CREATE TABLE Exam (
    Exam_id INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(50),
    Date DATE,
    Result_text TEXT,
    Result_value FLOAT,
    Unit VARCHAR(20),
    Cost DECIMAL(10,2),
    Hospitalisation_id INT,
    Doctor_AMKA VARCHAR(20),
    FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id),
    FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

-- MEDICINE
CREATE TABLE Medicine (
    Medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE ActiveSubstance (
    Substance_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE Medicine_Substance (
    medicine_id INT,
    substance_id INT,
    PRIMARY KEY (medicine_id, substance_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(Medicine_id),
    FOREIGN KEY (substance_id) REFERENCES ActiveSubstance(Substance_id)
) ENGINE=InnoDB;

CREATE TABLE Patient_Allergy (
    Patient_AMKA VARCHAR(20),
    Substance_id INT,
    PRIMARY KEY (Patient_AMKA, Substance_id),
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (Substance_id) REFERENCES ActiveSubstance(Substance_id)
) ENGINE=InnoDB;

-- PRESCRIPTION
CREATE TABLE Prescription (
    Prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_AMKA VARCHAR(20),
    Patient_AMKA VARCHAR(20),
    Medicine_id INT,
    Dose VARCHAR(50),
    Frequency VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA),
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id)
) ENGINE=InnoDB;

-- SHIFT
CREATE TABLE Shift (
    Shift_id INT PRIMARY KEY AUTO_INCREMENT,
    Date DATE,
    Type VARCHAR(50),
    Department_id INT,
    FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

CREATE TABLE Shift_Staff (
    Shift_id INT,
    Personel_AMKA VARCHAR(20),
    PRIMARY KEY (Shift_id, Personel_AMKA),
    FOREIGN KEY (Shift_id) REFERENCES Shift(Shift_id),
    FOREIGN KEY (Personel_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

-- TRIAGE
CREATE TABLE Triage (
    Triage_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_AMKA VARCHAR(20),
    Nurse_AMKA VARCHAR(20),
    Symptoms TEXT,
    Urgency_level INT,
    Arrival_time DATETIME,
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (Nurse_AMKA) REFERENCES Nurse(Nurse_AMKA)
) ENGINE=InnoDB;

-- RATING
CREATE TABLE Rating (
    Rating_id INT PRIMARY KEY AUTO_INCREMENT,
    Patient_AMKA VARCHAR(20),
    Hospitalisation_id INT,
    Medical_care INT,
    Nursing_care INT,
    Food INT,
    Hygiene INT,
    Overall_experience INT,
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id)
) ENGINE=InnoDB;

-- EMERGENCY CONTACT
CREATE TABLE EmergencyContact (
    EmergencyContact_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Number VARCHAR(20),
    Relation VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE Patient_EmergencyContact (
    Patient_AMKA VARCHAR(20),
    EmergencyContact_id INT,
    PRIMARY KEY (Patient_AMKA, EmergencyContact_id),
    FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    FOREIGN KEY (EmergencyContact_id) REFERENCES EmergencyContact(EmergencyContact_id)
) ENGINE=InnoDB;

ALTER TABLE Prescription
ADD CONSTRAINT unique_prescription 
UNIQUE (Doctor_AMKA, Patient_AMKA, Medicine_id, StartDate);
ALTER TABLE NURSE
ADD FOREIGN KEY (Department_id) REFERENCES Department(Department_id);
ALTER TABLE STAFF
ADD FOREIGN KEY (Department_id) REFERENCES Department(Department_id);
ALTER TABLE Hospitalisation
ADD FOREIGN KEY (KEN_id) REFERENCES KEN(KEN_id);

DELIMITER $$

CREATE TRIGGER check_allergy
BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Patient_Allergy pa
        JOIN Medicine_Substance ms 
            ON pa.Substance_id = ms.substance_id
        WHERE pa.Patient_AMKA = NEW.Patient_AMKA
          AND ms.medicine_id = NEW.Medicine_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patient is allergic to this medicine';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER check_doctor_supervisor
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.Rank = 'Resident' AND NEW.Supervisor_AMKA IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Resident must have a supervisor';
    END IF;

    IF NEW.Rank = 'Director' AND NEW.Supervisor_AMKA IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Director cannot have supervisor';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER prevent_self_supervision
BEFORE INSERT ON Doctor
FOR EACH ROW
BEGIN
    IF NEW.Supervisor_AMKA = NEW.Doctor_AMKA THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor cannot supervise themselves';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER update_bed_status
AFTER INSERT ON Hospitalisation
FOR EACH ROW
BEGIN
    UPDATE Bed
    SET Status = 'occupied'
    WHERE Bed_id = NEW.Bed_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER calculate_cost
BEFORE INSERT ON Hospitalisation
FOR EACH ROW
BEGIN
    DECLARE days INT;
    DECLARE base DECIMAL(10,2);
    DECLARE avg_days INT;
    DECLARE extra DECIMAL(10,2);

    SET days = DATEDIFF(NEW.ReleaseDate, NEW.EntryDate);

    SELECT Base_cost, AvarageStay, Additional_daily_cost
    INTO base, avg_days, extra
    FROM KEN
    WHERE KEN_id = NEW.KEN_id;

    IF days <= avg_days THEN
        SET NEW.Cost = base;
    ELSE
        SET NEW.Cost = base + (days - avg_days) * extra;
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER prevent_overlap
BEFORE INSERT ON Hospitalisation_Procedure
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Hospitalisation_Procedure
        WHERE Room_id = NEW.Room_id
          AND Date = NEW.Date
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Room already booked';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER limit_night_shifts
BEFORE INSERT ON Shift_Staff
FOR EACH ROW
BEGIN
    DECLARE count_shifts INT;

    SELECT COUNT(*) INTO count_shifts
    FROM Shift_Staff ss
    JOIN Shift s ON ss.Shift_id = s.Shift_id
    WHERE ss.Personel_AMKA = NEW.Personel_AMKA
      AND s.Type = 'night'
      AND MONTH(s.Date) = MONTH(CURDATE());

    IF count_shifts >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Too many night shifts';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER prevent_doctor_overlap
BEFORE INSERT ON MedicalProcedure_Staff
FOR EACH ROW
BEGIN
    DECLARE proc_date DATE;

    SELECT Date INTO proc_date
    FROM Hospitalisation_Procedure
    WHERE id = NEW.Hospitalisation_Procedure;

    IF EXISTS (
        SELECT 1
        FROM MedicalProcedure_Staff mps
        JOIN Hospitalisation_Procedure hp 
            ON mps.Hospitalisation_Procedure = hp.id
        WHERE mps.Personel_AMKA = NEW.Personel_AMKA
          AND hp.Date = proc_date
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor already in another procedure at same time';
    END IF;

END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER limit_monthly_shifts
BEFORE INSERT ON Shift_Staff
FOR EACH ROW
BEGIN
    DECLARE total INT;
    DECLARE role_type VARCHAR(20);

    SELECT COUNT(*) INTO total
    FROM Shift_Staff ss
    JOIN Shift s ON ss.Shift_id = s.Shift_id
    WHERE ss.Personel_AMKA = NEW.Personel_AMKA
      AND MONTH(s.Date) = MONTH(CURDATE());

    SELECT 
        CASE 
            WHEN d.Doctor_AMKA IS NOT NULL THEN 'Doctor'
            WHEN n.Nurse_AMKA IS NOT NULL THEN 'Nurse'
            ELSE 'Staff'
        END
    INTO role_type
    FROM Personel p
    LEFT JOIN Doctor d ON p.AMKA = d.Doctor_AMKA
    LEFT JOIN Nurse n ON p.AMKA = n.Nurse_AMKA
    WHERE p.AMKA = NEW.Personel_AMKA;

    IF role_type = 'Doctor' AND total >= 15 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Doctor shift limit exceeded';
    END IF;

    IF role_type = 'Nurse' AND total >= 20 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nurse shift limit exceeded';
    END IF;

    IF role_type = 'Staff' AND total >= 25 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff shift limit exceeded';
    END IF;

END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER check_rest_time
BEFORE INSERT ON Shift_Staff
FOR EACH ROW
BEGIN
    DECLARE last_shift DATETIME;

    SELECT MAX(CONCAT(s.Date, ' ', 
        CASE 
            WHEN s.Type='morning' THEN '07:00:00'
            WHEN s.Type='evening' THEN '15:00:00'
            ELSE '23:00:00'
        END))
    INTO last_shift
    FROM Shift_Staff ss
    JOIN Shift s ON ss.Shift_id = s.Shift_id
    WHERE ss.Personel_AMKA = NEW.Personel_AMKA;

    IF last_shift IS NOT NULL AND 
       TIMESTAMPDIFF(HOUR, last_shift, NOW()) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough rest time (8 hours required)';
    END IF;

END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER check_shift_coverage
AFTER INSERT ON Shift_Staff
FOR EACH ROW
BEGIN
    DECLARE doc_count INT;
    DECLARE nurse_count INT;
    DECLARE staff_count INT;

    SELECT COUNT(*) INTO doc_count
    FROM Shift_Staff ss
    JOIN Doctor d ON ss.Personel_AMKA = d.Doctor_AMKA
    WHERE ss.Shift_id = NEW.Shift_id;

    SELECT COUNT(*) INTO nurse_count
    FROM Shift_Staff ss
    JOIN Nurse n ON ss.Personel_AMKA = n.Nurse_AMKA
    WHERE ss.Shift_id = NEW.Shift_id;

    SELECT COUNT(*) INTO staff_count
    FROM Shift_Staff ss
    JOIN Staff s ON ss.Personel_AMKA = s.Staff_AMKA
    WHERE ss.Shift_id = NEW.Shift_id;

    IF doc_count < 3 OR nurse_count < 6 OR staff_count < 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shift does not meet minimum staffing requirements';
    END IF;

END$$

DELIMITER ;