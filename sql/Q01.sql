-- Q01: Συνολικά έσοδα ανά τμήμα και ανά έτος,
--       με ανάλυση ανά ΚΕΝ κωδικό (βασικό κόστος vs πρόσθετη χρέωση λόγω υπέρβασης ΜΔΝ)
--       και κατανομή νοσηλειών ανά ασφαλιστικό φορέα
 
SELECT
    d.Name                                          AS Department,
    YEAR(h.EntryDate)                               AS Year,
    k.KEN_id,
    k.Description                                   AS KEN_Description,
    p.Insurance,
 
    COUNT(h.Hospitalisation_id)                     AS Total_Hospitalisations,
 
    -- Βασικό κόστος: πάντα το Base_cost του KEN
    SUM(k.Base_cost)                                AS Total_Base_Cost,
 
    -- Πρόσθετη χρέωση: μόνο αν η παραμονή υπερβαίνει το ΜΔΝ
    SUM(
        GREATEST(0, DATEDIFF(h.ReleaseDate, h.EntryDate) - k.AverageStay)
        * k.Additional_daily_cost
    )                                               AS Total_Extra_Cost,
 
    -- Συνολικό κόστος (= αυτό που υπολογίζει το trigger calculate_cost)
    SUM(h.Cost)                                     AS Total_Revenue
 
FROM Hospitalisation h
JOIN Department   d ON h.Department_id = d.Department_id
JOIN KEN          k ON h.KEN_id        = k.KEN_id
JOIN Patient      p ON h.Patient_AMKA  = p.Patient_AMKA
 
WHERE h.ReleaseDate IS NOT NULL   -- μόνο ολοκληρωμένες νοσηλείες
 
GROUP BY
    d.Department_id,
    YEAR(h.EntryDate),
    k.KEN_id,
    p.Insurance
 
ORDER BY
    Year               DESC,
    Department         ASC,
    k.KEN_id           ASC,
    p.Insurance        ASC;