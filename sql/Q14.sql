-- Q14: Κατηγορίες ICD-10 με ίδιο αριθμό εισαγωγών σε δύο συνεχόμενα έτη,
--       με τουλάχιστον 5 περιστατικά ανά έτος
 
-- Βήμα 1: εισαγωγές ανά κατηγορία ICD-10 ανά έτος
-- Κατηγορία ICD-10 = το πρώτο γράμμα του κωδικού (πχ I21.0 → κατηγορία "I")
WITH YearlyCounts AS (
    SELECT
        LEFT(h.FirstDiagnosis, 1)       AS ICD10_Category,
        YEAR(h.EntryDate)               AS Year,
        COUNT(*)                        AS Admissions
    FROM Hospitalisation h
    WHERE h.FirstDiagnosis IS NOT NULL
    GROUP BY LEFT(h.FirstDiagnosis, 1), YEAR(h.EntryDate)
    HAVING COUNT(*) >= 5
)
 
SELECT
    y1.ICD10_Category,
    y1.Year         AS Year_1,
    y2.Year         AS Year_2,
    y1.Admissions   AS Admissions_Year_1,
    y2.Admissions   AS Admissions_Year_2
 
FROM YearlyCounts y1
JOIN YearlyCounts y2
    ON  y1.ICD10_Category = y2.ICD10_Category
    AND y2.Year           = y1.Year + 1        -- συνεχόμενα έτη
    AND y1.Admissions     = y2.Admissions      -- ίδιος αριθμός εισαγωγών
 
ORDER BY y1.ICD10_Category, y1.Year;