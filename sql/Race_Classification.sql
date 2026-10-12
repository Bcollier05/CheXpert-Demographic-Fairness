CREATE TABLE classified AS
SELECT
	patient_id,
	gender,
	age,
    CASE
        WHEN ethnicity = 'Hispanic/Latino'
             OR primary_race IN (
                 'White, Hispanic', 'Black, Hispanic', 'Asian, Hispanic',
                 'Other, Hispanic', 'Native American, Hispanic', 'Pacific Islander, Hispanic'
             )
        THEN 'Hispanic'
        WHEN primary_race IN ('White', 'White, non-Hispanic', 'White or Caucasian')
        THEN 'White'
        WHEN primary_race IN ('Black or African American', 'Black, non-Hispanic')
        THEN 'Black'
        WHEN primary_race IN ('Asian', 'Asian, non-Hispanic', 'Asian - Historical Conv')
        THEN 'Asian'
        WHEN primary_race IS NULL
             OR primary_race IN ('Unknown', 'Race and Ethnicity Unknown', 'Patient Refused')
        THEN 'Unknown'
        ELSE 'Other'
    END AS analysis_race
FROM demographic_data;


SELECT COUNT(*) AS total_rows, COUNT(DISTINCT patient_id) AS unique_patients
FROM classified;

SELECT patient_id FROM classified LIMIT 5;
