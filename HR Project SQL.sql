

/********************************** EMPLOYEE TABLE CLEANING  ***************************************/

-- COPPING ORIGINAL TABLE OF DATA INTO ANOTHER TABLE

select * 
into Employee_Copy_Final
from Employee 

-- COUNT # OF ROWS **BEFORE** REMOVE DUPLICATS -- 1740 COLUMNS

select COUNT(*)
from  Employee_Copy_Final

-- REMOVE DUPLICATES IF EXIST  

select *
from  Employee_Copy_Final e
where e.EmployeeID in (select EmployeeID
from  Employee_Copy_Final 
group by EmployeeID
having COUNT(*) >1)

-- Another method

select  distinct * 
from  Employee_Copy_Final


--COUNT # OF COLUMNS   -- 23 COLUMNS

select count(*) as "Number of columns"
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = ' Employee_Copy_Final'

-- RETRIVING COLUMNS THAT HAVE NULL VALUES  -- THERE IS NO NULL VALUES

select *
from   Employee_Copy_Final e
where e.Age  is null 
or  e.Department  is null 
or e.EducationField is null 
or e.EmployeeID is null
or e.FirstName is null 
or e.HireDate is null
or e.JobRole is null 
or e.LastName is null 
or e.OverTime is null 
or e.Salary is null 
or e.State is null 
or e.StockOptionLevel is null
or e.YearsAtCompany is null 
or e.YearsInMostRecentRole is null
or e.YearsSinceLastPromotion is null 
or e.YearsWithCurrManager is null 
or e.Gender is null 
or e.BusinessTravel is null 
or e.Attrition is null 
or e.DistanceFromHome_KM is null 
or e.Education is null 
or e.YearsInMostRecentRole is null



-- REMOVE SPACES USING TRIM IF EXIST
-- WE USE TRIM FOR COLUMNS WHICH HAVE STRING VALUES AND MORE THAN 1 BIT 

UPDATE  Employee_Copy_Final 
SET EmployeeID = TRIM(EmployeeID),
FirstName =  TRIM(FirstName),
LastName = TRIM(LastName),
Gender = TRIM(Gender ),
BusinessTravel = TRIM(BusinessTravel),
Department = TRIM(Department), 
State = TRIM(State),
EducationField = TRIM(EducationField),
JobRole = TRIM(JobRole)



-- CHECK IF THERE IS EMPTY VALUES         -- THERE IS NO EMPTY VALUES
 
select count(*) as "empty cells in Stock_Option_Level"
from  Employee_Copy_Final e
where e.StockOptionLevel ='  ' and e.StockOptionLevel <> 0

select count(*) as "empty cells in Years_At_Company"
from  Employee_Copy_Final e
where e.YearsAtCompany = '  ' and e.YearsAtCompany <> 0

select count(*) as "empty cells in Years_In_Most_Recent_Role"
from  Employee_Copy_Final e
where e.YearsInMostRecentRole = ' ' and e.YearsInMostRecentRole <> 0

select count(*) as "empty cells in Years_SinceLast_Promotion"
from  Employee_Copy_Final e
where e.YearsSinceLastPromotion = '  ' and e.YearsSinceLastPromotion <> 0

select count(*) as "empty cells in Years_With_Curr_Manager"
from  Employee_Copy_Final e
where e.YearsWithCurrManager = '  ' and  e.YearsWithCurrManager <> 0

select count(*) as "empty cells in Over Time"
from  Employee_Copy_Final e
where e.OverTime = '  ' and  e.OverTime <> 0

select count(*) as "empty cells in Attrition"
from  Employee_Copy_Final e
where e.Attrition = '  ' and e.Attrition  <> 0

select count(*) as "empty cells in Gender"
from  Employee_Copy_Final e
where e.Gender = '  ' 

select count(*) as "empty cells in Education"
from  Employee_Copy_Final e
where e.Education = '  ' 

select count(*) as "empty cells in Age"
from  Employee_Copy_Final e
where  e.Age  = '  ' 

select count(*) as "empty cells in Department"
from  Employee_Copy_Final e
where  e.Department = '  '  

select count(*) as "empty cells in Education Field"
from  Employee_Copy_Final e
where e.EducationField = '  ' 

select count(*) as "empty cells in EmployeeID"
from  Employee_Copy_Final e
where e.EmployeeID = '  ' 

select count(*) as "empty cells in FirstName"
from  Employee_Copy_Final e
where e.FirstName = '  '  

select count(*) as "empty cells in Hire Date"
from  Employee_Copy_Final e
where e.HireDate ='  ' 

select count(*) as "empty cells in Job_Role"
from  Employee_Copy_Final e
where e.JobRole = '  ' 

select count(*) as "empty cells in LastName"
from  Employee_Copy_Final e
where e.LastName = '  ' 

select count(*) as "empty cells in Salary"
from  Employee_Copy_Final e
where e.Salary = '  '  

select count(*) as "empty cells in State"
from  Employee_Copy_Final e
where e.State = '  ' 

select count(*) as "empty cells in Business Travel"
from  Employee_Copy_Final e
where e.BusinessTravel = '  ' 

select count(*) as "empty cells in Distance From Home_KM"
from  Employee_Copy_Final e
where e.DistanceFromHome_KM = '  ' 


--REPLACE COLUMNS NAMES AND VALUES IF NEEDED

--UPDATE COLUMNS NAME

ALTER TABLE  Employee_Copy_Final ADD Education_Level tinyint;

UPDATE  Employee_Copy_Final SET Education_Level = Education;
ALTER TABLE  Employee_Copy_Final DROP COLUMN Education; 

select*from  Employee_Copy_Final

-- UPDATE VALUES 

-- RETRIVING ALL OF DISTINCT VALUES OF COLUMNS TO DETERMINE IF THERE IS ANY VALUE NEED TO BE REPLACED

select distinct e.EducationField 
from  Employee_Copy_Final e

select distinct e.BusinessTravel
from  Employee_Copy_Final e

select distinct e.Department
from  Employee_Copy_Final e

select distinct e.State
from  Employee_Copy_Final e

select distinct e.JobRole
from  Employee_Copy_Final e

select distinct e.Age
from  Employee_Copy_Final e

select distinct e.YearsAtCompany 
from  Employee_Copy_Final e
-- Updated values

update  Employee_Copy_Final 
set BusinessTravel = 'Freq Traveller'
where BusinessTravel = 'Frequent Traveller'

COMMIT

update  Employee_Copy_Final 
set Department = 'HR'
where Department = 'Human Resources'

COMMIT

-- Change HireDate column data type from nvarchar to datetime

UPDATE  Employee_Copy_Final
SET HireDate = TRY_CAST(HireDate AS DATETIME)
WHERE TRY_CAST(HireDate AS DATETIME) IS NOT NULL;

-- check if the data type updated correctly

SELECT COLUMN_NAME , DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = ' Employee_Copy_Final' AND COLUMN_NAME = 'HireDate';



/********************************** Cleanning Performance Rating Table  ***************************************/


-- COPPING ORIGINAL TABLE OF DATA INTO ANOTRER TABLE

select * 
into Performance_Rating
from PerformanceRating 

SELECT * FROM Performance_Rating;

-- Remove duplicates
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY PerformanceID, EmployeeID, ReviewDate, EnvironmentSatisfaction,
                            JobSatisfaction, RelationshipSatisfaction, TrainingOpportunitiesWithinYear,
                            TrainingOpportunitiesTaken, WorkLifeBalance, SelfRating, ManagerRating
               ORDER BY PerformanceID
           ) AS RowNum
FROM Performance_Rating
)

DELETE FROM CTE
WHERE RowNum > 1;

-- Replace blank or invalid values with NULL
UPDATE Performance_Rating
SET ReviewDate = NULL
WHERE ReviewDate IS NULL OR LTRIM(RTRIM(ReviewDate)) = '';

-- Update valid dates
UPDATE Performance_Rating
SET ReviewDate = TRY_CONVERT(DATE, ReviewDate)
WHERE TRY_CONVERT(DATE, ReviewDate) IS NOT NULL;

-- Replace invalid dates with NULL
UPDATE Performance_Rating
SET ReviewDate = NULL
WHERE TRY_CONVERT(DATE, ReviewDate) IS NULL;

--Replace NULL values in numeric columns with default values (0) 
UPDATE Performance_Rating
SET EnvironmentSatisfaction = ISNULL(EnvironmentSatisfaction, 0),
    JobSatisfaction = ISNULL(JobSatisfaction, 0),
    RelationshipSatisfaction = ISNULL(RelationshipSatisfaction, 0),
    TrainingOpportunitiesWithinYear = ISNULL(TrainingOpportunitiesWithinYear, 0),
    TrainingOpportunitiesTaken = ISNULL(TrainingOpportunitiesTaken, 0),
    WorkLifeBalance = ISNULL(WorkLifeBalance, 0),
    SelfRating = ISNULL(SelfRating, 0),
    ManagerRating = ISNULL(ManagerRating, 0);

	-- Check for invalid values
SELECT *
FROM Performance_Rating
WHERE EnvironmentSatisfaction NOT BETWEEN 1 AND 5
   OR JobSatisfaction NOT BETWEEN 1 AND 5
   OR RelationshipSatisfaction NOT BETWEEN 1 AND 5
   OR WorkLifeBalance NOT BETWEEN 1 AND 5;

-- Correct invalid values
UPDATE Performance_Rating
SET EnvironmentSatisfaction = NULLIF(EnvironmentSatisfaction, 0)
WHERE EnvironmentSatisfaction NOT BETWEEN 1 AND 5;

-- Correct invalid values in Trainning houers column
SELECT *                                     -- 823 rows
FROM Performance_Rating
WHERE TrainingOpportunitiesTaken > TrainingOpportunitiesWithinYear;

UPDATE Performance_Rating
SET TrainingOpportunitiesTaken = TrainingOpportunitiesWithinYear
WHERE TrainingOpportunitiesTaken > TrainingOpportunitiesWithinYear;

UPDATE Performance_Rating
SET TrainingOpportunitiesWithinYear = 0
WHERE TrainingOpportunitiesWithinYear IS NULL;

SELECT COUNT(*)  as "# of TrainingOpportunitiesTaken"
FROM Performance_Rating
WHERE TrainingOpportunitiesTaken > TrainingOpportunitiesWithinYear;

/********************************** Cleanning Education Level Table ***************************************/

-- COPPING ORIGINAL TABLE OF DATA INTO ANOTRER TABLE

select * 
into Education_L
from EducationLevel

SELECT * 
FROM Education_L;

-- Trim Unnecessary Spaces

UPDATE Education_L
SET EducationLevel = TRIM(EducationLevel);

-- Standardization of EducationLevel Values

UPDATE Education_L
SET EducationLevel = UPPER(LEFT(EducationLevel, 1)) + LOWER(SUBSTRING(EducationLevel, 2, LEN(EducationLevel)));

-- Check duplicates Rawas

SELECT EducationLevel, COUNT(*)
FROM Education_L
GROUP BY EducationLevel
HAVING COUNT(*) > 1;

-- Correcting Wrong Values

UPDATE Education_L
SET EducationLevel = 
    CASE 
        WHEN EducationLevel = 'Bachelors' THEN 'Bachelor’s'
        WHEN EducationLevel = 'Masters' THEN 'Master’s'
        WHEN EducationLevel = 'Doctorate' THEN 'Doctorate Degree'
        ELSE EducationLevel
    END;

-- Check if there are NULL Values 

SELECT * FROM Education_L WHERE EducationLevel IS NULL;

-- Data AFTER Cleanning 
SELECT * FROM Education_L

/********************************** Cleanning Rating Level Table  ***************************************/

 

-- COPPING ORIGINAL TABLE OF DATA INTO ANOTRER TABLE

select * 
into Rating_L
from RatingLevel

select * from Rating_L

-- Trim Unnecessary Spaces

UPDATE Rating_L
SET RatingLevel = TRIM(RatingLevel);

-- Standardization of EducationLevel Values

UPDATE Rating_L
SET RatingLevel = UPPER(LEFT(RatingLevel, 1)) + LOWER(SUBSTRING(RatingLevel, 2, LEN(RatingLevel)));


-- Check duplicates Rawas

SELECT RatingLevel, COUNT(*)
FROM Rating_L
GROUP BY RatingLevel
HAVING COUNT(*) > 1;

-- Check if there are NULL Values 

SELECT * FROM Rating_L WHERE RatingLevel IS NULL;

 --Data AFTER Cleanning

SELECT * FROM Rating_L

/********************************** Cleanning Rating Level Table  ***************************************/

-- COPPING ORIGINAL TABLE OF DATA INTO ANOTRER TABLE

select * 
into Satisfied_L
from SatisfiedLevel

select * from Satisfied_L

-- Trim Unnecessary Spaces

UPDATE Satisfied_L
SET SatisfactionLevel = TRIM(SatisfactionLevel);

-- Check duplicates Rawas

SELECT SatisfactionLevel, COUNT(*)
FROM Satisfied_L
GROUP BY SatisfactionLevel
HAVING COUNT(*) > 1;

-- Check if there are NULL Values 

SELECT * FROM Satisfied_L WHERE SatisfactionLevel IS NULL;

/************************************************** Outliers ******************************************************/

select e.JobRole ,min(e.Salary ) ,max(e.Salary ), avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Machine Learning Engineer'--**--
group by e.JobRole 

select e.JobRole ,min(e.Salary ) as"min" ,max(e.Salary ) as"max" , avg(e.Salary)as"avg"
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist'
group by e.JobRole 

select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Sales Executive'--**--
group by e.JobRole 


select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'HR Business Partner'--**--
group by e.JobRole 


select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Engineering Manager'--**--
group by e.JobRole 


select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Recruiter'--**--
group by e.JobRole 


select e.JobRole ,min(e.Salary ) as"min" ,max(e.Salary ) as"max" , avg(e.Salary)as"avg"
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer'
group by e.JobRole 


select e.JobRole ,min(e.Salary ) as"min" ,max(e.Salary ) as"max" , avg(e.Salary)as"avg"
from Employee_Copy_Final e
where e.JobRole = 'Senior Software Engineer'--**--  -- ÇáÞíã ßæíÓÉ ÈÇáäÓÈÉ áäÝÓå áßä áãÇ ÊÞÇÑäå ÈÇáÓæÝÊæíÑ ÈÓ ÈÊÙåÑ ÇáãÔßáÉ
group by e.JobRole 


select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Sales Representative'--**--
group by e.JobRole 

select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Analytics Manager'--**--
group by e.JobRole

select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'HR Executive'--**--
group by e.JobRole

select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'HR Manager'--**--
group by e.JobRole

select e.JobRole ,min(e.Salary ) ,max(e.Salary ) , avg(e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Manager'--**--
group by e.JobRole


select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist' and e.Salary > 56000

select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist' and e.Salary > 100000


select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist' and e.Salary > 100000
order by e.Salary desc

select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist' and e.Salary > 56000 
order by e.Salary desc


select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer' and e.Salary > 51000

select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer' and e.Salary > 51000
order by e.Salary asc

select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer' and e.Salary > 100000


select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer' and e.Salary > 100000
order by e.Salary desc


select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Senior Software Engineer' and e.Salary > 126000

select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Senior Software Engineer' and e.Salary > 126000
order by e.Salary asc

select COUNT( e.Salary)
from Employee_Copy_Final e
where e.JobRole = 'Senior Software Engineer' and e.Salary > 200000
 
 Select e.Age,e.Department,e.Salary, e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
 p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating

 from Employee_Copy_Final e full outer join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary = 455643  and e.JobRole = 'Data Scientist'

 Select e.Age,e.Department,e.Salary,e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating
 from Employee_Copy_Final e join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary in(	56053 ,70182) and e.JobRole = 'Data Scientist'

Select e.Age,e.Department,e.Salary,e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating
 from Employee_Copy_Final e join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary in(	175692 ,142075) and e.JobRole = 'Data Scientist'


 Select e.Age,e.Department,e.Salary, e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
 p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating

 from Employee_Copy_Final e full outer join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary in(439641,314181)  and e.JobRole = 'Software Engineer'
 

 
 Select e.Age,e.Department,e.Salary, e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
 p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating

 from Employee_Copy_Final e full outer join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary in(155786,155259)  and e.JobRole = 'Software Engineer'
 

 Select e.Age,e.Department,e.Salary, e.DistanceFromHome_KM,e.Education_Level,e.EducationField,e.OverTime,e.State,e.StockOptionLevel,e.YearsInMostRecentRole,e.YearsAtCompany,
 p.JobSatisfaction,p.EnvironmentSatisfaction,p.RelationshipSatisfaction,p.ManagerRating,p.WorkLifeBalance,p.SelfRating

 from Employee_Copy_Final e full outer join Performance_Rating p
 on e.EmployeeID = p.EmployeeID
 where e.Salary > 150000  and e.JobRole = 'Senior Software Engineer'

 -- Delete Outliers

 
DELETE FROM Performance_Rating
WHERE EmployeeID IN (SELECT EmployeeID FROM Employee_Copy_Final WHERE Salary in (439641,314181) and JobRole = 'Software Engineer');

DELETE FROM Employee_Copy_Final
WHERE Salary in (439641,314181) and JobRole = 'Software Engineer'

DELETE FROM Performance_Rating
WHERE EmployeeID IN (SELECT EmployeeID FROM Employee_Copy_Final WHERE Salary in (455643, 423941) and JobRole = 'Data Scientist');

DELETE FROM Employee_Copy_Final
WHERE Salary in (455643, 423941) and JobRole = 'Data Scientist'

-- Check if Outliers is Deleted Succesfully

select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Data Scientist'
order by e.Salary desc

select e.Salary
from Employee_Copy_Final e
where e.JobRole = 'Software Engineer'
order by e.Salary desc


--Data AFTER Cleanning


SELECT * FROM Employee_Copy
SELECT * FROM Performance_Rating	
SELECT * FROM Education_L
SELECT * FROM Rating_L
SELECT * FROM Satisfied_L

/********************************** DATA MODELING  ***************************************/

-- Add Primary key


alter table  Employee_Copy_Final
add constraint emp_idf_pk primary key(EmployeeID)

alter table Performance_Rating
add constraint per_id_pk primary key(PerformanceID)

alter table Education_L
add constraint edu_l_id_pk primary key(EducationLevelID)

alter table Rating_L
add constraint rate_id_pk primary key(RatingID)

alter table Satisfied_L
add constraint sat_l_pk primary key(SatisfactionID)

-- Add foreign Key

alter table  Employee_Copy_Final
add constraint edu_lf_fk foreign key(Education_Level) references Education_L(EducationLevelID)

alter table Performance_Rating
add constraint emp_idf_fk foreign key(EmployeeID) references  Employee_Copy_Final(EmployeeID)

alter table Performance_Rating
add constraint env_l_fk foreign key(EnvironmentSatisfaction) references Satisfied_L(SatisfactionID)

alter table Performance_Rating
add constraint job_l_fk foreign key(JobSatisfaction) references Satisfied_L(SatisfactionID)

alter table Performance_Rating
add constraint rel_l_fk foreign key(RelationshipSatisfaction) references Satisfied_L(SatisfactionID)

alter table Performance_Rating
add constraint work_s_fk foreign key(WorklifeBalance) references Rating_L(RatingID)

alter table Performance_Rating
add constraint slf_r_fk foreign key(SelfRating) references Rating_L(RatingID)

alter table Performance_Rating
add constraint mang_r_fk foreign key(ManagerRating) references Rating_L(RatingID)

-- Check if ALL Tabels is Related Successfully

select e.FirstName , p.SelfRating , r.RatingLevel , ed.EducationLevel , s.SatisfactionLevel
from Employee_Copy_Final e join Performance_Rating p
ON e.EmployeeID = e.EmployeeID join Rating_L r
ON p.SelfRating = r.RatingID join Education_L ed
ON e.Education_Level = ed.EducationLevelID join Satisfied_L s
ON p.JobSatisfaction = s.SatisfactionID


SELECT * FROM  Employee_Copy_Final
SELECT * FROM Performance_Rating	
SELECT * FROM Education_L
SELECT * FROM Rating_L
SELECT * FROM Satisfied_L

/********************************** ANALYSIS QUESTIONS ***************************************/

/* Q1: What is the average YearsAtCompany of employees who leave vs. those who stay? */
SELECT 
    Attrition,
    AVG(YearsAtCompany) AS "Avg YearsAtCompany"
FROM  Employee_Copy_Final 
WHERE Attrition IN (0, 1)
GROUP BY Attrition;

/* Q2: How does job satisfaction impact employee retention? */
SELECT 
    pr.JobSatisfaction,
    COUNT(ec.EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN ec.Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN ec.Attrition = 1 THEN 1 ELSE 0 END) / COUNT(ec.EmployeeID), 2) AS AttritionRate
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
WHERE ec.Attrition IN (0, 1)
GROUP BY pr.JobSatisfaction
ORDER BY pr.JobSatisfaction;
Fixes:

/* Q3: What is the percentage of employees who leave the company? */

SELECT 
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM Employee_Copy_Final e 
WHERE Attrition IN (0, 1);

/* Q4: Which departments have the highest attrition rates ? */
SELECT 
    Department,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM Employee_Copy_Final e
WHERE Attrition IN (0, 1)
GROUP BY Department
ORDER BY AttritionRate DESC;

/* Q5: How does distance from home to the workplace affect how long an employee stays? */
SELECT 
    DistanceFromHome_KM,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM Employee_Copy_Final e
WHERE Attrition IN (0, 1)
GROUP BY DistanceFromHome_KM
ORDER BY DistanceFromHome_KM ;

/* Q6: Is there a relationship between salary and attrition rate? */
SELECT 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END AS SalaryCategory,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM Employee_Copy_Final
WHERE Attrition IN (0, 1)
GROUP BY 
    CASE 
        WHEN Salary < 50000 THEN 'Low'
        WHEN Salary BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'High'
    END
ORDER BY SalaryCategory;

/* Q7: Does years in current role (YearsInMostRecentRole) correlate with lower satisfaction? */

SELECT 
    YearsInMostRecentRole,
    AVG(CAST(JobSatisfaction AS FLOAT)) AS AvgJobSatisfaction
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
GROUP BY YearsInMostRecentRole
ORDER BY AVG(CAST(JobSatisfaction AS FLOAT)) desc;

/* Q8: How does years with current manager correlate with performance rating or attrition? */
SELECT 
    ec.YearsWithCurrManager,
    AVG(CAST(pr.SelfRating AS FLOAT)) AS AvgSelfRating,
    AVG(CAST(pr.ManagerRating AS FLOAT)) AS AvgManagerRating,
    ROUND(100.0 * SUM(CASE WHEN ec.Attrition = 1 THEN 1 ELSE 0 END) / COUNT(ec.EmployeeID), 2) AS AttritionRate
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
WHERE ec.Attrition IN (0, 1)
GROUP BY ec.YearsWithCurrManager
ORDER BY ec.YearsWithCurrManager;


/* Q9: Are there differences in satisfaction levels between male and female employees? */
SELECT 
    ec.Gender,
    COUNT(ec.EmployeeID) AS TotalEmployees,
    AVG(CAST(pr.JobSatisfaction AS FLOAT)) AS AvgJobSatisfaction
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
where ec.Gender in('Male' , 'Female')
GROUP BY ec.Gender;

/* Q11: What is the impact of overtime on employee productivity? */
SELECT 
    ec.Overtime,
    COUNT(ec.EmployeeID) AS TotalEmployees,
    AVG(CAST(pr.SelfRating AS FLOAT)) AS AvgSelfRating,
    AVG(CAST(pr.ManagerRating AS FLOAT)) AS AvgManagerRating
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
GROUP BY ec.Overtime;

/* Q12: How does education level correlate with employee performance? */
SELECT 
    ec.Education_Level,
    COUNT(ec.EmployeeID) AS TotalEmployees,
    AVG(CAST(pr.SelfRating AS FLOAT)) AS AvgSelfRating,
    AVG(CAST(pr.ManagerRating AS FLOAT)) AS AvgManagerRating
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
GROUP BY ec.Education_Level;

/* Q13: Is there a wage gap among employees based on education? */
SELECT 
    Education_Level,
    COUNT(EmployeeID) AS TotalEmployees,
    AVG(Salary) AS AvgSalary
FROM Employee_Copy_Final
GROUP BY Education_Level;

/* Q14: How does education field impact job performance? */
SELECT 
    ec.EducationField,
    COUNT(ec.EmployeeID) AS TotalEmployees,
    AVG(CAST(pr.SelfRating AS FLOAT)) AS AvgSelfRating,
    AVG(CAST(pr.ManagerRating AS FLOAT)) AS AvgManagerRating
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
GROUP BY ec.EducationField;

/* Q15: How long does it take for employees to get a promotion, and does it vary by department? */
SELECT 
    Department,
    AVG(YearsSinceLastPromotion) AS AvgYearsToPromotion
FROM Employee_Copy_Final
GROUP BY Department
ORDER BY AvgYearsToPromotion;

/* Q16: Do employees who take more training opportunities receive promotions faster? */
SELECT 
    TrainingOpportunitiesTaken,
    AVG(YearsSinceLastPromotion) AS AvgYearsToPromotion
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID
GROUP BY TrainingOpportunitiesTaken
ORDER BY TrainingOpportunitiesTaken;

/* Q17: What is the relationship between employee performance scores and salary increases? */
SELECT 
    AVG(CAST(SelfRating AS FLOAT)) AS AvgSelfRating,
    AVG(CAST(ManagerRating AS FLOAT)) AS AvgManagerRating,
    AVG(Salary) AS AvgSalary
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec ON pr.EmployeeID = ec.EmployeeID;

/* Q18: How do stock options and bonuses impact employee retention? */
SELECT 
    StockOptionLevel,
    COUNT(EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS EmployeesLeft,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) / COUNT(EmployeeID), 2) AS AttritionRate
FROM Employee_Copy_Final
WHERE Attrition IN (0, 1)
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;

/*Q19: Are employees with higher training hours more productive? */
SELECT 
    pr.TrainingOpportunitiesTaken,
    COUNT(pr.EmployeeID) AS TotalEmployees,
    AVG(CAST(ec.YearsSinceLastPromotion AS FLOAT)) AS AvgYearsSinceLastPromotion
FROM Performance_Rating pr
JOIN Employee_Copy_Final ec 
    ON pr.EmployeeID = ec.EmployeeID
WHERE ec.YearsSinceLastPromotion IS NOT NULL
GROUP BY pr.TrainingOpportunitiesTaken
ORDER BY pr.TrainingOpportunitiesTaken;

