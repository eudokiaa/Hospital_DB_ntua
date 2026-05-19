-- Q02: Για συγκεκριμένη ειδικότητα ιατρού, όλοι οι ιατροί με ένδειξη αν είχαν
--       εφημερία το τρέχον έτος και πόσες επεμβάσεις εκτέλεσαν ως κύριοι χειρουργοί

SELECT
    p.Name,
    p.Surname,
    d.Major,
    d.Rank,

    -- Ένδειξη αν είχε εφημερία το τρέχον έτος
    CASE WHEN COUNT(DISTINCT s.Shift_id) > 0 THEN 'YES' ELSE 'NO' END AS Had_Shift_This_Year,
    COUNT(DISTINCT s.Shift_id)                                          AS Total_Shifts_This_Year,

    -- Επεμβάσεις ως κύριος χειρουργός
    COUNT(DISTINCT mps.Hospitalisation_Procedure)                       AS Procedures_As_Lead

FROM Doctor d
JOIN Personel p ON d.Doctor_AMKA = p.AMKA

-- Εφημερίες τρέχοντος έτους
LEFT JOIN Shift_Staff ss  ON d.Doctor_AMKA = ss.Personel_AMKA
LEFT JOIN Shift s         ON ss.Shift_id   = s.Shift_id
                         AND YEAR(s.Date)  = YEAR(CURDATE())

-- Επεμβάσεις ως κύριος χειρουργός (Role = 'Lead doctor')
LEFT JOIN MedicalProcedure_Staff mps ON d.Doctor_AMKA = mps.Personel_AMKA
                                    AND mps.Role = 'Lead doctor'

WHERE d.Major = 'Cardiology'   -- αλλάζεις εδώ την ειδικότητα

GROUP BY
    d.Doctor_AMKA,
    p.Name,
    p.Surname,
    d.Major,
    d.Rank

ORDER BY
    Procedures_As_Lead DESC,
    p.Surname ASC;