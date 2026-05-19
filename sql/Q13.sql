WITH RECURSIVE SupervisionHierarchy AS (
    -- Anchor: ξεκινά από τον ΑΜΕΣΟ ΕΠΟΠΤΗ (όχι τον ίδιο)
    SELECT
        d.Doctor_AMKA        AS Root_AMKA,
        sup.Doctor_AMKA      AS Current_AMKA,
        sup.Supervisor_AMKA,
        sup.Rank,
        p.Name,
        p.Surname,
        1                    AS Level
    FROM Doctor d
    JOIN Doctor sup   ON d.Supervisor_AMKA = sup.Doctor_AMKA
    JOIN Personel p   ON sup.Doctor_AMKA   = p.AMKA
    WHERE d.Supervisor_AMKA IS NOT NULL

    UNION ALL

    -- Recursive: ανέβα στον επόμενο επόπτη
    SELECT
        sh.Root_AMKA,
        sup.Doctor_AMKA,
        sup.Supervisor_AMKA,
        sup.Rank,
        p.Name,
        p.Surname,
        sh.Level + 1
    FROM SupervisionHierarchy sh
    JOIN Doctor sup ON sup.Doctor_AMKA = sh.Supervisor_AMKA
    JOIN Personel p ON sup.Doctor_AMKA = p.AMKA
)

SELECT
    sh.Root_AMKA          AS Doctor_AMKA,
    pr.Name               AS Doctor_Name,
    pr.Surname            AS Doctor_Surname,
    sh.Level,
    sh.Current_AMKA       AS Hierarchy_Member_AMKA,
    sh.Name               AS Hierarchy_Member_Name,
    sh.Surname            AS Hierarchy_Member_Surname,
    sh.Rank
FROM SupervisionHierarchy sh
JOIN Personel pr ON sh.Root_AMKA = pr.AMKA
ORDER BY sh.Root_AMKA, sh.Level;