-- Purpose:
-- To explore whether the four target racial/ethnic groups differ in ways other than race that could matter when comparing CAD performance.

-- Racial/Ethnic Classification Table

CREATE VIEW demo_analysis AS
SELECT
    patient_id,
    gender,
    age,
    primary_race,
    ethnicity,

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

        ELSE 'Other/Unknown'
    END AS analysis_race

FROM demographic_data;


-- Age -- 
-- Overall age distribution of the four target groups

SELECT
    analysis_race,
    COUNT(*) AS patient_count,
    ROUND(AVG(age), 2) AS mean_age,
    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY age) AS median_age,
    MODE() WITHIN GROUP (ORDER BY age) AS mode_age,
    MIN(age) AS min_age,
    MAX(age) AS max_age

FROM demo_analysis

WHERE analysis_race IN (
    'White',
    'Hispanic',
    'Asian',
    'Black'
)
AND age IS NOT NULL

GROUP BY analysis_race
ORDER BY mean_age DESC;


-- Missing age among the four target groups

SELECT
    COUNT(*) AS missing_age,
    ROUND(
        100.0 * COUNT(*) /
        (
            SELECT COUNT(*)
            FROM demo_analysis
            WHERE analysis_race IN (
                'White',
                'Hispanic',
                'Asian',
                'Black'
            )
        ),
        2
    ) AS missing_age_percentage

FROM demo_analysis

WHERE analysis_race IN (
    'White',
    'Hispanic',
    'Asian',
    'Black'
)
AND age IS NULL;

 
-- GENDER
-- Gender distribution within each target racial/ethnic group

SELECT
    analysis_race AS race,
    COUNT(*) AS patients,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE gender = 'Female')
        / (
            SELECT COUNT(*)
            FROM demo_analysis
            WHERE analysis_race IN (
                'White',
                'Hispanic',
                'Asian',
                'Black'
            )
        ),
        2
    ) AS female_percentage,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE gender = 'Male')
        / (
            SELECT COUNT(*)
            FROM demo_analysis
            WHERE analysis_race IN (
                'White',
                'Hispanic',
                'Asian',
                'Black'
            )
        ),
        2
    ) AS male_percentage

FROM demo_analysis

WHERE analysis_race IN (
    'White',
    'Hispanic',
    'Asian',
    'Black'
)

GROUP BY analysis_race
ORDER BY patients DESC;

