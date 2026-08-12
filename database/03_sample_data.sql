USE InsightXDb;
GO

-------------------------------------------------------------------------------
-- Seed HR Data
-------------------------------------------------------------------------------
INSERT INTO HR.Departments (DepartmentName) VALUES 
('Engineering'), ('Sales'), ('Analytics'), ('Marketing');

INSERT INTO HR.Employees (FirstName, LastName, DepartmentID, Salary, HireDate) VALUES
('Alex', 'Mercer', 1, 75000.00, '2021-03-15'),
('Sarah', 'Connor', 1, 75000.00, '2022-01-10'),
('John', 'Doe', 1, 95000.00, '2019-06-01'),
('Emily', 'Watson', 2, 60000.00, '2023-02-01'),
('Michael', 'Scott', 2, 85000.00, '2020-11-20'),
('David', 'Miller', 3, 90000.00, '2021-08-14'),
('Rachel', 'Green', 3, 90000.00, '2022-05-19'),
('Jessica', 'Pearson', 4, 11000.00, '2018-04-01');

-------------------------------------------------------------------------------
-- Seed Product & Category Data
-------------------------------------------------------------------------------
INSERT INTO Sales.Categories (CategoryName) VALUES 
('Electronics'), ('Audio'), ('Accessories');

INSERT INTO Sales.Products (ProductName, CategoryID, UnitPrice) VALUES
('Pro Laptop 15"', 1, 1499.99),
('Ultrabook 13"', 1, 999.99),
('Noise-Canceling Headphones', 2, 349.99),
('Wireless Earbuds', 2, 129.99),
('Mechanical Keyboard', 3, 149.99),
('Ergonomic Mouse', 3, 79.99);

-------------------------------------------------------------------------------
-- Seed Customer Data
-------------------------------------------------------------------------------
INSERT INTO Sales.Customers (FullName, Email, CreatedDate) VALUES
('  johnathan SMITH ', 'john.smith@example.com', '2024-01-10'),
('mary JANE  ', 'mary.jane@example.com', '2024-01-12'),
('robert T. DOWNEY', 'robert.d@example.com', '2024-02-01'),
('Alice Walker', 'alice.w@example.com', '2024-02-15'),
('Bruce Wayne', 'bruce.w@example.com', '2024-03-01');

-------------------------------------------------------------------------------
-- Seed Order Data
-------------------------------------------------------------------------------
INSERT INTO Sales.Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2025-01-15', 1500.00),
(2, '2025-02-10', 350.00),
(3, '2025-03-05', 80.00),
(1, '2025-04-20', 150.00),
(2, '2025-05-11', 1000.00),
(1, '2025-07-18', 350.00),
(2, '2025-09-01', 130.00),
(1, '2025-10-10', 800.00),
(3, '2025-12-01', 1500.00);

-------------------------------------------------------------------------------
-- Seed Order Items
-------------------------------------------------------------------------------
INSERT INTO Sales.OrderItems (OrderID, ProductID, Quantity, PricePerUnit) VALUES
(1001, 1, 1, 1499.99),
(1002, 3, 1, 349.99),
(1003, 6, 1, 79.99),
(1004, NULL, 1, 150.00),
(1005, 2, 1, 999.99),
(1006, 3, 1, 349.99),
(1007, 4, 1, 129.99),
(1008, 99, 1, 800.00),
(1009, 1, 1, 1499.99);

-------------------------------------------------------------------------------
-- Seed Operations Data
-------------------------------------------------------------------------------
INSERT INTO Operations.DeliveryPartners (PartnerName) VALUES 
('SwiftExpress'), ('LogiTrack'), ('MetroExpress');

INSERT INTO Operations.Deliveries (OrderID, PartnerID, PromisedDeliveryDate, ActualDeliveryDate) VALUES
(1001, 1, '2025-01-20', '2025-01-19'),
(1002, 1, '2025-02-15', '2025-02-18'),
(1003, 1, '2025-03-10', '2025-03-14'),
(1004, 2, '2025-04-25', '2025-04-24'),
(1005, 2, '2025-05-15', '2025-05-15'),
(1006, 3, '2025-07-22', '2025-07-26'),
(1007, 3, '2025-09-05', '2025-09-09');

-------------------------------------------------------------------------------
-- Seed User Activity
-------------------------------------------------------------------------------
INSERT INTO Mobility.UserActivity (UserID, ActivityDate, ActivityType) VALUES
(101, '2025-08-04', 'Login'),
(101, '2025-08-09', 'Search'),
(102, '2025-08-05', 'Login'),
(102, '2025-08-06', 'Purchase'),
(103, '2025-08-10', 'Login');

-------------------------------------------------------------------------------
-- Seed User Mobility Transactions
-------------------------------------------------------------------------------
INSERT INTO Mobility.Transactions (UserID, TransactionTimestamp, Amount) VALUES
(501, '2025-01-01 08:30:00', 10.00),
(501, '2025-01-02 12:15:00', 25.50),
(501, '2025-01-05 18:45:00', 100.00),
(501, '2025-01-10 09:00:00', 15.00),
(502, '2025-02-01 10:00:00', 50.00),
(502, '2025-02-03 14:20:00', 75.00),
(502, '2025-02-07 11:10:00', 200.00),
(503, '2025-03-01 09:00:00', 5.00);
GO

-- Verification
SELECT 
    'HR.Employees' AS TableName, COUNT(*) AS RecordCount FROM HR.Employees
UNION ALL
SELECT 'Sales.Orders', COUNT(*) FROM Sales.Orders
UNION ALL
SELECT 'Sales.Products', COUNT(*) FROM Sales.Products;
GO