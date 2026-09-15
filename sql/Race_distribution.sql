-- Purpose: Understand how race and ethnicity are represented before modeling --

-- Race Distribution
-- How are the racial groups represented in the dataset? --
SELECT
    primary_race,
    COUNT(*) AS patient_count
FROM demographic_data
GROUP BY primary_race
ORDER BY patient_count DESC;

--How do PRIMARY_RACE and ETHNICITY interact?
SELECT
    primary_race,
    ethnicity,
    COUNT(*) AS patient_count
FROM demographic_data
GROUP BY primary_race, ethnicity
ORDER BY patient_count DESC;

-- Investigating target group classification

-- Exploratory classification of the four target groups --
SELECT
    CASE
        -- Hispanic/Latino takes priority
        WHEN ethnicity = 'Hispanic/Latino'
            OR primary_race IN (
                'White, Hispanic',
                'Black, Hispanic',
                'Asian, Hispanic',
                'Other, Hispanic',
                'Native American, Hispanic',
                'Pacific Islander, Hispanic'
            )
            THEN 'Hispanic'

        -- White
        WHEN primary_race IN (
            'White',
            'White, non-Hispanic',
            'White or Caucasian'
        )
            THEN 'White'

        -- Black
        WHEN primary_race IN (
            'Black or African American',
            'Black, non-Hispanic'
        )
            THEN 'Black'

        -- Asian
        WHEN primary_race IN (
            'Asian',
            'Asian, non-Hispanic',
            'Asian - Historical Conv'
        )
            THEN 'Asian'

        -- Everything else
        ELSE 'Other/Unknown'
    END AS analysis_race,

    COUNT(*) AS patient_count

FROM demographic_data
GROUP BY analysis_race
ORDER BY patient_count DESC;

-- Investigating other/unknown Categories --
SELECT
    primary_race,
    ethnicity,
    COUNT(*) AS patient_count
FROM demographic_data
WHERE NOT (
    ethnicity = 'Hispanic/Latino'
    OR primary_race IN (
        'White',
        'White, non-Hispanic',
        'White or Caucasian',
        'Black or African American',
        'Black, non-Hispanic',
        'Asian',
        'Asian, non-Hispanic'
    )
)
GROUP BY primary_race, ethnicity
ORDER BY patient_count DESC;

-- Create standardized groups --
-- Final standardized classification used for analysis.
CREATE TEMP TABLE classified AS
SELECT
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

-- Distribution Across Entire Dataset
SELECT
    analysis_race,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_dataset
FROM classified
GROUP BY analysis_race
ORDER BY patient_count DESC;


-- Distribution Across Four Target Groups
SELECT
    analysis_race,
    COUNT(*) AS patient_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) FILTER (
            WHERE analysis_race IN (
                'White', 'Black', 'Asian', 'Hispanic'
            )
        ) OVER (),
        2
    ) AS percentage_of_target_groups
FROM classified
WHERE analysis_race IN (
    'White', 'Black', 'Asian', 'Hispanic'
)
GROUP BY analysis_race
ORDER BY patient_count DESC;