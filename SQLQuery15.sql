USE [Sandpit];
GO

DECLARE @BatchSize INT = 50000;
DECLARE @BatchStart INT;
DECLARE @BatchEnd INT;
DECLARE @MaxRow INT;
DECLARE @RowsInserted INT;

SELECT
    @BatchStart = MIN([Row Number]),
    @MaxRow     = MAX([Row Number])
FROM dbo.Patient_Record;

WHILE @BatchStart IS NOT NULL AND @BatchStart <= @MaxRow
BEGIN
    SET @BatchEnd = @BatchStart + @BatchSize - 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [EPR_DataMigration].[NC_PAS].[PMI_Patient] (
            [Row Number],
            [Effective Date/Time],
            [Healthcare Organisation],
            [Hospital Number],
            [National Number],
            [National Number Status],
            [Title],
            [Surname],
            [Forename],
            [Middle Name(s)],
            [Preferred Name],
            [Date/Time of Birth],
            [Date/Time of Death],
            [Sex at Birth Code],
            [Gender Identity Code],
            [Administrative Gender Code],
            [Marital Status Code],
            [Religion Code],
            [Ethnic Category Code],
            [Nationality Code],
            [Primary Language Code],
            [Translation Required],
            [Preferred Letter Format],
            [Communication Preference Code],
            [Preferred Contact Time],
            [SMS Consent],
            [Address Street],
            [Address Area],
            [Address City],
            [Address County],
            [Address PostCode],
            [Address Country],
            [Temporary Address Street],
            [Temporary Address Area],
            [Temporary Address City],
            [Temporary Address County],
            [Temporary Address PostCode],
            [Temporary Address Country],
            [Temporary Address Expires],
            [Registered GP Code],
            [Registered GP Title],
            [Registered GP Surname],
            [Registered GP Forename],
            [Registered GP Middle Name(s)],
            [Registered GP Practice Code],
            [Registered GP Practice Name],
            [Nominted Pharmacy Code],
            [Optician Code],
            [Dental Practice Code],
            [Pregnant Indicator],
            [Last Menstrual Period Date],
            [Estimated Due Date],
            [Birth City],
            [Birth District],
            [Birth Country],
            [Birth Order],
            [Occupation],
            [School Code],
            [Unknown Patient],
            [Next of Kin Address Divulgable to Patient],
            [Restricted],
            [Ex-Armed Forces Indicator Code],
            [Witheld Identity Reason Code],
            [Estimated Age],
            [EPS Exemption Reason],
            [Correspondence Addressee],
            [Correspondence Address Street],
            [Correspondence Address Area],
            [Correspondence Address City],
            [Correspondence Address County],
            [Correspondence Address PostCode],
            [Correspondence Address Country],
            [Correspondence Address Expires],
            [Communication Restriction Reason],
            [Communication Restriction Expires],
            [Preferred Letter Delivery],
            [Preferred Notification Delivery],
            [Overseas Visitor Charging Category],
            [Overseas Visitor Charging Start Date],
            [Secondary Hospital Number],
            [Alternate hospital number],
            [Registered GP From Date],
            [Address From Date],
            [Temporary Address From Date],
            [Correspondence Address From Date],
            [Death Time Type],
            [Overseas Visitor Charging End Date]
        )
        SELECT
            [Row Number],
            [Effective Date/Time],
            [Healthcare Organisation],
            [Hospital Number],
            [National Number],
            [National Number Status],
            [Title],
            [Surname],
            [Forename],
            [Middle Name(s)],
            [Preferred Name],
            [Date/Time of Birth],
            [Date/Time of Death],
            [Sex at Birth Code],
            [Gender Identity Code],
            [Administrative Gender Code],
            [Marital Status Code],
            [Religion Code],
            [Ethnic Category Code],
            [Nationality Code],
            [Primary Language Code],
            [Translation Required],
            [Preferred Letter Format],
            [Communication Preference Code],
            [Preferred Contact Time],
            [SMS Consent],
            [Address Street],
            [Address Area],
            [Address City],
            [Address County],
            [Address PostCode],
            [Address Country],
            [Temporary Address Street],
            [Temporary Address Area],
            [Temporary Address City],
            [Temporary Address County],
            [Temporary Address PostCode],
            [Temporary Address Country],
            [Temporary Address Expires],
            [Registered GP Code],
            [Registered GP Title],
            [Registered GP Surname],
            [Registered GP Forename],
            [Registered GP Middle Name(s)],
            [Registered GP Practice Code],
            [Registered GP Practice Name],
            [Nominted Pharmacy Code],
            [Optician Code],
            [Dental Practice Code],
            [Pregnant Indicator],
            [Last Menstrual Period Date],
            [Estimated Due Date],
            [Birth City],
            [Birth District],
            [Birth Country],
            [Birth Order],
            [Occupation],
            [School Code],
            [Unknown Patient],
            [Next of Kin Address Divulgable to Patient],
            [Restricted],
            [Ex-Armed Forces Indicator Code],
            [Witheld Identity Reason Code],
            [Estimated Age],
            [EPS Exemption Reason],
            [Correspondence Addressee],
            [Correspondence Address Street],
            [Correspondence Address Area],
            [Correspondence Address City],
            [Correspondence Address County],
            [Correspondence Address PostCode],
            [Correspondence Address Country],
            [Correspondence Address Expires],
            [Communication Restriction Reason],
            [Communication Restriction Expires],
            [Preferred Letter Delivery],
            [Preferred Notification Delivery],
            [Overseas Visitor Charging Category],
            [Overseas Visitor Charging Start Date],
            [Secondary Hospital Number],
            [Alternate hospital number],
            [Registered GP From Date],
            [Address From Date],
            [Temporary Address From Date],
            [Correspondence Address From Date],
            [Death Time Type],
            [Overseas Visitor Charging End Date]
        FROM dbo.Patient_Record
        WHERE [Row Number] BETWEEN @BatchStart AND @BatchEnd;

        SET @RowsInserted = @@ROWCOUNT;

        COMMIT TRANSACTION;

        INSERT INTO [ERROR_LOG].[dbo].[Migration_Batch_Log] (
            BatchStart,
            BatchEnd,
            RowsInserted,
            Status,
            Message
        )
        VALUES (
            @BatchStart,
            @BatchEnd,
            @RowsInserted,
            'SUCCESS',
            'Batch committed successfully'
        );

        PRINT CONCAT('SUCCESS: Batch ', @BatchStart, ' to ', @BatchEnd, ' loaded. Rows inserted: ', @RowsInserted);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO [ERROR_LOG].[dbo].[Migration_Error_Log] (
            BatchStart,
            BatchEnd,
            ErrorMessage,
            ErrorNumber,
            ErrorLine,
            ErrorProcedure
        )
        VALUES (
            @BatchStart,
            @BatchEnd,
            ERROR_MESSAGE(),
            ERROR_NUMBER(),
            ERROR_LINE(),
            ERROR_PROCEDURE()
        );

        INSERT INTO [ERROR_LOG].[dbo].[Migration_Batch_Log] (
            BatchStart,
            BatchEnd,
            RowsInserted,
            Status,
            Message
        )
        VALUES (
            @BatchStart,
            @BatchEnd,
            0,
            'FAILED',
            ERROR_MESSAGE()
        );

        PRINT CONCAT('FAILED: Batch ', @BatchStart, ' to ', @BatchEnd);
    END CATCH;

    SET @BatchStart = @BatchEnd + 1;
END
GO

SELECT *
FROM ERROR_LOG.dbo.Migration_Error_Log

select 
from EPR_DataMigration