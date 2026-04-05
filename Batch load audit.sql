USE [ERROR_LOG];
GO

IF OBJECT_ID('dbo.Migration_Batch_Log', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Migration_Batch_Log (
        BatchLogID INT IDENTITY(1,1) PRIMARY KEY,
        LogDate DATETIME NOT NULL DEFAULT GETDATE(),
        BatchStart INT NOT NULL,
        BatchEnd INT NOT NULL,
        RowsInserted INT NULL,
        Status VARCHAR(20) NOT NULL,
        Message NVARCHAR(1000) NULL
    );
END
GO






