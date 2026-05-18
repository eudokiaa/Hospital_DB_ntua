-- Q07: Ανά δραστική ουσία: αριθμός αλλεργικών ασθενών και αριθμός φαρμάκων που την περιέχουν
--       ταξινομημένα κατά συνολικό αριθμό αλλεργικών ασθενών
 
SELECT
    a.Substance_id,
    a.Name                              AS Substance_Name,
    COUNT(DISTINCT pa.Patient_AMKA)     AS Allergic_Patients,
    COUNT(DISTINCT ms.medicine_id)      AS Medicines_Containing
 
FROM ActiveSubstance a
LEFT JOIN Patient_Allergy   pa ON a.Substance_id = pa.Substance_id
LEFT JOIN Medicine_Substance ms ON a.Substance_id = ms.substance_id
 
GROUP BY
    a.Substance_id,
    a.Name
 
ORDER BY Allergic_Patients DESC;