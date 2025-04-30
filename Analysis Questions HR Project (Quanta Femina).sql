create database DEPI_HR

select * from Employee_SQL
select * from Performance_Rating
select * from EducationLevel
select * from SatisfiedLevel
select * from RatingLevel



-- Add foreign Key

alter table  Employee_SQL
add constraint edu_lf_fk foreign key(Education_Level) references EducationLevel(EducationLevelID)

alter table Performance_Rating
add constraint emp_idfhp_fk foreign key(EmployeeID) references  Employee_SQL(EmployeeID)

alter table Performance_Rating
add constraint env_lp_fk foreign key(EnvironmentSatisfaction) references SatisfiedLevel(SatisfactionID)

alter table Performance_Rating
add constraint job_lp_fk foreign key(JobSatisfaction) references SatisfiedLevel(SatisfactionID)

alter table Performance_Rating
add constraint rel_lp_fk foreign key(RelationshipSatisfaction) references SatisfiedLevel(SatisfactionID)

alter table Performance_Rating
add constraint work_sp_fk foreign key(WorklifeBalance) references SatisfiedLevel(SatisfactionID)


alter table Performance_Rating
add constraint slf_rp_fk foreign key(SelfRating) references RatingLevel(RatingID)

alter table Performance_Rating
add constraint mang_rp_fk foreign key(ManagerRating) references RatingLevel(RatingID)

SELECT 
    e.*, 
    p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.SelfRating,
	p.WorkLifeBalance,p.ReviewDate,p.TrainingOpportunitiesTaken,p.TrainingOpportunitiesWithinYear,
	p.Scaled_Total_Employee_Rating,p.Scaled_Total_Employee_Satisfaction,
    sl.SatisfactionLevel, 
    el.EducationLevel, 
    rl.RatingLevel
INTO HR_Data 
FROM Employee_SQL e
LEFT JOIN Performance_Rating p ON e.EmployeeID = p.EmployeeID
LEFT JOIN SatisfiedLevel sl ON p.JobSatisfaction = sl.SatisfactionID
LEFT JOIN EducationLevel el ON e.Education_Level = el.EducationLevelID
LEFT JOIN RatingLevel rl ON p.ManagerRating = rl.RatingID;

select * from HR_Data



/******************************************* General Info ************************************/
--Q1 Count of Employees
select count (distinct h.EmployeeID) as"Count of Employees"
from HR_Data h

--Q2 AVG Years Of Experience at campony per JobRole

select h.JobRole, AVG (h.YearsAtCompany) as "AVG Years Of Experience"
from HR_Data h
group by h.JobRole 
ORDER BY "AVG Years Of Experience" desc

-- Q3 Count of Employees Per Ethnicity 

SELECT 
  h.Ethnicity, 
    COUNT(DISTINCT h.EmployeeID) AS TotalEmployees,
    ROUND(100.0 * COUNT(DISTINCT h.EmployeeID) / (Select COUNT(DISTINCT EmployeeID) FROM HRData), 2) AS PercentageEmployee
FROM HR_Data h
GROUP BY h.Ethnicity
ORDER BY PercentageEmployee DESc

-- Q4 % OF Employees per education level

SELECT 
    h.EducationLevel, 
    COUNT(DISTINCT h.EmployeeID) AS TotalEmployees,
    ROUND(100.0 * COUNT(DISTINCT h.EmployeeID) / (Select COUNT(DISTINCT EmployeeID) FROM HRData), 2) AS PercentageEmployee
FROM HR_Data h
GROUP BY h.EducationLevel
ORDER BY PercentageEmployee DESC


-- Q3 % OF Employees per Gender  *****************

SELECT 
    h.Gender, 
    COUNT(DISTINCT h.EmployeeID) AS TotalEmployees,
    ROUND(100.0 * COUNT(DISTINCT h.EmployeeID) / (Select COUNT(DISTINCT EmployeeID) FROM HRData), 2) AS PercentageEmployee
FROM HR_Data h
where h.Gender in ('Female','Male')
GROUP BY h.Gender
ORDER BY PercentageEmployee DESC;


-- Q5 % and Count of employee per each Department

select h.Department ,count(distinct h.EmployeeID)as Count_of_Employees,
ROUND(100.0 * COUNT(DISTINCT h.EmployeeID) / (Select COUNT(DISTINCT EmployeeID) FROM HRData), 2) AS PercentageEmployee
from HR_Data h
group by h.Department
order by Count_of_Employees desc



-- Q6 *********** Count & Age Groups % 
SELECT 
        CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
        END
     AS age_group,
    COUNT(DISTINCT EmployeeID) AS total_employees,
    ROUND(100.0 * COUNT(DISTINCT EmployeeID) / (SELECT COUNT(DISTINCT EmployeeID) FROM HRData), 2) AS "% of employees"
FROM HR_Data
GROUP BY 
        CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
        END
    
ORDER BY total_employees DESC;

--***************** Count of performance rating 

select h.EmployeeID ,count(EmployeeID)as Count_of_Employees_performance
from HR_Data h
group by h.EmployeeID
order by Count_of_Employees_performance desc


/*********************************** Attrition Rate ************************************************/

-- Q7 /  Attrition Rate Per average YearsAtCompany for Active Employees

SELECT 
    Attrition,
    AVG(YearsAtCompany) AS "Avg YearsAtCompany"
FROM  HR_Data 
WHERE Attrition IN (0, 1)
GROUP BY Attrition;

-- ********** Q8 What is the percentage of employees who leave the company? 

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition
    FROM HR_Data
)
SELECT 
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1);

--Q9 Attrition Rate Per Age Group

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition,Age 
    FROM HR_Data
)
SELECT 
        CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
        END
     AS age_group ,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY 
        CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
        END
ORDER BY AttritionRate desc



-- Q10 Attrition Per job satisfaction 

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition, JobSatisfaction , SatisfactionLevel
    FROM HR_Data
)
SELECT 
     JobSatisfaction,
	 SatisfactionLevel,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) /915, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY SatisfactionLevel ,JobSatisfaction
ORDER BY AttritionRate desc

-- Q11 Attrition Rate Per StockOptionLevel

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition,StockOptionLevel
    FROM HR_Data
)
SELECT 
    StockOptionLevel,
    COUNT(distinct EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees 
WHERE Attrition IN (0, 1)
GROUP BY StockOptionLevel
ORDER BY AttritionRate desc


--Q12 Attrition Rate Per JobRole 

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition,JobRole
    FROM HR_Data
)
SELECT 
    JobRole,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY JobRole
ORDER BY AttritionRate desc


--Q13 Attrition Rate Per Over Time

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition,OverTime
    FROM HR_Data
)
SELECT 
    OverTime,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY OverTime
ORDER BY AttritionRate desc

--Q14: Which departments have the highest attrition rates 


WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition, Department
    FROM HR_Data
)
SELECT 
    Department,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS "EmployeesLeft",
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY Department
ORDER BY AttritionRate desc

 -- Q15: Is there a relationship between salary and attrition rate

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition,Salary
    FROM HR_Data
)
SELECT 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory,
    COUNT(Distinct EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1)
GROUP BY 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END
ORDER BY AttritionRate DESC

--- Q16 Attretion Rate Per Gender 

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, Attrition, Gender
    FROM HR_Data
)
SELECT 
    Gender,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / 237, 2) AS AttritionRate
FROM UniqueEmployees
WHERE Attrition IN (0, 1) and Gender in ('Female','Male') 
GROUP BY Gender
ORDER BY AttritionRate desc


/************************************ Performance **********************************************/
-- Q17 AVG Performance Score

SELECT 
    
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
FROM HR_Data

--Q18 avg PerformanceScore Per job role

SELECT 
    JobRole,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
	
FROM  HR_Data
Group By JobRole
Order By  AvgPerformanceScore desc


--Q19 avg PerformanceScore Per Salary

SELECT 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
FROM  HR_Data
    
GROUP BY 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END

Order By  AvgPerformanceScore desc

--Q20 avg PerformanceScore Per Educatuion field

SELECT 
    EducationField,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
FROM  HR_Data
Group By EducationField
Order By  AvgPerformanceScore desc 

--Q21 avg PerformanceScore Per Over Time

SELECT 

   OverTime,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
	
FROM  HR_Data

Group By OverTime
Order By  AvgPerformanceScore desc 

--Q22 avg PerformanceScore per Years of experience

SELECT 
    YearsAtCompany,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating AS FLOAT)), 2) AS AvgPerformanceScore
FROM  HR_Data

Group By YearsAtCompany
Order By  AvgPerformanceScore desc

--Q23 avg PerformanceScore per Job Satisfaction

SELECT 
   JobSatisfaction,
	ROUND(AVG(CAST(Scaled_Total_Employee_Rating  AS FLOAT)), 2) AS AvgPerformanceScore
FROM HR_Data

Group By JobSatisfaction
Order By  AvgPerformanceScore desc


/**************************************** Satisfaction *********************************************/

--Q24  AVG Job Satisfaction 

SELECT 
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction, 
	COUNT(distinct EmployeeID) AS TotalEmployees
FROM HR_Data

--Q25 Job Satisfaction Per Age

SELECT 
     CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
        END
     AS age_group,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction
FROM HR_Data
GROUP BY CASE 
            WHEN Age < 25 THEN 'Age < 25'
            WHEN Age BETWEEN 25 AND 35 THEN 'Age in(25-35)'
            WHEN Age BETWEEN 36 AND 45 THEN 'Age in(36-45)'
            ELSE 'Age > 45'
		End
ORDER BY AvgJobSatisfaction DESC;


-- Q26 Job satisfaction Per Job Role 


SELECT 
    JobRole,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction
FROM HR_Data
GROUP BY JobRole
ORDER BY AvgJobSatisfaction DESC;

-- Q27 Job satisfaction per Salary Category


SELECT 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory, 
    AVG(CAST(JobSatisfaction AS FLOAT)) AS AvgJobSatisfaction
FROM HR_Data
GROUP BY CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END 
ORDER BY AvgJobSatisfaction desc

-- Q28 : How does education field correlate with JobSatisfaction ? 

SELECT 
    EducationField,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction
FROM HR_Data
GROUP BY EducationField 
ORDER BY AvgJobSatisfaction desc

-- Q29 JobSatisfaction per over time  åäÖíÝ ÇáÑÇÊÈ ÝáÊÑ 

SELECT 
   OverTime,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction
FROM  HR_Data
GROUP BY OverTime
ORDER BY AvgJobSatisfaction DESC


-- Q30  Job satisfaction per Gender? 

SELECT 
  Gender,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS AvgJobSatisfaction
FROM  HR_Data
where Gender in ('Male','Female')
GROUP BY Gender
ORDER BY AvgJobSatisfaction DESC


/************************************************** Over Time **************************************************/

-- Q31 % Of Employees Per Over Time -- AS Card

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, OverTime
    FROM HR_Data
)
SELECT 
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) AS Employees_Overtime,
    ROUND(100.0 * SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS "% of Overtime"
FROM UniqueEmployees
WHERE OverTime IN (0, 1);

--Q32  % Of Employees Over Time Per Marital Status            416

WITH UniqueEmployees AS (
    SELECT DISTINCT EmployeeID, OverTime , MaritalStatus
    FROM HR_Data
)
SELECT 
MaritalStatus,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) AS Employees_Overtime,
    ROUND(100.0 * SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) / 416, 2) AS "% of Overtime"
FROM UniqueEmployees
WHERE OverTime IN (0, 1)
GROUP BY MaritalStatus
ORDER BY "% of Overtime" desc

/********************************************** Saleries *******************************************************/

-- Q33 Avg Monthly Salraies
WITH UniqueEmployees AS (
    SELECT DISTINCT Salary, JobRole, EmployeeID
    FROM HR_Data
)
SELECT 
	COUNT(distinct EmployeeID) AS TotalEmployees,
    ROUND(AVG(CAST(Salary AS FLOAT)/12), 2) AS AvgSalary
FROM UniqueEmployees

-- Q33 Avg Monthely Saleries Per Job role

WITH UniqueEmployees AS (
    SELECT DISTINCT Salary, JobRole, EmployeeID
    FROM HR_Data
)
SELECT 
  JobRole,
	COUNT(distinct EmployeeID) AS TotalEmployees,
    ROUND(AVG(CAST(Salary AS FLOAT)/12), 2) AS AvgSalary
FROM UniqueEmployees
GROUP BY JobRole
ORDER BY AvgSalary DESC

-- Q34 Avg Monthely Saleries Per Education Level

WITH UniqueEmployees AS (
    SELECT DISTINCT Salary, EducationLevel, EmployeeID
    FROM HR_Data
)
SELECT 
  EducationLevel,
	COUNT(distinct EmployeeID) AS TotalEmployees,
    ROUND(AVG(CAST(Salary AS FLOAT)/12), 2) AS AvgSalary
FROM UniqueEmployees
GROUP BY EducationLevel
ORDER BY AvgSalary DESC





