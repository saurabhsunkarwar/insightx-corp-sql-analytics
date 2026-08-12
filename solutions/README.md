# 🧠 InsightX Corp — SQL Solutions & Analytics Output Matrix

> **Production-grade T-SQL solutions and output documentation for all 10 real-world analytical and technical interview challenges.**

---

## 📌 Analytical Summary Matrix

| # | Question / Challenge | Domain | Target SQL Concepts | Difficulty |
| :- | :--- | :--- | :--- | :--- |
| **01** | [Customers Purchasing in Every Quarter](#01-customers-purchasing-in-every-quarter) | Sales / Customer | CTEs, COUNT(DISTINCT), DATEPART | **Medium** |
| **02** | [Most Expensive Products by Category](#02-most-expensive-products-by-category) | Product Analytics | DENSE_RANK(), Window Partitioning | **Medium** |
| **03** | [Missing / Unmapped Products](#03-missing--unmapped-products-in-sales) | Data Quality | LEFT JOIN, Anti-Joins, NULL Handling | **Easy-Medium** |
| **04** | [Employees Sharing Department Salaries](#04-employees-sharing-salaries-in-same-department) | HR Analytics | Window Aggregations, COUNT() OVER() | **Medium** |
| **05** | [Third Transaction Per User](#05-third-transaction-per-user) | Mobility Analytics | ROW_NUMBER(), Window Partitioning | **Medium** |
| **06** | [Delayed Orders by Delivery Partner](#06-delayed-orders-by-delivery-partner) | Operations | Conditional Aggregation, SLA Rates | **Easy-Medium** |
| **07** | [Standardizing Customer Names](#07-standardize-raw-customer-names) | Data Quality | TRIM(), CHARINDEX(), String Functions | **Medium** |
| **08** | [Quarterly Customer Purchasing Trends](#08-quarterly-customer-purchasing-trends) | Executive BI | Date Aggregations, Rollups, AVG() | **Easy-Medium** |
| **09** | [Weekday vs. Weekend Active Users](#09-users-active-on-both-weekdays-and-weekends) | Mobility Analytics | DATEPART(), SET DATEFIRST, Grouping | **Medium** |
| **10** | [Products Performing Above Category Average](#10-products-above-category-average-price) | Product Analytics | Window Aggregations, Delta Calculations | **Medium** |

---

## 01. Customers Purchasing in Every Quarter

### Business Problem
Identify "loyal core customers" who stayed active by placing at least one order in **every single quarter (Q1, Q2, Q3, Q4) during calendar year 2025**.

```sql
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
    INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
    WHERE YEAR(o.OrderDate) = 2025
    GROUP BY c.CustomerID, c.FullName, c.Email
)
SELECT CustomerID, FullName, Email, TotalOrders, TotalSpent
FROM QuarterlyPurchases
WHERE ActiveQuarters = 4
ORDER BY TotalSpent DESC;
GO
```

---

## 02. Most Expensive Products by Category

### Business Problem
Find the highest-priced product within each product category to feature in premium catalog promotions.

```sql
USE InsightXDb;
GO

WITH RankedProducts AS (
    SELECT 
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        p.UnitPrice,
        DENSE_RANK() OVER(PARTITION BY p.CategoryID ORDER BY p.UnitPrice DESC) AS PriceRank
    FROM Sales.Products p
    INNER JOIN Sales.Categories c ON p.CategoryID = c.CategoryID
)
SELECT CategoryName, ProductName, UnitPrice
FROM RankedProducts
WHERE PriceRank = 1
ORDER BY UnitPrice DESC;
GO

```
---

## 03. Missing / Unmapped Products in Sales

### Business Problem
Detect sales line items where product reference IDs are either missing (`NULL`) or unmapped to the Master Product Catalog (foreign key integrity violations).

```sql
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
        WHEN p.ProductID IS NULL THEN 'Unmapped Product ID (FK Violation)'
    END AS QualityIssueType
FROM Sales.OrderItems oi
LEFT JOIN Sales.Products p 
    ON oi.ProductID = p.ProductID
WHERE oi.ProductID IS NULL 
   OR p.ProductID IS NULL;
GO
```

---

## 03. Missing / Unmapped Products in Sales

### Business Problem
Detect sales line items where product reference IDs are either missing (`NULL`) or unmapped to the Master Product Catalog (foreign key integrity violations).

```sql
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
        WHEN p.ProductID IS NULL THEN 'Unmapped Product ID (FK Violation)'
    END AS QualityIssueType
FROM Sales.OrderItems oi
LEFT JOIN Sales.Products p 
    ON oi.ProductID = p.ProductID
WHERE oi.ProductID IS NULL 
   OR p.ProductID IS NULL;
GO

```
---

## 04. Employees Sharing Salaries within Department

### Business Problem
Identify employees who have identical salaries within the same department to assist HR with compensation equity audits.

```sql
USE InsightXDb;
GO

WITH SalaryCounts AS (
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        d.DepartmentName,
        e.Salary,
        COUNT(*) OVER(PARTITION BY e.DepartmentID, e.Salary) AS SameSalaryCount
    FROM HR.Employees e
    INNER JOIN HR.Departments d ON e.DepartmentID = d.DepartmentID
)
SELECT 
    EmployeeID,
    EmployeeName,
    DepartmentName,
    Salary
FROM SalaryCounts
WHERE SameSalaryCount > 1
ORDER BY DepartmentName, Salary DESC;
GO
```
---

## 05. Third Transaction Per User

### Business Problem
Retrieve details of every user's **3rd transaction** ordered chronologically to trigger milestone loyalty rewards.

```sql
USE InsightXDb;
GO

WITH SequencedTransactions AS (
    SELECT 
        TransactionID,
        UserID,
        TransactionTimestamp,
        Amount,
        ROW_NUMBER() OVER(
            PARTITION BY UserID 
            ORDER BY TransactionTimestamp ASC
        ) AS TxSequence
    FROM Mobility.Transactions
)
SELECT 
    UserID, 
    TransactionID, 
    TransactionTimestamp, 
    Amount
FROM SequencedTransactions
WHERE TxSequence = 3
ORDER BY UserID;
GO

```
---

## 06. Delayed Orders by Delivery Partner

### Business Problem
Identify delivery partners failing delivery SLAs and calculate delay rates to support vendor performance reviews.

```sql
USE InsightXDb;
GO

SELECT 
    p.PartnerID,
    p.PartnerName,
    COUNT(d.DeliveryID) AS TotalDeliveries,
    SUM(CASE WHEN d.ActualDeliveryDate > d.PromisedDeliveryDate THEN 1 ELSE 0 END) AS DelayedDeliveries,
    CAST(
        (SUM(CASE WHEN d.ActualDeliveryDate > d.PromisedDeliveryDate THEN 1.0 ELSE 0.0 END) / COUNT(d.DeliveryID)) * 100 
        AS DECIMAL(5,2)
    ) AS DelayPercentage
FROM Operations.DeliveryPartners p
INNER JOIN Operations.Deliveries d ON p.PartnerID = d.PartnerID
GROUP BY p.PartnerID, p.PartnerName
ORDER BY DelayedDeliveries DESC, DelayPercentage DESC;
GO

```
---

## 07. Standardize Raw Customer Names

### Business Problem
Clean and reformat unstandardized customer names (irregular casing, extra whitespace) into standard `Title Case`.

```sql
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
    WHERE CHARINDEX(' ', TrimmedName) > 0
)
SELECT 
    CustomerID,
    OriginalName,
    UPPER(LEFT(RawFirstName, 1)) + LOWER(SUBSTRING(RawFirstName, 2, LEN(RawFirstName))) 
    + ' ' + 
    UPPER(LEFT(RawLastName, 1)) + LOWER(SUBSTRING(RawLastName, 2, LEN(RawLastName))) AS StandardizedName
FROM ParsedNames;
GO

```
---

## 08. Quarterly Customer Purchasing Trends

### Business Problem
Provide executive leadership with quarterly sales rollups displaying customer reach, order volume, total revenue, and average order value.

```sql
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
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
ORDER BY SalesYear ASC, DATEPART(QUARTER, OrderDate) ASC;
GO

```
---

## 09. Weekday vs. Weekend Active Users

### Business Problem
Identify highly engaged "power users" who log activity during both workdays (Monday through Friday) and weekends (Saturday/Sunday).

```sql
USE InsightXDb;
GO

SET DATEFIRST 1; -- 1 = Monday, 7 = Sunday

WITH UserDayClassification AS (
    SELECT 
        UserID,
        CASE 
            WHEN DATEPART(dw, ActivityDate) IN (6, 7) THEN 'Weekend' 
            ELSE 'Weekday' 
        END AS DayType
    FROM Mobility.UserActivity
)
SELECT 
    UserID,
    COUNT(CASE WHEN DayType = 'Weekday' THEN 1 END) AS WeekdayActivityCount,
    COUNT(CASE WHEN DayType = 'Weekend' THEN 1 END) AS WeekendActivityCount
FROM UserDayClassification
GROUP BY UserID
HAVING COUNT(CASE WHEN DayType = 'Weekday' THEN 1 END) > 0 
   AND COUNT(CASE WHEN DayType = 'Weekend' THEN 1 END) > 0;
GO
```
---

## 10. Products Performing Above Category Average Price

### Business Problem
Identify premium-tier products priced above their category mean, along with the exact price differential.

```sql
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
    INNER JOIN Sales.Categories c ON p.CategoryID = c.CategoryID
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
```
