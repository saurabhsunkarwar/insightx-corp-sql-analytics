/*
===============================================================================
Question 08: Quarterly Customer Purchasing Trends
Difficulty : Easy-Medium
Category   : Sales Analytics / Date Aggregations & Rollups
===============================================================================
BUSINESS PROBLEM:
Provide executive management with a high-level revenue rollup per quarter to identify peak sales seasons.

THOUGHT PROCESS:
1. Group Sales.Orders by YEAR(OrderDate) and DATEPART(quarter, OrderDate).
2. Calculate total order count, total revenue, and average revenue per order.
3. Order chronologically by Year and Quarter.
===============================================================================
*/

USE InsightXDb;
GO

SELECT 
    YEAR(OrderDate) AS SalesYear,
    'Q' + CAST(DATEPART(QUARTER, OrderDate) AS VARCHAR(1)) AS SalesQuarter,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    COUNT(OrderID) AS TotalOrders,
    SUM(TotalAmount) AS QuarterlyRevenue,
    CAST(AVG(TotalAmount) AS DECIMAL(10,2)) AS AvgOrderValue
FROM Sales.Orders
GROUP BY 
    YEAR(OrderDate),
    DATEPART(QUARTER, OrderDate)
ORDER BY SalesYear ASC, DATEPART(QUARTER, OrderDate) ASC;
GO