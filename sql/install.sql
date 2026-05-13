DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE hospital_db;

-- =========================
-- 1. PATIENT
-- =========================
CREATE TABLE Patient (
    Patient_AMKA VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    FathersName VARCHAR(50),
    Birthdate DATE,
    Sex VARCHAR(10),
    Weight DECIMAL(5,2),
    Height DECIMAL(4,2),
    Address VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Job VARCHAR(50),
    Nationality VARCHAR(50),
    Insurance VARCHAR(50)
) ENGINE=InnoDB;

-- =========================
-- 2. PERSONEL
-- =========================
CREATE TABLE Personel (
    AMKA VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    Birthdate DATE,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    HiringDate DATE
) ENGINE=InnoDB;

-- =========================
-- 3. DOCTOR
-- =========================
CREATE TABLE Doctor (
    Doctor_AMKA VARCHAR(20) PRIMARY KEY,
    LicenseNumber VARCHAR(50) NOT NULL,
    Major VARCHAR(100),
    `Rank` VARCHAR(50),
    Supervisor_AMKA VARCHAR(20),
    CONSTRAINT fk_doctor_personel
        FOREIGN KEY (Doctor_AMKA) REFERENCES Personel(AMKA),
    CONSTRAINT fk_doctor_supervisor
        FOREIGN KEY (Supervisor_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

-- =========================
-- 4. DEPARTMENT
-- =========================
CREATE TABLE Department (
    Department_id INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    BedTotal INT,
    Floor_Building VARCHAR(50),
    Head_AMKA VARCHAR(20),
    CONSTRAINT fk_department_head
        FOREIGN KEY (Head_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

-- =========================
-- 5. NURSE
-- =========================
CREATE TABLE Nurse (
    Nurse_AMKA VARCHAR(20) PRIMARY KEY,
    `Rank` VARCHAR(50),
    Department_id INT,
    CONSTRAINT fk_nurse_personel
        FOREIGN KEY (Nurse_AMKA) REFERENCES Personel(AMKA),
    CONSTRAINT fk_nurse_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- =========================
-- 6. STAFF
-- =========================
CREATE TABLE Staff (
    Staff_AMKA VARCHAR(20) PRIMARY KEY,
    Role VARCHAR(50),
    Office VARCHAR(50),
    Department_id INT,
    CONSTRAINT fk_staff_personel
        FOREIGN KEY (Staff_AMKA) REFERENCES Personel(AMKA),
    CONSTRAINT fk_staff_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- =========================
-- 7. DOCTOR_DEPARTMENT
-- =========================
CREATE TABLE Doctor_Department (
    Doctor_AMKA VARCHAR(20),
    Department_id INT,
    PRIMARY KEY (Doctor_AMKA, Department_id),
    CONSTRAINT fk_docdep_doctor
        FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA),
    CONSTRAINT fk_docdep_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- =========================
-- 8. BED
-- =========================
CREATE TABLE Bed (
    Bed_id INT PRIMARY KEY,
    Department_id INT NOT NULL,
    Type VARCHAR(50),
    Status VARCHAR(50),
    CONSTRAINT fk_bed_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- =========================
-- 9. KEN
-- Source-based table
-- =========================
CREATE TABLE KEN (
    KEN_id VARCHAR(20) PRIMARY KEY,
    Description TEXT,
    Base_cost DECIMAL(12,2),
    AverageStay INT,
    Additional_daily_cost DECIMAL(12,2)
) ENGINE=InnoDB;

-- =========================
-- 10. HOSPITALISATION
-- =========================
CREATE TABLE Hospitalisation (
    Hospitalisation_id INT PRIMARY KEY,
    Patient_AMKA VARCHAR(20) NOT NULL,
    Department_id INT NOT NULL,
    Bed_id INT NOT NULL,
    EntryDate DATE,
    ReleaseDate DATE,
    FirstDiagnosis TEXT,
    FinalDiagnosis TEXT,
    KEN_id VARCHAR(20),
    Cost DECIMAL(12,2),
    CONSTRAINT fk_hosp_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_hosp_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id),
    CONSTRAINT fk_hosp_bed
        FOREIGN KEY (Bed_id) REFERENCES Bed(Bed_id),
    CONSTRAINT fk_hosp_ken
        FOREIGN KEY (KEN_id) REFERENCES KEN(KEN_id)
) ENGINE=InnoDB;

-- =========================
-- 11. ROOM
-- =========================
CREATE TABLE Room (
    Room_id INT PRIMARY KEY,
    Type VARCHAR(50),
    Name VARCHAR(50)
) ENGINE=InnoDB;

-- =========================
-- 12. MEDICAL PROCEDURE
-- Source-based table
-- =========================
CREATE TABLE MedicalProcedure (
    MedicalProcedure_id VARCHAR(30) PRIMARY KEY,
    Name TEXT,
    Category VARCHAR(50),
    Duration INT,
    Cost DECIMAL(12,2)
) ENGINE=InnoDB;
-- =========================
-- 13. HOSPITALISATION_PROCEDURE
-- =========================
CREATE TABLE Hospitalisation_Procedure (
    id INT PRIMARY KEY,
    Hospitalisation_id INT NOT NULL,
    MedicalProcedure_id VARCHAR(30) NOT NULL,
    Date DATE,
    Room_id INT,
    CONSTRAINT fk_hospproc_hosp
        FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id),
    CONSTRAINT fk_hospproc_medproc
        FOREIGN KEY (MedicalProcedure_id) REFERENCES MedicalProcedure(MedicalProcedure_id),
    CONSTRAINT fk_hospproc_room
        FOREIGN KEY (Room_id) REFERENCES Room(Room_id)
) ENGINE=InnoDB;

-- =========================
-- 14. MEDICALPROCEDURE_STAFF
-- =========================
CREATE TABLE MedicalProcedure_Staff (
    Hospitalisation_Procedure INT,
    Personel_AMKA VARCHAR(20),
    Role VARCHAR(500),
    PRIMARY KEY (Hospitalisation_Procedure, Personel_AMKA),
    CONSTRAINT fk_mpstaff_proc
        FOREIGN KEY (Hospitalisation_Procedure) REFERENCES Hospitalisation_Procedure(id),
    CONSTRAINT fk_mpstaff_personel
        FOREIGN KEY (Personel_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

-- =========================
-- 15. EXAM
-- =========================
CREATE TABLE Exam (
    Exam_id INT PRIMARY KEY,
    Type VARCHAR(100),
    Date DATE,
    Result_text TEXT,
    Result_value DECIMAL(12,2),
    Unit VARCHAR(20),
    Cost DECIMAL(12,2),
    Hospitalisation_id INT,
    Doctor_AMKA VARCHAR(20),
    CONSTRAINT fk_exam_hosp
        FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id),
    CONSTRAINT fk_exam_doctor
        FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA)
) ENGINE=InnoDB;

-- =========================
-- 16. MEDICINE
-- =========================
CREATE TABLE Medicine (
    Medicine_id INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- =========================
-- 17. ACTIVESUBSTANCE
-- =========================
CREATE TABLE ActiveSubstance (
    Substance_id INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- =========================
-- 18. MEDICINE_SUBSTANCE
-- =========================
CREATE TABLE Medicine_Substance (
    Medicine_id INT,
    Substance_id INT,
    PRIMARY KEY (Medicine_id, Substance_id),
    CONSTRAINT fk_medsub_med
        FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id),
    CONSTRAINT fk_medsub_sub
        FOREIGN KEY (Substance_id) REFERENCES ActiveSubstance(Substance_id)
) ENGINE=InnoDB;

-- =========================
-- 19. PATIENT_ALLERGY
-- =========================
CREATE TABLE Patient_Allergy (
    Patient_AMKA VARCHAR(20),
    Substance_id INT,
    PRIMARY KEY (Patient_AMKA, Substance_id),
    CONSTRAINT fk_patall_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_patall_sub
        FOREIGN KEY (Substance_id) REFERENCES ActiveSubstance(Substance_id)
) ENGINE=InnoDB;

-- =========================
-- 20. PRESCRIPTION
-- =========================
CREATE TABLE Prescription (
    Prescription_id INT PRIMARY KEY,
    Doctor_AMKA VARCHAR(20),
    Patient_AMKA VARCHAR(20),
    Medicine_id INT,
    Dose VARCHAR(50),
    Frequency VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    CONSTRAINT uq_prescription
        UNIQUE (Doctor_AMKA, Patient_AMKA, Medicine_id, StartDate),
    CONSTRAINT fk_presc_doctor
        FOREIGN KEY (Doctor_AMKA) REFERENCES Doctor(Doctor_AMKA),
    CONSTRAINT fk_presc_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_presc_medicine
        FOREIGN KEY (Medicine_id) REFERENCES Medicine(Medicine_id)
) ENGINE=InnoDB;

-- =========================
-- 21. SHIFT
-- =========================
CREATE TABLE Shift (
    Shift_id INT PRIMARY KEY,
    Date DATE,
    Type VARCHAR(50),
    Department_id INT,
    CONSTRAINT fk_shift_department
        FOREIGN KEY (Department_id) REFERENCES Department(Department_id)
) ENGINE=InnoDB;

-- =========================
-- 22. SHIFT_STAFF
-- =========================
CREATE TABLE Shift_Staff (
    Shift_id INT,
    Personel_AMKA VARCHAR(20),
    PRIMARY KEY (Shift_id, Personel_AMKA),
    CONSTRAINT fk_shiftstaff_shift
        FOREIGN KEY (Shift_id) REFERENCES Shift(Shift_id),
    CONSTRAINT fk_shiftstaff_personel
        FOREIGN KEY (Personel_AMKA) REFERENCES Personel(AMKA)
) ENGINE=InnoDB;

-- =========================
-- 23. TRIAGE
-- =========================
CREATE TABLE Triage (
    Triage_id INT PRIMARY KEY,
    Patient_AMKA VARCHAR(20),
    Nurse_AMKA VARCHAR(20),
    Symptoms TEXT,
    Urgency_level INT,
    Arrival_time DATETIME,
    CONSTRAINT fk_triage_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_triage_nurse
        FOREIGN KEY (Nurse_AMKA) REFERENCES Nurse(Nurse_AMKA)
) ENGINE=InnoDB;

-- =========================
-- 24. RATING
-- =========================
CREATE TABLE Rating (
    Rating_id INT PRIMARY KEY,
    Patient_AMKA VARCHAR(20),
    Hospitalisation_id INT,
    Medical_care INT,
    Nursing_care INT,
    Food INT,
    Hygiene INT,
    Overall_experience INT,
    CONSTRAINT fk_rating_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_rating_hosp
        FOREIGN KEY (Hospitalisation_id) REFERENCES Hospitalisation(Hospitalisation_id)
) ENGINE=InnoDB;

-- =========================
-- 25. EMERGENCY CONTACT
-- =========================
CREATE TABLE EmergencyContact (
    EmergencyContact_id INT PRIMARY KEY,
    Name VARCHAR(50),
    Number VARCHAR(20),
    Relation VARCHAR(50)
) ENGINE=InnoDB;

-- =========================
-- 26. PATIENT_EMERGENCYCONTACT
-- =========================
CREATE TABLE Patient_EmergencyContact (
    Patient_AMKA VARCHAR(20),
    EmergencyContact_id INT,
    PRIMARY KEY (Patient_AMKA, EmergencyContact_id),
    CONSTRAINT fk_pec_patient
        FOREIGN KEY (Patient_AMKA) REFERENCES Patient(Patient_AMKA),
    CONSTRAINT fk_pec_contact
        FOREIGN KEY (EmergencyContact_id) REFERENCES EmergencyContact(EmergencyContact_id)
) ENGINE=InnoDB;

-- =========================
-- INDEXES
-- =========================
CREATE INDEX idx_doctor_major ON Doctor(Major);
CREATE INDEX idx_doctor_rank ON Doctor(`Rank`);
CREATE INDEX idx_nurse_department ON Nurse(Department_id);
CREATE INDEX idx_staff_department ON Staff(Department_id);
CREATE INDEX idx_bed_department ON Bed(Department_id);
CREATE INDEX idx_hosp_patient ON Hospitalisation(Patient_AMKA);
CREATE INDEX idx_hosp_department ON Hospitalisation(Department_id);
CREATE INDEX idx_hosp_ken ON Hospitalisation(KEN_id);
CREATE INDEX idx_exam_hosp ON Exam(Hospitalisation_id);
CREATE INDEX idx_exam_doctor ON Exam(Doctor_AMKA);
CREATE INDEX idx_presc_patient ON Prescription(Patient_AMKA);
CREATE INDEX idx_presc_doctor ON Prescription(Doctor_AMKA);
CREATE INDEX idx_shift_date ON Shift(Date);
CREATE INDEX idx_triage_patient ON Triage(Patient_AMKA);
CREATE INDEX idx_rating_hosp ON Rating(Hospitalisation_id);
