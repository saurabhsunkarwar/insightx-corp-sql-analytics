USE master;
GO

-- Create fresh database with new name
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'InsightXDb')
BEGIN
    CREATE DATABASE InsightXDb;
END
GO

USE InsightXDb;
GO

-- Create Schemas safely
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Sales')
    EXEC('CREATE SCHEMA Sales;');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'HR')
    EXEC('CREATE SCHEMA HR;');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Operations')
    EXEC('CREATE SCHEMA Operations;');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Mobility')
    EXEC('CREATE SCHEMA Mobility;');
GO

-- Verify
SELECT schema_name FROM information_schema.schemata 
WHERE schema_name IN ('Sales', 'HR', 'Operations', 'Mobility');
GO