/*===============================================================================
Question 07: Standardize Raw Customer Names
Difficulty : Medium
Category   : Data Quality / String Manipulation & Formatting
===============================================================================
BUSINESS PROBLEM:
Raw customer entries often contain extra spaces or irregular casing (e.g., '  johnathan SMITH '). 
Standardize these strings into clean 'Johnathan Smith' format for UI and reporting.

THOUGHT PROCESS:
1. Trim leading and trailing whitespace from FullName.
2. Split the string into individual words using STRING_SPLIT.
3. Apply Proper Case to EVERY word individually: UPPER(LEFT(word, 1)) + LOWER(SUBSTRING(word, 2, len)).
4. Re-aggregate the words in their original sequence using STRING_AGG.
===============================================================================*/
USE InsightXDb;
GO

WITH SplitWords AS (
    SELECT 
        c.CustomerID,
        c.FullName AS OriginalName,
        s.value AS NameWord,
        /* Ordinal value preserves exact word position in the full name */
        ROW_NUMBER() OVER(PARTITION BY c.CustomerID ORDER BY (SELECT NULL)) AS WordOrder
    FROM Sales.Customers c
    CROSS APPLY STRING_SPLIT(TRIM(c.FullName), ' ') s
    WHERE s.value <> '' -- Filter out extra consecutive spaces
),
CapitalizedWords AS (
    SELECT 
        CustomerID,
        OriginalName,
        WordOrder,
        UPPER(LEFT(NameWord, 1)) + LOWER(SUBSTRING(NameWord, 2, LEN(NameWord))) AS CleanWord
    FROM SplitWords
)
SELECT 
    CustomerID,
    OriginalName,
    STRING_AGG(CleanWord, ' ') WITHIN GROUP (ORDER BY WordOrder) AS StandardizedName
FROM CapitalizedWords
GROUP BY CustomerID, OriginalName
ORDER BY CustomerID;
GO