---Insert date values from 2010/01/01 to curret day + 500 days

WITH Dates AS (
        SELECT
         [Date] = CONVERT(DATETIME,'01/01/2010')
        UNION ALL 
		SELECT
         [Date] = DATEADD(DAY, 1, [Date])
        FROM
         Dates
        WHERE
         Date < DATEADD (d,500, getdate())   
) 

INSERT INTO [dbo].[Dates]
           ([DateValue]
           ,[DateDayofMonth]
           ,[DateDayofYear]
           ,[DateQuarter]
           ,[DateWeekdayName]
           ,[DateMonthName]
           ,[DateYearMonth])

SELECT
 
	[Date]
 	,(DAY ([Date]))   ---day of month
	,DATEPART (DY, [Date])    --day of year
	,DATEPART (QQ, [Date])    --date quarter
	,DATENAME (DW, [Date])    --weekday name
	,DATENAME (mm, [Date])    -- month name
	,SUBSTRING(CONVERT(VARCHAR(8), [Date], 112),1,6)   --year month

FROM
 Dates
 OPTION (MAXRECURSION 5000)