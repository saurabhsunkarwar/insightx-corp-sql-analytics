/*
===============================================================================
Question 03: Missing / Unmapped Products in Sales
Difficulty : Easy-Medium
Category   : Data Quality / Referential Integrity / Anti-Joins
===============================================================================
BUSINESS PROBLEM:
Detect data integrity errors where sales occurred for non-existent or NULL product IDs.

THOUGHT PROCESS:
1. Perform a LEFT JOIN from Sales.OrderItems to Sales.Products.
2. Identify records where the ProductID in OrderItems is NULL OR does not match any ID in Products.
===============================================================================
*/

USE InsightXDb;
GO

SELECT 
    oi.OrderItemID,
    oi.OrderID,
    oi.ProductID AS RecordedProductID,
    oi.Quantity,
    oi.PricePerUnit,
    CASE 
        WHEN oi.ProductID IS NULL THEN 'Missing Product ID (NULL)'
        WHEN p.ProductID IS NULL THEN 'Unmapped Product ID (Foreign Key Integrity Violation)'
    END AS QualityIssueType
FROM Sales.OrderItems oi
LEFT JOIN Sales.Products p 
    ON oi.ProductID = p.ProductID
WHERE oi.ProductID IS NULL 
   OR p.ProductID IS NULL;
GO