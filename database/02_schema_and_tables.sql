USE InsightXDb;
GO

-------------------------------------------------------------------------------
-- 1. HR SCHEMA TABLES
-------------------------------------------------------------------------------
CREATE TABLE HR.Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE HR.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES HR.Departments(DepartmentID),
    Salary DECIMAL(12,2) NOT NULL,
    HireDate DATE NOT NULL
);

-------------------------------------------------------------------------------
-- 2. SALES SCHEMA TABLES
-------------------------------------------------------------------------------
CREATE TABLE Sales.Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    CreatedDate DATE NOT NULL
);

CREATE TABLE Sales.Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Sales.Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Sales.Categories(CategoryID),
    UnitPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE Sales.Orders (
    OrderID INT IDENTITY(1001,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Sales.Customers(CustomerID),
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL
);

CREATE TABLE Sales.OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Sales.Orders(OrderID),
    ProductID INT NULL,
    Quantity INT NOT NULL,
    PricePerUnit DECIMAL(10,2) NOT NULL
);

-------------------------------------------------------------------------------
-- 3. OPERATIONS SCHEMA TABLES
-------------------------------------------------------------------------------
CREATE TABLE Operations.DeliveryPartners (
    PartnerID INT IDENTITY(1,1) PRIMARY KEY,
    PartnerName VARCHAR(100) NOT NULL
);

CREATE TABLE Operations.Deliveries (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Sales.Orders(OrderID),
    PartnerID INT FOREIGN KEY REFERENCES Operations.DeliveryPartners(PartnerID),
    PromisedDeliveryDate DATE NOT NULL,
    ActualDeliveryDate DATE NULL
);

-------------------------------------------------------------------------------
-- 4. MOBILITY & TRANSACTIONS SCHEMA TABLES
-------------------------------------------------------------------------------
CREATE TABLE Mobility.UserActivity (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ActivityDate DATE NOT NULL,
    ActivityType VARCHAR(50) NOT NULL
);

CREATE TABLE Mobility.Transactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TransactionTimestamp DATETIME2 NOT NULL,
    Amount DECIMAL(10,2) NOT NULL
);
GO

-- Verify tables created
SELECT TABLE_SCHEMA, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA;
GO