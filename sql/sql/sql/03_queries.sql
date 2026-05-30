-- =============================================
-- Azure HR Database
-- File: 03_queries.sql
-- Description: Business queries for HR reporting
-- Author: Sara Correia
-- Date: 2026-05-30
-- =============================================

-- =============================================
-- Query 1: Full employee directory
-- Returns all active employees with department,
-- role, and years of service
-- =============================================
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    e.Email,
    d.DepartmentName,
    r.RoleTitle,
    r.RoleLevel,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsEmployed
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
WHERE e.IsActive = 1
ORDER BY d.DepartmentName, e.LastName;

-- =============================================
-- Query 2: Department headcount and salary report
-- Used by HR management for budget planning
-- =============================================
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS Headcount,
    AVG(s.BaseSalary) AS AvgSalary,
    MIN(s.BaseSalary) AS MinSalary,
    MAX(s.BaseSalary) AS MaxSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
    AND e.IsActive = 1
LEFT JOIN Salaries s ON e.EmployeeID = s.EmployeeID
    AND s.EndDate IS NULL
GROUP BY d.DepartmentName
ORDER BY Headcount DESC;

-- =============================================
-- Query 3: Employees hired in the last 2 years
-- Used for probation period tracking
-- =============================================
SELECT 
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    r.RoleTitle,
    e.HireDate,
    s.BaseSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r ON e.RoleID = r.RoleID
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
    AND s.EndDate IS NULL
WHERE e.HireDate >= DATEADD(YEAR, -2, GETDATE())
ORDER BY e.HireDate DESC;

-- =============================================
-- Query 4: Verify hr_analyst permissions
-- Confirms least privilege access is in place
-- =============================================
SELECT 
    dp.name AS UserName,
    o.name AS TableName,
    p.permission_name AS Permission
FROM sys.database_permissions p
JOIN sys.database_principals dp ON p.grantee_principal_id = dp.principal_id
JOIN sys.objects o ON p.major_id = o.object_id
WHERE dp.name = 'hr_analyst';
