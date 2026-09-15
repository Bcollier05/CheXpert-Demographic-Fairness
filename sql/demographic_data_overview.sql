-- Purpose:
-- Data-quality overview checks on demographic_data, including counts, uniqueness, missing values, and value distributions.

--How many patients?--
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT patient_id) AS unique_patients
FROM demographic_data;

--Are there any missing demographic values?--
SELECT
    COUNT(*) FILTER (WHERE patient_id IS NULL) AS missing_patient,
    COUNT(*) FILTER (WHERE gender IS NULL) AS missing_gender,
    COUNT(*) FILTER (WHERE age IS NULL) AS missing_age,
    COUNT(*) FILTER (WHERE primary_race IS NULL) AS missing_race,
    COUNT(*) FILTER (WHERE ethnicity IS NULL) AS missing_ethnicity
FROM demographic_data;

-- Missing values % --
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE primary_race IS NULL)
        / COUNT(*),
        2
    ) AS missing_race_percentage
FROM demographic_data;

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE ethnicity IS NULL)
        / COUNT(*),
        2
    ) AS missing_eth_percentage
FROM demographic_data;

-- Consolidated missing percentages for key demographic columns --
SELECT
    ROUND(100.0 * COUNT(*) FILTER (WHERE patient_id IS NULL) / NULLIF(COUNT(*),0), 2) AS missing_patient_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE gender IS NULL) / NULLIF(COUNT(*),0), 2) AS missing_gender_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE age IS NULL) / NULLIF(COUNT(*),0), 2) AS missing_age_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE primary_race IS NULL) / NULLIF(COUNT(*),0), 2) AS missing_race_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE ethnicity IS NULL) / NULLIF(COUNT(*),0), 2) AS missing_ethnicity_pct
FROM demographic_data;

-- Value distributions (counts + percentages) --
-- primary_race distribution --
SELECT
    primary_race AS value,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM demographic_data),0), 2) AS percent
FROM demographic_data
GROUP BY primary_race
ORDER BY count DESC;

-- ethnicity distribution --
SELECT
    ethnicity AS value,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM demographic_data),0), 2) AS percent
FROM demographic_data
GROUP BY ethnicity
ORDER BY count DESC;

-- gender distribution --
SELECT
    gender AS value,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM demographic_data),0), 2) AS percent
FROM demographic_data
GROUP BY gender
ORDER BY count DESC;

-- Duplicate patient_id check --
SELECT
    CASE WHEN EXISTS (
        SELECT 1 FROM demographic_data GROUP BY patient_id HAVING COUNT(*) > 1
    ) THEN 'duplicates_found' ELSE 'no_duplicates' END AS duplicate_check;