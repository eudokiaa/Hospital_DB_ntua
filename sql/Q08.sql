-- Q08: Προσωπικό που ΔΕΝ έχει προγραμματισμένη εφημερία σε συγκεκριμένη ημερομηνία και τμήμα
 
SET @target_date   = '2026-04-01';   -- αλλάζεις εδώ
SET @target_dept   = 1;              -- αλλάζεις εδώ (Department_id)
 
SELECT
    per.AMKA,
    per.Name,
    per.Surname,
    CASE
        WHEN d.Doctor_AMKA IS NOT NULL THEN 'Doctor'
        WHEN n.Nurse_AMKA  IS NOT NULL THEN 'Nurse'
        ELSE 'Staff'
    END                             AS Personnel_Type
 
FROM Personel per
LEFT JOIN Doctor d ON per.AMKA = d.Doctor_AMKA
LEFT JOIN Nurse  n ON per.AMKA = n.Nurse_AMKA
LEFT JOIN Staff  st ON per.AMKA = st.Staff_AMKA
 
WHERE NOT EXISTS (
    SELECT 1
    FROM Shift_Staff ss
    JOIN Shift s ON ss.Shift_id = s.Shift_id
    WHERE ss.Personel_AMKA  = per.AMKA
      AND s.Date             = @target_date
      AND s.Department_id    = @target_dept
)
 
ORDER BY Personnel_Type, per.Surname;