-- Q05: Νέοι ιατροί (ηλικία < 35) με τις περισσότερες χειρουργικές επεμβάσεις
--       ως κύριοι χειρουργοί

SELECT
    p.Name,
    p.Surname,
    TIMESTAMPDIFF(YEAR, p.Birthdate, CURDATE())   AS Age,
    d.Major,
    d.Rank,
    COUNT(mps.Hospitalisation_Procedure)           AS Procedures_As_Lead

FROM Doctor d
JOIN Personel p ON d.Doctor_AMKA = p.AMKA
JOIN MedicalProcedure_Staff mps ON d.Doctor_AMKA = mps.Personel_AMKA
                                AND mps.Role = 'Lead doctor'
JOIN Hospitalisation_Procedure hp ON mps.Hospitalisation_Procedure = hp.id
JOIN MedicalProcedure mp ON hp.MedicalProcedure_id = mp.MedicalProcedure_id

WHERE TIMESTAMPDIFF(YEAR, p.Birthdate, CURDATE()) < 35
  AND mp.Category LIKE 'Β%'

GROUP BY
    d.Doctor_AMKA,
    p.Name,
    p.Surname,
    p.Birthdate,
    d.Major,
    d.Rank

ORDER BY Procedures_As_Lead DESC;