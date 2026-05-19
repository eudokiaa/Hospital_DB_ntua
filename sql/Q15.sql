WITH TriageStats AS (
    SELECT
        t.Urgency_level,
        COUNT(DISTINCT t.Triage_id)                               AS Total_Cases,
        ROUND(
            AVG(
                CASE
                    WHEN h.EntryDate IS NOT NULL
                    THEN DATEDIFF(h.EntryDate, DATE(t.Arrival_time))
                    ELSE NULL
                END
            ), 2
        )                                                         AS Avg_Wait_Days,
        ROUND(
            100.0 * COUNT(DISTINCT h.Hospitalisation_id) / COUNT(DISTINCT t.Triage_id),
            2
        )                                                         AS Pct_Hospitalised,
        COUNT(DISTINCT h.Hospitalisation_id)                      AS Total_Hospitalised
    FROM Triage t
    LEFT JOIN Hospitalisation h ON t.Patient_AMKA = h.Patient_AMKA
        AND h.EntryDate >= DATE(t.Arrival_time)
        AND h.EntryDate = (
            SELECT MIN(h2.EntryDate)
            FROM Hospitalisation h2
            WHERE h2.Patient_AMKA = t.Patient_AMKA
              AND h2.EntryDate >= DATE(t.Arrival_time)
        )
    GROUP BY t.Urgency_level
),
DepartmentDist AS (
    SELECT
        t.Urgency_level,
        d.Department_id,
        d.Name                                                    AS Department,
        COUNT(DISTINCT h.Hospitalisation_id)                      AS Referrals_To_Department
    FROM Triage t
    JOIN Hospitalisation h ON t.Patient_AMKA = h.Patient_AMKA
        AND h.EntryDate >= DATE(t.Arrival_time)
        AND h.EntryDate = (
            SELECT MIN(h2.EntryDate)
            FROM Hospitalisation h2
            WHERE h2.Patient_AMKA = t.Patient_AMKA
              AND h2.EntryDate >= DATE(t.Arrival_time)
        )
    JOIN Department d ON h.Department_id = d.Department_id
    GROUP BY t.Urgency_level, d.Department_id, d.Name
)

SELECT
    ts.Urgency_level,
    ts.Total_Cases,
    ts.Avg_Wait_Days,
    ts.Pct_Hospitalised,
    ts.Total_Hospitalised,
    dd.Department,
    dd.Referrals_To_Department
FROM TriageStats ts
LEFT JOIN DepartmentDist dd ON ts.Urgency_level = dd.Urgency_level
ORDER BY ts.Urgency_level ASC, dd.Referrals_To_Department DESC;