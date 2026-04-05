BULK INSERT [dbo].[PMI_Patient_Raw]
FROM 'C:\Users\Chira\Downloads\Patient Record.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    FORMAT = 'CSV',
    FIELDQUOTE = '"',
    TABLOCK
);

SELECT COUNT(*) AS Total_Row_Count
FROM Sandpit.dbo.PMI_Patient_Raw

Select Distinct Hospital -- gfmlmkr