/*
===============================================================================
Question 04: Employees Sharing Salaries in Department
Difficulty : Medium
Category   : Employee Analytics / Self-Join / Window Aggregations
===============================================================================
BUSINESS PROBLEM:
Find salary duplicates within departments for equity and compensation reviews.

THOUGHT PROCESS:
1. Use a COUNT(*) OVER(PARTITION BY DepartmentID, Salary) window aggregate.
2. Filter for records where DuplicateCount > 1.
===============================================================================
*/

USE InsightXDb;
GO

WITH SalaryDuplicates AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.Salary,
        COUNT(*) OVER(
            PARTITION BY e.DepartmentID, e.Salary
        ) AS DuplicateCount
    FROM HR.Employees e
    INNER JOIN HR.Departments d 
        ON e.DepartmentID = d.DepartmentID
)
SELECT 
    DepartmentName,
    EmployeeName,
    Salary
FROM SalaryDuplicates
WHERE DuplicateCount > 1
ORDER BY DepartmentName, Salary DESC;
GO