-- Q12: Απαιτούμενο προσωπικό ανά τμήμα και ανά βάρδια για συγκεκριμένη εβδομάδα,
--       με ανάλυση ανά υποκλάση προσωπικού

SET @week_start = '2026-04-01';
SET @week_end   = '2026-04-07';

SELECT
    dep.Name                            AS Department,
    s.Date,
    s.Type                              AS Shift_Type,
    CASE
        WHEN doc.Doctor_AMKA IS NOT NULL THEN 'Doctor'
        WHEN nur.Nurse_AMKA  IS NOT NULL THEN 'Nurse'
        ELSE 'Staff'
    END                                 AS Personnel_Category,

    CASE
        WHEN doc.Doctor_AMKA IS NOT NULL THEN doc.Major
        WHEN nur.Nurse_AMKA  IS NOT NULL THEN nur.Rank
        ELSE st.Role
    END                                 AS Subcategory,

    COUNT(ss.Personel_AMKA)             AS Personnel_Count

FROM Shift s
JOIN Department   dep ON s.Department_id  = dep.Department_id
JOIN Shift_Staff  ss  ON s.Shift_id       = ss.Shift_id
JOIN Personel     per ON ss.Personel_AMKA = per.AMKA
LEFT JOIN Doctor  doc ON per.AMKA = doc.Doctor_AMKA
LEFT JOIN Nurse   nur ON per.AMKA = nur.Nurse_AMKA
LEFT JOIN Staff   st  ON per.AMKA = st.Staff_AMKA

WHERE s.Date BETWEEN @week_start AND @week_end

GROUP BY
    dep.Department_id,
    s.Date,
    s.Type,
    Personnel_Category,
    Subcategory

ORDER BY
    s.Date,
    dep.Name,
    s.Type,
    Personnel_Category,
    Subcategory;
