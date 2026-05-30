-- =============================================
-- Azure HR Database
-- File: 04_stored_procedures.sql
-- Description: Stored procedures for HR operations
-- Author: Sara Correia
-- Date: 2026-05-30
-- =============================================


-- =============================================
-- Procedure 1: Onboard a new employee
-- Creates employee record, salary entry,
-- and writes to audit log automatically
-- =============================================
CREATE PROCEDURE sp_OnboardEmployee
    @FirstName    NVARCHAR(50),
    @LastName     NVARCHAR(50),
    @Email        NVARCHAR(100),
    @DepartmentID INT,
    @RoleID       INT,
    @HireDate     DATE,
    @BaseSalary   DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Employees (FirstName, LastName, Email, HireDate, DepartmentID, RoleID)
    VALUES (@FirstName, @LastName, @Email, @HireDate, @DepartmentID, @RoleID);

    DECLARE @NewEmployeeID INT = SCOPE_IDENTITY();

    INSERT INTO Salaries (EmployeeID, BaseSalary, EffectiveDate)
    VALUES (@NewEmployeeID, @BaseSalary, @HireDate);

    INSERT INTO AuditLog (TableName, RecordID, Action, NewValue)
    VALUES ('Employees', @NewEmployeeID, 'INSERT',
            'New employee onboarded: ' + @FirstName + ' ' + @LastName);

    SELECT @NewEmployeeID AS NewEmployeeID,
           'Employee successfully onboarded' AS Message;
END;

-- Usage example:
-- EXEC sp_OnboardEmployee 
--     'Alex', 'Johnson', 'alex.johnson@hrcompany.co.uk',
--     2, 4, '2026-05-30', 34000.00;


-- =============================================
-- Procedure 2: Offboard an employee
-- Marks employee inactive, closes salary record,
-- and writes to audit log
-- =============================================
CREATE PROCEDURE sp_OffboardEmployee
    @EmployeeID   INT,
    @LeavingDate  DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeName NVARCHAR(100);

    SELECT @EmployeeName = FirstName + ' ' + LastName
    FROM Employees
    WHERE EmployeeID = @EmployeeID;

    IF @EmployeeName IS NULL
    BEGIN
        SELECT 'Employee not found' AS Message;
        RETURN;
    END;

    -- Mark employee as inactive
    UPDATE Employees
    SET IsActive = 0
    WHERE EmployeeID = @EmployeeID;

    -- Close current salary record
    UPDATE Salaries
    SET EndDate = @LeavingDate
    WHERE EmployeeID = @EmployeeID
    AND EndDate IS NULL;

    -- Write to audit log
    INSERT INTO AuditLog (TableName, RecordID, Action, NewValue)
    VALUES ('Employees', @EmployeeID, 'UPDATE',
            'Employee offboarded: ' + @EmployeeName + 
            ' | Leaving date: ' + CAST(@LeavingDate AS NVARCHAR));

    SELECT @EmployeeID AS EmployeeID,
           @EmployeeName AS EmployeeName,
           'Employee successfully offboarded' AS Message;
END;

-- Usage example:
-- EXEC sp_OffboardEmployee 4, '2026-05-30';


-- =============================================
-- Procedure 3: Give an employee a salary raise
-- Updates salary history and logs the change
-- =============================================
CREATE PROCEDURE sp_UpdateSalary
    @EmployeeID    INT,
    @NewSalary     DECIMAL(10,2),
    @EffectiveDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeName NVARCHAR(100);
    DECLARE @OldSalary DECIMAL(10,2);

    SELECT @EmployeeName = FirstName + ' ' + LastName
    FROM Employees
    WHERE EmployeeID = @EmployeeID;

    SELECT @OldSalary = BaseSalary
    FROM Salaries
    WHERE EmployeeID = @EmployeeID
    AND EndDate IS NULL;

    IF @EmployeeName IS NULL
    BEGIN
        SELECT 'Employee not found' AS Message;
        RETURN;
    END;

    -- Close old salary record
    UPDATE Salaries
    SET EndDate = @EffectiveDate
    WHERE EmployeeID = @EmployeeID
    AND EndDate IS NULL;

    -- Insert new salary record
    INSERT INTO Salaries (EmployeeID, BaseSalary, EffectiveDate)
    VALUES (@EmployeeID, @NewSalary, @EffectiveDate);

    -- Log the change
    INSERT INTO AuditLog (TableName, RecordID, Action, OldValue, NewValue)
    VALUES ('Salaries', @EmployeeID, 'UPDATE',
            'Old salary: £' + CAST(@OldSalary AS NVARCHAR),
            'New salary: £' + CAST(@NewSalary AS NVARCHAR));

    SELECT @EmployeeID AS EmployeeID,
           @EmployeeName AS EmployeeName,
           @OldSalary AS OldSalary,
           @NewSalary AS NewSalary,
           'Salary updated successfully' AS Message;
END;

-- Usage example:
-- EXEC sp_UpdateSalary 3, 58000.00, '2026-05-30';
