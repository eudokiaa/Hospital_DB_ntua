-- Q10: Top-3 ζεύγη δραστικών ουσιών που συνταγογραφήθηκαν ταυτόχρονα
--       στον ίδιο ασθενή κατά την ίδια νοσηλεία, ταξινομημένα κατά συχνότητα

-- Βήμα 1: DISTINCT για να αποφύγουμε διπλοεμφάνιση ίδιας ουσίας
--         από διαφορετικά φάρμακα στην ίδια νοσηλεία
WITH HospitalisationSubstances AS (
    SELECT DISTINCT
        h.Hospitalisation_id,
        h.Patient_AMKA,
        ms.substance_id
    FROM Hospitalisation h
    JOIN Prescription pr ON h.Patient_AMKA = pr.Patient_AMKA
                        AND pr.StartDate   >= h.EntryDate
                        AND pr.StartDate   <= h.ReleaseDate
    JOIN Medicine_Substance ms ON pr.Medicine_id = ms.medicine_id
),

-- Βήμα 2: self-join για να φτιάξεις ζεύγη ουσιών στην ίδια νοσηλεία
SubstancePairs AS (
    SELECT
        hs1.Hospitalisation_id,
        hs1.substance_id    AS Substance_1,
        hs2.substance_id    AS Substance_2
    FROM HospitalisationSubstances hs1
    JOIN HospitalisationSubstances hs2
        ON hs1.Hospitalisation_id = hs2.Hospitalisation_id
       AND hs1.substance_id < hs2.substance_id
)

SELECT
    a1.Name                             AS Substance_1,
    a2.Name                             AS Substance_2,
    COUNT(*)                            AS Co_Prescription_Count

FROM SubstancePairs sp
JOIN ActiveSubstance a1 ON sp.Substance_1 = a1.Substance_id
JOIN ActiveSubstance a2 ON sp.Substance_2 = a2.Substance_id

GROUP BY
    sp.Substance_1,
    sp.Substance_2,
    a1.Name,        
    a2.Name         

ORDER BY Co_Prescription_Count DESC
LIMIT 3;