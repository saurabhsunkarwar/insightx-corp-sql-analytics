/*
===============================================================================
Question 02: Most Expensive Product by Category
Difficulty : Medium
Category   : Product Analytics / Window Functions
===============================================================================
BUSINESS PROBLEM:
Identify the highest-priced item in each product category for premium marketing placements.

THOUGHT PROCESS:
1. Join Sales.Products and Sales.Categories.
2. Use DENSE_RANK() OVER (PARTITION BY CategoryID ORDER BY UnitPrice DESC) to handle ties.
3. Wrap in a CTE and filter for PriceRank = 1.
===============================================================================
*/

USE InsightXDb;
GO

WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        p.UnitPrice,
        DENSE_RANK() OVER(
            PARTITION BY p.CategoryID 
            ORDER BY p.UnitPrice DESC
        ) AS PriceRank
    FROM Sales.Products p
    INNER JOIN Sales.Categories c 
        ON p.CategoryID = c.CategoryID
)
SELECT 
    CategoryName,
    ProductName,
    UnitPrice
FROM RankedProducts
WHERE PriceRank = 1
ORDER BY UnitPrice DESC;
GO