/*
===============================================================================
Question 10: Products Above Category Average Price
Difficulty : Medium
Category   : Product Analytics / Correlated Subqueries / Window Functions
===============================================================================
BUSINESS PROBLEM:
Identify premium-priced items within each catalog segment for marketing positioning.

THOUGHT PROCESS:
1. Compute average unit price per category using AVG(UnitPrice) OVER (PARTITION BY CategoryID).
2. Wrap in a CTE or derive inline.
3. Filter where UnitPrice > CategoryAvgPrice.
===============================================================================
*/

USE InsightXDb;
GO

WITH CategoryAverages AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        p.UnitPrice,
        AVG(p.UnitPrice) OVER(PARTITION BY p.CategoryID) AS CategoryAvgPrice
    FROM Sales.Products p
    INNER JOIN Sales.Categories c 
        ON p.CategoryID = c.CategoryID
)
SELECT 
    ProductID,
    ProductName,
    CategoryName,
    UnitPrice,
    CAST(CategoryAvgPrice AS DECIMAL(10,2)) AS CategoryAvgPrice,
    CAST((UnitPrice - CategoryAvgPrice) AS DECIMAL(10,2)) AS PriceDifferenceAboveAvg
FROM CategoryAverages
WHERE UnitPrice > CategoryAvgPrice
ORDER BY CategoryName, PriceDifferenceAboveAvg DESC;
GO