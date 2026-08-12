/*
===============================================================================
Question 07: Standardize Raw Customer Names
Difficulty : Medium
Category   : Data Quality / String Manipulation & Formatting
===============================================================================
BUSINESS PROBLEM:
Raw customer entries often contain extra spaces or irregular casing (e.g., '  johnathan SMITH '). 
Standardize these strings into clean 'Johnathan Smith' format for UI and reporting.

THOUGHT PROCESS:
1. Use LTRIM(RTRIM()) or TRIM() to remove leading and trailing whitespace.
2. Split string into First Name and Last Name using CHARINDEX(' ', trimmed_string).
3. Capitalize first letter (UPPER(LEFT(..., 1))) and lowercase remaining characters (LOWER(SUBSTRING(..., 2, ...))).
4. Re-combine First Name and Last Name.
===============================================================================
*/

USE InsightXDb;
GO

WITH CleanedWhitespace AS (
    SELECT 
        CustomerID,
        FullName AS OriginalName,
        TRIM(FullName) AS TrimmedName
    FROM Sales.Customers
),
ParsedNames AS (
    SELECT 
        CustomerID,
        OriginalName,
        TrimmedName,
        LEFT(TrimmedName, CHARINDEX(' ', TrimmedName) - 1) AS RawFirstName,
        SUBSTRING(TrimmedName, CHARINDEX(' ', TrimmedName) + 1, LEN(TrimmedName)) AS RawLastName
    FROM CleanedWhitespace
    WHERE CHARINDEX(' ', TrimmedName) > 0 -- Ensure name contains a space
)
SELECT 
    CustomerID,
    OriginalName,
    UPPER(LEFT(RawFirstName, 1)) + LOWER(SUBSTRING(RawFirstName, 2, LEN(RawFirstName))) 
    + ' ' + 
    UPPER(LEFT(RawLastName, 1)) + LOWER(SUBSTRING(RawLastName, 2, LEN(RawLastName))) AS StandardizedName
FROM ParsedNames;
GO