# Dataset Analysis & Exploratory Data Analysis (SQL, PowerBI, Python)

## 1. Objective

### Purpose

To characterize the demographic, clinical, and imaging composition of the CheXpert dataset and identify potential sources of imbalance or variation that could influence the performance of computer-aided diagnosis (CAD) models across racial groups. 

"What does my dataset look like, and what differences exist between the groups I'm going to compare?"

**1. Who is represented?**
  How many patients per target racial groups?
  Are some groups heavily underrepresented?
  Are age, sex, and ethnicity distributed differently?
  
**2. What diseases are represented?**
  How common is each disease?
  Are certain diseases more prevalent in certain racial groups?
  Are there large differences in positive/negative/uncertain labels?
  
**3. What does the imaging data look like?**
  How many images?
  How many images per patient?
  What views are represented?
  Are there differences in image characteristics between groups?

### Research Goal

Understand whether and how race may influence CAD model diagnostic performance
across different racial groups.

---

## 2. Data Sources

### CheXpert Dataset
<!-- Briefly describe the dataset and source. -->

### Demographic Data
<!-- Describe where the demographic data came from. -->

### Database Tables

- `chexpert_data`
- `demographic_data`

---

## 3. Dataset Overview

### Questions
- How many images are in the dataset?
- How many unique patients?
- How many studies?
- How many images per patient?
- What variables are available?

### Findings
<!-- Add your results here. -->

### Interpretation
<!-- What do these numbers tell us about the dataset? -->

---

## 4. Race Distribution

### Questions
- How many patients belong to each racial group?
- What percentage of the dataset does each group represent?
- How many images are associated with each racial group?
- Is the dataset racially imbalanced?

### SQL Analysis
<!-- Link or reference the SQL queries used. -->

### Results
<!-- Add tables/numbers here. -->

### Visualization
<!-- Add figure/dashboard here. -->

### Interpretation
<!-- What does the racial distribution mean for the research? -->

---

## 5. Disease Distribution

### Questions
- How frequently is each disease represented?
- How many positive, negative, and uncertain labels exist?
- Are diseases distributed differently across racial groups?

### Diseases Analyzed

- Cardiomegaly
- Lung Opacity
- Edema
- Pneumonia
- Atelectasis
- Pleural Effusion

### Results
<!-- Add results here. -->

### Visualization
<!-- Add figures here. -->

### Interpretation
<!-- What patterns or imbalances do we observe? -->

---

## 6. Demographic Statistics

### Age

#### Questions
- What is the mean age?
- What is the median age?
- What is the age range?
- Does age differ across racial groups?

#### Results
<!-- Add results here. -->

#### Interpretation
<!-- What does this tell us? -->


### Gender

#### Questions
- What is the gender distribution?
- Does gender distribution differ across racial groups?

#### Results
<!-- Add results here. -->

#### Interpretation
<!-- What does this tell us? -->


### Ethnicity

#### Questions
- What is the ethnicity distribution?
- How does ethnicity relate to the racial categories?

#### Results
<!-- Add results here. -->

#### Interpretation
<!-- What does this tell us? -->

---

## 7. Image Characteristics

### Questions
- What imaging views are present?
- How are AP and PA views distributed?
- How are frontal and lateral images distributed?
- Are image characteristics different across racial groups?

### Results
<!-- Add results here. -->

### Visualization
<!-- Add figures here. -->

### Interpretation
<!-- What does this tell us? -->

---

## 8. Data Quality

### Missing Values

<!-- Document missing values and where they occur. -->

### Duplicate Records

<!-- Document duplicate patients, studies, or images. -->

### Inconsistent Values

<!-- Document inconsistent race, gender, ethnicity, or disease labels. -->

### Uncertain Labels

<!-- Document how CheXpert uncertain labels (-1) are represented. -->

### Findings

<!-- Summarize important data-quality issues. -->

---

## 9. Key Findings

### Finding 1
<!-- What did we learn? -->

### Finding 2
<!-- What did we learn? -->

### Finding 3
<!-- What did we learn? -->

### Overall Interpretation

<!-- What does the EDA tell us about the dataset and potential
implications for the upcoming modeling experiments? -->

---

## 10. Data Cleaning Decisions

<!-- Based on the EDA, document what needs to be cleaned
and why. Do not make the decisions until the analysis supports them. -->

| Issue | Decision | Reason |
|---|---|---|
| | | |
| | | |
| | | |

---

## 11. SQL Queries

SQL queries used for this analysis are located in:

`sql/01_initial_eda.sql`

---

## 12. Visualizations

Generated figures are stored in:

`figures/`

<!-- Add important figures as the analysis progresses. -->

---

## 13. Next Steps

- [ ] Complete dataset overview
- [ ] Complete race analysis
- [ ] Complete disease analysis
- [ ] Complete demographic analysis
- [ ] Complete image analysis
- [ ] Complete data-quality analysis
- [ ] Document cleaning decisions
- [ ] Create cleaned dataset
- [ ] Begin baseline CAD model
