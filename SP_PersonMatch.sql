USE PRIVIA_PersonDatabase 
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PersonMatch') AND type in (N'P', N'PC'))
  DROP PROCEDURE dbo.PersonMatch
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Person Match Score using supplied variables
-- =============================================

CREATE PROCEDURE dbo.PersonMatch
	(@FirstName varchar (255)
	,@LastName varchar (255)
	,@DateofBirth datetime
	,@Sex varchar (1)
	,@isSuccess char(1) Output
	)


	AS
BEGIN

  BEGIN TRY
    set nocount on


SELECT
	PersonID    
    ,(
		CASE
            WHEN LTRIM(RTRIM(FirstName)) = @FirstName
            THEN 1
            ELSE 0.5
		END)
		 + 
		 (CASE
		WHEN LTRIM(RTRIM(LastName)) = @LastName
            THEN 0.8
            ELSE 0.4
        END)
		+
   	 (CASE
	  WHEN convert(varchar, [DateofBirth], 101)  = convert(varchar, @DateofBirth, 101)
            THEN 0.75
            ELSE 0.3
        END)
		+
		(CASE
			WHEN SUBSTRING(Sex,1,1) = @Sex
			THEN 0.6 
			ELSE 0.25
        END) as MatchScore
		
		FROM [dbo].[Person]


if @@rowcount = 1 
      select @isSuccess = 'Y'
    else 
      select @isSuccess = 'N'
        
  End try

  Begin Catch
    select @isSuccess = 'N' 
  End Catch

  End
  GO