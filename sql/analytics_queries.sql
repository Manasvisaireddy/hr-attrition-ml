-- ============================================================
-- Employee Attrition Project — SQL Analytics Queries
-- Database: attrition.db (SQLite)
-- Run via: sqlite3 attrition.db or pandas read_sql()
-- ============================================================

-- 1. Attrition rate by department
SELECT
    Department,
    COUNT(*)                                AS total_employees,
    SUM(Attrition_Binary)                   AS employees_left,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- 2. Attrition rate by job role
SELECT
    JobRole,
    COUNT(*)                                AS total_employees,
    SUM(Attrition_Binary)                   AS employees_left,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- 3. Overtime effect on attrition
SELECT
    OverTime,
    COUNT(*)                                AS total_employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
GROUP BY OverTime;

-- 4. Attrition by tenure band
SELECT
    CASE
        WHEN YearsAtCompany <= 2  THEN '0-2 years'
        WHEN YearsAtCompany <= 5  THEN '3-5 years'
        WHEN YearsAtCompany <= 10 THEN '6-10 years'
        ELSE '10+ years'
    END                                     AS tenure_band,
    COUNT(*)                                AS total_employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
GROUP BY tenure_band
ORDER BY MIN(YearsAtCompany);

-- 5. Attrition by income quartile
SELECT
    NTILE(4) OVER (ORDER BY MonthlyIncome)  AS income_quartile,
    COUNT(*)                                AS total_employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct,
    ROUND(MIN(MonthlyIncome), 0)            AS min_income,
    ROUND(MAX(MonthlyIncome), 0)            AS max_income
FROM employees
GROUP BY income_quartile
ORDER BY income_quartile;

-- 6. Overtime x low satisfaction (headline finding)
SELECT
    'Overtime + Low Satisfaction'           AS segment,
    COUNT(*)                                AS employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
WHERE OverTime = 'Yes' AND JobSatisfaction <= 2
UNION ALL
SELECT
    'No Overtime + High Satisfaction'       AS segment,
    COUNT(*)                                AS employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
WHERE OverTime = 'No' AND JobSatisfaction >= 3;

-- 7. Cost of attrition by department
SELECT
    Department,
    SUM(Attrition_Binary)                           AS employees_left,
    ROUND(AVG(MonthlyIncome), 0)                    AS avg_monthly_income,
    ROUND(SUM(MonthlyIncome * 12 * 0.5), 0)        AS replacement_cost_usd
FROM employees
WHERE Attrition_Binary = 1
GROUP BY Department
ORDER BY replacement_cost_usd DESC;

-- 8. Early tenure churn (years 1-3 highest risk)
SELECT
    YearsAtCompany,
    COUNT(*)                                AS employees,
    ROUND(AVG(Attrition_Binary) * 100, 1)  AS attrition_rate_pct
FROM employees
WHERE YearsAtCompany <= 10
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;
