CASE_STATEMENT
--Select FirstName, LastName, Age,
--CASE
--	WHEN Age > 30 THEN 'Old'
--	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
--	ELSE 'Baby'
--END
--FROM
--	[SQL Tutorial].dbo.EmployeeDemographics
--WHERE
--	Age is NOT NULL
--ORDER BY
--	Age

HAVING_CLAUSE
--SELECT JobTitle, AVG(Salary)
--FROM [SQL Tutorial].dbo.EmployeeDemographics
--JOIN [SQL Tutorial].dbo.EmployeeSalary
--		on EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--GROUP BY JobTitle
--HAVING AVG(Salary) > 4500
--ORDER BY AVG(Salary)

UPDATING
--Select *
--FROM [SQL Tutorial].dbo.EmployeeDemographics

--UPDATE [SQL Tutorial].dbo.EmployeeDemographics
--SET Age = 31, Gender = 'Female'
--WHERE FirstName = 'Holly' AND LastName = 'Flax'

DELETING
--DELETE FROM [SQL Tutorial].dbo.EmployeeDemographics
--WHERE EmployeeID = 1005

PARTITION_BY
--Select Demo.EmployeeID, Sal.Salary
--FROM [SQL Tutorial].dbo.EmployeeDemographics AS Demo
--JOIN [SQL Tutorial].dbo.EmployeeSalary as Sal
--	on Demo.EmployeeID = Sal.EmployeeID

--SELECT FirstName, LastName, Salary
--, COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
--FROM [SQL Tutorial].dbo.EmployeeDemographics dem
--JOIN [SQL Tutorial].dbo.EmployeeSalary sal
--	on dem.EmployeeID = sal.EmployeeID

COMMON_TABLE_EXPRESSION
--WITH CTE_Employee as 
--(SELECT FirstName, LastName, Gender, Salary
-- , COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
-- , AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
--FROM [SQL Tutorial].dbo.EmployeeDemographics emp
--JOIN [SQL Tutorial].dbo.EmployeeSalary sal
--	on emp.EmployeeID = sal.EmployeeID
--WHERE Salary > '45000'
--)

--select FirstName, AvgSalary
--FROM CTE_Employee

TEMPORARY_TABLES
--CREATE TABLE #temp_Employee (
--	EmployeeID int
--  , JobTitle varchar(100)
--  , Salary int
--)

--select *
--from #temp_Employee

--INSERT INTO #temp_Employee VALUES (
--'1001', 'HR', '45000'
--)

--INSERT INTO #temp_Employee
--SELECT *
--FROM [SQL Tutorial].dbo.EmployeeSalary

STRING_FUNCTIONS
--CREATE TABLE EmployeeErrors (
--EmployeeID varchar(50)
--,FirstName varchar(50)
--,LastName varchar(50)
--)

--Insert into EmployeeErrors Values 
--('1001  ', 'Jimbo', 'Halbert')
--,('  1002', 'Pamela', 'Beasely')
--,('1005', 'TOby', 'Flenderson - Fired')

--Select *
--From EmployeeErrors

USING_TRIM_LTRIM_RTRIM

--Select EmployeeID, TRIM(EmployeeID) as IDTRIM
--FROM EmployeeErrors

--Select EmployeeID, LTRIM(EmployeeID) as IDTRIM
--FROM EmployeeErrors

--Select EmployeeID, RTRIM(EmployeeID) as IDTRIM
--FROM EmployeeErrors

USING_REPLACE

--Select LastName, REPLACE(LastName, '- Fired','') as LastNameFixed
--FROM EmployeeErrors


USING_STRING

--Select err.FirstName , dem.FirstName
--FROM EmployeeErrors err
--JOIN EmployeeDemographics dem
--	on err.FirstName = dem.FirstName


USING_UPPER_AND_LOWER

--Select FirstName, LOWER(FirstName)
--FROM EmployeeErrors

--Select FirstName, UPPER(FirstName)
--FROM EmployeeErrors

STORED_PROCEDURES (WORK_ON_IT)

--CREATE PROCEDURE TEST
--AS
--select *
--from EmployeeDemographics

--EXEC TEST


--CREATE PROCEDURE Temp_Employee
--AS
--Create table #Temp_employee (
--	JobTitle varchar(100)
--  , EmployeesPerJob int
--  , AvgAge int
--  , AvgSalary int
--)

--INSERT INTO #Temp_employee
--Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
--FROM [SQL Tutorial].dbo.EmployeeDemographics emp
--JOIN [SQL Tutorial].dbo.EmployeeSalary sal
--	on emp.EmployeeID = sal.EmployeeID
--group by
--	JobTitle

--select *
--from #temp_employee

--EXEC Temp_Employee


Subqueries(Select_from_where_statements)

Select *
from EmployeeSalary

--Subquery in select

select EmployeeID, Salary, (Select Avg(Salary) From EmployeeSalary) as AllAvgSalary
from EmployeeSalary

--With Partition

select EmployeeID, Salary, Avg(Salary) Over() as AllAvgSalary
from EmployeeSalary

--Why Group By doesn't Work

select EmployeeID, Salary, Avg(Salary) as AllAvgSalary
from EmployeeSalary
group by EmployeeId, Salary
Order by 1,2

--Subquery in From

select a.EmployeeID, AllAvgSalary
from (select EmployeeID, Salary, Avg(Salary) Over() as AllAvgSalary
	From EmployeeSalary) a

--Subquery in Where

select EmployeeID, JobTitle, Salary
from EmployeeSalary
where EmployeeId in (
		Select EmployeeID
		From EmployeeDemographics
		where Age > 30)