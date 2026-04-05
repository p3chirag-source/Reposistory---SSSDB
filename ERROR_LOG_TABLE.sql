USE ERROR_LOG;
GO

IF OBJECT_ID('dbo.Migration_Error_Log', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Migration_Error_Log (
        ErrorID INT IDENTITY(1,1),
        ErrorDate DATETIME DEFAULT GETDATE(),
        BatchStart INT,
        BatchEnd INT,
        ErrorMessage NVARCHAR(MAX),
        ErrorNumber INT,
        ErrorLine INT,
        ErrorProcedure NVARCHAR(200)
    );
END
GO