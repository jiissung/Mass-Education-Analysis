USE MASS_SCHOOLS_DATABASE;

-- Question: Does teacher proficiency correlate with better student performance in MCAS results?
-- This query joins teacher proficiency data with MCAS results to analyze whether districts with higher teacher proficiency percentages tend to have better student outcomes 
SELECT
    d.district_name AS dist_name,
    ee.percent_proficient AS teacher_proficiency,
    AVG(m.avg_scaled_score) AS avg_student_score
FROM
    educator_eval ee
JOIN
    mcas m ON ee.district_id = m.district_id
JOIN
    district d ON ee.district_id = d.district_id
GROUP BY
    dist_name, teacher_proficiency
ORDER BY
    avg_student_score DESC;


-- Question: Which districts have the largest populations of economically disadvantaged students?
-- This query calculates the number of economically disadvantaged students in each district 
SELECT
    d.district_name AS dist_name,
    ROUND((sd.econimically_disadvantaged / 100) * sd.number_students, 0) AS economically_disadvantaged_students
FROM
    student_demographics sd
JOIN
    district d ON sd.district_id = d.district_id
ORDER BY
    economically_disadvantaged_students DESC;


-- Question: How have teacher proficiency scores changed across districts ?
-- This query calculates the average teacher proficiency scores in each district 
SELECT
    d.district_name AS dist_name,
    AVG(ee.percent_proficient) AS avg_teacher_proficiency
FROM
    educator_eval ee
JOIN
    district d ON ee.district_id = d.district_id
GROUP BY
    dist_name
ORDER BY
    avg_teacher_proficiency DESC;

    
-- Question: Which subjects consistently achieve high scores on MCAS tests?
-- This query identifies the average percentage of students exceeding expectations in different school subjects across all districts 
SELECT
    m.subject AS subject,
    AVG(m.avg_scaled_score) AS avg_score
FROM
    mcas m
GROUP BY
    subject
ORDER BY
    avg_score DESC;

     
-- Question: Do higher average student scores tend to have a higher percentage of good teachers?

SELECT 
    d.district_name,
    m.subject AS school_subject,
    (m.avg_scaled_score) AS avg_student_score,
    (ee.percent_exemplary + ee.percent_proficient) AS percent_good_teacher
FROM 
    district d
JOIN 
    mcas m ON d.district_id = m.district_id
JOIN 
    educator_eval ee ON d.district_id = ee.district_id
ORDER BY
    avg_student_score DESC;
    
-- Question: Which districts have above-average teacher salaries compared to the state average?

SELECT 
    d.district_name AS district_name, 
    s.avg_salary AS district_salary
FROM 
    salaries s
JOIN 
    district d ON s.district_id = d.district_id
WHERE 
    s.avg_salary > (SELECT AVG(avg_salary) FROM salaries)
ORDER BY 
    s.avg_salary DESC;

-- Question: Which districts have a higher-than-average percentage of proficient teachers but below-average MCAS scores?

SELECT 
    d.district_name AS district_name,
    ee.percent_proficient AS teacher_proficiency,
    (SELECT AVG(m.avg_scaled_score) FROM mcas m WHERE m.district_id = d.district_id) AS avg_mcas_score
FROM 
    educator_eval ee
JOIN 
    district d ON ee.district_id = d.district_id
WHERE 
    ee.percent_proficient > (SELECT AVG(percent_proficient) FROM educator_eval)
    AND (SELECT AVG(m.avg_scaled_score) FROM mcas m WHERE m.district_id = d.district_id) < (SELECT AVG(avg_scaled_score) FROM mcas)
ORDER BY 
    teacher_proficiency DESC;

-- Question: Which districts have higher SAT math scores than the average reading/writing score?

SELECT 
    d.district_name AS district_name,
    sat.math AS math_score,
    (SELECT AVG(sat.reading_writing) FROM sat) AS avg_reading_writing
FROM 
    sat
JOIN 
    district d ON sat.district_id = d.district_id
WHERE 
    sat.math > (SELECT AVG(sat.reading_writing) FROM sat)
ORDER BY 
    math_score DESC;
    
-- Question: Which districts have higher SAT participation rates than the average but lower SAT scores?

SELECT 
    d.district_name AS district_name,
    sat.tests_taken AS participation,
    (sat.reading_writing + sat.math) AS total_sat_score
FROM 
    sat
JOIN 
    district d ON sat.district_id = d.district_id
WHERE 
    sat.tests_taken > (SELECT AVG(tests_taken) FROM sat)
    AND (sat.reading_writing + sat.math) < (SELECT AVG(reading_writing + math) FROM sat)
ORDER BY 
    total_sat_score ASC;
    
-- Question: Do schools with a large percent of their student population considered economically disadvantged 
-- do worse on the MCAS?
-- calculates average mcas scores
WITH AvgMCAS AS (
    SELECT 
        AVG(avg_scaled_score) AS avg_scaled_score
    FROM mcas
),

-- finds the percent economically disadvantaged
EconDisadvantage AS (
    SELECT 
        d.district_id,
        d.number_students,
        (d.econimically_disadvantaged) AS percent_economically_disadvantaged
    FROM student_demographics d
)

-- Combines data and filters
SELECT 
    e.district_id,
    e.percent_economically_disadvantaged,
    m.subject,
    m.avg_scaled_score,
    a.avg_scaled_score
FROM EconDisadvantage e
JOIN mcas m ON e.district_id = m.district_id
CROSS JOIN AvgMCAS a
WHERE 
    m.avg_scaled_score < a.avg_scaled_score;
