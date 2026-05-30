-- =============================================
-- Azure HR Database
-- File: 01_create_tables.sql
-- Description: Schema creation for HR database
-- Author: Sara Correia
-- Date: 2026-05-30
-- =============================================

-- Create Departments table first (referenced by Employees)
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL,
    Location NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Create Roles table
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleTitle NVARCHAR(100) NOT NULL,
    RoleLevel NVARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID)
);

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber NVARCHAR(20),
    HireDate DATE NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Create Salaries table (separate from Employees - best practice)
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    BaseSalary DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(3) DEFAULT 'GBP',
    EffectiveDate DATE NOT NULL,
    EndDate DATE NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Audit log - tracks all changes for compliance
CREATE TABLE AuditLog (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    TableName NVARCHAR(100),
    RecordID INT,
    Action NVARCHAR(10),
    ChangedBy NVARCHAR(100) DEFAULT SYSTEM_USER,
    ChangedAt DATETIME DEFAULT GETDATE(),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX)
);
