-- Q04: EXPLAIN ANALYSIS

-- ============================================================
-- (α) ΒΗΜΑ 1: EXPLAIN ANALYZE κανονικής έκδοσης
-- ============================================================
EXPLAIN ANALYZE
SELECT
    p.Name, p.Surname, d.Major, d.Rank,
    COUNT(DISTINCT h.Hospitalisation_id)        AS Total_Hospitalisations_Rated,
    ROUND(AVG(r.Medical_care), 2)               AS Avg_Medical_Care,
    ROUND(AVG(r.Overall_experience), 2)         AS Avg_Overall_Experience
FROM Doctor d
JOIN Personel p           ON d.Doctor_AMKA        = p.AMKA
JOIN Doctor_Department dd ON d.Doctor_AMKA         = dd.Doctor_AMKA
JOIN Hospitalisation h    ON dd.Department_id      = h.Department_id
JOIN Rating r             ON h.Hospitalisation_id  = r.Hospitalisation_id
WHERE d.Doctor_AMKA = '20000000001'
GROUP BY d.Doctor_AMKA, p.Name, p.Surname, d.Major, d.Rank;

-- ============================================================
-- (β) ΒΗΜΑ 2: EXPLAIN ANALYZE εναλλακτικής έκδοσης με FORCE INDEX
-- ============================================================
EXPLAIN ANALYZE
SELECT
    p.Name, p.Surname, d.Major, d.Rank,
    COUNT(DISTINCT h.Hospitalisation_id)        AS Total_Hospitalisations_Rated,
    ROUND(AVG(r.Medical_care), 2)               AS Avg_Medical_Care,
    ROUND(AVG(r.Overall_experience), 2)         AS Avg_Overall_Experience
FROM Doctor d
JOIN Personel p           ON d.Doctor_AMKA        = p.AMKA
JOIN Doctor_Department dd ON d.Doctor_AMKA         = dd.Doctor_AMKA
JOIN Hospitalisation h FORCE INDEX (idx_hosp_department) ON dd.Department_id = h.Department_id
JOIN Rating r FORCE INDEX (idx_rating_hosp)              ON h.Hospitalisation_id = r.Hospitalisation_id
WHERE d.Doctor_AMKA = '20000000001'
GROUP BY d.Doctor_AMKA, p.Name, p.Surname, d.Major, d.Rank;