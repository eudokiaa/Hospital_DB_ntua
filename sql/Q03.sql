-- Q03: Ασθενείς που νοσηλεύτηκαν περισσότερες από 3 φορές στο ίδιο τμήμα
--       με το συνολικό κόστος νοσηλείας τους
 
SELECT
    p.Patient_AMKA,
    p.Name,
    p.Surname,
    d.Name                          AS Department,
    COUNT(h.Hospitalisation_id)     AS Times_Hospitalised,
    SUM(h.Cost)                     AS Total_Cost
 
FROM Hospitalisation h
JOIN Patient    p ON h.Patient_AMKA   = p.Patient_AMKA
JOIN Department d ON h.Department_id  = d.Department_id
 
GROUP BY
    p.Patient_AMKA,
    h.Department_id
 
HAVING COUNT(h.Hospitalisation_id) > 3
 
ORDER BY
    Times_Hospitalised DESC,
    Total_Cost DESC;