-- sgJobData: Create Data Dictionary
SELECT
    table_schema,
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
ORDER BY table_name, ordinal_position;

--sgJobData: Header and DataType Description 
DESCRIBE main.sg_job_data;

--sgJobData: Simple Descriptive Stats
SUMMARIZE main.sg_job_data;

--Select Unique Category records
SELECT DISTINCT
    categories
FROM sg_job_data;

-- Overall Figure: Total Job Openings vs Total Job Applications [Note: to clean NULL values]
SELECT
    postedCompany_name,
    --positionLevels,
    --employmentTypes,
    SUM(numberOfVacancies) AS Total_Job_Openings,
    ROUND((SUM(numberOfVacancies) / SUM(SUM(numberOfVacancies)) OVER() * 100), 2) AS Pct_of_Total_Vacancies,
    SUM(metadata_totalNumberJobApplication) AS Total_Job_Applications,
    ROUND((SUM(metadata_totalNumberJobApplication) / SUM(SUM(metadata_totalNumberJobApplication)) OVER() * 100), 2) AS Pct_of_Total_Application
FROM
    sg_job_data
GROUP BY postedCompany_name--, positionLevels
--GROUP BY employmentTypes;
ORDER BY Total_Job_Openings DESC, Total_Job_Applications DESC;
    
--Create top level summary table showing top 10 total vacancies vs number of applications by categories (1st level) [and employmentTypes(2nd level)] by categories
SELECT
    cat.category,
    --employmentTypes,
    SUM(numberOfVacancies) AS Total_Job_Openings,
    ROUND((SUM(numberOfVacancies) / SUM(SUM(numberOfVacancies)) OVER() * 100), 2) AS Pct_of_Total_Vacancies,
    SUM(metadata_totalNumberJobApplication) AS Total_Job_Applications,
    ROUND((SUM(metadata_totalNumberJobApplication) / SUM(SUM(metadata_totalNumberJobApplication)) OVER() * 100), 2) AS Pct_of_Total_Application
FROM 
    sg_job_data s,
    UNNEST(json_extract_string(s.categories, '$[*].category')) AS cat(category)
GROUP BY cat.category--,employmentTypes
ORDER BY Pct_of_Total_Vacancies DESC, Pct_of_Total_Application DESC
LIMIT 10;

-- Create top level summary table total vacancies vs number of applications by positionLevels (1st level)[and employmentTypes (2nd level)]
SELECT
    positionLevels, --employmentTypes,
    SUM(numberOfVacancies) AS Total_Job_Openings,
    ROUND((SUM(numberOfVacancies) / SUM(SUM(numberOfVacancies)) OVER() * 100), 2) AS Pct_of_Total_Vacancies,
    SUM(metadata_totalNumberJobApplication) AS Total_Job_Applications,
    ROUND((SUM(metadata_totalNumberJobApplication) / SUM(SUM(metadata_totalNumberJobApplication)) OVER() * 100), 2) AS Pct_of_Total_Application
FROM sg_job_data
GROUP BY positionLevels--, employmentTypes
-- HAVING Total_Job_Openings < Total_Job_Applications
-- HAVING Total_Job_Openings > Total_Job_Applications
ORDER BY Total_Job_Openings DESC;

-- Top 10 categories with highest job openings with repost count of more than 1 (putting up job ad more than once might indicate difficulty in filling the role with local candidate)
SELECT
    cat.category,
    --positionLevels,
    COUNT(s.postedCompany_name) AS numberOfCompanies
FROM
    sg_job_data s,
    UNNEST(json_extract_string(s.categories, '$[*].category')) AS cat(category)
WHERE s.metadata_repostCount > 1
GROUP BY cat.category,s.metadata_repostCount--,positionLevels
ORDER BY numberOfCompanies DESC
LIMIT 10;

--Top 10 categories with highest no of job openings and applications with salary above 3.15k by categories and postionLevels (min salary criteria for S Pass in 2023), [opening posted by outsourced agency (metadata_isPostedOnBehalf = TRUE)]
SELECT
    cat.category,
    positionLevels, 
    SUM(numberOfVacancies) AS Total_Vacancies,
    SUM(metadata_totalNumberJobApplication) AS Total_Applications
FROM
    sg_job_data s,
    UNNEST(json_extract_string(s.categories, '$[*].category')) AS cat(category)
WHERE
    salary_minimum > 3150
    --AND metadata_isPostedOnBehalf = TRUE
GROUP BY
    cat.category, positionLevels
-- HAVING SUM(numberOfVacancies) < SUM(metadata_totalNumberJobApplication)
-- HAVING SUM(numberOfVacancies) > SUM(metadata_totalNumberJobApplication)
ORDER BY
    Total_Vacancies DESC
LIMIT 10;

--Top 10 categories of job openings and applications with salary above 3.15k by categories and employmentTypes (min salary criteria for S Pass in 2023) [opening posted by outsourced agency (metadata_isPostedOnBehalf = TRUE)]
SELECT
    cat.category,
    employmentTypes, 
    SUM(numberOfVacancies) AS Total_Vacancies,
    SUM(metadata_totalNumberJobApplication) AS Total_Applications
FROM
    sg_job_data s,
    UNNEST(json_extract_string(s.categories, '$[*].category')) AS cat(category)
WHERE
    salary_minimum > 3150
    --AND metadata_isPostedOnBehalf = TRUE
GROUP BY
    cat.category, employmentTypes
-- HAVING SUM(numberOfVacancies) < SUM(metadata_totalNumberJobApplication)
-- HAVING SUM(numberOfVacancies) > SUM(metadata_totalNumberJobApplication)
ORDER BY
    Total_Vacancies DESC
LIMIT 10;
