-- Q15: Κατανομή triage ανά επίπεδο επείγοντος:
--       μέσος χρόνος αναμονής, % που οδήγησαν σε νοσηλεία, κατανομή παραπομπών ανά τμήμα
 
SELECT
    t.Urgency_level,
 
    COUNT(t.Triage_id)                                          AS Total_Cases,
 
    -- Μέσος χρόνος αναμονής: από άφιξη (Arrival_time) μέχρι εισαγωγή (EntryDate)
    -- Χρησιμοποιούμε TIMESTAMPDIFF σε λεπτά
    AVG(
        CASE
            WHEN h.EntryDate IS NOT NULL
            THEN TIMESTAMPDIFF(MINUTE, t.Arrival_time, TIMESTAMP(h.EntryDate))
            ELSE NULL
        END
    )                                                           AS Avg_Wait_Minutes,
 
    -- Ποσοστό που οδήγησε σε νοσηλεία
    ROUND(
        100.0 * COUNT(h.Hospitalisation_id) / COUNT(t.Triage_id),
        2
    )                                                           AS Pct_Hospitalised,
 
    COUNT(h.Hospitalisation_id)                                 AS Total_Hospitalised,
 
    -- Κατανομή παραπομπών ανά τμήμα
    d.Name                                                      AS Department,
    COUNT(h.Hospitalisation_id)                                 AS Referrals_To_Department
 
FROM Triage t
LEFT JOIN Hospitalisation h ON t.Patient_AMKA  = h.Patient_AMKA
                            -- ο ασθενής νοσηλεύτηκε μετά το triage (ίδια ή επόμενη μέρα)
                           AND h.EntryDate >= DATE(t.Arrival_time)
LEFT JOIN Department d ON h.Department_id = d.Department_id
 
GROUP BY
    t.Urgency_level,
    d.Department_id,
    d.Name
 
ORDER BY
    t.Urgency_level ASC,
    Referrals_To_Department DESC;
 