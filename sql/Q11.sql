-- Q11: Ιατροί που έχουν εκτελέσει τουλάχιστον 5 λιγότερες επεμβάσεις
--       από τον ιατρό με τις περισσότερες επεμβάσεις στο τρέχον έτος
 
-- Βήμα 1: επεμβάσεις ανά ιατρό στο τρέχον έτος
WITH DoctorProcedures AS (
    SELECT
        mps.Personel_AMKA       AS Doctor_AMKA,
        COUNT(*)                AS Procedure_Count
    FROM MedicalProcedure_Staff mps
    JOIN Hospitalisation_Procedure hp ON mps.Hospitalisation_Procedure = hp.id
    WHERE YEAR(hp.Date) = YEAR(CURDATE())
    GROUP BY mps.Personel_AMKA
),
 
-- Βήμα 2: μέγιστος αριθμός επεμβάσεων
MaxProcedures AS (
    SELECT MAX(Procedure_Count) AS Max_Count
    FROM DoctorProcedures
)
 
SELECT
    p.Name,
    p.Surname,
    d.Major,
    d.Rank,
    COALESCE(dp.Procedure_Count, 0)         AS Procedures_This_Year,
    m.Max_Count                             AS Max_Procedures,
    m.Max_Count - COALESCE(dp.Procedure_Count, 0) AS Difference
 
FROM Doctor d
JOIN Personel p ON d.Doctor_AMKA = p.AMKA
LEFT JOIN DoctorProcedures dp ON d.Doctor_AMKA = dp.Doctor_AMKA
CROSS JOIN MaxProcedures m
 
WHERE m.Max_Count - COALESCE(dp.Procedure_Count, 0) >= 5
 
ORDER BY Procedures_This_Year DESC;
 