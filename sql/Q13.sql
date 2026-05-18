-- Q13: Για κάθε ιατρό, η πλήρης ιεραρχία εποπτείας μέχρι τον Διευθυντή,
--       με ένδειξη επιπέδου σε κάθε βαθμίδα
 
WITH RECURSIVE SupervisionHierarchy AS (
    -- Βάση: κάθε ιατρός ξεκινά ως επίπεδο 0 (ο ίδιος)
    SELECT
        d.Doctor_AMKA,
        p.Name,
        p.Surname,
        d.Rank,
        d.Supervisor_AMKA,
        d.Doctor_AMKA       AS Root_AMKA,   -- ο ιατρός για τον οποίο χτίζουμε την ιεραρχία
        0                   AS Level        -- 0 = ο ίδιος
    FROM Doctor d
    JOIN Personel p ON d.Doctor_AMKA = p.AMKA
 
    UNION ALL
 
    -- Αναδρομή: ανέβα στον επόπτη
    SELECT
        d.Doctor_AMKA,
        p.Name,
        p.Surname,
        d.Rank,
        d.Supervisor_AMKA,
        sh.Root_AMKA,
        sh.Level + 1
    FROM Doctor d
    JOIN Personel p            ON d.Doctor_AMKA   = p.AMKA
    JOIN SupervisionHierarchy sh ON sh.Supervisor_AMKA = d.Doctor_AMKA
    WHERE d.Supervisor_AMKA IS NOT NULL OR d.Rank = 'Director'
)
 
SELECT
    sh.Root_AMKA                            AS Doctor_AMKA,
    pr.Name                                 AS Doctor_Name,
    pr.Surname                              AS Doctor_Surname,
    sh.Level,
    sh.Doctor_AMKA                          AS Hierarchy_Member_AMKA,
    sh.Name                                 AS Hierarchy_Member_Name,
    sh.Surname                              AS Hierarchy_Member_Surname,
    sh.Rank
FROM SupervisionHierarchy sh
JOIN Doctor  dr ON sh.Root_AMKA = dr.Doctor_AMKA
JOIN Personel pr ON dr.Doctor_AMKA = pr.AMKA
 
ORDER BY
    sh.Root_AMKA,
    sh.Level;
 