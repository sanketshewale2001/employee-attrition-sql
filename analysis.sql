
-- ===============================
-- Employee Attrition SQL Analysis
-- ===============================

-- Database creation
CREATE DATABASE Employee;
USE Employee;

-- Table overview
SHOW TABLES;
SELECT * FROM employee;
DESCRIBE employee;

-- ===============================
-- Data Quality Checks
-- ===============================

-- Check NULL values
SELECT * FROM employee
WHERE Education IS NULL
   OR JoiningYear IS NULL
   OR City IS NULL
   OR PaymentTier IS NULL
   OR Age IS NULL
   OR Gender IS NULL
   OR EverBenched IS NULL
   OR ExperienceInCurrentDomain IS NULL
   OR LeaveOrNot IS NULL;

-- ===============================
-- Basic Exploration
-- ===============================

SELECT COUNT(*) AS total_employees FROM employee;

SELECT LeaveOrNot, COUNT(*) 
FROM employee
GROUP BY LeaveOrNot;

SELECT Gender, COUNT(*)
FROM employee
GROUP BY Gender;

SELECT City, COUNT(*)
FROM employee
GROUP BY City;

SELECT Gender, ROUND(AVG(Age),2) AS avg_age
FROM employee
GROUP BY Gender;

-- ===============================
-- Attrition Analysis
-- ===============================

-- Overall attrition rate
SELECT ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate_pct 
FROM employee;

-- Gender-wise attrition
SELECT Gender, 
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate_gender_wise
FROM employee
GROUP BY Gender;

-- City-wise attrition
SELECT City, 
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate_city_wise
FROM employee
GROUP BY City
ORDER BY attrition_rate_city_wise DESC;

-- Payment tier vs attrition
SELECT PaymentTier,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_pct
FROM employee
GROUP BY PaymentTier
ORDER BY PaymentTier;

-- City + PaymentTier attrition
SELECT City, PaymentTier,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY City, PaymentTier
ORDER BY PaymentTier DESC;

-- Experience + City + PaymentTier
SELECT City, ExperienceInCurrentDomain, PaymentTier,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY City, ExperienceInCurrentDomain, PaymentTier
ORDER BY attrition_rate DESC;

-- ===============================
-- Age Group Analysis
-- ===============================

SELECT 
  CASE
    WHEN Age < 25 THEN '<25'
    WHEN Age BETWEEN 25 AND 30 THEN '25-30'
    WHEN Age BETWEEN 31 AND 35 THEN '31-35'
    ELSE '36+'        
  END AS age_group,
  COUNT(*) AS total,
  ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY age_group
ORDER BY age_group;

-- ===============================
-- Bench Analysis
-- ===============================

SELECT EverBenched, 
       COUNT(*) AS total,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY EverBenched;

SELECT Gender, COUNT(*) 
FROM employee
WHERE EverBenched = 'Yes'
GROUP BY Gender;

-- ===============================
-- Education Analysis
-- ===============================

SELECT Education, 
       COUNT(*) AS total,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY Education
ORDER BY attrition_rate DESC;

-- ===============================
-- Ranking & Advanced Analysis
-- ===============================

SELECT City,
       COUNT(*) AS total,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate,
       RANK() OVER (ORDER BY AVG(LeaveOrNot) DESC) AS attrition_rank
FROM employee
GROUP BY City;

-- ===============================
-- Additional Insights
-- ===============================

SELECT AVG(PaymentTier) AS avg_payment_tier, COUNT(*)
FROM employee
WHERE LeaveOrNot = 1;

SELECT Gender, COUNT(*)
FROM employee
WHERE Age > (SELECT AVG(Age) FROM employee)
  AND LeaveOrNot = 1
GROUP BY Gender;

SELECT ExperienceInCurrentDomain,
       ROUND(AVG(LeaveOrNot)*100,2) AS attrition_rate
FROM employee
GROUP BY ExperienceInCurrentDomain
ORDER BY attrition_rate DESC
LIMIT 3;
