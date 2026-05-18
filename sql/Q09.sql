-- Q09: Ασθενείς που νοσηλεύτηκαν τον ίδιο αριθμό ημερών σε διάστημα ενός έτους,
--       με συνολική διάρκεια άνω των 15 ημερών
 
-- Βήμα 1: υπολογισμός συνολικών ημερών νοσηλείας ανά ασθενή ανά έτος
WITH PatientDays AS (
    SELECT
        Patient_AMKA,
        YEAR(EntryDate)                                 AS Year,
        SUM(DATEDIFF(ReleaseDate, EntryDate))           AS Total_Days
    FROM Hospitalisation
    WHERE ReleaseDate IS NOT NULL
    GROUP BY Patient_AMKA, YEAR(EntryDate)
    HAVING SUM(DATEDIFF(ReleaseDate, EntryDate)) > 15
)
 
-- Βήμα 2: self-join για να βρούμε ζεύγη ασθενών με ίδιο αριθμό ημερών στο ίδιο έτος
SELECT
    pd1.Patient_AMKA    AS Patient_1,
    p1.Name             AS Name_1,
    p1.Surname          AS Surname_1,
    pd2.Patient_AMKA    AS Patient_2,
    p2.Name             AS Name_2,
    p2.Surname          AS Surname_2,
    pd1.Year,
    pd1.Total_Days
 
FROM PatientDays pd1
JOIN PatientDays pd2 ON pd1.Year       = pd2.Year
                    AND pd1.Total_Days  = pd2.Total_Days
                    AND pd1.Patient_AMKA < pd2.Patient_AMKA   -- αποφυγή διπλότυπων
JOIN Patient p1 ON pd1.Patient_AMKA = p1.Patient_AMKA
JOIN Patient p2 ON pd2.Patient_AMKA = p2.Patient_AMKA
 
ORDER BY pd1.Year, pd1.Total_Days DESC;
 