-- Q06: Για συγκεκριμένο ασθενή: ιστορικό νοσηλειών, διαγνώσεις ICD-10,
--       συνολικό κόστος ανά νοσηλεία και μέσος όρος αξιολόγησης

SELECT
    h.Hospitalisation_id,
    h.EntryDate,
    h.ReleaseDate,
    DATEDIFF(h.ReleaseDate, h.EntryDate)        AS Days_Stayed,
    h.FirstDiagnosis,
    h.FinalDiagnosis,
    k.KEN_id,
    k.Description                               AS KEN_Description,
    h.Cost,
    d.Name                                      AS Department,
    r.Medical_care,
    r.Nursing_care,
    r.Food,
    r.Hygiene,
    r.Overall_experience,
    ROUND(
        (r.Medical_care + r.Nursing_care + r.Food + r.Hygiene + r.Overall_experience) / 5.0
    , 2)                                        AS Avg_Rating

FROM Hospitalisation h
JOIN Department d   ON h.Department_id      = d.Department_id
JOIN KEN k          ON h.KEN_id             = k.KEN_id
LEFT JOIN Rating r  ON h.Hospitalisation_id = r.Hospitalisation_id

WHERE h.Patient_AMKA = '10000000001'

ORDER BY h.EntryDate ASC;