/*
===============================================================================
Question 01: Customers Purchasing in Every Quarter
Difficulty : Medium
Category   : Customer Analytics / Conditional Aggregation / CTEs
===============================================================================
BUSINESS PROBLEM:
Identify loyal "core" customers who stayed active across all 4 quarters of 2025.

THOUGHT PROCESS:
1. Extract the quarter using DATEPART(quarter, OrderDate).
2. Filter for orders placed within the target calendar year (2025).
3. Count distinct quarters per customer using COUNT(DISTINCT DATEPART(quarter, OrderDate)).
4. Filter using HAVING clause where the distinct count equals 4.
===============================================================================
*/

USE InsightXDb;
GO

WITH QuarterlyPurchases AS (
    SELECT 
        c.CustomerID,
        c.FullName,
        c.Email,
        COUNT(DISTINCT DATEPART(QUARTER, o.OrderDate)) AS ActiveQuarters,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Sales.Customers c
    INNER JOIN Sales.Orders o 
        ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.OrderDate) = 2025
    GROUP BY 
        c.CustomerID, 
        c.FullName,
        c.Email
)
SELECT 
    CustomerID,
    FullName,
    Email,
    TotalOrders,
    TotalSpent
FROM QuarterlyPurchases
WHERE ActiveQuarters = 4
ORDER BY TotalSpent DESC;
GO