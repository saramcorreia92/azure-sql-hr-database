-- =============================================
-- Azure HR Database
-- File: 02_insert_data.sql
-- Description: Sample HR data for testing
-- Author: Sara Correia
-- Date: 2026-05-30
-- =============================================

-- Insert departments
INSERT INTO Departments (DepartmentName, Location) VALUES
('Human Resources', 'London'),
('IT & Infrastructure', 'London'),
('Finance', 'Manchester'),
('Operations', 'Birmingham'),
('Cybersecurity', 'London');

-- Insert roles
INSERT INTO Roles (RoleTitle, RoleLevel, DepartmentID) VALUES
('HR Manager', 'Senior', 1),
('Systems Administrator', 'Mid', 2),
('Security Analyst', 'Mid', 5),
('IT Support Technician', 'Junior', 2),
('Finance Officer', 'Mid', 3),
('SOC Analyst', 'Senior', 5);

-- Insert employees
INSERT INTO Employees (FirstName, LastName, Email, PhoneNumber, HireDate, DepartmentID, RoleID) VALUES
('Sarah', 'Mitchell', 'sarah.mitchell@hrcompany.co.uk', '07700900001', '2021-03-15', 1, 1),
('James', 'Okafor', 'james.okafor@hrcompany.co.uk', '07700900002', '2020-07-01', 2, 2),
('Priya', 'Sharma', 'priya.sharma@hrcompany.co.uk', '07700900003', '2022-01-10', 5, 3),
('Tom', 'Walsh', 'tom.walsh@hrcompany.co.uk', '07700900004', '2023-06-20', 2, 4),
('Diane', 'Osei', 'diane.osei@hrcompany.co.uk', '07700900005', '2019-11-05', 3, 5),
('Marcus', 'Chen', 'marcus.chen@hrcompany.co.uk', '07700900006', '2022-09-12', 5, 6);

-- Insert salaries
INSERT INTO Salaries (EmployeeID, BaseSalary, EffectiveDate) VALUES
(1, 48000.00, '2021-03-15'),
(2, 52000.00, '2020-07-01'),
(3, 55000.00, '2022-01-10'),
(4, 32000.00, '2023-06-20'),
(5, 45000.00, '2019-11-05'),
(6, 62000.00, '2022-09-12');
