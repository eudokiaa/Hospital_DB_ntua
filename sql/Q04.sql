-- Q04: Για συγκεκριμένο ιατρό, μέσος όρος αξιολογήσεων ασθενών
--       (κριτήριο: Ποιότητα ιατρικής φροντίδας) και Συνολική εμπειρία νοσηλείας

-- ============================================================
-- ΕΚΔΟΣΗ Α: Κανονική (χωρίς hint)
-- ============================================================
SELECT
    p.Name,
    p.Surname,
    d.Major,
    d.Rank,
    COUNT(DISTINCT e.Hospitalisation_id)        AS Total_Hospitalisations_Rated,
    ROUND(AVG(r.Medical_care), 2)               AS Avg_Medical_Care,
    ROUND(AVG(r.Overall_experience), 2)         AS Avg_Overall_Experience

FROM Doctor d
JOIN Personel p  ON d.Doctor_AMKA       = p.AMKA
JOIN Exam e      ON d.Doctor_AMKA       = e.Doctor_AMKA
JOIN Rating r    ON e.Hospitalisation_id = r.Hospitalisation_id

WHERE d.Doctor_AMKA = '20000000001'

GROUP BY d.Doctor_AMKA, p.Name, p.Surname, d.Major, d.Rank;